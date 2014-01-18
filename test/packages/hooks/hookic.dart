part of hooks;

final _dependency = {'named':{},'positional':[]};
final _namedSupport = Hub.classMirrorInvokeNamedSupportTest();

class _DropGenerator{
	String name;
	Symbol constructor;
	ClassMirror interface;
	ClassMirror cm;
	List positionalArguments;
	Map<Symbol,dynamic> namedArguments;
	InverseController controller;
	Function instanceCreator;
		
	static create(n,d,c,f) => new _DropGenerator(n,d,c,f);
	
	_DropGenerator(name,dependency,interface,controller){
		this.name = name;
		this.interface = interface;
		this.namedArguments = Hub.encryptNamedArguments(dependency['named']);
		this.positionalArguments = dependency['positional'];
		this.controller = controller;
	}
	
	bool get hasDependencies{
		if(this.positionalArguments.isEmpty && this.namedArguments.isEmpty) return false;
		return true;
	}
	
	bool get hasNamedArguments{
		return !this.namedArguments.isEmpty;
	}
			
	bool get hasMakable{
		return (this.cm != null);
	}
	
	void use(ClassMirror m,[Symbol constructor,Function creator]){ 
		if(!this.validate(m)) throw "ClassMirror ${m.simpleName} has no Interface: ${this.interface.simpleName}";
		this.cm = m;
		this.constructor = constructor;
		if(creator != null) this.instanceCreator = creator;
	}
	
	bool validate(ClassMirror m){
		var iname = this.interface.simpleName;
		var mi = m.superinterfaces;
		for(var n in mi){
			if(n.simpleName != iname) continue;
			return true;
			break;
		}
		return false;
	}
		
	Future generate(){
		if(!this.hasMakable) return;
		return this.controller.fetchDependency(this.name).then((_){
			if(_namedSupport || !this.hasNamedArguments){
				if(_ == null) return this.cm.newInstance(this.constructor,[]);
				if(_.length < 2) return this.cm.newInstance(this.constructor,_[0]);
				if(_.length == 2) return this.cm.newInstance(this.constructor,_[0],_[1]);
			}else{
				if(_ == null) return Function.apply(this.instanceCreator,[]);
				if(_.length < 2) return Function.apply(this.instanceCreator,_[0]);
				if(_.length == 2) return Function.apply(this.instanceCreator,_[0],_[1]);
			}
		});
	}
	
	void nullify(){
		this.interface = null;
		this.cm = null;
		this.controller = null;
		this.instanceCreator = null;
		this.namedArguments.clear();
		this.positionalArguments.clear();
	}
}

class InverseController extends InverseControllerAbstract{
	final cache = Hub.createSymbolCache();
	final generators = InvocationMap.create();
	var libraryManager;
	
	static create([n]){
		return new InverseController(n);
	}
		
	InverseController([String library]){
		if(library != null) this.libraryManager = Hub.singleLibrary(library);
	}
	
	dynamic _useLibrary(dynamic n){
		if(this.libraryManager != null && n is String)
			return (n is String ? this.libraryManager.getClass(n) : reflectClass(n));
		if(n is String && this.libraryManager == null) 
			throw new Exception("Only class Names are allowed!");
		return reflectClass(n);
	}
		
	void define(String rule,dynamic interface,[Map dependency]){
		if(this.generators.has(this.cache.create(rule))) 
			throw "Generators Name: $rule is already used!"; 
		
		var de = (dependency != null ? dependency : _dependency);
		if(de['positional'] == null) de['positional'] = _dependency['positional'];
		if(de['named'] == null) de['named'] = _dependency['named'];
		
		var di = this._useLibrary(interface);
		if(di == null) throw "Interface $interface not found!";
		this.generators.add(this.cache.create(rule),_DropGenerator.create(rule,de,di,this));
	}
	
	
	void provide(String tag,dynamic provider,{String constructor:null, Function creator: null}){	
		var gen = this.generators.get(this.cache.create(tag));
		
		if(gen == null) throw "$tag rule unavailable!";
		
		if(gen.hasMakable) throw "Provider $tag already provided!";
		
		if(gen.hasNamedArguments && !_namedSupport && creator == null)
			throw new Exception("""
	Name: $tag, Object: $provider , Error: UnimplementedError: named argument support is not implemented
	Due to lack of namedArgument support with ClassMirror.newInstance,
	Please supply a named argument just as below:
	.provide($tag,$provider,creator:(name,{version: null}){
		return new Instance(name,version:version);
	}); """);
	
		var ci = this._useLibrary(provider);
		return gen.use(ci,this.cache.create((constructor != null ? constructor : '')),creator);
	}
			
	Future generate(String tag){
		var component = this.generators.get(this.cache.create(tag));
		if(component == null) return false;
		return component.generate().then((_){
			if(_ is InstanceMirror) return _.reflectee;
			return _;
		});
	}
	
	Future fetchDependency(String tag){
		if(!this.generators.has(this.cache.create(tag))) return null;
		var component = this.generators.get(this.cache.create(tag));
		if(!component.hasDependencies) return new Future.value(null);
		
		return this.assertDependency(tag).then((state){
			if(!state) return null;
		
			var positional = [];
			Map<Symbol,dynamic> named = new Map<Symbol,dynamic>();
			
			var posFuture = Hub.captureEachFuture(component.positionalArguments,(n){
				return this.generators.get(this.cache.create(n)).generate();
			}).then((m){
				m.forEach((_){ _.then((k){ positional.add(k.reflectee); }); });
			});
			
			var namedFuture = Hub.eachFuture(component.namedArguments,(n,v){
				return this.generators.get(this.cache.create(v)).generate().then((_){
					named[n] = _.reflectee;
				});
			});		
			
			return Future.wait([posFuture,namedFuture]).then((_){ 
				if(named.isEmpty) return [positional];
				return [positional,named];
			});
			
		});	
	}
		
	Future assertDependency(String tag){
		var component = this.generators.get(this.cache.create(tag));
		if(component == null) return null;

		if(!component.hasDependencies) return new Future.value(true);
		
		var positional = component.positionalArguments;
		var named = component.namedArguments;
			
		var fpos = Hub.eachFuture(positional,(n){
			var g = this.generators.get(this.cache.create(n));
			return (g != null && g.hasMakable);
		});
		var fnamed = Hub.eachFuture(named,(n,v){
			var g = this.generators.get(this.cache.create(v));
			return (g != null && g.hasMakable);
		});
		
		return Future.wait([fpos,fnamed]).then((_){
			return (((_[0] is bool && _[0] == true) && (_[1] is bool && _[1] == true)) ? true : false);
		});
	}

	void explode(){
		this.cache.flush();
		this.generators.forEach((n){ n.nullify(); })
		this.generators.flush();
	}
}

class InverseManager extends InverseManagerAbstract{
	final manager = Hub.createMapDecorator();
	
	InverseManager();
	
	void createController(String tag,[String libName]){
		this.manager.add(tag,InverseController.create(libName));
	}
		
	InverseController getController(String tag){
		return this.manager.get(tag);
	}
	
	void destroyController(String tag){
		this.get(tag).explode();
	}
		
}
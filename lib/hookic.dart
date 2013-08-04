part of hooks;

class DropGenerator extends DynamicGenerator{
	
	static create(n,d,c) => new DropGenerator(n,d,c);
	
	DropGenerator(name,deps,criteria): super(name,deps,criteria);
	
}

class DropController extends DynamicController{
	
	static create(){
		return new DropController();
	}
		
	DropController();
	
	void define(String ruleName,{ Map dependency:null, Function criteria:null }){
		if(this.generators.has(this.cache.create(ruleName)))
			 throw "Generators Name: $ruleName is already used!"; 
		if(dependency == null) dependency = {'named':{},'positional':[]};
		this.generators.add(this.cache.create(ruleName),DropGenerator.create(ruleName,dependency,criteria));
	}
	
	void provide(String tag,Function generator){
		if(this.providers.has(this.cache.create(tag))) 
			throw "Provider $tag already provided!";
		this.providers.add(this.cache.create(tag),generator);
	}
	
	dynamic generate(String tag){
		return null;
	}
	
	dynamic dropHandler(Invocation n){
	
	}
	
	Future assertDependencies(List positional,Map named){
		var fpos = Hub.forEachFuture(positional,(n){
			print('positional:$n');
			return (this.providers.has(n));
		});
		var fnamed = Hub.forEachFuture(named,(n){
			print('named:$n');
			return (this.providers.has(n));
		});
	}

}
	
@deprecated
class MirrorICController {
	final injected = ds.dsStorage.createMap();
	final interface = ds.dsStorage.createMap();
	
	static create(){
		return new MirrorICController();
	}
	
	void need(String id,dynamic face){
		var mirror = reflectClass(face);
		if(!mirror.isClass) throw new Exception('Second argument must be a class');
		
		var storage = ds.dsStorage.createMap();
		storage.add('class', face);
		storage.add('mirror', mirror);
		interface.add(id,storage);
	}
	
	void provide(String id,dynamic face){
		var sid = this.interface.get(id);
		if(sid == null) throw new Exception('Identifier $id is not valid!');

		var instance = reflect(face);
		var instanceClass = instance.type;
		var seed = sid.get('class');
		var seedClass = sid.get('mirror');
				
	}
	
}


class HookIC extends HookInverseControlAbstract{
		
	static create(){
		return new HookIC();
	}
	
	HookIC(){
		
	}
	
	void inject(Object o){
		
	}
	
}

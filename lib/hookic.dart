part of hooks;

class DynamicAttributes extends HookDynamic{
	
	static create(){ 
		return new DynamicAttributes();
	}
	
	void define(dynamic key,dynamic value){
		this.injected.add(this.generateName(key),value);
	}
	
	dynamic get(dynamic key){
		return this.injected.get(this.generateName(key));
	}
	
	dynamic noSuchMethodCaller(Invocatio n){
		if(this.injected.has(n.memberName)){
			return this.injected.get(n.memberName);
		}
	}
		
}

class DropICController{
	final injected = ds.dsStorage.createMap();
	final attr = ds.dsStorage.createMap();
	
	static create(){
		return new DropICController();
	}
	
	void add(dynamic instance,{String tag:null}){
		try{
			var mirror = reflect(instance);	
			var id = (tag == null) ? this.injected.store.length : tag; 
			this.injected.add(id,{'mirror':mirror, 'instance':instance});
		}
		catch(e){
			throw e;
		}
	}
	
	void defineAttr(dynamic attr,dynamic value){
	
	}
	
	Object noSuchMethod(Invocation n){
		print(n.memberName);
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

		var mirror = reflect(face);
		var seed = sid.get('class');
		var classmirror = sid.get('mirror');
		
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

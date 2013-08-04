part of hooks;
 
abstract class Hookable{
  
    Hookable hook();
    void use();
    void noSuchMethodHook(Invocation m);
    void noSuchMethod(Invocation m){ this.noSuchMethodHook(m); }
}

abstract class HookStackAbstract{
  
  /* 
   * Name: [_call]
   * Description: handles return-transformation serial invocation where calls are made through the
   * ladder of callbacks/namedCallbacks to be executed on method invocations
   * */
  Future _call(Map params);

  /* 
   * Name: [noSuchMethodHandler]
   * Description: lets you redirect the call of noSuchMethod so you can easily customize to needs, for eg, i use it to define
   * a ghost exec method that doesnt exists,instead when called,its redirected to _call
   * */
  Object noSuchMethodHandler(Invocation m); 	

  Object noSuchMethod(Invocation n){
 	 return this.noSuchMethodHandler(n);
  }
  
}

abstract class HookInverseControlAbstract{
  
  /*
   * Name: [inject]
   * Description: takes an object to be injected into the controller as dependency
   * */
  void inject(Object o);
  
}

abstract class HookControllerAbstract{
  
  void _call();
  void disposeAll();
  void flushAll();

}

abstract class HookDynamic{
	final ds.dsMapStorage<Symbol,dynamic> injected = new ds.dsMapStorage<Symbol,dynamic>();
	
	void define();
	void get();
	dynamic noSuchMethodCaller(Invocation n);
		
	dynamic noSuchMethodError(Invocation n){
		this.noSuchMethodCaller(n);
	}
}

abstract class DynamicGenerator{
	String name;
	Function criteria;
	List positionalArguments;
	Map<Symbol,dynamic> namedArguments;
	
	DynamicGenerator(String name,Map dependency,Function criteria){
		this.name = name;
		this.namedArguments = Hub.encryptNamedArguments(dependency['named']);
		this.positionalArguments = dependency['positional'];
		this.criteria = criteria;
	}
	
	bool matchProvider(Object provider){
		return this.criteria(provider);
	}
	
	String toString(){
		return """
			Name: ${this.name}
			PositionalArguments: ${this.positionalArguments}
			NamedArguments:${this.namedArguments}
		""";
	}
}

abstract class DynamicController{
	final cache = Hub.createSymbolCache();
	final generators = InvocationMap.create();
	final providers = InvocationMap.create();
	
	void define(String ruleName,{ Map dependency:null, Function criteria:null });
	
	void provide(String tag,Function generator);
	
	dynamic generate();
	
	dynamic dropHandler(Invocation n);
	
	Object noSuchMethod(Invocation n){
		return this.dropHandler(n);
	}
}
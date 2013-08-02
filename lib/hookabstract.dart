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
	
	Symbol generateName(String n){
		return new Symbol(n);
	}
	
	String getPureName(Symbol n){
		return MirrorSystem.getName(n);
	}
		
	dynamic noSuchMethodError(Invocation n){
		this.noSuchMethodCaller(n);
	}
}



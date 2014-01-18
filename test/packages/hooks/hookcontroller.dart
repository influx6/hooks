part of hooks;

dynamic _staticCallable(List args){
	return (dynamic n){
		return _Utility.funcCaller(n,_Utility.prepareResponse(args));
	};
}

class HookController extends HookControllerAbstract{
  Future returned;
  Future postreturned;
  Future prereturned;
  dynamic _preStack;
  dynamic _postStack;
  Function _handle;
  bool _mutate;
  bool ready = false;

  static dynamic create(Function handle,{bool mutate:false}){
    return new HookController(handle,mutate:mutate);
  }

  HookController(Function handle,{ bool mutate:false}){
    this._handle = handle;
    this._mutate = mutate;
  }

  Future _call(List args){
    if(this._preStack == null && this._postStack == null){
      var core = _staticCallable(_Utility.funcCaller(this._handle,_Utility.prepareResponse(args)));
      return new Future.value(core);
    }

    if(this._preStack != null && this._postStack == null){
      return _Utility.funcCaller(this._preStack.callHook,_Utility.prepareResponse(args)).then((param){
          var bea = new ParamBeautifier(_Utility.prepareResponse(param));
          this.prereturned = new Future.value(param);
          var core = _Utility.funcCaller(this._handle,_Utility.prepareResponse(param));
          var stat = _staticCallable([core]);
          this.returned = new Future.value(stat);
          return stat;
       });
    }

    if(this._preStack == null && this._postStack != null){
	   var core = _Utility.funcCaller(this._handle,_Utility.prepareResponse(args));
	   this.returned = new Future.value(core);
       return new Future.value(core).then((param){
        return this._postStack.callHook(param).then((n){
          var stat = _staticCallable(n);
          this.postreturned = new Future.value(stat);
          return stat;
        });
	   });
    }

	if(this._preStack != null && this._postStack != null){
	  return _Utility.funcCaller(this._preStack.callHook,_Utility.prepareResponse(args)).then((param){
		   var core = _Utility.funcCaller(this._handle,_Utility.prepareResponse(param));
		   this.prereturned = new Future.value(core);
		   this.returned = new Future.value(core);
		   return core;
		}).then((n){
			return this._postStack.callHook(n).then((p){
				var stat = _staticCallable(p);
				this.postreturned = new Future.value(stat);
				return stat;
			});
		});
	}
  }

  dynamic get preStack{
    this.ready = true;
    if(this._preStack == null)
      return this._preStack = HookStack.create(this._mutate);
    return this._preStack;
  }

  dynamic get postStack{
    this.ready = true;
    if(this._postStack == null)
      return this._postStack = HookStack.create(this._mutate);
    return this._postStack;
  }

  dynamic get before => this.preStack;
  dynamic get after => this.postStack;

  Object noSuchMethod(Invocation m){
    if(m.memberName == const Symbol('control')){
      var args = [m.positionalArguments,m.namedArguments];
      return this._call(args);
    }
  }


}

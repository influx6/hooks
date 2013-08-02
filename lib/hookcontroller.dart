part of hooks;

dynamic _staticCallable(List args){
	var beauty = ParamBeautifier.create(args);
	return (dynamic n){
		return _Utility.funcCaller(n,beauty.map);
	};
}

class HookController extends HookControllerAbstract{
  Future returned;
  Future postreturned;
  Future prereturned;
  dynamic preStack;
  dynamic postStack;
  Function _handle;

  static dynamic create(Function handle,{bool mutate:false,bool pre:true, bool post:true}){
	return new HookController(handle,mutate:mutate,pre:pre,post:post);
  }

  HookController(Function handle,{ bool mutate:false, bool pre:true, bool post:true}){
    postStack = post ? HookStack.create(mutate) : null;
    preStack = pre ? HookStack.create(mutate) : null;
    this._handle = handle;
  }

  Future _call(List args){
    if(preStack == null && postStack == null) return Future.value(_Utility.funcCaller(this._handle,args));

    if(this.preStack != null && this.postStack == null){
       return preStack.callHook(args).then((param){
		  var bea = new ParamBeautifier(_Utility.prepareResponse(param));
		  this.prereturned = new Future.value(param);
          var core = _Utility.funcCaller(this._handle,bea.map);
		  var stat = _staticCallable([core]);
		  this.returned = new Future.value(stat);
		  return stat;
       });
    }

    if(this.preStack == null && this.postStack != null){
	   var bea = new ParamBeautifier(_Utility.prepareResponse(param));
	   var core = _Utility.funcCaller(this._handle,bea.map);
	   this.returned = new Future.value(core);
       return new Future.value(core).then((param){
			return this.postStack.callHook(param).then((n){
				var stat = _staticCallable(n);
				this.postreturned = new Future.value(stat);
				return stat;
			});
	   });
    }

	if(this.preStack != null && this.postStack != null){
		return this.preStack.callHook(args).then((param){
		   var bea = new ParamBeautifier(_Utility.prepareResponse(param));
		   var core = _Utility.funcCaller(this._handle,bea.map);
		   this.prereturned = new Future.value(core);
		   this.returned = new Future.value(core);
		   return core;
		}).then((n){
			var bea = _Utility.prepareResponse(n);
			return this.postStack.callHook(bea).then((p){
				var stat = _staticCallable(p);
				this.postreturned = new Future.value(stat);
				return stat;
			});
		});
	}
  }


  Object noSuchMethod(Invocation m){
    if(m.memberName == const Symbol('control')){
      var args = [m.positionalArguments,m.namedArguments];
	  //if(!m.namedArguments.isEmpty) args.add(m.namedArguments);
      return this._call(args);
    }
  }


}

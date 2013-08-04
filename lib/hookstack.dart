part of hooks;

class _Utility{

  static List prepareResponse(param){
	if(param is List){
		if(param.length == 2 && param[0] is List && param[1] is Map) return param;
		if(param.length < 2 || param > 2) return [param];
	}else return [[param]];
	
  }

  static dynamic funcCaller(func,List param){
    if(param.length == 1) return Function.apply(func,param[0]);
    return Function.apply(func,param[0],param[1]);
  }

 static updateTagCount(List tags,String tag){
	if(tags.contains(tag)) return -1;
	tags.add(tag);
	return tags.length - 1;
 }
}

class ParamBeautifier{
    dynamic _params;

    static create(List p){
		return new ParamBeautifier(p);
	}
	
    ParamBeautifier(List p){
      if(p.length > 1) p[1] = Hub.encryptNamedArguments(p[1]);
      this._params = p;
    }

    dynamic get positional { 
      if(this._params.length  > 0) return this._params[0]; 
	  return [];
    }

    dynamic get named { 
      if(this._params.length > 1) return this._params[1];
 	  return new Map<Symbol,dynamic>();
    }

	dynamic get map{
		return this._params;
	}

}

class _MutableHookStack extends HookStack{
  final bool canMutate = true;
  dynamic _callParams;
  
  Future _call(params){
    var cur = null;
	this._callParams = params;
    var done = new Completer();

    if(this._executors.isEmpty){
      done.complete(params);
      return done.future;
    }

    this._executors.forEach((n){
        if(cur == null) cur = n(params);
        else cur = cur.then(n);
    });
    
    cur.then((param){
      done.complete(param);
    });
    
	return done.future;
  }


  Object _handleFeed(feed){
    if(!this._useNamedFlag){
      if(feed.length > 1) return [[feed]];
      return feed;
    }else{
      if(feed is List){
        if(feed.length > 2 || feed.length < 2) return [feed];
        if(feed.length == 2){
          feed[1] = Hub.encryptNamedArguments(feed[1]);
          return feed;
        }
      }
    }
  }
  
  dynamic get feed{
	  return this._callParams;
  }

}

class _ImmutableHookStack extends HookStack{
  final bool canMutate = false;
  dynamic _callParams;
  
  Future _call(params){
	  this._callParams = params;
      var done = new Completer();
      if(this._executors.isEmpty){
        done.complete(params);
        return done.future;
      }
      var it = Future.forEach(this._executors,(n){
         n(params);
        return new Future.value(0);
      });
	
	it.whenComplete((){ 
      done.complete(param);
	});

	return done.future;
  }

  Object _handleFeed(feed){
    return feed;
  }
  
  dynamic get feed{
	  return this._callParams;
  }

}

class HookStack extends HookStackAbstract{
  bool _useNamedFlag = false;
  final _exec = const Symbol('exec');
  final _cache = new Map();
  final List _executors = new List();

  static create(bool mutate){
    if(!mutate) return new _ImmutableHookStack();
    else return new _MutableHookStack();
  }

  void add(dynamic executable,{String tag:null}){
    var handle = (params){
      var feed = this._handleFeed(params);
      var it = _Utility.funcCaller(executable,feed);
      if(it is! Future && it is! Completer) it = new Future.value(it);
      if(it is Completer) it = it.future;
      return it;
    };

	if(tag != null){
		if(this._cache.containsKey(tag)) throw new Error('Tag already used!');	
		this._cache[tag] = this._executors.length;	
	}
	
	this._executors.add(handle);
	
  }

  void removeTag(String tag){
	if(this._cache.containsKey(tag)){ 
		this._executors.removeAt(this._cache[tag]);
		this._cache.remove(tag);
	}
  }

  void flush(){
	this._executors.clear();
  }

  Future _call(arg);

  Future callHook(List a){
	var test = new ParamBeautifier(a);
	if(!test.named.isEmpty) this._useNamedFlag = true;
	return this._call(a);
  }

  Object noSuchMethodHandler(Invocation m){
    if(!m.namedArguments.isEmpty) this._useNamedFlag = true;
    var args = new List();
    args.add(m.positionalArguments);
    if(this._useNamedFlag) args.add(m.namedArguments);
    if(m.memberName == this._exec){
      return this._call(args);
    }
  }

}

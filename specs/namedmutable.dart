library Specs;

import 'package:hooks/hooks.dart';

main(){
  var m = HookStack.create(true);

  m.add((keys,{String name:null}){
    keys.sort();
    print('recieved: $keys :$name');
    return [[keys],{'name':name}];
  },tag:'sort');

  m.add((keys,{String name: null}){
	keys.add(665);
      name = "sugar";
      return [[keys],{'name':name}];
  },tag:'merger');

  m.add((keys,{String name: null}){
    print('got: $keys : $name');
      return [[keys],{'name':name}];
  },tag:'printer');


  m.exec([1,2,323,23223,2],name:'alex').then((param){
		var m = new ParamBeautifier(param);
		print('execution finished: ${m.positional} and with keys ${m.named}');
  });
  m.flush();
}

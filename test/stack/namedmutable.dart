library specs;

import 'package:hooks/hooks.dart';

main(){
  var m = HookStack.create(true);

  m.add((keys,{String name:null}){
    keys.sort();
    return [[keys],{'name':name}];
  },tag:'sort');

  m.add((keys,{String name: null}){
      keys.add(665);
      name = "sugar";
      return [[keys],{'name':name}];
  },tag:'merger');

  m.add((keys,{String name: null}){
    print('got: $keys : $name but not returning anything');
  },tag:'noreturner');

  m.add((keys,{String name: null}){
      return [[keys],{'name':name}];
  },tag:'printer');

  m.exec([1,2,323,23223,2],name:'alex').then((param){
		var mm = new ParamBeautifier(param);
		print('execution finished: ${mm.positional} and with keys ${mm.named}');
  });
  m.flush();
}keys

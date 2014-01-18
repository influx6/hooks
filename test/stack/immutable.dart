library specs;

import 'package:hooks/hooks.dart';

main(){

  var m = HookStack.create(false);
  var m1 = HookStack.create(false);

  m.add((keys){
    print('recieved: $keys');
    return keys;
  },tag:'sort');

  m.add((keys){
    keys += "11";
    return keys;
  },tag:'merger');

  m.add((keys){
    print('got: $keys');
    return keys;
  },tag:'printer');

  m1.add((keys,{name:null}){
	print('success: $keys : $name');
  });

  m1.exec([1,32],name:'alex');
  m.exec("alex");
  
}

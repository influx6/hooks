library Specs;

import 'package:hooks/hooks.dart';

main(){  
  var m = HookStack.create(true);
  var m1 = HookStack.create(true);

  m.add((keys){
    keys.sort();
    return keys;
  });

  m.add((keys){
	keys.add(665);
      return keys;
  });

  m.add((keys){
    print('printer: $keys');
    return keys;
  },tag:'printer');

  m1.add((name){
	print('prefixing: $name');
	var pre = "Mr. ".concat(name);
    return pre;
  });

  m1.add((name){
	 print('suffixing: $name');
	 var suf = name.concat(" hoostack!");
     return suf;
  });

  m1.add((name){
    print('got: $name');
    return name;
  });

  m.exec([12,43,1,3,4,435,2]);
  m1.callHook([["alex"]]).then((m){ print("$m"); });

}
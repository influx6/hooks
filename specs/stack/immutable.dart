part of specs;

immutable(){

  var m = HookStack.create(false);
  var m1 = HookStack.create(false);

  m.add((keys){
    keys.sort();
    print('recieved: $keys');
    return keys;
  },tag:'sort');

  m.add((keys){
	var key = new List();
	key.addAll(keys);
	key.add(665);
    return key;
  },tag:'merger');

  m.add((keys){
    print('got: $keys');
    return keys;
  },tag:'printer');

  m1.add((keys,{name:null}){
	print('success: $keys : $name');
  });

  m1.exec([1,32],name:'alex');
  m.exec([12,43,1,3,4,435,2]);
  
}

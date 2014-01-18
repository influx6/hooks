library specs;

import 'package:hooks/hooks.dart';

main(){
	
	var controller = HookController.create((name){
    print("infix: $name");
		return name;
	},mutate:true);
	
	controller.preStack.add((name){
    print("pre $name");
    name = "Mr. "+name;
		return name;
	});
	
	controller.postStack.add((name){
    print(name);
		name = name + (" Goolum!"); 
		return name;
	});
	
	controller.control("1").then((runnable){
		runnable((name){
			print('Reply: my name is $name');	
		});
	});
	
}

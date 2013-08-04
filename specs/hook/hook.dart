library hookspec;

import 'dart:mirrors';
import 'fixtures.dart';
import 'package:ds/ds.dart' as ds;
import 'package:hooks/hooks.dart' as hook;

part 'loader.dart';

main(){
	
	var library = currentMirrorSystem();
	print(library.libraries);
	
	// var libs = MirrorSystem.findLibrary(const Symbol('ds'));
// 	print(libs);
	
	var hc = hook.MirrorICController.create();
	hc.need('map',Cage);
	hc.need('list',ds.dsListStorage);	
	hc.provide('map',new ds.dsMapStorage());
	
	
	var dc = hook.DropController.create();
// 	dc.add(new ds.dsMapStorage(),tag:'pump');

	dc.define('Calculator',dependency:{ 
		'named': {'mutiplier':'Multiplier', 'divider':'Divider'},
		'positional': ['Adder','Subtracter']
	},criteria:(i){ 
		if(i is CaculatorInterface) return true; 
		return false; 	
	});
	
	dc.define('Add',criteria:(i){
		if(i is AddInterface) return true; 
		return false; 
	});
	
	dc.define('Subtract',criteria:(i){
		if(i is SubtractInterface) return true; 
		return false; 
	});
	
	dc.define('Mutiplier',criteria:(i){
		if(i is MutiplierInterface) return true; 
		return false; 
	});

	dc.define('Divider',criteria:(i){
		if(i is DividerInterface) return true; 
		return false; 
	});
	
// 	dc.provide('Calculator',Calculator);
// 	
// 	dc.provide('Add',Add);
// 	
// 	dc.provide('Subtract',Subtract);
// 	
// 	dc.provide('Multiplier',Multiplier);
// 	
// 	dc.provide('Divider',Divider);
// 	
// 	var calculator = dc.generate("Calculator");
// 	assert(calculator is Calculator);
	
}

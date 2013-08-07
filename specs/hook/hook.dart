library hookspec;

import 'dart:mirrors';
import 'fixtures.dart';
import 'package:hub/hub.dart';
import 'package:ds/ds.dart' as ds;
import 'package:hooks/hooks.dart' as hook;

main(){

	var fix = Hub.singleLibrary('fixtures');
	var cal = fix.getClass('Calculator');
	var match = fix.matchClassWithInterface('Calculator','CalculatorInterface');
	
	//you can optionally supply a library name from which it can retrieve class by strings
	// when calling the define and provide methods
	var dc = hook.InverseController.create('fixtures');

	dc.define('Calculator','CalculatorInterface',{ 
		'named': {'multiply':'Multiply', 'divider':'Divider'},
		'positional': ['Add','Subtract']
	});
	
	dc.define('Calculator.clone','CalculatorInterface',{
		'positional': ['Add','Subtract']
	});
	
	dc.define('Add','Operable');
	
	dc.define('Subtract','Operable');
	
	dc.define('Multiply','Operable');

	dc.define('Divider','Operable');
	
	//when the second argument is a string then we get the name of that library as stated
	//by the string  from the currentMirrorSystem libraries list
	dc.provide('Add','Add');
	
	dc.provide('Subtract',"Subtract");
	
	//you can also provide the class name directly
	dc.provide('Multiply',Multiply);
	
	dc.provide('Divider',"Divider");
	
	dc.fetchDependency('Calculator').then((n){
		assert(n is List && n != null);
	});
	
	//ensure to pass a creator:(){} which deals with the ClassMirror.newInstance lack of support for named arguments
	dc.provide('Calculator','Calculator',creator:(add,subtract,{multiply:null,divider: null}){
		return new Calculator(add,subtract,multiply:multiply,divider:divider);		
	});
	
	// by specifying the constructor:value,you can divde what contructor to use
	dc.provide('Calculator.clone','Calculator',constructor:'clone');
	
	dc.generate("Calculator").then((_){
		assert(_ is Calculator);
		assert(_.add(4,4) == 8);		
		assert(_.subtract(4,2) == 2);		
		assert(_.multiply(4,4) == 16);		
		assert(_.divide(4,4) == 1);		
	});
	
	dc.generate("Calculator.clone").then((_){
		assert(_ is Calculator);		
		assert(_.add(4,4) == 8);		
		assert(_.subtract(4,2) == 2);		
		assert(_.multiply(4,4) == 16);		
		assert(_.divide(4,4) == 1);
	});
	
	dc.generate("Add").then((_){
		assert(_ is Add);		
		assert(_.compute(4,4) == 8);
	});
	
	dc.generate("Subtract").then((_){
		assert(_ is Subtract);		
		assert(_.compute(4,4) == 0);
	});
	
	dc.generate("Multiply").then((_){
		assert(_ is Multiply);		
		assert(_.compute(4,4) == 16);
	});
	
	dc.generate("Divider").then((_){
		assert(_ is Divider);		
		assert(_.compute(4,4) == 1);
	});
	
}

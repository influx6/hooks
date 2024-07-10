## DEPRECATED - DO NOT USE

# Hooks
####Version: 0.0.1
####Description: 
	hooks is a library with a very simple goal and follows the ideals that simplicity is the ultimate sophistication and underneath hooks provides a few candies for the masses.
	
### Cande 1: HookStacks
	
		HookStack meets my needs for some form of callback chain that operates in a different manner,it allows the modification of the returned value of such a function call if needed. Meaning we can create a hookstack to sit upon a regular function and when invocation time comes around we can perform some pre or post operations which can also affect the returned value of that call. HookStack is the unit mechanism for this but its more preferable to use a HookController which automates the whole tasks for setting up a pre and post stacks.
		
Types of HookStack: 
		
* MutableHookStack 
	
			allows the mutation of the return type by the callback chains return when its invoked, allowing a situation where the next callback in the chain receives a modified return value if a value was returned or else uses the last returned value to continue execution of the callback stack. eg:
    > 		var m = HookStack.create(true);
    > 
    >         m.add((keys,{String name:null}){
    >             keys.sort();
    >             print('recieved: $keys :$name');
    >		      //return values containing both positional 
    >			  // and named values
    >   		 // must be specified in this manner otherwise they
    >		     // can simply be returned as usual
    >             return [[keys],{'name':name}];
    >         },tag:'sort');
    >         
    >         m.add((keys,{String name: null}){
    > 	        keys.add(665);
    >             var name = "sugar";
    >             return [[keys],{'name':name}];
    >         },tag:'merger');
    >         
    >	      // the named argument tag is optional,incase you wish to be able to remove a specific callback out of chain without affecting other callback in chain
    >         m.add((keys,{String name: null}){
    >             print('got: $keys : $name but not returning anything');
    >         });
    >         
    >         m.add((keys,{String name: null}){
    >             print('got: $keys : $name');
    >             return [[keys],{'name':name}];
    >         },tag:'printer');
    >         
    >         m.exec([1,2,323,23223,2],name:'alex').then((param){
    > 		        var mm = new ParamBeautifier(param);
    > 		        print('execution finished: ${mm.positional} and with keys ${mm.named}');
    >                     print('returned stack: ${m.retStack}');
    >         });
    >		  
    >		 // removes callback with tag printer from callback chain
    >		  m.removeTag('printer');
    >		// removes all callbacks
    >         m.flush();
		
	* ImmutableHookStack 
	
			simple runs the callback chain and returns the original parameters passed to the stack. eg:
    >     var m = HookStack.create(false);
    >     
    >     var m1 = HookStack.create(false);
    >     
    >     m.add((keys){
    >         keys.sort();
    >         print('recieved: $keys');
    >         return keys;
    >     },tag:'sort');
    >     
    >     m.add((keys){
    > 	    var key = new List();
    > 	    key.addAll(keys);
    > 	    key.add(665);
    >         return key;
    >     },tag:'merger');
    >     
    >     m.add((keys){
    >         print('got: $keys');
    >         return keys;
    >     },tag:'printer');
    >     
    >     m1.add((keys,{name:null}){
    > 	    print('success: $keys : $name');
    >     });
    >
    >     m1.add((keys,{name:null}){
    > 	    print('success2: $keys : $name');
    >		// the return value will be discarded
    >		return [[[1,32,23],{'name':name}];
    >     }); 
    >     
    >     m1.exec([1,32],name:'alex');
    >     
    >     m.exec([12,43,1,3,4,435,2]);
  
  * HookController

			The hookcontroller lets you bind a function call to a pre and post hookstack and depending if the value is allowed to be modified ,it feeds in the return value if the stacks are mutable to the function as such,allows a form of pre-evaluation of arguments and post evaluation of returned value of the function call. eg:				
> 	    var controller = HookController.create((name,{sex:null}){
>			//the return value is up to you,you are not required to returned value in this format,just ensure your poststack callbacks align with the value type and format being returned
> 		    return [[name],{'sex':sex}];
> 	    },mutate:true);
> 	    
> 	    controller.preStack.add((name,{sex:null}){
> 		    print('pre: $name : $sex');
> 		    return [["Mr. ".concat(name)],{'sex':sex}];
> 	    });
> 	    
> 	    controller.postStack.add((name,{sex:null}){
> 		    print('post: $name : $sex');
> 		    return [[name.concat(" Goolum!")],{'sex':'female'}];
> 	    });
> 	    
> 	    controller.control("Alex",sex:'male').then((runnable){
>			//unlike a hookstack,a controllers future completes with a function to allow easier syntax,simple call the function as below
> 		    runnable((name,{sex:null}){
> 			    print('Reply: my name is $name and am a $sex');	
> 		    });
> 	    });

### Candy 2:  InverseController

		Due to my love of the topic of dependency injection,it was decided early on that hooks will come with a flavor of a very simplified,don't get in the way style implementation which had the gaols of not requiring any special syntax or coding style,except simple requiring all injected objects are passed using the constructor method. By taking the approach of a object generator,the HookInverseController was made. eg:		
>
> 	    //assert classmirror support for named arguments to be false hence its still not resolved by dart team
> 	    assert(Hub.classMirrorInvokeNamedSupportTest() == false);
> 	    
>	
> 	    //you can optionally supply a library name from which itcan 
>		//retrieve class by strings
> 	    // when calling the define and provide methods
> 	    var dc = hook.InverseController.create('fixtures');
>     
>		//defines a object to be created,arguments are:
>		//name,nameOfInterface(String or unstring), arguments map
>
> 	    dc.define('Calculator','CalculatorInterface',{ 
>		//named arguments will be giving the key as used in the map 
> 		    'named': {'multiply':'Multiply', 'divider':'Divider'},
> 		    'positional': ['Add','Subtract']
> 	    });
> 	    
> 	    dc.define('Calculator.clone','CalculatorInterface',{
> 		    'positional': ['Add','Subtract']
> 	    });
> 	    
> 	    dc.define('Add','Operable');
> 	    
> 	    dc.define('Subtract','Operable');
> 	    
> 	    dc.define('Multiply','Operable');
>     
> 	    dc.define('Divider','Operable');
> 	    
> 	    //when the second argument is a string then we 
>		//get the name of that library as stated
> 	    //by the string  from the library name passed which contains the library or else simple pass the name of the class unstringed
> 	    dc.provide('Add','Add');
> 	    
> 	    dc.provide('Subtract',"Subtract");
> 	    
> 	    //you can also provide the class name directly
> 	    dc.provide('Multiply',Multiply);
> 	    
> 	    dc.provide('Divider',"Divider");
> 	    
> 	    dc.fetchDependency('Calculator').then((n){
> 		    assert(n is List && n != null);
> 	    });
> 	    
> 	    //ensure to pass a creator:(){} if it uses named 
>		//arguments due to ClassMirror.newInstance lack 
>		//of support for named arguments
> 	    dc.provide('Calculator','Calculator',creator:(add,subtract,{multiply:null,divider: null}){
> 		    return new Calculator(add,subtract,multiply:multiply,divider:divider);		
> 	    });
> 	    
> 	    // by specifying the constructor:value,you can define what contructor to use
> 	    dc.provide('Calculator.clone','Calculator',constructor:'clone');
> 	    
> 	    dc.generate("Calculator").then((_){
> 		    assert(_ is Calculator);
> 		    assert(_.add(4,4) == 8);		
> 		    assert(_.subtract(4,2) == 2);		
> 		    assert(_.multiply(4,4) == 16);		
> 		    assert(_.divide(4,4) == 1);		
> 	    });
> 	    
> 	    dc.generate("Calculator.clone").then((_){
> 		    assert(_ is Calculator);		
> 		    assert(_.add(4,4) == 8);		
> 		    assert(_.subtract(4,2) == 2);		
> 		    assert(_.multiply(4,4) == 16);		
> 		    assert(_.divide(4,4) == 1);
> 	    });
> 	    
> 	    dc.generate("Add").then((_){
> 		    assert(_ is Add);		
> 		    assert(_.compute(4,4) == 8);
> 	    });
> 	    
> 	    dc.generate("Subtract").then((_){
> 		    assert(_ is Subtract);		
> 		    assert(_.compute(4,4) == 0);
> 	    });
> 	    
> 	    dc.generate("Multiply").then((_){
> 		    assert(_ is Multiply);		
> 		    assert(_.compute(4,4) == 16);
> 	    });
> 	    
> 	    dc.generate("Divider").then((_){
> 		    assert(_ is Divider);		
> 		    assert(_.compute(4,4) == 1);
>
>     class Cage{
> 	    
> 	    Cage();
> 	    
> 	    String toString() => "CageObject";
>     }
> 	    
>     class CalculatorInterface{
> 	    dynamic add(a,b);
> 	    dynamic multiply(a,b);
> 	    dynamic divide(a,b);
> 	    dynamic subtract(a,b);
>     }
>     
>     class Operable{
> 	    dynamic compute(a,b);
>     }
>     
>     class Calculator implements CalculatorInterface{
> 	    Add adder;
> 	    Subtract subtracter;
> 	    Multiply multiplier;
> 	    Divider divider;
> 	    
> 	    Calculator(Add a,Subtract s,{Multiply multiply:null,Divider divider:null}){
> 		    this.adder = a;
> 		    this.subtracter = s;
> 		    this.divider = divider;
> 		    this.multiplier = multiply;
> 	    }
> 	    
> 	    factory Calculator.clone(Add a,Subtract s){
> 		    var z = new Calculator(a,s,multiply:new Multiply(),divider:new Divider());
> 		    return z;
> 	    }
> 	    
> 	    dynamic add(num a,num b){
> 		    return this.adder.compute(a,b);
> 	    }
> 	    
> 	    dynamic subtract(num a,num b){
> 		    return this.subtracter.compute(a,b);
> 	    }
> 		    
> 	    dynamic multiply(num a,num b){
> 		    return this.multiplier.compute(a,b);
> 	    }
> 		    
> 	    dynamic divide(num a,num b){
> 		    return this.divider.compute(a,b);
> 	    }
> 	    
>     }
> 	    
>     class Add implements Operable{
> 	    Add(){}
> 	    dynamic compute(num a,num b) => a+b; 
>     }
> 	    
>     class Subtract implements Operable{
> 	    Subtract();
> 	    dynamic compute(num a,num b) => a-b; 
>     }
> 	    
>     class Multiply implements Operable{
> 	    Multiply();
> 	    dynamic compute(num a,num b) => a*b; 
>     }
> 	    
>     class Divider implements Operable{	
> 	    Divider();
> 	    dynamic compute(num a,num b) => a/b; 
>     }

### More Candies Comming!

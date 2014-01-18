library fixtures;

class Cage{
	
	Cage();
	
	String toString() => "CageObject";
}
	
class CalculatorInterface{
	dynamic add(a,b);
	dynamic multiply(a,b);
	dynamic divide(a,b);
	dynamic subtract(a,b);
}

class Operable{
	dynamic compute(a,b);
}

class Calculator implements CalculatorInterface{
	Add adder;
	Subtract subtracter;
	Multiply multiplier;
	Divider divider;
	
	Calculator(Add a,Subtract s,{Multiply multiply:null,Divider divider:null}){
		this.adder = a;
		this.subtracter = s;
		this.divider = divider;
		this.multiplier = multiply;
	}
	
	factory Calculator.clone(Add a,Subtract s){
		var z = new Calculator(a,s,multiply:new Multiply(),divider:new Divider());
		return z;
	}
	
	dynamic add(num a,num b){
		return this.adder.compute(a,b);
	}
	
	dynamic subtract(num a,num b){
		return this.subtracter.compute(a,b);
	}
		
	dynamic multiply(num a,num b){
		return this.multiplier.compute(a,b);
	}
		
	dynamic divide(num a,num b){
		return this.divider.compute(a,b);
	}
	
}
	
class Add implements Operable{
	Add(){}
	dynamic compute(num a,num b) => a+b; 
}
	
class Subtract implements Operable{
	Subtract();
	dynamic compute(num a,num b) => a-b; 
}
	
class Multiply implements Operable{
	Multiply();
	dynamic compute(num a,num b) => a*b; 
}
	
class Divider implements Operable{	
	Divider();
	dynamic compute(num a,num b) => a/b; 
}
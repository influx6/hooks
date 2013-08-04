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

class AddInterface{
	dynamic add(a,b);
}

class SubtractInterface{
	dynamic subtract(a,b);
}

class DivideInterface{
	dynamic divide(a,b);
}

class MultiplyInterface{
	dynamic mutilply(a,b);
}

class Calculator implements CalculatorInterface{
	Add adder;
	Subtract subtracter;
	Multiply multiplier;
	Divider divider;
	
	Calculator(Add a,Subtract s,{Multiply multiplier:null,Divider divider:null}){
		this.adder = a;
		this.subtracter = s;
		this.divider = divider;
		this.multiplier = multiplier;
	}
	
	dynamic add(num a,num b){
		return this.adder(a,b);
	}
	
	dynamic subtract(num a,num b){
		return this.subtracter.subtract(a,b);
	}
		
	dynamic multiply(num a,num b){
		return this.multiplier.multiply(a,b);
	}
		
	dynamic divide(num a,num b){
		return this.divider.divide(a,b);
	}
	
}
	
class Add implements AddInterface{
	dynamic add(num a,num b) => b+a; 
}
	
class Subtract implements SubtractInterface{
	dynamic subtract(num a,num b) => b-a; 
}
	
class Multiply implements MultiplyInterface{
	dynamic multiply(num a,num b) => a*b; 
}
	
class Divider implements DivideInterface{	
	dynamic divide(num a,num b) => a/b; 
}
part of hooks;

class HookICController {
	final injected = Storage<dynamic,dynamic>.createMap();
	
	static create(){
		return new HookICController();
	}
	
}


class HookIC extends HookInverseControl{
		
	static create(){
		return new HookIC();
	}
	
	HookIC(){
		
	}
	
	void inject(Object o){
		
	}
	
}
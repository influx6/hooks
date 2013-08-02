part of specs;


contoller(){
	
	var controller = HookController.create((name,{sex:null}){
		return [[name],{'sex':sex}];
	},mutate:true);
	
	controller.preStack.add((name,{sex:null}){
		print('pre: $name : $sex');
		return [["Mr. ".concat(name)],{'sex':sex}];
	});
	
	controller.postStack.add((name,{sex:null}){
		print('post: $name : $sex');
		return [[name.concat(" Goolum!")],{'sex':'female'}];
	});
	
	
	controller.control("Alex",sex:'male').then((runnable){
		runnable((name,{sex:null}){
			print('Reply: my name is $name and am a $sex');	
		});
	});
	
}
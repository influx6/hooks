library hookspec;

import 'dart:mirrors';
import 'package:ds/ds.dart' as ds;
import 'package:hooks/hooks.dart' as hook;

main(){
			
	var hc = hook.MirrorICController.create();
	hc.need('map',ds.dsMapStorage);
	hc.need('list',ds.dsListStorage);	
	hc.provide('map',new ds.dsMapStorage());
	
	var dc = hook.DropICController.create();
	dc.add(new ds.dsMapStorage());
	dc.add(new ds.dsMapStorage(),tag:'pump');
	
	var da = hook.DynamicAttributes.create();
	da.define('clobber','clobbing it down!');
// 	da.define(1,'one');

	var map = ds.dsMapStorage.create();
	map.date = 43;
	
}

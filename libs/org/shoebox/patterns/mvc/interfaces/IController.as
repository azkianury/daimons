package org.shoebox.patterns.mvc.interfaces {
	import flash.events.Event;		
	/**
	 * @author shoe[box]
	 */
	public interface IController {
		
		function onEvent(e:Event):void;
		function initialize():void;
		function cancel(e:Event = null):void;
		
	}
}

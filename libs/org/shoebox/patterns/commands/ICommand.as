package org.shoebox.patterns.commands {
	import flash.events.IEventDispatcher;
	import flash.events.Event;			/**
	 * @author shoe[box]
	 */
	public interface ICommand extends IEventDispatcher{
		
		function onExecute(e:Event = null):void;
		
		function onCancel(e:Event = null):void;
		
	}
}

package org.shoebox.patterns.mvc.interfaces {
	import flash.events.Event;

	/**
	 * @author shoe[box]
	 */
	public interface IModel {
		
		function initialize( e : Event = null ):void;
		function cancel(e:Event = null):void;
		
	}
}

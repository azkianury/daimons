package org.shoebox.patterns.commands.samples {
	import flash.events.Event;

	/**
	 * @author shoe[box]
	 */
	public interface IResizeable {
		
		function onResize(e:Event = null):void;
	}
}

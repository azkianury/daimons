package org.shoebox.patterns.commands.samples {
	import flash.events.Event;

	/**
	 * @author shoe[box]
	 */
	public interface IStageable {
		
		function onStaged(e:Event = null):void;		function onRemoved(e:Event = null):void;
		
	}
}

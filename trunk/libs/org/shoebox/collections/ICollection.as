package org.shoebox.collections {
	import flash.events.IEventDispatcher;

	/**
	 * @author shoe[box]
	 */
	public interface ICollection extends IEventDispatcher {
		
		function addItem( ...items : Array):Boolean;
		
	}
}
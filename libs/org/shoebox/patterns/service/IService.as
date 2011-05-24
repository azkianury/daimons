package org.shoebox.patterns.service {
	import flash.events.IEventDispatcher;

	/**
	 * @author shoe[box]
	 */
	public interface IService extends IEventDispatcher{
		
		function onCall() : void;
		function onRefresh() : void;
		
	}
}

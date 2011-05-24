package org.shoebox.interfaces {
	import flash.events.IEventDispatcher;
	/**
	 * @author shoe[box]
	 */
	public interface ISignal extends IEventDispatcher {
		
		function connect( f : Function , c : * = null , prio : uint = 0 , bOS : Boolean = false , from : * = null ):Boolean;
		function disconnect( f : Function , c : * ) : Boolean;
		function emit( c : * = null , ...values : Array ) : Boolean;
		function disconnectChannel( c : * ) : void
		
	}
}

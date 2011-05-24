package org.shoebox.io.form {
	import flash.events.IEventDispatcher;			
	/**
	 * @author shoe[box]
	 */
	public interface IField extends IEventDispatcher {
				function validate():Boolean;
		function get value():String;
		
	}
}

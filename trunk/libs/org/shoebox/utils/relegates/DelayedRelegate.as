/**
* This is about <code>org.shoebox.utils.relegates.DelayedRelegate</code>.
* {@link www.hyperfiction.fr}
* @author shoe[box]
*/

package org.shoebox.utils.relegates {

	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.commands.ICommand;
	import org.shoebox.utils.logger.Logger;
	import org.shoebox.utils.namespaces.SignalMode;
	import org.shoebox.utils.system.SignalFromEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	* Relegated <code>Timer</code>
	*  
	* org.shoebox.utils.relegates.DelayedRelegate
	* @author shoebox
	*/
	public class DelayedRelegate extends AbstractCommand implements ICommand {
		
		public var sgTick				: SignalFromEvent;
		public var sgComplete				: SignalFromEvent;
		
		protected var _fRef				: Function;
		protected var _oTimer				: Timer;
		
		// -------o constructor
		
			/**
			* Constructor of the AScript command class
			*
			* @public
			* @return	void
			*/
			public function DelayedRelegate(f : Function, delay : Number, repeat : int) : void {
				super(SignalMode );
				cancelable = false;
				_fRef = f;
				_oTimer = new Timer( delay , repeat );
			}

		// -------o public
			
			/**
			* Executing the command
			* 
			* @public
			* @param	e : optional event (Event) 
			* @return	void
			*/
			override public function onExecute( e : Event = null ) : void {
				
				sgTick = connectEvent( _oTimer , TimerEvent.TIMER , null , false  );
				sgTick.bBroadcastEvent = true;
				sgTick.add( _fRef );
				
				sgComplete = connectEvent( _oTimer , TimerEvent.TIMER_COMPLETE , null , false );
				sgComplete.add( _onComplete );
				
				_oTimer.start( );
				
			}
			
			/**
			* When the command is canceled
			* 
			* @public
			* @param	e : optional event (Event)	 
			* @return	void
			*/
			override public function onCancel( e : Event = null ) : void {
			
				if( _oTimer.running )
					_oTimer.stop( );
				
				sgComplete.cancel( );
				sgTick.cancel( );
			}
			
			/**
			* stop function
			* @public
			* @param 
			* @return
			*/
			final public function stop() : void {
				_oTimer.stop( );
			}
			
			/**
			* reset function
			* @public
			* @param 
			* @return
			*/
			final public function reset() : void {
				_oTimer.reset( );
			}
			
			/**
			* get timer function
			* @public
			* @param 
			* @return
			*/
			final public function get timer() : Timer {
				return _oTimer;
			}
			
		// -------o protected
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _onTimer( ...args : Array ) : void {
				
			}
			
			/**
			* After an delay, the <code>DelayedRelegate</code> canceld
			*
			* @param	e : Timer arguments		( TimerEvent ) 
			* @return	void
			*/
			final protected function _onDelayed( e : TimerEvent ) : void {
				_fRef( e );
			}
			
			/**
			* When the Timer is Completed, canceling the <code>DelayedRelegate</code> command
			*
			* @param	e : Timer arguments		( TimerEvent ) 
			* @return	void
			*/
			final protected function _onComplete( ) : void {
				cancel( );
				onComplete( );
			}
			
		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(DelayedRelegate, args);
			}
	}
}

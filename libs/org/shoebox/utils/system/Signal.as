/**
  HomeMade by shoe[box]
 
  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of shoe[box] nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.shoebox.utils.system {

	import org.shoebox.interfaces.ISignal;
	import org.shoebox.utils.logger.Logger;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	* org.shoebox.utils.system.Signal
	* @author shoebox
	*/
	public class Signal extends EventDispatcher implements ISignal {
		
		protected var _vListeners			: Vector.<SignalListener>;
		protected var _vEvents				: Vector.<SignalFromEvent>;
		
		// -------o constructor
		
			/**
			* Constructor of the Signal class
			*
			* @public
			* @param 	listeners	: Optional vector of listeners functions		( Vector.<Function> )
			* @return	void
			*/
			public function Signal( listeners : Vector.<Function> = null ) : void {
				
				_vListeners = new Vector.<SignalListener>( );
				_vEvents 	= new Vector.<SignalFromEvent>( );
				
				if( listeners !== null ){
					
					var f : Function;
					for each( f in listeners )
						connect( f );
					
				}
			
			}

		// -------o public
			
			/**
			* Register a listener function to the Signal
			* 
			* @public
			* @param	f 	: Function to be registered	( Function ) 
			* @param	prio 	: Listener priority			( uint )
			* @param	bOS 	: One shot usage				( Boolean )
			* @return	void
			*/
			final public function connect( f : Function , c : * = null , prio : uint = 0 , bOS : Boolean = false , from : * = null ) : Boolean {
			
				if( isRegistered( f , c ) )
					return false;
								
				_vListeners.push( new SignalListener( f , c , prio , bOS , from ) );
				_vListeners = _vListeners.sort( _sortFunc );
					
				return true;
			}
			
			/**
			* connectEvent function
			* @public
			* @param 
			* @return
			*/
			final public function connectEvent( 
										target : IEventDispatcher , 
										sType : String , 
										channel : * = null , 
										bubble : Boolean = false , 
										cType : Class = null , 
										...args: Array 
									) : SignalFromEvent {
										
				var 	o : SignalFromEvent = new SignalFromEvent( target , bubble, sType , (channel == null) ? sType : channel , this , cType , args );
				_vEvents.push( o );	
				return o;
				
			}
			
			/**
			* hasListener function
			* @public
			* @param 
			* @return
			*/
			final public function hasListener( c : * = null ) : Boolean {
				
				var o : SignalListener;
				for each( o in _vListeners ){
					
					if( o.channel == c ) 
						return true;
						
				}
				
				return false;
			}
			
			/**
			* disconnectEvent function
			* @public
			* @param 
			* @return
			*/
			final public function disconnectEvent( target : IEventDispatcher , sType : String , channel : * = null , b : Boolean = false ) : void {

				
				if( channel == null )
					channel = sType;
				
				var func : Function = function( o : SignalFromEvent , i : uint , v : Vector.<SignalFromEvent> ) : Boolean{
					
					if( o.oFrom == target && o.sType == sType && o.channel == channel && o.bBubbling == b ){
						o.cancel( );
						return false;
					}
					return true;
				};
				
				_vEvents = _vEvents.filter( func );
				trace('_vEvents ::: '+_vEvents.length);
			}
			
			/**
			* unRegister function
			* @public
			* @param 
			* @return
			*/
			final public function disconnect( f : Function , c : * ) : Boolean {
				
				
				var i : uint = 0;
				var l : uint = _vListeners.length;
				var s : SignalListener;
				for( i ; i < l ; i++ ){
					
					if( _vListeners[i].fRef == f && _vListeners[i].channel == c ){
						s = _vListeners[i];
						break;
					}
					 
				}
				
				if( s == null )
					return false;
				
				_vListeners.splice( _vListeners.indexOf(s) , 1 );
				
				return true;
				
			}
			
			/**
			* disconnectChannel function
			* @public
			* @param 
			* @return
			*/
			final public function disconnectChannel( c : * ) : void {
				
				//
					var func : Function = function( s : SignalListener , i : uint , v : Vector.<SignalListener> ) : Boolean{
						
						if( s.channel == s )
							return false;
						
						return true;
					};
					_vListeners = _vListeners.filter( func );
				
			}
			
			/**
			* isRegistered function
			* @public
			* @param 
			* @return
			*/
			final public function isRegistered( f : Function , c : * ) : Boolean {
				
				var i : uint = 0;
				var l : uint = _vListeners.length;
				for( i ; i < l ; i++ ){
					
					if( _vListeners[i].fRef == f && _vListeners[i].channel == c ){
						return true;
						break;
					}
					
				}
				
				return false;
			}
			
			/**
			* emit function
			* @public
			* @param 
			* @return
			*/
			public function emit( c : * = null , ...values : Array ) : Boolean {
				
				//
					if( _vListeners.length == 0 )
						return false;
				
				//
					
					var vTmp : Vector.<SignalListener> = new Vector.<SignalListener>( );
					var fFilter : Function = function( l : SignalListener , u : uint , v : Vector.<SignalListener> ) : Boolean{
						
						if( l.channel == c ) {
							vTmp.push( l );
							return !l.bOs;
						}
						
						if( l.channel == null )
							return false;
						
						return true;
					};
					_vListeners = _vListeners.filter( fFilter );
				
				//
					var s : SignalListener;
					for each( s in vTmp ) {
						s.fRef.apply( s.from , values ) ;	
					}
				
				return true;	
			}
			
		// -------o protected
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _sortFunc( s1 : SignalListener , s2 : SignalListener ) : int {
				if( s1.uPrio < s2.uPrio )
					return -1;
				else if( s1.uPrio == s2.uPrio )
					return 0;
				else if( s1.uPrio > s2.uPrio )
					return 1;
					
				return 0;
			}
			
		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(Signal, args);
			}
	}
}


	/**
	* org.shoebox.utils.system.SignalListener
	* @author shoebox
	*/
	internal class SignalListener {
		
		public var from			: *;
		public var channel		: *;
		public var bOs			: Boolean;
		public var fRef			: Function;
		public var uPrio			: uint;
		
		// -------o constructor
		
			/**
			* Constructor of the Signal class
			* 
			* @internal
			* @param	f 	: Function to be registered	( Function ) 
			* @param	prio 	: Listener priority			( uint )
			* @param	bOs 	: One shot usage				( Boolean )
			* @return	void
			*/
			public function SignalListener( f : Function , c : * , prio : uint , b : Boolean , from : * = null ) : void {
				this.bOs = b;
				this.fRef = f;
				this.uPrio = prio;
				this.channel = c;
				this.from = from;
			}

		// -------o public
		
		// -------o protected

		// -------o misc

	}

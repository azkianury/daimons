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

	import org.shoebox.utils.logger.Logger;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	* org.shoebox.utils.system.SignalFromEvent
	* @author shoebox
	*/
	public class SignalFromEvent {
		
		public var aArgs			: Array;
		public var bBubbling		: Boolean;
		public var bBroadcastEvent	: Boolean = false;
		public var cClass			: Class;
		public var oFrom			: IEventDispatcher;
		public var sType			: String;
		public var channel		: *;
		public var signal			: Signal;
		public var uPrio			: uint;
		
		protected var _bRunning		: Boolean = false;
		protected var _uCount		: uint = 0;
		
		// -------o constructor
		
			/**
			* Constructor of the Signal class
			*
			* @public
			* @return	void
			*/
			public function SignalFromEvent( from : IEventDispatcher , bb : Boolean , type : String , c : * , s : Signal , cc : Class = null , a : Array = null  ) : void {
				aArgs = a == null ? [ ] : a;
				bBubbling = bb;
				sType = type;
				oFrom = from;
				signal = s;
				channel = c;
				cClass = cc;
				prio = 1;
			}

		// -------o public
			
			/**
			* set prio function
			* @public
			* @param 
			* @return
			*/
			final public function set prio( u : uint  ) : void {
				
				uPrio = u;
				
				if( _bRunning )
					_run( );
								
			}
			
			/**
			* cancel function
			* @public
			* @param 
			* @return
			*/
			final public function cancel() : void {
			
				if( oFrom.hasEventListener( sType ))
					oFrom.removeEventListener( sType , _onExecute , bBubbling  );
					
				signal.disconnectChannel( channel );
			}
			
			/**
			* connect function
			* @public
			* @param 
			* @return
			*/
			final public function add( f : Function , b : Boolean = false , u : uint = 10 ) : Boolean {
				
				var b : Boolean = signal.connect( f , channel , u , b );
				
				if( b ){
					_uCount ++;
					if( !_bRunning )
						_run( );
				}
				
				
				return b;
			}
			
			/**
			* disconnect function
			* @public
			* @param 
			* @return
			*/
			final public function remove( f : Function ) : void {
				var b : Boolean = signal.disconnect( f , channel );
				if( b ){
					_uCount --;
					if( _uCount == 0 && _bRunning )
						_stop( );
				}
			}
			
		// -------o protected
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _run() : void {
				
				_stop( );
				_bRunning = true;
				oFrom.addEventListener( sType , _onExecute , bBubbling , uPrio , true );
				
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _stop() : void {
				_bRunning = false;
				if( oFrom.hasEventListener( sType ) )
					oFrom.removeEventListener( sType , _onExecute , bBubbling );
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _onExecute( e : Event ) : void {
				
				if( !signal.hasListener( channel ) )
					return;
				
				if( cClass ){
					if( !(e.target is cClass) )
						return;
				}
				
				var aTmp : Array = aArgs.slice( );
				if( bBroadcastEvent )
					aTmp.unshift( e );
				
				if( bBubbling )
					signal.emit.apply( null , [ channel , e.target ].concat( aTmp ) );
				else
					signal.emit.apply( null , [ channel ].concat( aTmp ) );
			}
			
		// -------o misc
			
			public static function trc(...args : *) : void {
				Logger.log(SignalFromEvent, args);
			}
			
	}
}


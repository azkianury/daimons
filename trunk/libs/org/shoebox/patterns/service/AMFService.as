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

package org.shoebox.patterns.service {

	import org.shoebox.errors.Errors;
	import org.shoebox.utils.logger.Logger;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	/**
	* org.shoebox.patterns.service.AMFService
	* @author shoebox
	*/
	public class AMFService extends AbstractService implements IService{
		
		protected var _sGatewayURL			: String;
		protected var _sServicePath			: String;
		
		protected var _uENCODING			: uint = ObjectEncoding.AMF3;
		protected var _oNetConn			: NetConnection;
		protected var _oResponder			: Responder;
		
		// -------o constructor
		
			/**
			* Constructor of the AMFService class
			*
			* @public
			* @return	void
			*/
			public function AMFService() : void {
				super( );
				_oResponder = new Responder( _onResults , _onFault );
	        	}

		// -------o public
			
			/**
			* onCall function
			* @public
			* @param 
			* @return
			*/
			public function onCall() : void {
			
				//
					_init( );
	        			
	        		// Calling the service
	        			_oNetConn.call( _sServicePath , _oResponder );
	        		
			}
			
			/**
			* onRefresh function
			* @public
			* @param 
			* @return
			*/
			public function onRefresh() : void {
				
			}
			
			/**
			* Setter of the gateway URL
			* 
			* @public
			* @param	s : Gateway URL 			( String )
			* @return	void
			*/
			final public function set gatewayURL( s : String ) : void {
				_sGatewayURL = s;
			}
			
			/**
			* Path of the service ( ex : Test.TestService )
			* 
			* @public
			* @param	s : Service path			( String ) 
			* @return	void
			*/
			final public function set servicePath( s : String ) : void {
				_sServicePath = s;
			}
			
			/**
			* Setter of the AMF encoding version
			* 
			* @public
			* @param	u : Encoding version		( uint ) 
			* @return	void
			*/
			final public function set encodingType( u : uint ) : void {
				_uENCODING = u;
			}
			
			/**
			* dispose function
			* @public
			* @param 
			* @return
			*/
			public function dispose() : void {
				
				if( _oNetConn ){
					if( _oNetConn.connected )
						_oNetConn.close();
						_oNetConn.removeEventListener( NetStatusEvent.NET_STATUS , _onNetStatus , false );
						_oNetConn.removeEventListener( SecurityErrorEvent.SECURITY_ERROR , _onNetStatus , false );
					
				}
				
				_oResponder = null;
			}
			
		// -------o protected
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _init() : void {
				
				//
					if( _oNetConn )
						return;
				
				// NetConnection initialization
					_oNetConn = new NetConnection( );
					_oNetConn.objectEncoding = _uENCODING;
					_oNetConn.addEventListener( NetStatusEvent.NET_STATUS , _onNetStatus , false , 10 , true );
		           		_oNetConn.addEventListener( SecurityErrorEvent.SECURITY_ERROR , _onSecu , false , 10 , true );
					
				// Connection to the gateway
	        			_oNetConn.connect( _sGatewayURL );
			}
			
			/**
			* On security error
			*
			* @param 	e : Security error event 	( SecurityErrorEvent )
			* @return	void
			*/
			final protected function _onSecu( e : SecurityErrorEvent ) : void {
				Errors.throwError( 'SecurityErrorEvent : '+e.errorID+'-'+e.text , this );
			}
			
			/**
			* On NetStatus event
			*
			* @param 	e : Net Status Event 		( NetStatusEvent )
			* @return	void
			*/
			final protected function _onNetStatus( e : NetStatusEvent ) : void {
				//TODO:
				var s : String = '';
				for( var prop : String in e.info )
					s = s + '\n'+prop+'='+e.info[prop];
				Errors.throwError( 'NetStatusEvent : '+s+'' , this );
			}
			
			/**
			* Result listener
			*
			* @param 
			* @return
			*/
			final protected function _onResults( ...args  ) : void {
				dispatch( args , false );
				onComplete( );
			}
			
			
			/**
			* On Service call fault
			*
			* @param	o : Fault object		( Object )	 
			* @return	void
			*/
			final protected function _onFault( o : Object ) : void {
				Errors.throwError( o , this );
			}
			
		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(AMFService, args);
			}
	}
}

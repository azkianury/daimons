/**  HomeMade by shoe[box]   Redistribution and use in source and binary forms, with or without   modification, are permitted provided that the following conditions are  met:  * Redistributions of source code must retain the above copyright notice,     this list of conditions and the following disclaimer.    * Redistributions in binary form must reproduce the above copyright    notice, this list of conditions and the following disclaimer in the     documentation and/or other materials provided with the distribution.    * Neither the name of shoe[box] nor the names of its     contributors may be used to endorse or promote products derived from     this software without specific prior written permission.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/package org.shoebox.patterns.service {	import org.shoebox.errors.Errors;	import org.shoebox.utils.logger.Logger;	import flash.events.Event;	import flash.events.HTTPStatusEvent;	import flash.events.IOErrorEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;		/**	 * org.shoebox.patterns.service.HTTP_Service	* @author shoebox	*/	public class HTTP_Service extends AbstractService implements IService {				public static const TEXTDATAS	: String = 'STRING_DATAS';		public static const XMLDATAS	: String = 'XML_DATAS';				public var pragmaNoCache		: Boolean = true;		public var request			: URLRequest = null;				protected var _sCachedVars		: String;		protected var _sMethod			: String = URLRequestMethod.GET;		protected var _oLoader			: URLLoader;		protected var _oVars			: URLVariables;		// -------o constructor					public function HTTP_Service( ) : void {				dataFormat = HTTP_Service.TEXTDATAS;				timeout = 20000;				super( );			}		// -------o public						/**			* When the service is called			* 			* @public			* @return	void			*/			public function onCall() : void {								if( _bUseCaching && !pragmaNoCache && _baCached ){										if( _oVars )						if( _sCachedVars == _oVars.toString() )							dispatch( _baCached.readObject( ) , true );						else							_call( );												else if( _baCached )						dispatch( _baCached.readObject( ) , true );									}else					_call( );							}						/**			* When the service is refreshed			* 			* @public			* @return	void			*/			public function onRefresh() : void {				_refresh();			}						/**			* Set the url call method			* 			* @public			* @param	s : HTTP Mehod		( String ) 			* @return	void			*/			public function set method(  s : String ) : void {				_sMethod = s;			}						/**			* Adding a variable to the <code>URLVariable</code>			* 			* @public			* @param	name	 : Variable name		( String )			* @param 	value	 : Variable value 	( Object ) 			* @return	void			*/			public function addVariable( name : String , value : * ) : void {								if( !_oVars )					_oVars = new URLVariables( );					_oVars[ name ] = value;								}						/**
			* removeVariable function
			* @public
			* @param 
			* @return
			*/
			final public function removeVariable( sName : String ) : void {
								if( _oVars )					delete _oVars[sName];				
			}						/**
			* clearVariables function
			* @public
			* @param 
			* @return
			*/
			final public function clearVariables() : void {
				_oVars = null;
			}						/**			* Disposing the service			* 			* @public			* @return	void			*/			public function dispose() : void {				_dispose();			}						/**
			* cancel function
			* @public
			* @param 
			* @return
			*/
			final override public function cancel() : void {				_dispose( );
			}					// -------o protected						/**			* Calling the service			*			* @return	void			*/			protected function _call() : void {								if( request == null )					throw new ArgumentError('The URLRequest is not defined');								if( pragmaNoCache ) 					addVariable('nocache',new Date().time.toString()); 								if( _oVars )					request.data = _oVars;								_oLoader = new URLLoader();					_oLoader.dataFormat = _sDATAFORMAT;				_oLoader.addEventListener( Event.COMPLETE , 			_onDatas 	, false , 1 , false );
				_oLoader.addEventListener( IOErrorEvent.IO_ERROR, 		_onIoError	, false , 1 , false );
				_oLoader.addEventListener( IOErrorEvent.DISK_ERROR, 	_onIoError	, false , 1 , false );
				_oLoader.addEventListener( IOErrorEvent.NETWORK_ERROR, 	_onIoError	, false , 1 , false );
				_oLoader.addEventListener( IOErrorEvent.VERIFY_ERROR, 	_onIoError	, false , 1 , false );				_oLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, 	_onStatus  	, false , 1 , false );				_oLoader.load(request);						}						/**			* Refreshing the service			*			* @return	void			*/			protected function _refresh() : void {				trc('refresh');				clearCache( );				_baCached = null;				_sCachedVars = null;				_call();			}						/**			* Data listener			*			* @param	e : Complete event		( Event ) 			* @return	void			*/			protected function _onDatas( e : Event ) : void {								if( _bUseCaching )					_cache( _oLoader.data );								onComplete( );				dispatch( _oLoader.data );			}						/**			* 			*			* @param 			* @return			*/			protected function _onStatus( e : HTTPStatusEvent ) : void {				trc('onHTTPStatus ::: '+e.status);				if( e.status >= 400)					Errors.throwError( e );							}						/**			* 			*			* @param 			* @return			*/			protected function _dispose() : void {							if( _oLoader ) { 					_oLoader.removeEventListener(Event.COMPLETE , 				_onDatas , false);					_oLoader.removeEventListener(IOErrorEvent.IO_ERROR, 		_onError , false);					_oLoader.removeEventListener(IOErrorEvent.DISK_ERROR, 		_onError , false);					_oLoader.removeEventListener(IOErrorEvent.NETWORK_ERROR, 		_onError , false);					_oLoader.removeEventListener(IOErrorEvent.VERIFY_ERROR, 		_onError , false);					_oLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, 	_onStatus , false);					_oLoader.close( );				}								_oLoader = null;			}						/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _onIoError( e : Event ) : void {				trc('_onIoError ::: '+e.type+' - '+e);				Errors.throwError( e );
			}						/**
			* 
			*
			* @param 
			* @return
			*/
			final protected override function _cache( o : * ) : void {								super._cache( o );				if( _oVars )					_sCachedVars = _oVars.toString( );				else							_sCachedVars = null;								}			// -------o misc			public static function trc(...args : *) : void {				Logger.log(HTTP_Service, args);			}	}}
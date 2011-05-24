/**  HomeMade by shoe[box]   Redistribution and use in source and binary forms, with or without   modification, are permitted provided that the following conditions are  met:  * Redistributions of source code must retain the above copyright notice,     this list of conditions and the following disclaimer.    * Redistributions in binary form must reproduce the above copyright    notice, this list of conditions and the following disclaimer in the     documentation and/or other materials provided with the distribution.    * Neither the name of shoe[box] nor the names of its     contributors may be used to endorse or promote products derived from     this software without specific prior written permission.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/package org.shoebox.patterns.frontcontroller {	import org.shoebox.collections.HashMap;	import org.shoebox.errors.Errors;	import org.shoebox.patterns.commands.AbstractCommand;	import org.shoebox.patterns.commands.samples.IResizeable;	import org.shoebox.patterns.factory.Factory;	import org.shoebox.patterns.mvc.commands.MVCCommand;	import org.shoebox.patterns.service.AbstractService;	import org.shoebox.patterns.service.ServiceEvent;	import org.shoebox.utils.DescribeTypeCache;	import org.shoebox.utils.logger.Logger;	import org.shoebox.utils.system.Signal;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.MovieClip;	import flash.errors.IllegalOperationError;	import flash.events.AsyncErrorEvent;	import flash.events.Event;	import flash.utils.Dictionary;		/**	 * org.shoebox.patterns.frontcontroller.FrontController	* @author shoebox	*/	public class FrontController extends Signal {				public static const STATE_CHANGED		: String = 'STATE_CHANGED';				public var owner					: DisplayObjectContainer;				protected var _vCommands			: Vector.<SignalCommand>;		protected var _dCommands			: HashMap;		protected var _hStates				: HashMap = new HashMap( true );		protected var _dApps				: Dictionary = new Dictionary();		protected var _hApps				: HashMap;		protected var _hTriads				: HashMap = new HashMap( true );		protected var _hServices			: HashMap;		protected var _sState				: String;		protected var _prevState			: String = null;				// -------o constructor					/**
			* FrontController constructor method			* 
			* @public
			* @param	container : optional container reference	( DisplayObjectContainer ) 
			* @return	void
			*/
			public function FrontController( owner : DisplayObjectContainer = null ) : void {								this.owner = owner;								_hApps 	= new HashMap( true );				_hServices 	= new HashMap( false );				_vCommands 	= new Vector.<SignalCommand>( );				super( );			}		// -------o public						/**			* Link a commmand to an event			*  			* @deprecated			* @public			* @param	name  : Command code name		( String ) 			* @param	comm  : Command class ref		( Class ) 			* @param	bWeak : Use weak reference		( Boolean ) 			* @return	true if success 				( Boolean )			*/			public function addCommand( name : String , comm : Class , bWeak : Boolean = true ) : Boolean {								if( !_dCommands )					_dCommands = new HashMap( false );								if( _dCommands.containsKey( name ) )						throw new IllegalOperationError('This command '+name+' is already registered');									_dCommands.addItem( name , comm );				addEventListener( name , _executeCommand , false , 0 , bWeak );								return true;			}						/**			* Unlink a command to an event			* 			* @deprecated			* @public			* @param 	name  : Command code name		( String ) 			* @return	true if succes				( Boolean )			*/			public function removeCommand( name : String ) : Boolean {								if( !_dCommands.containsKey( name ) )					throw new ArgumentError( 'The command name '+name+' is unknow');								_dCommands.removeKey( name );				removeEventListener( name , _executeCommand , false );								return true;			}						/**			* Execute a command by code name			* 			* @public			* @param	sName	 : Command code name		( String ) 			* @return	void			*/			public function execute( sName : String ) : void {				getCommand( sName ).execute();			}						/**			* Get a command instance by code name			* 			* @public			* @param	sName	 : Command code name		( String ) 			* @return	command instance			( AbstractCommand )			*/			public function getCommand( sName : String ) : AbstractCommand {								if(!_dCommands.containsKey( sName ))					throw new ArgumentError( 'The code name '+sName+' is unknow');								return Factory.build( _dCommands.getValue( sName ) );			}						/**			* Register an MVC triad			* 			* @public			* @param	sName	: Triad code name		( String ) 			* @param	m 	: Model ref			( Class ) 			* @param	v 	: View ref				( Class ) 			* @param	c 	: Controller ref		( Class ) 			* @return	true if success				( Boolean )			*/			public function registerTriad( 								sName		: String , 								m 		: Class = null , 								v	 	: Class = null , 								c 		: Class = null ,								container	: DisplayObjectContainer = null								) : Boolean {								if( _hTriads.containsKey( sName ) )					throw new IllegalOperationError('A triad with the code name '+sName+' is already registered');								_hTriads.addItem( sName , new MVCCommand( m , v , c , container , this ) );								return true; 							}						/**			* Get a triad command by his code name			* 			* @public			* @param	sName	: Triad code name		( String ) 			* @return	void			*/			public function getTriad( sName : String ) : MVCCommand {				return _hTriads.getValue( sName ); 			}						/**			* Register a state which is a combinaison of triads			* 			* @public			* @param 	sName		: State code name		( String )			* @param 	codes		: Triad codes list		( Vector.<String> ) 			* @return	true if success					( Boolean )			*/			public function registerState( sName : String , ...args : Array /*codes : Vector.<String>*/ ) : Boolean {								var codes : Vector.<String>;				if( args[ 0 ] is Vector.<String> )					codes = args[ 0 ];				else					codes = Vector.<String>( args );								trace( 'registerStates ::: '+codes );							if(_hStates.containsKey( sName ) )					throw new IllegalOperationError('A state with the name '+ sName +' is already registered');								_hStates.addItem( sName , codes );				return true;			}						/**			* UnRegister a state			* 			* @public			* @param 	sName		: State code name		( String )			* @return	true if success					( Boolean )			*/			public function unRegisterState( sName : String ) : Boolean {								if( !_hStates.containsKey( sName ))					throw new ArgumentError( 'The state '+sName+' is not registered' );								_hStates.removeKey( sName );				return true;			}						/**			* Set the current display state code				* 			* @public			* @param 	sName		: State code name		( String )			* @return	true if success					( Boolean )			*/			public function set state( sName : String ) : void {																if( !_hStates.containsKey( sName ))					throw new ArgumentError( 'The state '+sName+' is unknow');								if(_sState == sName )					throw new IllegalOperationError( 'The state '+sName+' is already the current state');								_prevState = _sState;				_sState = sName;								_drawState();				//System.gc( );			}						/**			* execTriad function			* @public			* @param 			* @return			*/			final public function execTriad( s : String ) : void {				_executeTriad( s );			}						/**			* Stage Resize central			* @public			* @param 			* @return			*/			public function onResize( e : Event = null ) : void {								var vL : Vector.<MVCCommand> = Vector.<MVCCommand>( _hApps.getItemsValues() );				var oC : MVCCommand;				for each( oC in vL )					if( oC.view is IResizeable )						( oC.view as IResizeable ).onResize( e );												}									/**			* connectCommand function			* @public			* @param 			* @return			*/			final public function connectCommand( cRef : Class , chan : * , prio : uint = 1  , b : Boolean = false ) : void {				_vCommands.push( new SignalCommand( this , cRef , chan , prio , b ) );			}						/**
			* registerService function
			* @public
			* @param 
			* @return
			*/
			final public function registerService( c : Class ) : Boolean {
								var 	s : AbstractService = new c( );					s.connect( _onTimeout , ServiceEvent.ON_TIMEOUT , 10 , false );									if( !( s is AbstractService )){					throw new Error( c+' is not a valid AbstractService class');					return false;				}				_hServices.addItem( DescribeTypeCache.getDesc(  c  ).@name.toString( ) , s );								return true;			}						/**
			* registerServices function
			* @public
			* @param 
			* @return
			*/
			final public function registerServices( ...args : Array ) : void {								var c : Class;				for each( c in args )					registerService( c );				
			}						/**
			* getService function
			* @public
			* @param 
			* @return
			*/
			final public function getService( c : Class ) : AbstractService {								var s : String = DescribeTypeCache.getDesc(  c  ).@name.toString( );								if( !_hServices.containsKey(s))					throw new ArgumentError('Unregistered service '+s );								return _hServices.getValue( s );			}		// -------o protected						/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _onTimeout( from : AbstractService ) : void {				Errors.throwError( new AsyncErrorEvent( AsyncErrorEvent.ASYNC_ERROR , false , false , from +' service timeout' ) , from );
			}						/**			* 			*			* @param 			* @return			*/			protected function _executeCommand( e : Event ) : void {				getCommand(e.type).execute( e );				}						/**			* Drawning the DisplayList of the current state			*			* @return	void			*/			protected function _drawState() : void {								//					var v : Vector.<String> = _hStates.getValue(_sState).concat( );					var l : int = v.length , i : int = 0 , s : String ;					for( i ; i < l ; i++ ){												s = v[i];						_executeTriad( v[i] );										}								//					if( _prevState ) {												var c : MVCCommand;												i = 0;						var vTmp : Vector.<String> = _hStates.getValue(_prevState).concat( );						l = vTmp.length;						for( i ; i < l ; i++ ){														// App code name ( string )								s = vTmp[ i ];														if( v.indexOf( s ) !== -1 )								continue;															// Cancelling app								c = _hApps.getValue( s ) as MVCCommand;								c.cancel( );								c = null;														// Unregister app								_hApps.removeKey( s );														}					}									// Z Sorting					l = v.length - 1;					i = 0;										var mc : DisplayObject;					var z : int = 0;					for( i ; i < l ; i ++) {												s = v[i];						mc = owner.getChildByName( s );						if( mc == null )							continue;												owner.setChildIndex( owner.getChildByName( s ) , z );						z++;					}								//Deprecated					if( hasEventListener( FrontController.STATE_CHANGED ))						dispatchEvent( new Event( FrontController.STATE_CHANGED ));								_prevState = _sState;						}						/**			* 			*			* @param 			* @return			*/			protected function _executeTriad( sCodeName : String ) : void {								//					if( !_hTriads.containsKey( sCodeName ) )						throw new IllegalOperationError('The triad '+sCodeName+' is not registered');									// Testing ig the triad is not already activated					//if(owner.getChildByName( sCodeName ) !== null)					//	return;								//					var 	oTriad : MVCCommand = _hTriads.getValue( sCodeName );					if( oTriad.isRunning )						return;									// Creating the triad container					if(oTriad.container == null){								var 	mc : MovieClip = new MovieClip();							mc.name = sCodeName;						owner.addChild( mc );						oTriad.container = mc;					}									//					oTriad.execute();										//					_hApps.addItem( sCodeName , oTriad );			}		// -------o misc			public static function trc(...args : *) : void {				Logger.log(FrontController, args);			}				}}import org.shoebox.patterns.commands.AbstractCommand;import org.shoebox.patterns.factory.Factory;import org.shoebox.patterns.frontcontroller.FrontController;internal class SingletonEnforcer{	}
	/**
	* org.shoebox.patterns.frontcontroller.FrontController
	* @author shoebox
	*/
	internal class SignalCommand {
				public var chan			: *;		public var cComm			: Class;		public var bOneShot		: Boolean;		public var from			: FrontController;		public var prio			: uint;		
		// -------o constructor
		
			/**
			* Constructor of the FrontController class
			*
			* @public
			* @return	void
			*/
			public function SignalCommand( from : FrontController , c : Class , chan : * , prio : uint = 1 , b : Boolean = false ) : void {				this.from = from;				this.chan = chan;				this.cComm = c;				this.bOneShot = b;				this.prio = prio;				from.connect( _onExecute , chan , prio , b );
			}

		// -------o public
						/**
			* cancel function
			* @public
			* @param 
			* @return
			*/
			final public function cancel() : void {
				
			}			
		// -------o protected
						/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _onExecute( props : Object = null ) : void {								var 	prop : String;								var 	o : AbstractCommand = Factory.build( cComm ) as AbstractCommand;				for( prop in props )					if( o.hasOwnProperty( prop ))						o[prop] = props[prop];					o.frontController = from;					o.execute( );							}			
		// -------o misc

	}


package org.shoebox.patterns.mvc.abstracts {

	import flash.errors.IllegalOperationError;
	import org.shoebox.utils.system.Signal;
	import org.shoebox.collections.HashMap;
	import org.shoebox.errors.Errors;
	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.factory.Factory;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.interfaces.IController;
	import org.shoebox.utils.AbstractValidation;
	import org.shoebox.utils.Relegate;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	* ABSTRACT CONTROLLER (MVC PACKAGE)
	* Responsabilities:
	* 
	*	===> The controller store the model instance and the view instance
	* 
	* 	===> The controller update the view / model
	* 	
	* org.shoebox.patterns.mvc.controller.AController
	* @date:26 janv. 09
	* @author shoe[box]
	*/
	public class AController extends Signal implements IController{
		
		public var app				: AApplication;
		public var model				: AModel;
		public var view				: AView;
		public var frontController		: FrontController;
		
		protected var _oDICO			: Dictionary = new Dictionary(true);		protected var _oGATES_DICO		: HashMap = new HashMap( true );
		protected var _uGATES			: uint = 0;
		
		// -------o constructor
			
			/**
			* 
			* @param
			* @return
			*/
			public function AController():void{
				AbstractValidation.validate(AController,this);
			}
			
		// -------o public
				
			/**
			* 
			*
			* @param 
			* @return
			*/
			public function onEvent(e:Event) : void {
				Errors.throwError(new Error(Errors.DONOTHING));
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function initialize():void{
				Errors.throwError(new Error(Errors.DONOTHING));
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function cancel(e:Event = null):void{
				Errors.throwError( new Error(Errors.DONOTHING));
			}
			
			/**
			* Register an listener to a source
			* 
			* @param source		: Event source (* at least eventdispatch)
			* @param sEVENTNAME	: Event Name (STRING)
			* 
			* @return
			*/
			public function register(source:EventDispatcher,sEVENTNAME:String, bCAPTURE : Boolean = false, bPRIO : int = 0, bWEAK : Boolean = false):void{
				source.addEventListener(sEVENTNAME,(super as IController).onEvent , bCAPTURE,bPRIO,bWEAK);
			}
			
			/**
			* 
			* 
			* @param
			* @return
			*/
			public function unRegister(source:EventDispatcher,sEVENTNAME:String, bCAPTURE : Boolean = false):void{
				source.removeEventListener(sEVENTNAME,(super as IController).onEvent,bCAPTURE);
			}
			
			/**
			* registerGateway function
			* @public
			* @param 
			* @return
			*/
			final public function registerGateway(
										source 	: EventDispatcher , 
										sEventName 	: String ,
										target 	: Function,
										bOS		: Boolean = false,
										capture 	: Boolean 	= false,
										iPRIO		: int		= 10,
										bWEAK 	: Boolean 	= true 
										
										) : void {
			
				if( source is DisplayObject)
					_oGATES_DICO.addItem( (source as DisplayObject).name + '-' + sEventName , new GatewayItem(source, sEventName, target, capture , bOS));
				else					_oGATES_DICO.addItem(source + '-' + sEventName , new GatewayItem(source, sEventName, target, capture , bOS));
				source.addEventListener(sEventName , _callGateway , capture , iPRIO , bWEAK );
			}
			
			/**
			* unRegisterGateway function
			* @public
			* @param 
			* @return
			*/
			final public function unRegisterGateway( 
											source 	: EventDispatcher , 
											sEventName 	: String ,
											target 	: Function,
											capture 	: Boolean 	= false
											
										) : void {
				
				_oGATES_DICO.removeKey(source + '-' + sEventName );
				
				if( source.hasEventListener(sEventName))					
					source.removeEventListener(sEventName , _callGateway , capture );
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function registerCommand(	command:Class,
									props:Object = null,
									tgt:EventDispatcher = null,
									sEVENTNAME:String = null, 
									bCAPTURE : Boolean = false, 
									bPRIO : int = 0, 
									bWEAK : Boolean = false):void{
				
				throw new IllegalOperationError('Deprecate');
				
				/*
				if(tgt == null || sEVENTNAME == null)
					throw new ArgumentError(Errors.ARGUMENTSERROR);
				
				var oFUNC:Function = Relegate.create( this , _onCallCommand , false , command , tgt , props );
				if(_oDICO[tgt]==undefined)
					_oDICO[tgt] = {};
					
				_oDICO[tgt][sEVENTNAME] = oFUNC;
				tgt.addEventListener(sEVENTNAME,oFUNC, bCAPTURE,bPRIO,bWEAK);		
				 *
				 */	
			}

			/**
			* @param
			* @return
			*/
			public function unRegisterCommand(command : Class,
									tgt :EventDispatcher,
									sEVENTNAME : String) : void {
				
				if(_oDICO[tgt][sEVENTNAME]!==undefined)
					tgt.removeEventListener(sEVENTNAME, _oDICO[tgt][sEVENTNAME]);	
				
			}
			
			/**
			* Do nothing method, call to intialize the controller
			* (After than the view have been added to the stage)
			* 
			* @return void
			public function initialize():void{
				throw new Error(Errors.DONOTHING);
			}
			*/
			
			/**
			* runApp function
			* @public
			* @param 
			* @return
			*/
			public function startUp() : void {
			
			}
			
			
		// -------o private
			
			/**
			* Calling the command and executing it after the event
			* @param e : Event from which the call is from
			* @param cCOMMAND	: Command class (CLASS)
			* @param tgt:Target on which the command will be applied
			* @return void
			*/
			protected function _onCallCommand(e:Event , cCOMMAND:Class = null , tgt:EventDispatcher = null , props:Object = null):void{
				
				var 	oCOMM:AbstractCommand = Factory.build(cCOMMAND , props);
					oCOMM.execute(e);
				
				/*
				var oCOMMAND : ICommand = CommandFactory.getCommand(cCOMMAND);
				for(var prop in props)
					oCOMMAND[prop] = props[prop];
				oCOMMAND.execute();				
				*/
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _callGateway( e : Event ) : void {
				
				
				var 	o : GatewayItem;
				if( e.target is DisplayObject )					o  = _oGATES_DICO.getValue( (e.target as DisplayObject ).name + '-' + e.type);
				else
					o  = _oGATES_DICO.getValue(e.target + '-' + e.type);
					o.fTarget.call( o.fTarget , e );

				if( o.bOneShot )
					unRegisterGateway( o.from, o.sEvent, o.fTarget , o.bCapture ); 
				
			}

		// -------o misc
			public static function trc(arguments:*) : void {
				//Logger.log(AController,arguments);
			}
	}
}

import flash.events.EventDispatcher;

internal class GatewayItem{
	
	public var bCapture		: Boolean = false;	public var bOneShot		: Boolean = false;	public var from			: EventDispatcher;	public var sEvent		: String;	public var fTarget		: Function;
	
	public function GatewayItem( 
						oFROM 	: EventDispatcher , 
						sEVENT 	: String  , 
						fTARGET 	: Function, 
						bCAPTURE	: Boolean = false,
						bOS	 	: Boolean = false ) : void{
		
		bCapture = bCAPTURE;		from = oFROM;
		sEvent = sEVENT;
		fTarget = fTARGET;
		bOneShot = bOS;
		
	}
}
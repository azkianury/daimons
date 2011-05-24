package org.shoebox.patterns.mvc.commands {

	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.commands.ICommand;
	import org.shoebox.patterns.factory.Factory;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.abstracts.AApplication;
	import org.shoebox.patterns.mvc.abstracts.AController;
	import org.shoebox.patterns.mvc.abstracts.AModel;
	import org.shoebox.patterns.mvc.abstracts.AView;
	import org.shoebox.patterns.mvc.interfaces.IController;
	import org.shoebox.patterns.mvc.interfaces.IModel;
	import org.shoebox.patterns.mvc.interfaces.IView;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 *
	* org.shoebox.patterns.mvc.commands.CommandInitTriad
	* @date:4 sept. 09
	* @author shoe[box]
	*/
	public class MVCCommand extends AbstractCommand implements ICommand{
		
		protected var _oAPP				:AApplication;
		protected var _oFrontController		: FrontController;
		protected var _oModel				:AModel;
		protected var _oView				:AView;
		protected var _oController			:AController;
		protected var _cModel				:Class;
		protected var _cView				:Class;		protected var _cController			:Class;		protected var _mcContainer			:DisplayObjectContainer = null ;
		
		// -------o constructor
			/**
			* contructor
			* @return void
			*/
			public function MVCCommand( m : Class = null , v : Class = null , c : Class = null , container : DisplayObjectContainer = null , fC : FrontController = null ):void{
				
				_cModel = m;
				_cView  = v;
				_cController = c;
				_mcContainer = container;
				_oFrontController = fC;
				cancelable = false;
			}
			
		// -------o public
			
			/**
			* get model function
			* @public
			* @param 
			* @return
			*/
			public function get model() : AModel {
				return _oModel;
			}
			
			/**
			* get view function
			* @public
			* @param 
			* @return
			*/
			final public function get view() : AView {
				return _oView;
			}
			
			/**
			* get controller function
			* @public
			* @param 
			* @return
			*/
			final public function get controller() : AController {
				return _oController;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			final public function set app(a:AApplication):void{
				_oAPP = a;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			final public function set modelClass(c:Class):void{
				_cModel = c;				
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function set viewClass(c:Class):void{
				_cView = c;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			final public function set controllerClass(c:Class):void{
				_cController = c;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			final public function set container(mc:DisplayObjectContainer):void{
				_mcContainer = mc;
			}
			
			/**
			* get container function
			* @public
			* @param 
			* @return
			*/
			public function get container() : DisplayObjectContainer {
				return _mcContainer;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			override final public function onExecute(e:Event = null):void{
				
				// Model
					if( _cModel )
						_oModel = new _cModel( );//Factory.build( _cModel );
				
				// View
					if( _cView )
						_oView = new _cView( );//Factory.build( _cView );
						
				// Controller
					if( _cController )
						_oController = new _cController( );//Factory.build( _cController );
					
				//
					var prop : String;
					var oTmp : Object = { model : _oModel , view : _oView , controller : _oController , app : _oAPP , frontController : _oFrontController };
					for( prop in oTmp ){
						
						if( _cModel )
							if( _oModel.hasOwnProperty( prop ) )
								_oModel[prop] = oTmp[prop];
						
						if( _cView )
							if( _oView.hasOwnProperty( prop ) )
								_oView[prop] = oTmp[prop];
						
						if( _cController )
							if( _oController.hasOwnProperty( prop ) )
								_oController[prop] = oTmp[prop];
								
					}
					
				//
					if(_mcContainer !== null && !_mcContainer.contains(_oView))
						_mcContainer.addChild(_oView);			
				
				//
					if(_cModel !== null)
						(_oModel as IModel).initialize( e );
						
					if(_cController !== null)
						(_oController as IController).initialize();
					
					if(_cView !== null)
						(_oView as IView).initialize();
						
				//
					if( _oController )
						(_oController as AController).startUp();
					
					if( _oModel )
						(_oModel as AModel).startUp( );
						
					if( _oView )
						(_oView as AView).startUp();
					
				
			}
			
			/**
			* 
			* @param
			* @return
			*/
			override final public function onCancel(e:Event = null):void{
				
				if(_oView!==null)
					if(_mcContainer.contains(_oView))
						_mcContainer.removeChild(_oView);
				
				if(_oModel!==null){
					_oModel.cancel( );
					_oModel.view = null;
					_oModel.controller = null;
					_oModel.frontController = null;					_oModel.app = null;
				}
				
				if(_oView!==null){
					_oView.cancel( );
					_oView.model = null;
					_oView.controller = null;
					_oView.frontController = null;
					_oView.app = null;
				}
								if(_oController!==null){
					_oController.cancel( );
					_oController.model = null;
					_oController.view = null;
					_oController.frontController = null;					_oController.app = null;
				}
				
				_oModel = null;
				_oView = null;
				_oController = null;
				
			}
			
		// -------o private
				
		// -------o misc
			public static function trc(arguments:*) : void {
				//Logger.log(MVCCommand,arguments);
			}
	}
}

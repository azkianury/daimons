package org.shoebox.utils {

	import org.shoebox.utils.logger.Logger;
	import org.shoebox.utils.relegates.ClassicRelegate;
	import org.shoebox.utils.relegates.DelayedRelegate;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author shoebox
	 */
	public class Relegate extends MovieClip {
		
		protected static var _vRelegates				: Vector.<ClassicRelegate> = new Vector.<ClassicRelegate>( );
		
		//@@constructor
		
		//public -------------00
			
			/**
			* Relegate classic AS3 rewritten
			*
			* @param f 		: CallBack function 	( Function )
			* @param args		: Arguments to pass to the callback (*)
			* @return wrapper	: Wrapper function 	( Function)
			*/
			public static function create( from : * , f : Function , b : Boolean = false , ...args ) : ClassicRelegate {
				
				var 	c : ClassicRelegate = new ClassicRelegate( from , f , b , args ); 
				_vRelegates.push( c );
				return c;
				
			}
			
			/**
			* Cancel a relegate classic 
			*
			* @param 
			* @return
			*/
			public static function cancel( c : ClassicRelegate ) : Function {
				
				//
					if( _vRelegates.indexOf( c ) == -1 )
						throw new ArgumentError('Unknowed ClassicRelegate');
				
				//
					_vRelegates.splice( _vRelegates.indexOf( c ) ,  1 );
				
				//
					var f : Function = c.wrapper;
					c.wrapper = null;
					
				return f;		
			}
			
			/**
			* hasRelegateFor function
			* @public
			* @param 
			* @return
			*/
			static public function hasRelegateFor( from : * , f : Function ) : Boolean {
			
				return ( getRelegate( from , f ) !== null );
				
			}
			
			/**
			* getRelegate function
			* @public
			* @param 
			* @return
			*/
			static public function getRelegate( from : * , f : Function ) : ClassicRelegate {
				
				var c : ClassicRelegate;
				for each( c in _vRelegates )
					if( c.from == from && c.refFunc == f )
						return c;
						
				return null;
				
			}
			
			
			/**
			* Wait for frame
			*
			* @param ref	:Reference from which listen the event
			* @param f		:CallBack function
			* @return void
			*/
			static public function afterFrame(ref:DisplayObject , f:Function , iFrameCount:uint = 1) : void {
				
				//
					if(ref==null || f==null)	
						throw new ArgumentError();
				//
					var iCount:uint = 0;
					var 	func : Function;
						func = function(e:Event = null):void{
							//trc('AFTERFRAME > '+f+' /// '+ref+' /// '+e+' // '+iCOUNT+' // '+iFRAMECOUNT);
							iCount++;
							if(iCount==iFrameCount){
								ref.removeEventListener(Event.ENTER_FRAME,func);
								f(e);
							}
						};
					
					ref.addEventListener(Event.ENTER_FRAME , func , false , 1 , true);
			}
			
			/**
			* Wait for delay
			*
			* @param  f		:CallBack function	( Function )
			* @param  i		:Timer delay 		( uint )	
			* @param  iCOUNT		:Timer count		( uint )	
			* @return void
			*/
			static public function afterDelay( 
										f		: Function , 
										delay 	: Number , 
										repeat 	: uint = 1
									) : DelayedRelegate {
				
				//
					if(f==null)	
						throw new ArgumentError('Callback function cannot be null');
				
				//
					var 	oR : DelayedRelegate = new DelayedRelegate( f , delay , repeat );
						oR.execute( );
					
				return oR;
			}
			
			
		//private ------------00
			
			
		//misc ---------------00
			public static function trc(arguments:*) : void {
				Logger.log(Relegate,arguments);
			}
	}
}

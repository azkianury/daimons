package org.shoebox.patterns.mvc.events {		import org.shoebox.utils.logger.Logger;		import flash.events.Event;		/**	*	* org.shoebox.patterns.mvc2.events.ServiceCompleteEvent	* @date:28 janv. 09	* @author shoe[box]	*/	public class ServiceCompleteEvent extends Event{				protected var _bCACHEDDATAS		:Boolean = false;		protected var _oDATAS			:*;		protected var _sDATATYPE		:String;				// -------o constructor						/**			* 			* @param			* @return			*/			public function ServiceCompleteEvent(	sTYPE : String, 										bBUB : Boolean = false, 										bCANCELABLE : Boolean = false){															super(sTYPE,bBUB,bCANCELABLE);			}					// -------o public						/**			* 			* @param			* @return			*/			override public function toString():String{				return '['+ServiceCompleteEvent+' | DATATYPES :'+_sDATATYPE+' | DATASOBJECT : '+_oDATAS;			}						/**			* 			* @param			* @return			*/			public function set isCachedDatas(b:Boolean):void{				_bCACHEDDATAS = b;			}						/**			* 			* @param			* @return			*/			public function get isCachedDatas():Boolean{				return _bCACHEDDATAS;			}						/**			* Retrieve the datas			* @return datas:the datas (*)			*/			public function get datas():*{				return _oDATAS;			}						/**			* 			* @param			* @return			*/			public function set datas(o:*):void{				_oDATAS = o;			}						/**			* Retrieve the data type (IMAGE,SWF,DATAS....) 			* @see : ServiceDataType			* @return s:datatype (STRING)			*/			public function get dataType():String{				return _sDATATYPE;			}						/**			* 			* @param			* @return			*/			public function set dataType(s:String):void{				_sDATATYPE = s;			}					// -------o private					// -------o misc			public static function trc(arguments:*) : void {				Logger.log(ServiceCompleteEvent,arguments);			}	}}
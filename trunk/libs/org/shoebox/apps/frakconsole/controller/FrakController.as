/**  HomeMade by shoe[box]   Redistribution and use in source and binary forms, with or without   modification, are permitted provided that the following conditions are  met:  * Redistributions of source code must retain the above copyright notice,     this list of conditions and the following disclaimer.    * Redistributions in binary form must reproduce the above copyright    notice, this list of conditions and the following disclaimer in the     documentation and/or other materials provided with the distribution.    * Neither the name of shoe[box] nor the names of its     contributors may be used to endorse or promote products derived from     this software without specific prior written permission.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/package org.shoebox.apps.frakconsole.controller {	import org.shoebox.apps.frakconsole.model.FrakModel;	import org.shoebox.apps.frakconsole.views.FrakView;	import org.shoebox.patterns.mvc.abstracts.AController;	import org.shoebox.patterns.mvc.interfaces.IController;	import org.shoebox.ui.keyboard.MultiKey;	import org.shoebox.utils.display.STAGEINSTANCE;	import org.shoebox.utils.logger.Logger;		import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.ui.Keyboard;		/**	 * org.shoebox.apps.frakconsole.controller.FrakController	* @author shoebox	*/	public class FrakController extends AController implements IController {				protected var _oKEY		:MultiKey;				// -------o constructor					public function FrakController() : void {			}		// -------o public						/**			* initialize function			* @public			* @param 			* @return			*/			final override public function initialize() : void {				//trc('initialize');															}						/**			* init function			* @public			* @param 			* @return			*/			final public function init() : void {								if( _oKEY )					return;								_oKEY = new MultiKey();				_oKEY.addEventListener( MultiKey.DONE , _onOpenClose , false , 10 , true);				_oKEY.target = view.stage;				_oKEY.listen([Keyboard.F9]);			}			/**			* onEvent function			* @public			* @param 			* @return			*/			final override public function onEvent( e : Event ) : void {								if(e.type == KeyboardEvent.KEY_DOWN )					if( (e as KeyboardEvent).keyCode == Keyboard.ENTER)						(model as FrakModel).send();									if( e.type == Event.CHANGE )					(model as FrakModel).autoComplete( );			}						/**			* cancel function			* @public			* @param 			* @return			*/			final override public function cancel( e : Event = null) : void {						}					// -------o protected						/**			* 			*			* @param 			* @return			*/			protected function _onOpenClose ( e : Event ) : void {				(view as FrakView).openclose();			}					// -------o misc			public static function trc(arguments:*) : void {				Logger.log(FrakController,arguments);			}	}}
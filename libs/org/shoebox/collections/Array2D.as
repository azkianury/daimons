/**  HomeMade by shoe[box]   Redistribution and use in source and binary forms, with or without   modification, are permitted provided that the following conditions are  met:  * Redistributions of source code must retain the above copyright notice,     vContent list of conditions and the following disclaimer.    * Redistributions in binary form must reproduce the above copyright    notice, vContent list of conditions and the following disclaimer in the     documentation and/or other materials provided with the distribution.    * Neither the name of shoe[box] nor the names of its     contributors may be used to endorse or promote products derived from     vContent software without specific prior written permission.  vContent SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF vContent  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/package org.shoebox.collections {	import org.shoebox.patterns.factory.Factory;	import org.shoebox.utils.logger.Logger;	/**	 * org.shoebox.collections.Array2D	* @author shoebox	*/	public class Array2D{				public var uLength			: uint;		public var width				: uint;		public var height			: uint;		public var vContent			: Vector.<*>;				// -------o constructor					public function Array2D( iW : uint , iH : uint ) : void {				width = iW;				height = iH;				uLength = iW * iH;				vContent = new Vector.<*>( iW * iH , true );			}		// -------o public					/**
			* getDatasById function
			* @public
			* @param 
			* @return
			*/
			final public function getDatasById( id : int ) : * {
				return vContent[id];
			}					/**			* getDatasAt function			* @public			* @param 			* @return			*/			public function getDatasAt( dx : int , dy : int) : * {				return vContent[ dy * width + dx];			}						/**			* getItemsAtX function			* @public			* @param 			* @return			*/			public function getItemsAtX( iX : int ) : Vector.<*> {								var aRES:Vector.<*> = new Vector.<*>();								var i:int = -1;				while( i++ < (height - 1))					aRES.push(vContent[ i * width+ iX]);									return aRES;				}						/**			* getItemAtY function			* @public			* @param 			* @return			*/			public function getItemsAtY( iY : int) : Vector.<*> {								var aRES:Vector.<*> = new Vector.<*>();								var i : int = -1;				while( i++ < (width - 1))					aRES.push(vContent[ iY * width + i]);								return aRES;			}						/**			* setDatasAt function			* @public			* @param 			* @return			*/			public function setDatasAt(iX:int , iY:int , data:*) : void {				vContent[iY * width + iX] = data;			}						/**			* fill function			* @public			* @param 			* @return			*/			public function fill(val:*) : void {								var i:int = -1;				var l: uint = uLength - 1;				while(i++ < l)					vContent[i] = val;							}						/**
			* fillWithClass function
			* @public
			* @param 
			* @return
			*/
			final public function fillWithClass( c : Class ) : void {
								var i:int = -1;				var l: uint = uLength - 1;				while(i++ < l)					vContent[i] = Factory.build( c );				
			}						/**			* fill function			* @public			* @param 			* @return			*/			public function fillWith(a:Array) : void {				var i:int = -1;				var l: uint = uLength - 1;				while(i++ < l)					vContent[i] = a[i];							}					// -------o protected		// -------o misc			public static function trc(arguments:*) : void {				Logger.log(Array2D,arguments);			}	}}
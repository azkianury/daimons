/**  HomeMade by shoe[box]   Redistribution and use in source and binary forms, with or without   modification, are permitted provided that the following conditions are  met:  * Redistributions of source code must retain the above copyright notice,     this list of conditions and the following disclaimer.    * Redistributions in binary form must reproduce the above copyright    notice, this list of conditions and the following disclaimer in the     documentation and/or other materials provided with the distribution.    * Neither the name of shoe[box] nor the names of its     contributors may be used to endorse or promote products derived from     this software without specific prior written permission.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/package org.shoebox.core {	import flash.geom.Point;
	import org.shoebox.utils.logger.Logger;	import flash.geom.Rectangle;		/**	* org.shoebox.core.BoxTriangle	* @author shoebox	*/	public class BoxTriangle {				// -------o constructor					/**			* Constructor of the BoxTriangle class			*			* @public			* @return	void			*/			public function BoxTriangle() : void {							}		// -------o public						/**			* rect function			* @public			* @param 			* @return			*/			static public function rect( v : Vector.<Point> ) : Rectangle {								var pTMP : Point = v[0]; 								var minX : Number = pTMP.x;				var minY : Number = pTMP.y;				var maxX : Number = minX;				var maxY : Number = minY;								var i : int = 0;				var l : int = v.length;				for( i ; i < l ; i++ ){										pTMP = v[i];					minX = Math.min( minX , pTMP.x );					minY = Math.min( minY , pTMP.y );					maxX = Math.max( maxX , pTMP.x );					maxY = Math.max( maxX , pTMP.y );									}								return new Rectangle( minX , minY , maxX - minX , maxY - minY );											}						/**			* recTrig function			* @public			* @param 			* @return			*/			static public function recTrig( rect : Rectangle , vertex0 : Point , vertex1 : Point , vertex2 : Point ) : Boolean {								var b0 : int , b1 : int , b2 : int;				var i0 : int , i1 : int , i2 : int;				var m : Number , c : Number , s : Number;								var l : Number = rect.left;
				var r : Number = rect.right;
				var t : Number = rect.top;
				var b : Number = rect.bottom;
												var x0 : Number = vertex0.x;
				var y0 : Number = vertex0.y;
				var x1 : Number = vertex1.x;
				var y1 : Number = vertex1.y;
				var x2 : Number = vertex2.x;
				var y2 : Number = vertex2.y;				
				b0 = int(x0 > l) | int(y0 > t) << 1 | int(x0 > r) << 2 | int(y0 > b) << 3;
				if (b0 == 3)
					return true;
				b1 = int(x1 > l) | int(y1 > t) << 1 | int(x1 > r) << 2 | int(y1 > b) << 3;
				if (b1 == 3)
					return true;
				b2 = int(x2 > l) | int(y2 > t) << 1 | int(x2 > r) << 2 | int(y2 > b) << 3;
				if (b2 == 3)
					return true;					
				i0 = b0 ^ b1;
				if (i0 != 0) {
					m = (y1 - y0) / (x1 - x0);
					c = y0 - (m * x0);
					if (Boolean(i0 & 1)) {
						s = m * l + c;
						if ( s > t && s < b)
							return true;
					}
					if (Boolean(i0 & 2)) {
						s = (t - c) / m;
						if ( s > l && s < r)
							return true;
					}
					if (Boolean(i0 & 4)) {
						s = m * r + c;
						if ( s > t && s < b)
							return true;
					}
					if (Boolean(i0 & 8)) {
						s = (b - c) / m;
						if ( s > l && s < r)
							return true;
					}
				}
				i1 = b1 ^ b2;
				if (i1 != 0) {
					m = (y2 - y1) / (x2 - x1);
					c = y1 - (m * x1);
					if (Boolean(i1 & 1)) {
						s = m * l + c;
						if ( s > t && s < b)
							return true;
					}
					if (Boolean(i1 & 2)) {
						s = (t - c) / m;
						if ( s > l && s < r)
							return true;
					}
					if (Boolean(i1 & 4)) {
						s = m * r + c;
						if ( s > t && s < b)
							return true;
					}
					if (Boolean(i1 & 8)) {
						s = (b - c) / m;
						if ( s > l && s < r)
							return true;
					}
				}
				i2 = b0 ^ b2;
				if (i2 != 0) {
					m = (y2 - y0) / (x2 - x0);
					c = y0 - (m * x0);
					if (Boolean(i2 & 1)) {
						s = m * l + c;
						if ( s > t && s < b)
							return true;
					}
					if (Boolean(i2 & 2)) {
						s = (t - c) / m;
						if ( s > l && s < r)
							return true;
					}
					if (Boolean(i2 & 4)) {
						s = m * r + c;
						if ( s > t && s < b)
							return true;
					}
					if (Boolean(i2 & 8)) {
						s = (b - c) / m;
						if ( s > l && s < r)
							return true;
					}
				}			        				return false;
								}							// -------o protected					// -------o misc			public static function trc(...args : *) : void {				Logger.log(BoxTriangle, args);			}	}}
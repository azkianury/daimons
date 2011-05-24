
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

package org.shoebox.core {

	import org.shoebox.utils.logger.Logger;
	import flash.geom.Rectangle;
	
	/**
	* org.shoebox.core.BoxRectangle
	* @author shoebox
	*/
	public class BoxRectangle {
		
		// -------o constructor
		
			/**
			* Constructor of the BoxRectangle class
			*
			* @public
			* @return	void
			*/
			public function BoxRectangle() : void {
				
			}

		// -------o public
			
			/**
			* intersect function
			* @public
			* @param 
			* @return
			*/
			static public function intersect( r1 : Rectangle , r2 : Rectangle ) : Boolean {
				
				
				if (!((r1.right < r2.left) || (r1.left > r2.right)))
				if (!((r1.bottom < r2.top) || (r1.top > r2.bottom)))
					return true; 
					
				return false; 
				
			}
			
			/**
			* intersection function
			* @public
			* @param 
			* @return
			*/
			static public function intersection( r1 : Rectangle , r2 : Rectangle , rTgt : Rectangle = null ) : Rectangle {
				
				//
					if(!rTgt) 
						rTgt = new Rectangle(); 
				
				//
					if (!intersect( r1, r2)) {
						rTgt.x = rTgt.y = rTgt.width = rTgt.height = 0;
						return rTgt;
					}
				
				//
					rTgt.left = (r1.left>r2.left) ? r1.left : r2.left; 
					rTgt.right = (r1.right<r2.right) ? r1.right : r2.right; 
					rTgt.top = (r1.top>r2.top) ? r1.top : r2.top; 
					rTgt.bottom = (r1.bottom<r2.bottom) ? r1.bottom : r2.bottom; 
				
				
				return rTgt; 
			
			}
			
			/**
			* contains function
			* @public
			* @param 
			* @return
			*/
			static public function contains( rContainer : Rectangle , r : Rectangle ) : Boolean {
				return ( (r.x >= rContainer.x) && (r.y >= rContainer.y ) && ( (r.width + r.x) < (rContainer.width + rContainer.x) ) && ( (r.height + r.y ) < ( rContainer.height + rContainer.y )));
			}
			
		// -------o protected

		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(BoxRectangle, args);
			}
	}
}
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

package org.shoebox.display.containers {

	import org.shoebox.collections.QuadTree;
	import org.shoebox.utils.logger.Logger;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	* org.shoebox.display.containers.LargeBitmapData
	* @author shoebox
	*/
	public class LargeBitmapData {
		
		protected var _vMAPS				: Vector.<BitmapData>;
		
		protected const SUB_MAP_SIZE		: uint = 100;
		
		// -------o constructor
		
			/**
			* Constructor of the LargeBitmapData class
			*
			* @public
			* @return	void
			*/
			public function LargeBitmapData( uW : uint , uH : uint , bAlpha : Boolean = false , uCol : uint = 0 ) : void {
				trc('largeBitmapData !!! '+uW+'-'+uH);
				
				_vMAPS = new Vector.<BitmapData>( );
				
				var uTX : uint = 0;
				var uTY : uint = 0;
				var uTW : uint = Math.ceil( uW / SUB_MAP_SIZE );
				var uTH : uint = Math.ceil( uW / SUB_MAP_SIZE );
				
				for( uTX ; uTX < uTW ; uTX++ ){
					
					uTY = 0;
					for( uTY ; uTY < uTH ; uTY++ ){
						
						_vMAPS.push( new BitmapData( SUB_MAP_SIZE , SUB_MAP_SIZE , bAlpha , uCol ))	;	
							
					}
					
				}
				
			}	

		// -------o public
			
			/**
			* copyPixels function
			* @public
			* @param 
			* @return
			*/
			final public function copyPixels( b : BitmapData , r : Rectangle ) : void {
				
			}
			
		// -------o protected

		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(LargeBitmapData, args);
			}
	}
}

/**
  HomeMade by shoe[box]
  IN THE BOX PACKAGE (http://code.google.com/p/inthebox/)
   
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

package org.shoebox.display {

	import flash.errors.IllegalOperationError;
	import org.shoebox.utils.relegates.ClassicRelegate;
	import org.shoebox.utils.DescribeTypeCache;
	import org.shoebox.utils.Relegate;
	import org.shoebox.utils.logger.Logger;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	/**
	*
	* org.shoebox.display.DisplayFuncs
	* @date:3 févr. 09
	* @author shoe[box]
	*/
	public class DisplayFuncs extends MovieClip{
		
		// -------o constructor
			
		// -------o public
			
			/**
			* name function
			* @public
			* @param 
			* @return
			*/
			static public function bresenham( x0:int, y0:int, x1:int, y1:int ) : Vector.<Vector3D> {
				
				var vRes : Vector.<Vector3D> = new Vector.<Vector3D>();
	
				var dx : int = x1 - x0;
				var dy : int = y1 - y0;
				var xinc : int = ( dx > 0 ) ? 1 : -1;
				var yinc : int = ( dy > 0 ) ? 1 : -1;
				dx = Math.abs(dx);
				dy = Math.abs(dy);
	
				var cumul : int;
				var i : int;
				if ( dx > dy ) {
					cumul = dx >> 1;
					for ( i = 1; i <= dx; i++ ) {
						x0 += xinc;
						cumul += dy;
						if ( cumul >= dx ) {
							y0 += yinc;
							cumul -= dx;
						}
						vRes.push(new Vector3D(x0, y0));
					}
				} else {
					cumul = dy >> 1;
					for ( i = 1; i <= dy; i++ ) {
						y0 += yinc;
						cumul += dx;
						if ( cumul >= dy ) {
							x0 += xinc;
							cumul -= dy;
						}
						vRes.push(new Vector3D(x0, y0));
					}
				}
	
				return vRes;
			}

		
			
			/**
			* Return the list of the childs contains in to the specified container
			* @public
			* @param 	tgt : container (DisplayObjectContainer)
			* @return	list of childs name (Vector.<String>)
			*/
			static public function getChildsName( tgt : DisplayObjectContainer ) : Vector.<String> {
				
				var i:uint;
				var l:uint = tgt.numChildren;
				var v : Vector.<String> = new Vector.<String>();
				for(i ; i < l ; i++)	
					v.push( tgt.getChildAt(i).name);
				
				return v;
			}
			
			/**
			* get path function
			* @public
			* @param 
			* @return
			*/
			static public function getPath( o : DisplayObject ) : String {
				
				var s: String = 'DisplayObject path of the object : '+o+' /// name : '+o.name+'\n';
				while( true ){
					
					if( !o.parent )
						break;
					
					o = o.parent;
					
					s += '\t parent :'+o+' - name : '+o.name+' ==== type : '+DescribeTypeCache.getDesc(o).@name+'\n';
					
				}
				return s;
			}
			
			/**
			* getChildsByType function
			* @public
			* @param 
			* @return
			*/
			static public function getChildsByType( tgt : DisplayObjectContainer , 	c : Class ) : Vector.<DisplayObject> {
				
				var 	i:uint;
				var 	l:uint = tgt.numChildren;
				var 	v : Vector.<DisplayObject> = new Vector.<DisplayObject>();
				
				for(i ; i < l ; i++)
					if( tgt.getChildAt(i) is c )
						v.push( tgt as c );
				
				return v;
				
			}
			
			/**
			* getChildsOf function
			* @public
			* @param 
			* @return
			*/
			static public function getChildsOf( tgt : DisplayObjectContainer ) : Vector.<DisplayObject> {
				var 	i:uint;
				var 	l:uint = tgt.numChildren;
				var 	v : Vector.<DisplayObject> = new Vector.<DisplayObject>();
				for(i ; i < l ; i++)
					v.push( tgt );
				return v;
			}
			
			/**
			* lineIntersection function
			* @public
			* @param 
			* @return
			*/
			static public function lineIntersection(pA:Point , pB:Point , pC:Point , pD:Point) : Point {
				
				var a1:Number;
				var a2:Number;
				var b1:Number;
				var b2:Number;
				var c1:Number;
				var c2:Number;
				var d1:Number;
				var d2:Number;
				
				a1 = pB.y - pA.y;
				b1 = pA.x - pB.x;
				c1 = pB.x * pA.y - pA.x - pB.y;
				
				a2 = pD.y - pC.y;
				b2 = pC.x - pD.x;
				c2 = pD.x * pC.y - pC.x - pD.y;
				
				var n:Number = a1 * b2 - a2 * b1;
				if(n==0)
					return null;
				
				
				
				return new Point((b1 * c2 - b2 * c1) / n , (a2 * c1 - a1 * c2) / n);
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			static public function align(o : * , oREC:Rectangle , _sALIGN:String = null) : void {
				
				switch(_sALIGN){
					
					case StageAlign.RIGHT:
					case StageAlign.TOP_RIGHT:					case StageAlign.BOTTOM_RIGHT:
						o.x = oREC.x + (oREC.width - o.width);
						break;
					
					case StageAlign.TOP:					case StageAlign.BOTTOM:
					case StageAlign.LEFT:					case StageAlign.TOP_LEFT:					case StageAlign.BOTTOM_LEFT:
						o.x = oREC.x;						break;
						
					default:
						o.x = oREC.x + (oREC.width - o.width)/2;
					
				}
				
				switch(_sALIGN){
					
					case StageAlign.BOTTOM:
					case StageAlign.BOTTOM_RIGHT:
					case StageAlign.BOTTOM_LEFT:
						o.y = oREC.y + (oREC.height - o.height);
						break;
					
					case StageAlign.TOP:
					case StageAlign.TOP_RIGHT:
					case StageAlign.TOP_LEFT:
						o.y = oREC.y;
						break;
					
					default:
						o.y = oREC.y + (oREC.height - o.height)/2;
						break;
				}
				
			}
			
			/**
			* Purge all the childs contains in a displayobjectcontainer
			* @param	tgt: target (DISPLAYOBJECTCONTAINER)
			* @return	void
			*/
			static public function purge(mc : DisplayObjectContainer) : void {
				
				while(mc.numChildren > 0)
					mc.removeChildAt(0);
				
			}
			
			static public function distributeX(tgt:DisplayObjectContainer , iSEPARATOR:uint = 0):void{
				
				var iLEN:uint = tgt.numChildren;
				var o:DisplayObject;
				var i:uint;
				var iINCX:uint;
				for(i ; i<iLEN ; i++){
					
					o = tgt.getChildAt(i);
					o.x = iINCX;
					iINCX+=o.width + iSEPARATOR;
				}
			}
			
			static public function distributeY(tgt:DisplayObjectContainer , iSEPARATOR:uint = 0):void{
				
				var iLEN:uint = tgt.numChildren;
				var o:DisplayObject;
				var i:uint;				var iINCY:uint;
				for(i ; i<iLEN ; i++){
					
					o = tgt.getChildAt(i);
					o.y = iINCY;
					iINCY+=o.height + iSEPARATOR;
				}
			}
			
			
			
			/**
			* 
			* @param
			* @return
			*/
			static public function setColor(mc:DisplayObject , uCOL:uint):void{
				
				var oT:ColorTransform;
				if(mc.transform.colorTransform!==null)
					oT = mc.transform.colorTransform;
				else
					oT = new ColorTransform();
					oT.color = uCOL;
				
				mc.transform.colorTransform = oT; 
					
				
			}
			
			/**
			* drawArc function
			* @public
			* @param 
			* @return
			*/
			static public function drawArc( g : Graphics , nX:uint , nY:uint, nRadius:Number, nArc:Number, nStartingAngle:Number , bRadialLines:Boolean = true ) : void {
				
				if (nArc > 360) 
					nArc = 360;
					nArc = Math.PI / 180 * nArc;
					
				var nAngleDelta : Number = nArc / 8;
				var nCtrlDist : Number = nRadius / Math.cos(nAngleDelta / 2);
	
				nStartingAngle -= 90;
				nStartingAngle *= Math.PI / 180;
	
				var nAngle : Number = nStartingAngle;
				var nCtrlX : Number , nCtrlY : Number;
				var nAnchorX : Number , nAnchorY : Number;
				
				var nStartX : Number = nX + Math.cos(nStartingAngle) * nRadius;
				var nStartY : Number = nY + Math.sin(nStartingAngle) * nRadius;
	
				if (bRadialLines) 
					g.moveTo(nX, nY);
					g.lineTo(nStartX, nStartY);
				
				for (var i : Number = 0; i < 8; i++) {
					nAngle += nAngleDelta;
	
					nCtrlX = nX + Math.cos(nAngle - (nAngleDelta / 2)) * (nCtrlDist);
					nCtrlY = nY + Math.sin(nAngle - (nAngleDelta / 2)) * (nCtrlDist);
	
					nAnchorX = nX + Math.cos(nAngle) * nRadius;
					nAnchorY = nY + Math.sin(nAngle) * nRadius;
	
					g.curveTo(nCtrlX, nCtrlY, nAnchorX, nAnchorY);
				}
				
				if (bRadialLines) 
					g.lineTo(nX, nY);
					
			}
			
			/**
			* playUntil function
			* @public
			* @param 
			* @return
			*/
			static public function playUntil( tgt : MovieClip , uFrame : uint ) : Boolean {
				throw new IllegalOperationError('prout');
				/*
				if( uFrame > tgt.totalFrames )
					return false;
				
				if( tgt.hasEventListener( Event.ENTER_FRAME ))
					tgt.removeEventListener( Event.ENTER_FRAME , Relegate.cancel( DisplayFuncs , _onFrame ) );
					
				var r : ClassicRelegate
					tgt.addEventListener( Event.ENTER_FRAME , Relegate.create( DisplayFuncs , _onFrame , false , uFrame ) , false , 10 , true );
				*/	
				return true;
			}
			
		// -------o private
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			static protected function _onFrame( e : Event , u : uint ) : void {
				/*
				var mc : MovieClip = e.currentTarget as MovieClip;
				
				//
					if( mc.currentFrame == u ) {
						mc.removeEventListener( Event.ENTER_FRAME , Relegate.cancel( DisplayFuncs , _onFrame ) );
						return;
					}
				
				//
					if( mc.currentFrame < u )
						mc.gotoAndStop( mc.currentFrame + 1 );
					else if( mc.currentFrame > u )
						mc.gotoAndStop( mc.currentFrame - 1 );
						 * 
						 */
			}
			
		// -------o misc
			public static function trc(arguments:*) : void {
				Logger.log(DisplayFuncs,arguments);
			}
	}
}

	



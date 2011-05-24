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

package org.shoebox.display.astro {
	import org.shoebox.utils.logger.Logger;

	import flash.display.MovieClip;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	/**
	* org.shoebox.display.astro.MeshRenderer
	* @author shoebox
	*/
	public class MeshRenderer extends MovieClip {
		
		protected var _oPROJ		:PerspectiveProjection = new PerspectiveProjection();

		// -------o constructor
		
			public function MeshRenderer() : void {
				trc('constructor');
				
				//
					_oPROJ.projectionCenter = new Point(0,0);
					_oPROJ.fieldOfView = 100;
				
				addEventListener(Event.ADDED_TO_STAGE, _onStaged, false, 1, false);
			}

		// -------o public
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			public function render(o:AstroMesh) : void {
				
				var 	oMAT:Matrix3D = _oPROJ.toMatrix3D();
					oMAT.identity();
					oMAT.appendRotation(25, Vector3D.X_AXIS);
					oMAT.appendRotation(25, Vector3D.Y_AXIS);
					oMAT.appendRotation(25, Vector3D.Z_AXIS);
				
				//Utils3D.projectVectors(oMAT , o.vertices3D , o.vertices2D , null);
				//trace(o.vertices2D);
				
				var oRES:Vector3D;
				var oVEC:Vector3D;
				for each(oVEC in o.vertices3D){
					oRES = Utils3D.projectVector(oMAT,oVEC);
					o.vertices2D.push(oRES.x,oRES.y);
				}
				
				/*
				var oIND:Vector.<Vector3D> = o.faces.slice();
				
				var oRES:Vector3D;
				for each(oVEC in oIND){
					oRES = Utils3D.projectVector(oMAT,o.vertices3D[oVEC.x]);
					
					oRES.incrementBy(Utils3D.projectVector(oMAT , o.vertices3D[oVEC.y]));					oRES.incrementBy(Utils3D.projectVector(oMAT , o.vertices3D[oVEC.z]));
					oVEC.w = (oRES.x + oRES.y + oRES.z)/3;					
				}
				
				
				oIND.sort(_wSort);
				
				var oINDICES:Vector.<int> = new Vector.<int>();
				for each(oVEC in oIND)
					oINDICES.push(oVEC.x , oVEC.y , oVEC.z);
				
				var oVEC2:Vector.<Number> = new Vector.<Number>();
				
				Utils3D.projectVectors(oMAT , o.vertices3DNum , oVEC2 , new Vector.<Number>());
				*/
				graphics.clear();
				graphics.lineStyle(1,0x333333,1);
				graphics.beginFill(0xFF6600, 1);
				graphics.drawTriangles(o.vertices2D, o.indices, null, TriangleCulling.NONE);
				
			}
			
		// -------o protected
			
			/**
			* 
			* @param
			* @return
			*/
			protected function _wSort(v1:Vector3D , v2:Vector3D):int{
				
				if(v1.w < v2.w)
					return +1;
				else
					return -1;
					
				return 0;
				
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			protected function _onStaged(e : Event = null) : void {
				trc('onStaged');
				transform.perspectiveProjection = _oPROJ;
				removeEventListener(Event.ADDED_TO_STAGE, _onStaged);
				addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved, false, 1, false);
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			protected function _onRemoved(e:Event = null) : void {
				removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			}

		// -------o misc

			public static function trc(arguments:*) : void {
				Logger.log(MeshRenderer,arguments);
			}
	}
}

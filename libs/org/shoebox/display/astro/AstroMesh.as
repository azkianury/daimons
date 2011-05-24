/**  HomeMade by shoe[box]   Redistribution and use in source and binary forms, with or without   modification, are permitted provided that the following conditions are  met:  * Redistributions of source code must retain the above copyright notice,     this list of conditions and the following disclaimer.    * Redistributions in binary form must reproduce the above copyright    notice, this list of conditions and the following disclaimer in the     documentation and/or other materials provided with the distribution.    * Neither the name of shoe[box] nor the names of its     contributors may be used to endorse or promote products derived from     this software without specific prior written permission.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/package org.shoebox.display.astro {	import org.shoebox.utils.logger.Logger;		import flash.geom.Vector3D;		/**	* org.shoebox.display.astro.AstroMesh	* @author shoebox	*/	public class AstroMesh{				protected var _vINDICES			:Vector.<int>;		protected var _vVERTICES2D		:Vector.<Number>;		protected var _vVERTICES3D		:Vector.<Vector3D>;		protected var _vVERTICES3DNUM		:Vector.<Number>;		protected var _vVERTICES3DClone	:Vector.<Vector3D>;		protected var _vUVDATAS			:Vector.<Number>;		protected var _vFACES			:Vector.<Vector3D>;				// -------o constructor					public function AstroMesh() : void {								_vINDICES 		= new Vector.<int>();				_vVERTICES2D 	= new Vector.<Number>();				_vVERTICES3D 	= new Vector.<Vector3D>();				_vVERTICES3DNUM 	= new Vector.<Number>();				_vVERTICES3DClone = new Vector.<Vector3D>();				_vUVDATAS 		= new Vector.<Number>();				_vFACES 		= new Vector.<Vector3D>();							}		// -------o public						/**			* 			*			* @param 			* @return			*/			public function addVertice(v:Vector3D) : uint {				_vVERTICES3D.push(v);												_vVERTICES3DNUM.push(v.x,v.y,v.z);												_vUVDATAS.push(1, 0, 0);				return _vVERTICES3D.length - 1;							}						/**			* 			*			* @param 			* @return			*/			public function addTriangle(i0:uint , i1:uint , i2:uint) : void {				_vINDICES.push(i0 , i1 , i2);				_vFACES.push(new Vector3D(i0,i1,i2));				_vVERTICES3D.push(new Vector3D(i0,i1,i2));			}						/**			* 			*			* @param 			* @return			*/			public function addQuad(i0:uint , i1:uint , i2:uint , i3:uint) : void {				addTriangle(i0 , i1 , i2);				addTriangle(i0 , i2 , i3);								}									/**			* 			*			* @param 			* @return			*/			public function get indices() : Vector.<int> {				return _vINDICES;			}						/**			* 			*			* @param 			* @return			*/			public function get vertices2D() : Vector.<Number> {				return _vVERTICES2D;			}						/**			* 			*			* @param 			* @return			*/			public function get vertices3D() : Vector.<Vector3D> {				return _vVERTICES3D;			}						/**			* 			* @param			* @return			*/			public function get vertices3DNum():Vector.<Number>{				return _vVERTICES3DNUM;			}						/**			* 			*			* @param 			* @return			*/			public function get vertices3DClone() : Vector.<Vector3D> {				return _vVERTICES3DClone;			}						/**			* 			*			* @param 			* @return			*/			public function get uvDatas() : Vector.<Number> {				return _vUVDATAS;			}						/**			* 			*			* @param 			* @return			*/			public function get faces() : Vector.<Vector3D> {				return _vFACES;			}								// -------o protected					// -------o misc			public static function trc(arguments:*) : void {				Logger.log(AstroMesh,arguments);			}							}}
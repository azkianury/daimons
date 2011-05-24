/**  HomeMade by shoe[box]   Redistribution and use in source and binary forms, with or without   modification, are permitted provided that the following conditions are  met:  * Redistributions of source code must retain the above copyright notice,     this list of conditions and the following disclaimer.    * Redistributions in binary form must reproduce the above copyright    notice, this list of conditions and the following disclaimer in the     documentation and/or other materials provided with the distribution.    * Neither the name of shoe[box] nor the names of its     contributors may be used to endorse or promote products derived from     this software without specific prior written permission.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/package org.shoebox.display.astro {	import org.shoebox.utils.logger.Logger;		import flash.geom.Vector3D;			/**	* org.shoebox.display.astro.Plane	* @author shoebox	*/	public class Plane extends AstroMesh {				// -------o constructor					public function Plane() : void {				super();								var uSIZE:uint = 50;								addVertice(new Vector3D(-uSIZE , -uSIZE , +uSIZE));				addVertice(new Vector3D(+uSIZE , -uSIZE , +uSIZE));				addVertice(new Vector3D(+uSIZE , +uSIZE , +uSIZE));				addVertice(new Vector3D(-uSIZE , +uSIZE , +uSIZE));								addVertice(new Vector3D(-uSIZE , -uSIZE , -uSIZE));				addVertice(new Vector3D(+uSIZE , -uSIZE , -uSIZE));				addVertice(new Vector3D(+uSIZE , +uSIZE , -uSIZE));				addVertice(new Vector3D(-uSIZE , +uSIZE , -uSIZE));												addQuad(0,1,2,3);				addQuad(1,5,6,2);				addQuad(4,5,6,7);				addQuad(0,4,7,3);				addQuad(0,1,5,4);				addQuad(3,2,6,7);								}		// -------o public				// -------o protected					// -------o misc			public static function trc(arguments:*) : void {				Logger.log(Plane,arguments);			}	}}
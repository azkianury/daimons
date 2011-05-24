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


package org.shoebox.io {
	import org.shoebox.errors.Errors;	import org.shoebox.utils.logger.Logger;		import flash.net.SharedObject;	
	/**
	* org.shoebox.net.SharedObjects
	 * @author shoe[box]
	 */
	public class BoxSO {

		// -------o constructor
			
			/**
			* 
			* @param
			* @return
			*/
			public function BoxSO():void{
				throw new Error(Errors.STATICCLASSERROR);
			}
			
		// -------o public
			
			/**
			*Get cookie data
			@param sNAME : Cookie name
			*@return Object (Object containing cookie datas)
			*/
			static public function getDatas(sNAME:String):Object{
				return getCookie(sNAME).data;				
			}
			
			/**
			*Save cookie data
			*@param sNAME:String : Cookie name
			*@param o:Object from where variables will be copied
			*@return void
			*/
			static public function saveDatas(sNAME:String,o:Object = null):void{
				
				var oSO:SharedObject = getCookie(sNAME);
				var prop : String;
				for( prop in o)
					oSO.data[prop] = o[prop];				
					oSO.flush();
			}
			
			/**
			*Clear cookie datas
			*@param sNAME : Cookie name
			*@return
			*/
			static  public function clearCookie(sNAME:String):void{
				var 	oSO:SharedObject = getCookie(sNAME);
					oSO.clear();
			}
			
		// -------o private
			
			/**
			*
			*@return
			*/
			static protected function getCookie(sNAME:String):SharedObject{
				return SharedObject.getLocal(sNAME,'/');
			}
			
		// -------o misc
			public static function trc(arguments:*) : void {
				Logger.log(BoxSO,arguments);
			}
	}
}

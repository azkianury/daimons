/**
* This is about <code>org.shoebox.core.BoxString</code>.
* {@link www.hyperfiction.fr}
* @author shoe[box]
*/

package org.shoebox.core {
	import org.shoebox.utils.logger.Logger;
	
	/**
	* org.shoebox.core.BoxString
	* @author shoebox
	*/
	public class BoxString {
		
		protected static const REG_TO_HREFB4		: RegExp = new RegExp("([[:space:]()[{}])(www.[-a-zA-Z0-9@:%_\+.~#?&//=]+)", "gi");
		protected static const REG_TO_HREFA4		: RegExp = new RegExp("([[:space:]()[{}])(((f|ht){1}tp://)[-a-zA-Z0-9@:%_\+.~#?&//=]+)", "gi");
		
		// -------o constructor
		
			/**
			* Constructor of the BoxString class
			*
			* @public
			* @return	void
			*/
			public function BoxString() : void {
			}

		// -------o public
			
			/**
			* linksToHrefs function
			* @public
			* @param 
			* @return
			*/
			static public function linksToHrefs( s : String ) : String {
				return s.replace( REG_TO_HREFB4 , "<a href='http://$2'>$2</a>" ).replace( REG_TO_HREFA4 , " <a href='$2'>$2</a>");
			}
			
		// -------o protected

		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(BoxString, args);
			}
	}
}

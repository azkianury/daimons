package org.shoebox.collections {
	import flash.geom.Rectangle;
	/**
	 * @author shoe[box]
	 */
	public class QuadTreeResult {
		
		public var ref			: *;
		public var indice		: uint;
		public var value			: Rectangle;
		
		/**
		* name function
		* @public
		* @param 
		* @return
		*/
		final public function QuadTreeResult(i : uint, r : Rectangle) : void {
			indice = i;
			value = r;
		}
		
	}
}

/**
* This is about <code>org.shoebox.utils.relegates.ClassicRelegate</code>.
* {@link www.hyperfiction.fr}
* @author shoe[box]
*/

package org.shoebox.utils.relegates {

	import org.shoebox.utils.Relegate;
	import org.shoebox.utils.logger.Logger;
	
	/**
	* org.shoebox.utils.relegates.ClassicRelegate
	* @author shoebox
	*/
	public class ClassicRelegate {
		
		public var wrapper				: Function;
		
		protected var fromWhat				: *;
		protected var aArgs				: Array;
		protected var bInnerArgs			: Boolean = true;
		protected var bOs				: Boolean = false;
		protected var fRef				: Function;
		
		// -------o constructor
		
			/**
			* Constructor of the ClassicRelegate class
			*
			* @public
			* @return	void
			*/
			public function ClassicRelegate( from : * , fRef : Function , b : Boolean = false , args : Array = null  ) : void {
				this.fromWhat = from;
				this.fRef = fRef;
				this.bOs = b;
				this.aArgs = args;
				wrapper = _onRelegate;
			}

		// -------o public
			
			/**
			* get from function
			* @public
			* @param 
			* @return
			*/
			final public function get from() : * {
				return fromWhat;
			}
			
			/**
			* get refFunc function
			* @public
			* @param 
			* @return
			*/
			final public function get refFunc() : Function {
				return fRef;
			}
			
		// -------o protected
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _onRelegate( ...innerArgs : Array ) : void {
				
				if( bInnerArgs )
					fRef.apply( this, innerArgs.concat( aArgs ));
				else
					fRef.apply( this, aArgs );
					
				if( bOs ){ 
					Relegate.cancel( this );	
					wrapper = null;
				}
			}
			
			
		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(ClassicRelegate, args);
			}
	}
}

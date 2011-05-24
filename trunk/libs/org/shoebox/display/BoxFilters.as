package org.shoebox.display {
	import org.shoebox.errors.Errors;
	import org.shoebox.utils.logger.Logger;

	import flash.errors.IllegalOperationError;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;

	/**
	 *
	* org.shoebox.display.BoxFilters
	* @date:3 sept. 09
	* @author shoe[box]
	*/
	public class BoxFilters{
		
		
		
		// -------o constructor
		
			/**
			* contructor
			* @return void
			*/
			public function BoxFilters():void{
				Errors.throwError(new IllegalOperationError(Errors.STATICCLASSERROR));
			}
			
		// -------o public
			
			/**
			* 
			* @param
			* @return
			*/
			static public function get SobelX():ConvolutionFilter{
				
				return new ConvolutionFilter(3,3,[	
									-1,-2,-1,
									+0,+0,+0,
									+1,+2,+1
									],1,127);
														
		
			}
			
			/**
			* 
			* @param
			* @return
			*/
			static public function get SobelY():ConvolutionFilter{
				return new ConvolutionFilter(3,3,[	
									-1,+0,+1,
									-2,+0,+2,
									-1,+0,+1
									],1,127);
			}
			
			/**
			*
			*@return
			*/
			public static function desature(t:int=0):ColorMatrixFilter{
				t = t ? t : 1;
				var r:Number = 0.212671;
				var g:Number = 0.715160;
				var b:Number = 0.072169;
				return new ColorMatrixFilter([t*r+1-t, t*g, t*b, 0, 0,t*r, t*g+1-t, t*b, 0, 0,t*r, t*g, t*b+1-t, 0, 0,0, 0, 0, 1, 0]);
			}
			
		// -------o private

		// -------o misc
			public static function trc(arguments:*) : void {
				Logger.log(BoxFilters,arguments);
			}
	}
}

package org.shoebox.utils {	import flash.display.MovieClip;	import flash.display.Stage;	/**	 * @author shoe[box]	 */	public class Status extends MovieClip{						// -------o public						public static function isLocal(stage:Stage):Boolean{				return (String(stage.loaderInfo.url).indexOf('file://')!==-1);			}					// -------o private				// -------o misc			public static function trc(arguments:*) : void {				trace('org.shoebox.utils.Status ::: '+arguments.join(' :: '));			}	}}
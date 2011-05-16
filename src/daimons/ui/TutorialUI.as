package daimons.ui
{
	import flash.display.MovieClip;

	/**
	 * @author lbineau
	 */
	public class TutorialUI extends MovieClip
	{
		public function TutorialUI()
		{
		}

		public function displayPicto($name : String) : void
		{
			if(currentLabel != $name)
				gotoAndPlay($name);
		}
	}
}

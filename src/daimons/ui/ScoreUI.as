package daimons.ui
{
	import flash.text.TextField;
	import flash.display.MovieClip;

	/**
	 * @author lbineau
	 */
	public class ScoreUI extends MovieClip
	{
		private var _tf:TextField;
		public function ScoreUI()
		{
			_tf = new TextField();
			addChild(_tf);
		}
		
		public function updateUI(percent:Number):void
		{
			_tf.text = "Score : " + percent + "%";			
		}
	}
}

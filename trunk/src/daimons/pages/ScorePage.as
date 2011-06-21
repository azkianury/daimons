package daimons.pages
{
	import daimons.core.consts.CONFIG;
	import fr.lbineau.utils.UMath;
	import daimons.score.ScoreManager;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * @author lbineau
	 */
	public class ScorePage extends EventDispatcher
	{
		private var _view : MovieClip;

		public function ScorePage($view : MovieClip)
		{
			_view = $view;
			_initialize();
		}

		private function _initialize() : void
		{
			view['scoreUI'].gotoAndStop(CONFIG.PLAYER_TYPE);
			view['scoreUI']['score'].text = ScoreManager.getInstance().percentage + ' %';
			view['scoreUI']['scoreTotal'].text = uint(UMath.randomRange(40, 60)) + ' %';
			var congrat:String;
			if(ScoreManager.getInstance().percentage < 50){
				congrat = "Oh my... You should try an other day...";
			}
			else if(ScoreManager.getInstance().percentage < 75){
				congrat = "Not bad, you can do better.";
			}
			else if(ScoreManager.getInstance().percentage <= 100){
				congrat = "Congratulations !";
			}			
			view['scoreUI']['congrat'].text = congrat;
		}

		public function get view() : MovieClip
		{
			return _view;
		}

		public function set view(view : MovieClip) : void
		{
			_view = view;
		}
	}
}

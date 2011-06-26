package daimons.game.pages
{
	import daimons.game.core.consts.CONFIG;
	import daimons.game.score.ScoreManager;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import fr.lbineau.utils.UMath;

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
			ScoreManager.getInstance().saveScore();
			view['scoreUI'].gotoAndStop(CONFIG.PLAYER_TYPE);
			view['scoreUI']['score'].text = ScoreManager.getInstance().percentage + ' %';
			//view['scoreUI']['scoreTotal'].text = uint(UMath.randomRange(40, 60)) + ' %';
			view['scoreUI']['scoreTotal'].text = ((ScoreManager.getInstance().scoreSO.data.percentage != undefined) ? ScoreManager.getInstance().scoreSO.data.teamPercentage : '50') + ' %';

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

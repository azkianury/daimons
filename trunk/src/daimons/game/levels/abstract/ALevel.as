package daimons.game.levels.abstract
{
	import daimons.game.MainGame;
	import daimons.ui.TutorialUI;
	import daimons.score.ScoreManager;
	import daimons.ui.ScoreUI;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.core.State;

	import org.osflash.signals.Signal;

	/**
	 * @author lbineau
	 */
	public class ALevel extends State implements ILevel
	{
		public var lvlEnded : Signal;
		protected var _timer : PerfectTimer;
		protected var _scoreUI : ScoreUI;
		protected var _tutoUI : TutorialUI;

		public function ALevel()
		{
			super();
			init();
		}

		public function init() : void
		{
			lvlEnded = new Signal();
			_scoreUI = new ScoreUI();
			_scoreUI.x = (MainGame.STAGE.stageWidth - _scoreUI.width) / 2;
			_scoreUI.y = (MainGame.STAGE.stageHeight - _scoreUI.height) / 2;
			_tutoUI = new TutorialUI();
			ScoreManager.getInstance().init(_scoreUI);
			addChild(_tutoUI.view);
			addChild(_scoreUI);
		}

		override public function destroy() : void
		{
			lvlEnded.removeAll();
			super.destroy();
		}

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);
		}

		public function pause() : void
		{
		}

		public function resume() : void
		{
		}
	}
}

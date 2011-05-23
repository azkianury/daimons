package daimons.game.levels.abstract
{
	import com.citrusengine.core.State;
	import daimons.game.tutorial.Tutorial;
	import daimons.score.ScoreManager;
	import fr.lbineau.utils.PerfectTimer;
	import org.osflash.signals.Signal;




	/**
	 * @author lbineau
	 */
	public class ALevel extends State implements ILevel
	{
		public var lvlEnded : Signal;
		protected var _timer : PerfectTimer;
		protected var _tutoUI : Tutorial;

		public function ALevel()
		{
			super();
			init();
		}

		public function init() : void
		{
			lvlEnded = new Signal();
			_tutoUI = new Tutorial();
			_tutoUI.init(new TutorialUIAsset());
			addChild(_tutoUI.view);
			ScoreManager.getInstance().init(new ScoreUIAsset());
			addChild(ScoreManager.getInstance().view);
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

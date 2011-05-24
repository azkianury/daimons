package daimons.game.levels.abstract
{
	import daimons.game.time.CountdownManager;
	import daimons.game.tutorial.TutorialManager;
	import daimons.score.ScoreManager;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.core.State;

	import org.osflash.signals.Signal;

	import flash.events.TimerEvent;

	/**
	 * @author lbineau
	 */
	public class ALevel extends State implements ILevel
	{
		public var lvlEnded : Signal;
		protected var _timerGame : PerfectTimer;
		protected var _tuto : TutorialManager;
		protected var _countdown : CountdownManager;

		public function ALevel()
		{
			super();
			lvlEnded = new Signal();
		}

		override public function initialize() : void
		{
			_countdown = new CountdownManager(new CountdownUIAsset());
			_countdown.init(300);
			_countdown.start();
			addChild(_countdown.view);
			_countdown.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			_tuto = new TutorialManager(new TutorialUIAsset());
			addChild(_tuto.view);
			
			ScoreManager.getInstance().init(new ScoreUIAsset());
			addChild(ScoreManager.getInstance().view);
			
			super.initialize();
		}

		private function _onTimerComplete(event : TimerEvent) : void
		{
			_countdown.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			lvlEnded.dispatch();
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

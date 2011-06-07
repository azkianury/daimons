package daimons.game.levels
{
	import daimons.game.MainGame;
	import daimons.game.actions.ActionManager;
	import daimons.game.time.CountdownManager;
	import daimons.game.tutorial.TutorialManager;
	import daimons.score.ScoreManager;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.core.State;

	import org.osflash.signals.Signal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		private var _bmp : Bitmap;
		private var _head : EonHeadUIAsset;

		public function ALevel()
		{
			super();
			lvlEnded = new Signal();
		}

		override public function initialize() : void
		{
			_countdown = new CountdownManager(new CountdownUIAsset());
			_countdown.init(3);
			_countdown.start();
			addChild(_countdown.view);
			_countdown.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);

			_tuto = new TutorialManager(new TutorialUIAsset());
			addChild(_tuto.view);

			ScoreManager.getInstance().init(new ScoreUIAsset());
			addChild(ScoreManager.getInstance().view);

			ActionManager.getInstance().init(new ActionsUIAsset());
			addChild(ActionManager.getInstance().view);

			_head = new EonHeadUIAsset();
			addChild(_head);
			_head.x = MainGame.STAGE.stageWidth;
			_head.y = MainGame.STAGE.stageHeight;

			super.initialize();
		}

		override public function destroy() : void
		{
			_timerGame = null;
			removeChild(_tuto.view);
			_tuto = null;
			removeChild(_countdown.view);
			_countdown = null;
			removeChild(ScoreManager.getInstance().view);
			removeChild(ActionManager.getInstance().view);
			_head = null;
			_tuto = null;
			_bmp = null;
			lvlEnded.removeAll();
			lvlEnded = null;
			super.destroy();
		}

		private function _onTimerComplete(event : TimerEvent) : void
		{
			_countdown.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			lvlEnded.dispatch();
		}

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);
		}

		public function pause() : void
		{
			var bitmapdata : BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight);

			bitmapdata.draw(stage);

			_bmp = new Bitmap(bitmapdata);

			addChild(_bmp);
		}

		public function resume() : void
		{
			removeChild(_bmp);
			_bmp.bitmapData.dispose();
			_bmp = null;
		}
	}
}

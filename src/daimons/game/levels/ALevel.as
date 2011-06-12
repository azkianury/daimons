package daimons.game.levels
{
	import com.greensock.TweenMax;

	import flash.events.Event;

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

		public function ALevel($duration : uint)
		{
			super();
			lvlEnded = new Signal();
			_countdown = new CountdownManager(new CountdownUIAsset());
			_countdown.init($duration);
		}

		override public function initialize() : void
		{
			_countdown.start();
			addChild(_countdown.view);
			_countdown.addEventListener(Event.COMPLETE, _onGameComplete);

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

		private function _onGameComplete(event : Event) : void
		{
			_countdown.removeEventListener(Event.COMPLETE, _onGameComplete);
			trace("END");
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
			TweenMax.to(_bmp, 0.5, {blurFilter:{blurX:10, blurY:10}});
			_countdown.pause();
			addChild(_bmp);
		}

		public function resume() : void
		{
			removeChild(_bmp);
			_bmp.bitmapData.dispose();
			_bmp = null;
			_countdown.resume();
		}
	}
}

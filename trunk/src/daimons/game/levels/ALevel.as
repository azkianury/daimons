package daimons.game.levels
{
	import daimons.game.MainGame;
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.State;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.physics.Box2D;
	import com.greensock.TweenMax;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import daimons.game.actions.ActionManager;
	import daimons.game.characters.Attacker;
	import daimons.game.characters.Defender;
	import daimons.game.core.consts.CONFIG;
	import daimons.game.hurtingobjects.AHurtingObject;
	import daimons.game.score.ScoreManager;
	import daimons.game.time.CountdownManager;
	import daimons.game.tutorial.TutorialManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import fr.lbineau.utils.PerfectTimer;

	import org.osflash.signals.Signal;

	/**
	 * @author lbineau
	 */
	public class ALevel extends State implements ILevel
	{
		public var lvlEnded : Signal;
		protected var _checkTimer : PerfectTimer;
		protected var _tuto : TutorialManager;
		protected var _countdown : CountdownManager;
		protected var _bmp : Bitmap;
		protected var _head : MovieClip;
		protected var _arrow : ArrowIndicator;
		protected var _defender : Defender;
		protected var _attacker : Attacker;

		public function ALevel($duration : uint)
		{
			super();
			lvlEnded = new Signal();
			_countdown = new CountdownManager(new CountdownUIAsset());
			_countdown.view.gotoAndStop(CONFIG.PLAYER_TYPE);
			_countdown.init($duration);

			_countdown.start();
			addChild(_countdown.view);
			_countdown.addEventListener(Event.COMPLETE, _onGameComplete);

			ScoreManager.getInstance().init((CONFIG.PLAYER_TYPE == CONFIG.DEFENDER) ? new ScoreDefenderUIAsset() : new ScoreAttackerUIAsset());
			addChild(ScoreManager.getInstance().view);

			ActionManager.getInstance().init(new ActionsUIAsset());
			addChild(ActionManager.getInstance().view);

			_head = new HeadUIAsset();
			_head.gotoAndStop(CONFIG.PLAYER_TYPE);
			addChild(_head);
			_head.x = (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER) ? CONFIG.APP_WIDTH : 0;
			_head.y = CONFIG.APP_HEIGHT;

			_tuto = new TutorialManager((CONFIG.PLAYER_TYPE == CONFIG.DEFENDER) ? new TutorialDefenderUIAsset() : new TutorialAttackerUIAsset());
			addChild(_tuto.view);

		}

		override public function initialize() : void
		{
			super.initialize();
			var box2D : Box2D = new Box2D("Box2D");
			add(box2D);
			box2D.visible = CONFIG.BOX2D;

			_attacker = new Attacker("Attacker");
			_attacker.onAttack.add(_onAttack);

			_defender = new Defender("Hero", {view:((LoaderMax.getLoader("hero") as SWFLoader).getClass("Hero")), gravity:0.5, width:50, height:120, group:2});
			_defender.offsetY = -20;
			_defender.offsetX = -80;
			_defender.x = 200;
			_defender.y = CONFIG.APP_HEIGHT - 300;
			add(_defender);

			view.cameraTarget = _defender;
			view.cameraLensHeight = 0;
			view.cameraLensWidth = 0;
			view.cameraOffset = new MathVector(150, 200);
			view.cameraEasing.y = 0;
			
		}

		override public function destroy() : void
		{
			_checkTimer = null;
			if (contains(_tuto.view)) removeChild(_tuto.view);
			_tuto = null;
			if (contains(_countdown.view)) removeChild(_countdown.view);
			_countdown = null;
			if (contains(ScoreManager.getInstance().view)) removeChild(ScoreManager.getInstance().view);
			if (contains(ActionManager.getInstance().view)) removeChild(ActionManager.getInstance().view);
			_head = null;
			_tuto = null;
			_bmp = null;
			lvlEnded.removeAll();
			lvlEnded = null;
			super.destroy();
		}

		protected function _onAttack(ennemi : AHurtingObject) : void
		{
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
			CitrusEngine.getInstance().playing = false;
			_attacker.onAttack.remove(_onAttack);
			var bitmapdata : BitmapData = new BitmapData(CONFIG.APP_WIDTH, CONFIG.APP_HEIGHT);

			bitmapdata.draw(this);

			_bmp = new Bitmap(bitmapdata);
			TweenMax.to(_bmp, 0.5, {blurFilter:{blurX:10, blurY:10}});
			_countdown.pause();
			addChild(_bmp);
		}

		public function resume() : void
		{
			CitrusEngine.getInstance().playing = true;
			_attacker.onAttack.add(_onAttack);
			if (_bmp != null && this.contains(_bmp))
			{
				removeChild(_bmp);
				_bmp.bitmapData.dispose();
				_bmp = null;
			}
			_countdown.resume();
		}
	}
}

package daimons.game.levels
{
	import daimons.core.consts.CONFIG;
	import daimons.game.MainGame;
	import daimons.game.actions.ActionManager;
	import daimons.game.characters.Attacker;
	import daimons.game.characters.Defender;
	import daimons.game.hurtingobjects.AHurtingObject;
	import daimons.game.time.CountdownManager;
	import daimons.game.tutorial.TutorialManager;
	import daimons.score.ScoreManager;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.State;
	import com.citrusengine.physics.Box2D;
	import com.greensock.TweenMax;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import org.osflash.signals.Signal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;

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
		}

		override public function initialize() : void
		{
			super.initialize();

			var box2D : Box2D = new Box2D("Box2D");
			add(box2D);
			box2D.visible = CONFIG.BOX2D;

			_defender = new Defender("Hero", {view:((LoaderMax.getLoader("hero") as SWFLoader).getClass("Hero")), gravity:0.5, width:50, height:120, group:2});
			_defender.offsetY = -20;
			_defender.offsetX = -80;

			add(_defender);
			_defender.x = 200;
			_defender.y = stage.stageHeight - 300;

			_attacker = new Attacker("Attacker");
			_attacker.onAttack.add(_onAttack);

			_countdown.start();
			stage.addChild(_countdown.view);
			_countdown.addEventListener(Event.COMPLETE, _onGameComplete);

			_tuto = new TutorialManager((CONFIG.PLAYER_TYPE == CONFIG.DEFENDER) ? new TutorialDefenderUIAsset() : new TutorialAttackerUIAsset());
			stage.addChild(_tuto.view);

			ScoreManager.getInstance().init(new ScoreUIAsset());
			stage.addChild(ScoreManager.getInstance().view);

			ActionManager.getInstance().init(new ActionsUIAsset());
			stage.addChild(ActionManager.getInstance().view);

			_head = new HeadUIAsset();
			_head.gotoAndStop(CONFIG.PLAYER_TYPE);
			stage.addChild(_head);
			_head.x = (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER) ? MainGame.STAGE.stageWidth : 0;
			_head.y = MainGame.STAGE.stageHeight;
		}

		override public function destroy() : void
		{
			_checkTimer = null;
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
			// ActionManager.getInstance().pause();
			_attacker.onAttack.remove(_onAttack);
			var bitmapdata : BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight);

			bitmapdata.draw(stage);

			_bmp = new Bitmap(bitmapdata);
			TweenMax.to(_bmp, 0.5, {blurFilter:{blurX:10, blurY:10}});
			_countdown.pause();
			addChild(_bmp);
		}

		public function resume() : void
		{
			CitrusEngine.getInstance().playing = true;
			// ActionManager.getInstance().resume();
			_attacker.onAttack.add(_onAttack);
			removeChild(_bmp);
			_bmp.bitmapData.dispose();
			_bmp = null;
			_countdown.resume();
		}
	}
}

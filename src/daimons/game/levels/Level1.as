package daimons.game.levels
{
	import Box2DAS.Dynamics.ContactEvent;

	import daimons.core.consts.PATHS;
	import daimons.game.characters.Defender;
	import daimons.game.hurtingobjects.Rock;
	import daimons.game.hurtingobjects.Spikes;
	import daimons.game.hurtingobjects.Wall;
	import daimons.game.hurtingobjects.abstract.AHurtingObject;
	import daimons.game.levels.abstract.ALevel;
	import daimons.score.ScoreManager;

	import fr.lbineau.utils.PerfectTimer;
	import fr.lbineau.utils.UMath;

	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.PhysicsObject;
	import com.citrusengine.objects.platformer.Platform;
	import com.citrusengine.physics.Box2D;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;

	/**
	 * @author lbineau
	 */
	public class Level1 extends ALevel
	{
		private var _tutorial : Boolean = true;
		private var _hero : Defender;
		private var _ground : Platform;
		// Arrière plan
		private var _containerBg : Sprite;
		private var _currentBg : CitrusSprite;
		// Premier plan
		private var _containerFg : Sprite;
		private var _currentFg : CitrusSprite;
		// Middle plan
		private var _containerMg : Sprite;
		private var _currentMg : CitrusSprite;
		private var _ennemi : PhysicsObject;
		private var _ennemyArray : Array = [Wall, Rock, Spikes];
		private var _ennemyStock : Vector.<AHurtingObject>;
		private var _currentEnnemyIdx : uint ;
		private static const MAX_ENNEMIES : uint = 10;

		public function Level1()
		{
			super();
		}

		override public function initialize() : void
		{
			super.initialize();

			_ennemyStock = new Vector.<AHurtingObject>(MAX_ENNEMIES, true);

			var box2D : Box2D = new Box2D("Box2D");
			add(box2D);
			box2D.visible = true;

			_initDecor();

			_hero = new Defender("Hero", {view:(PATHS.CHARACTER_ASSETS + "eon.swf"), gravity:0.5, width:50, height:100, group:2});
			_hero.offsetY = -30;
			_hero.hurtVelocityX = 1;
			_hero.hurtVelocityY = 1;
			_hero.killVelocity = 1;
			_hero.acceleration = 5;
			_hero.maxVelocity = 5;
			_hero.skidFriction = 1;
			add(_hero);
			_hero.x = 200;
			_hero.y = stage.stageHeight - 400;

			_ground = new Platform("Platform1", {width:stage.stageWidth * 2, height:20});
			add(_ground);
			_ground.y = stage.stageHeight - 180;
			_ground.x = -stage.stageWidth;

			view.cameraTarget = _hero;
			view.cameraOffset = new MathVector(50, 200);
			view.cameraEasing.y = 0;

			_timerGame = new PerfectTimer(5000, 0);
			_timerGame.addEventListener(TimerEvent.TIMER, _onTick);
			_timerGame.start();
		}

		private function _initDecor() : void
		{
			var fgClass : Class = ((LoaderMax.getLoader("decor1") as SWFLoader).getClass("FG"));
			var bgClass : Class = ((LoaderMax.getLoader("decor1") as SWFLoader).getClass("BG"));
			var mgClass : Class = ((LoaderMax.getLoader("decor1") as SWFLoader).getClass("MG"));
			var bmp0 : Bitmap;
			var bmp1 : Bitmap;
			_containerFg = new Sprite();
			_containerBg = new Sprite();
			_containerMg = new Sprite();

			bmp0 = new Bitmap(new bgClass());
			_containerBg.addChild(bmp0);
			bmp0.cacheAsBitmap = true;

			bmp1 = new Bitmap(new bgClass());
			bmp1.x = _containerBg.width - 10;
			bmp1.cacheAsBitmap = true;
			_containerBg.addChild(bmp1);
			_currentBg = new CitrusSprite("Background", {view:_containerBg, parallax:0.5, group:0});
			add(_currentBg);

			bmp0 = new Bitmap(new mgClass());
			_containerMg.addChild(bmp0);
			bmp0.cacheAsBitmap = true;

			bmp1 = new Bitmap(new mgClass());
			bmp1.x = _containerMg.width - 10;
			bmp1.cacheAsBitmap = true;
			_containerMg.addChild(bmp1);
			_currentMg = new CitrusSprite("Middleground", {view:_containerMg, parallax:1, group:0});
			add(_currentMg);

			bmp0 = new Bitmap(new fgClass());
			_containerFg.addChild(bmp0);
			bmp0.cacheAsBitmap = true;

			bmp1 = new Bitmap(new fgClass());
			bmp1.x = _containerFg.width - 10;
			bmp1.cacheAsBitmap = true;
			_containerFg.addChild(bmp1);

			_currentFg = new CitrusSprite("Foreground", {view:_containerFg, parallax:2, group:4});
			add(_currentFg);
		}

		private function _onTick(event : TimerEvent) : void
		{
			_ennemi = new _ennemyArray[UMath.round(UMath.randomRange(-0.6, _ennemyArray.length - 1.4))]("Ennemi" + _timerGame.currentCount + 1);
			add(_ennemi);
			_ennemi.x = _ground.x + stage.stageWidth;
			_ennemi.y = _ground.y - 200;

			_currentEnnemyIdx = (_currentEnnemyIdx < MAX_ENNEMIES - 1) ? _currentEnnemyIdx + 1 : 0;

			_ennemyStock[_currentEnnemyIdx] = _ennemi as AHurtingObject;

			for each (var ennemi : AHurtingObject in _ennemyStock)
			{
				if (ennemi != null && ennemi.x < _hero.x - 100)
				{
					// ennemi.destroy(); // BUG
					ennemi.kill = true;
				}
			}

			// Roulement des Backgrounds
			var tailleBg : Number = view.getArt(_currentBg).x + _containerBg.getChildAt(0).x + _containerBg.getChildAt(0).width;
			if (_hero.x > tailleBg)
			{
				trace("REMOVED Background");
				_containerBg.getChildAt(0).x = _containerBg.getChildAt(1).x + _containerBg.getChildAt(1).width - 10;
				_containerBg.setChildIndex(_containerBg.getChildAt(0), 1);
			}

			// Roulement des Middlegrounds
			var tailleMg : Number = view.getArt(_currentMg).x + _containerMg.getChildAt(0).x + _containerMg.getChildAt(0).width;
			if (_hero.x > tailleMg)
			{
				trace("REMOVED Middleground");
				_containerMg.getChildAt(0).x = _containerMg.getChildAt(1).x + _containerMg.getChildAt(1).width - 10;
				_containerMg.setChildIndex(_containerMg.getChildAt(0), 1);
			}

			// Roulement des Foregrounds
			var tailleFg : Number = view.getArt(_currentFg).x + _containerFg.getChildAt(0).x + _containerFg.getChildAt(0).width;
			if (_hero.x > tailleFg)
			{
				trace("REMOVED Foreground");
				_containerFg.getChildAt(0).x = _containerFg.getChildAt(1).x + _containerFg.getChildAt(1).width - 10;
				_containerFg.setChildIndex(_containerFg.getChildAt(0), 1);
			}
		}

		override public function update(timeDelta : Number) : void
		{
			for each (var ennemi : AHurtingObject in _ennemyStock)
			{
				if (ennemi != null && !ennemi.passed)
				{
					if ((ennemi.x < _hero.x))
					{
						if (!ennemi.touched)
							ScoreManager.getInstance().add(1);
						else
							ScoreManager.getInstance().remove(1);
						ennemi.passed = true;
					}
					if (_tutorial)
					{
						if (ennemi.x < (_hero.x + 600))
						{
							_tuto.show();
							_tuto.displayPicto(ennemi.hurtAction);
						}
						else
							_tuto.hide();
					}
				}
			}
			_ground.x = _hero.x;
			super.update(timeDelta);
		}

		/*	private function _hurt():void {
		this.dispatchEvent(new GameEvent(GameEvent.LOSE_LIFE));
		}
		 */
		private function _resetLevel(cEvt : ContactEvent) : void
		{
			if (cEvt.other.GetBody().GetUserData() is Defender)
			{
			}
		}

		override public function pause() : void
		{
			for each (var ennemi : AHurtingObject in _ennemyStock)
			{
				if (ennemi != null && ennemi.x < _hero.x - 100)
				{
					ennemi.changeAnimation("idle");
				}
			}
			_hero.changeAnimation("idle");
			_timerGame.pause();
			_countdown.pause();
		}

		override public function resume() : void
		{
			for each (var ennemi : AHurtingObject in _ennemyStock)
			{
				if (ennemi != null && ennemi.x < _hero.x - 100)
				{
					ennemi.changeAnimation(ennemi.prevAnimation);
				}
			}
			_hero.changeAnimation("walk");
			_timerGame.resume();
			_countdown.resume();
		}
	}
}

package daimons.game.levels
{
	import daimons.core.consts.CONFIG;
	import daimons.game.grounds.Ground1;
	import daimons.game.hurtingobjects.projectiles.Lightning;

	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.Platform;
	import com.citrusengine.physics.Box2D;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import daimons.game.characters.Defender;
	import daimons.game.hurtingobjects.statics.AHurtingObject;
	import daimons.game.hurtingobjects.statics.Rock;
	import daimons.game.hurtingobjects.statics.Spikes;
	import daimons.game.hurtingobjects.statics.Wall;
	import daimons.game.sensors.DestroyerSensor;
	import daimons.score.ScoreManager;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;

	import fr.lbineau.utils.PerfectTimer;
	import fr.lbineau.utils.UMath;

	/**
	 * @author lbineau
	 */
	public class Level1 extends ALevel
	{
		private var _tutorial : Boolean = true;
		private var _hero : Defender;
		private var _ground : Platform;
		private var _destroyer : DestroyerSensor;
		// Arrière plan
		private var _containerBg : Sprite;
		private var _currentBg : CitrusSprite;
		// Premier plan
		private var _containerFg : Sprite;
		private var _currentFg : CitrusSprite;
		// Plan médian
		private var _containerMg : Sprite;
		private var _currentMg : CitrusSprite;
		private var _ennemyArray : Vector.<AHurtingObject>;
		private static const MAX_ENNEMIES : uint = 4;

		public function Level1($duration : uint)
		{
			super($duration);
		}

		override public function initialize() : void
		{
			super.initialize();

			_ennemyArray = new Vector.<AHurtingObject>(MAX_ENNEMIES, true);

			var box2D : Box2D = new Box2D("Box2D");
			add(box2D);
			box2D.visible = CONFIG.BOX2D;
			trace(CONFIG.BOX2D);

			_initDecor();

			_initHurtingObjects();

			_hero = new Defender("Hero", {view:((LoaderMax.getLoader("hero") as SWFLoader).getClass("Hero")), gravity:0.5, width:50, height:120, group:2});
			_hero.offsetY = -20;
			_hero.offsetX = -80;
			_hero.hurtVelocityX = 1;
			_hero.hurtVelocityY = 1;
			_hero.killVelocity = 1;
			_hero.acceleration = 6;
			_hero.maxVelocity = 6;
			_hero.skidFriction = 1;

			add(_hero);
			_hero.theMc = MovieClip(view.getArt(_hero));
			// Obligé d'attendre qu'il soit ajouté au state
			_hero.x = 200;
			_hero.y = stage.stageHeight - 300;

			_ground = new Ground1("Platform1", {width:stage.stageWidth * 2, height:20});
			add(_ground);
			_ground.y = stage.stageHeight - 180;
			_ground.x = -stage.stageWidth;

			_destroyer = new DestroyerSensor("theDestroyer", {width:100, height:stage.stageHeight});
			_destroyer.x = stage.stageWidth;
			_destroyer.y = 100;
			add(_destroyer);

			view.cameraTarget = _hero;
			view.cameraOffset = new MathVector(150, 200);
			view.cameraEasing.y = 0;

			if (CONFIG.ENNEMI_AUTO)
			{
				_timerGame = new PerfectTimer(CONFIG.ENNEMI_INTERVAL, 0);
				_timerGame.addEventListener(TimerEvent.TIMER, _onTick);
				_timerGame.start();
			}
		}

		override public function destroy() : void
		{
			_hero.destroy();
			_hero = null;
			_timerGame.stop();
			_timerGame.removeEventListener(TimerEvent.TIMER, _onTick);
			super.destroy();
		}

		private function _initHurtingObjects() : void
		{
			var spike : Spikes = new Spikes("spikes1", {view:(LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Spike"), width:90, height:40, offsetX:-220, offsetY:-80});
			var rock : Rock = new Rock("rock1", {view:(LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Rock"), radius:80, offsetX:- 100, offsetY:- 100});
			var wall : Wall = new Wall("wall1", {view:(LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Wall"), width:20, height:220, offsetX:- 40, offsetY:- 280});
			var lightning : Lightning = new Lightning("lightning1", {view:((LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Lightning")), gravity:0, width:250, height:20});
			_ennemyArray[0] = spike;
			_ennemyArray[1] = rock;
			_ennemyArray[2] = wall;
			_ennemyArray[3] = lightning;
			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
				ennemi.x = - 200;
				ennemi.onTouched.add(_onEnnemiTouched);
				ennemi.onDestroyed.add(_onEnnemiDestroyed);
				add(ennemi);
			}
		}

		private function _onEnnemiDestroyed() : void
		{
			ScoreManager.getInstance().add(1);
		}

		private function _onEnnemiTouched() : void
		{
			_hero.hurt();
			ScoreManager.getInstance().remove(1);
		}

		private function _initDecor() : void
		{
			var fgClass : Class = ((LoaderMax.getLoader("decors1") as SWFLoader).getClass("FG"));
			var bgClass : Class = ((LoaderMax.getLoader("decors1") as SWFLoader).getClass("BG"));
			var mgClass : Class = ((LoaderMax.getLoader("decors1") as SWFLoader).getClass("MG"));
			var bmp0 : Bitmap;
			var bmp1 : Bitmap;
			_containerFg = new Sprite();
			_containerBg = new Sprite();
			_containerMg = new Sprite();

			bmp0 = new Bitmap(new bgClass());
			bmp0.cacheAsBitmap = true;
			_containerBg.addChild(bmp0);

			bmp1 = new Bitmap(new bgClass());
			bmp1.cacheAsBitmap = true;
			bmp1.x = _containerBg.width - 10;
			_containerBg.addChild(bmp1);
			_currentBg = new CitrusSprite("Background", {view:_containerBg, parallax:0.5, group:0});
			add(_currentBg);

			bmp0 = new Bitmap(new mgClass());
			bmp0.cacheAsBitmap = true;
			_containerMg.addChild(bmp0);

			bmp1 = new Bitmap(new mgClass());
			bmp1.cacheAsBitmap = true;
			bmp1.x = _containerMg.width - 10;
			_containerMg.addChild(bmp1);
			_currentMg = new CitrusSprite("Middleground", {view:_containerMg, parallax:1, group:0});
			add(_currentMg);

			bmp0 = new Bitmap(new fgClass());
			bmp0.cacheAsBitmap = true;
			_containerFg.addChild(bmp0);

			bmp1 = new Bitmap(new fgClass());
			bmp1.cacheAsBitmap = true;
			bmp1.x = _containerFg.width - 10;
			_containerFg.addChild(bmp1);

			_currentFg = new CitrusSprite("Foreground", {view:_containerFg, parallax:2, group:4});
			add(_currentFg);
		}

		private function _onTick(event : TimerEvent) : void
		{
			var _ennemi : AHurtingObject = _ennemyArray[int(UMath.randomRange(0, MAX_ENNEMIES - 0.01))];
			// var _ennemi : AHurtingObject = _ennemyArray[1];
			_ennemi.reset();
			_ennemi.x = _ground.x + stage.stageWidth - 200;
			_ennemi.y = _ground.y - _ennemi.height - _ennemi.initialHeight;

			/*_currentEnnemyIdx = (_currentEnnemyIdx < MAX_ENNEMIES - 1) ? _currentEnnemyIdx + 1 : 0;

			_ennemyArray[_currentEnnemyIdx] = _ennemi as AHurtingObject;

			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
			if (ennemi != null && ennemi.x < _hero.x - 100)
			{
			ennemi.kill = true;
			}
			}*/

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
			super.update(timeDelta);
			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
				if (!ennemi.passed)
				{
					if ((ennemi.x + ennemi.width < _hero.x))
					{
						if ((ennemi is Spikes || ennemi is Lightning) && !ennemi.touched)
							ScoreManager.getInstance().add(1);
						ennemi.passed = true;
					}
					if (_tutorial)
					{
						if (ennemi.x < (_hero.x + 600))
						{
							_tuto.displayPicto(ennemi.hurtAction);
							_tuto.show();
						}
					}
				}
			}
			_ground.x = _hero.x;
			_destroyer.x = _hero.x + stage.stageWidth;
		}

		override public function pause() : void
		{
			super.pause();
			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
				if (ennemi.x < _hero.x - 100)
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
			super.resume();
			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
				if (ennemi.x < _hero.x - 100)
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

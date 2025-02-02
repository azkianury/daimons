package daimons.game.levels
{
	import daimons.game.MainGame;
	import daimons.game.actions.AAction;
	import daimons.game.actions.ActionManager;
	import daimons.game.core.consts.CONFIG;
	import daimons.game.grounds.Ground1;
	import daimons.game.hurtingobjects.AHurtingObject;
	import daimons.game.hurtingobjects.projectiles.Lightning;
	import daimons.game.hurtingobjects.statics.Spikes;
	import daimons.game.score.ScoreManager;
	import daimons.game.sensors.DestroyerSensor;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.Platform;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author lbineau
	 */
	public class Level1 extends ALevel
	{
		private var _tutorial : Boolean = true;
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
		private var _offsetXEnnemies : uint = 300;
		// Tuto timer
		private var _tutoTimer : PerfectTimer;
		private var _tutoIdx : uint;

		public function Level1($duration : uint)
		{
			super($duration);
			if (CONFIG.PLAYER_TYPE == CONFIG.ATTACKER)
			{
				_tutoTimer = new PerfectTimer((CONFIG.TUTORIAL[_tutoIdx]).time, 1);
				_tutoTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			}
		}

		override public function initialize() : void
		{
			super.initialize();

			_initDecor();

			_initHurtingObjects();

			_ground = new Ground1("Platform1", {width:stage.stageWidth * 2, height:20});
			add(_ground);
			_ground.y = CONFIG.APP_HEIGHT - 180;
			_ground.x = -CONFIG.APP_WIDTH;

			_destroyer = new DestroyerSensor("theDestroyer", {width:100, height:stage.stageHeight});
			_destroyer.x = stage.stageWidth;
			_destroyer.y = 100;
			add(_destroyer);

			_checkTimer = new PerfectTimer(2000, 0);
			_checkTimer.addEventListener(TimerEvent.TIMER, _onTick);
			_checkTimer.start();

			_arrow = new ArrowIndicator();
			_arrow.x = _ground.x + CONFIG.APP_WIDTH - _offsetXEnnemies;
			_arrow.y = 400;
			addChild(_arrow);

			ActionManager.getInstance().onPositionChanged.add(_onPositionChanged);

			if (_tutoTimer != null)
				_tutoTimer.start();

			dispatchEvent(new Event(Event.INIT));
		}

		private function _onTimerComplete(event : TimerEvent) : void
		{
			if (CONFIG.TUTORIAL[_tutoIdx] != null)
			{
				_tuto.displayPicto((CONFIG.TUTORIAL[_tutoIdx]).action);
				_tuto.show();

				pause();
			}
			ActionManager.getInstance().onAction.add(_onTutorialAction);
		}

		private function _onTutorialAction(a : AAction) : void
		{
			if (a.name == _tuto.currentActionName)
			{
				ActionManager.getInstance().onAction.remove(_onTutorialAction);
				_tutoIdx++;
				if (CONFIG.TUTORIAL[_tutoIdx] != null)
					_tutoTimer.delay = (CONFIG.TUTORIAL[_tutoIdx]).time;
				_tutoTimer.reset();
				resume();
				_tuto.hide();
			}
		}

		override public function destroy() : void
		{
			_defender.destroy();
			_defender = null;
			_checkTimer.stop();
			_checkTimer.removeEventListener(TimerEvent.TIMER, _onTick);
			super.destroy();
		}

		private function _initHurtingObjects() : void
		{
			_ennemyArray = new Vector.<AHurtingObject>();

			/*var spike : Spikes = new Spikes("spikes1", {view:(LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Spike"), width:90, height:40, offsetX:-220, offsetY:-80});
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
			}*/
		}

		override protected function _onAttack(ennemi : AHurtingObject) : void
		{
			super._onAttack(ennemi);
			_ennemyArray.push(ennemi);
			add(ennemi);
			ennemi.reset();
			ennemi.x = _ground.x + CONFIG.APP_WIDTH - _offsetXEnnemies;
			ennemi.y = _ground.y - ennemi.height - ennemi.initialHeight;
			ennemi.onTouched.add(_onEnnemiTouched);
			ennemi.onDestroyed.add(_onEnnemiDestroyed);
		}

		private function _onEnnemiDestroyed() : void
		{
			ScoreManager.getInstance().add(1);

			if (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER && _tutorial)
				_tuto.hide();
		}

		private function _onEnnemiTouched() : void
		{
			_defender.hurt();
			ScoreManager.getInstance().remove(1);

			if (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER && _tutorial)
				_tuto.hide();
		}

		private function _initDecor() : void
		{
			this.scrollRect = new Rectangle(0, 0, MainGame.STAGE.stageWidth, MainGame.STAGE.stageHeight);
			this.cacheAsBitmap = true;
			var fgClass : Class = ((LoaderMax.getLoader("decors1") as SWFLoader).getClass("FG"));
			var bgClass : Class = ((LoaderMax.getLoader("decors1") as SWFLoader).getClass("BG"));
			var mgClass : Class = ((LoaderMax.getLoader("decors1") as SWFLoader).getClass("MG"));
			var bmp0 : Bitmap;
			var bmp1 : Bitmap;
			_containerFg = new Sprite();
			_containerBg = new Sprite();
			_containerMg = new Sprite();
			_containerFg.cacheAsBitmap = _containerBg.cacheAsBitmap = _containerMg.cacheAsBitmap = true;

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
			/*var _ennemi : AHurtingObject = _ennemyArray[int(UMath.randomRange(0, _ennemyArray.length - 1.01))];
			// var _ennemi : AHurtingObject = _ennemyArray[1];
			_ennemi.reset();
			_ennemi.x = _ground.x + stage.stageWidth - 200;
			_ennemi.y = _ground.y - _ennemi.height - _ennemi.initialHeight;*/

			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
				if (ennemi != null && ennemi.x < _defender.x - 100)
				{
					ennemi.kill = true;
				}
			}

			// Roulement des Backgrounds
			var tailleBg : Number = view.getArt(_currentBg).x + _containerBg.getChildAt(0).x + _containerBg.getChildAt(0).width + 200;
			if (_defender.x > tailleBg)
			{
				// trace("REMOVED Background");
				_containerBg.getChildAt(0).x = _containerBg.getChildAt(1).x + _containerBg.getChildAt(1).width - 5;
				_containerBg.setChildIndex(_containerBg.getChildAt(0), 1);
			}

			// Roulement des Middlegrounds
			var tailleMg : Number = view.getArt(_currentMg).x + _containerMg.getChildAt(0).x + _containerMg.getChildAt(0).width + 200;
			if (_defender.x > tailleMg)
			{
				// trace("REMOVED Middleground");
				_containerMg.getChildAt(0).x = _containerMg.getChildAt(1).x + _containerMg.getChildAt(1).width - 5;
				_containerMg.setChildIndex(_containerMg.getChildAt(0), 1);
			}

			// Roulement des Foregrounds
			var tailleFg : Number = view.getArt(_currentFg).x + _containerFg.getChildAt(0).x + _containerFg.getChildAt(0).width + 200;
			if (_defender.x > tailleFg)
			{
				// trace("REMOVED Foreground");
				_containerFg.getChildAt(0).x = _containerFg.getChildAt(1).x + _containerFg.getChildAt(1).width - 5;
				_containerFg.setChildIndex(_containerFg.getChildAt(0), 1);
			}
		}

		private function _onPositionChanged(code : uint) : void
		{
			switch(code)
			{
				case Keyboard.LEFT:
					_offsetXEnnemies = 500;
					break;
				case Keyboard.UP:
					_offsetXEnnemies = 300;
					break;
				case Keyboard.RIGHT:
					_offsetXEnnemies = 200;
					break;
			}
			_arrow.x = CONFIG.APP_WIDTH - _offsetXEnnemies + 100;
		}

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);
			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
				if (!ennemi.passed)
				{
					if ((ennemi.x + ennemi.width < _defender.x))
					{
						if ((ennemi is Spikes || ennemi is Lightning) && !ennemi.touched)
							ScoreManager.getInstance().add(1);
						ennemi.passed = true;
						if (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER && _tutorial)
							_tuto.hide();
					}
					else if (ennemi.x < (_defender.x + 600))
					{
						if (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER && _tutorial)
						{
							_tuto.displayPicto(ennemi.hurtAction);
							_tuto.show();
						}
					}
				}
			}
			_ground.x = _defender.x;
			_destroyer.x = _defender.x + stage.stageWidth;
		}

		override public function pause() : void
		{
			super.pause();
			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
				if (ennemi.x < _defender.x - 100)
				{
					ennemi.changeAnimation("idle");
				}
			}
			if (_tutoTimer != null) _tutoTimer.pause();
			_checkTimer.pause();
		}

		override public function resume() : void
		{
			super.resume();
			for each (var ennemi : AHurtingObject in _ennemyArray)
			{
				if (ennemi.x < _defender.x - 100)
				{
					ennemi.changeAnimation(ennemi.prevAnimation);
				}
			}
			if (_tutoTimer != null) _tutoTimer.resume();
			_checkTimer.resume();
		}
	}
}

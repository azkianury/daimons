package daimons.game.levels
{
	import daimons.score.ScoreManager;
	import Box2DAS.Dynamics.ContactEvent;

	import daimons.core.consts.PATHS;
	import daimons.game.characters.Defender;
	import daimons.game.hurtingobjects.Rock;
	import daimons.game.hurtingobjects.Wall;
	import daimons.game.hurtingobjects.abstract.AHurtingObject;
	import daimons.game.levels.abstract.ALevel;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.PhysicsObject;
	import com.citrusengine.objects.platformer.Platform;
	import com.citrusengine.physics.Box2D;

	import flash.events.TimerEvent;

	/**
	 * @author lbineau
	 */
	public class Level1 extends ALevel
	{
		private var _hero : Defender;
		private var _ground : Platform;
		// Arrière plan
		private var _currentBg : CitrusSprite;
		private var _bg : CitrusSprite;
		// Premier plan
		private var _currentFg : CitrusSprite;
		private var _fg : CitrusSprite;
		private var _ennemi : PhysicsObject;
		private var _ennemyArray : Array = [Wall, Rock];
		private var _ennemyStock : Vector.<AHurtingObject>;
		private var _currentEnnemyIdx : uint ;

		private static const MAX_ENNEMIES : uint = 10;

		public function Level1()
		{
			super();
		}

		override public function initialize() : void
		{
			_ennemyStock = new Vector.<AHurtingObject>(MAX_ENNEMIES, true);

			var box2D : Box2D = new Box2D("Box2D");
			add(box2D);
			box2D.visible = true;

			_currentBg = new CitrusSprite("Background", {view:PATHS.LEVELS_ASSETS + "level1/bg.swf", parallax:1, group:0});
			add(_currentBg);
			_hero = new Defender("Hero", {view:(PATHS.CHARACTER_ASSETS + "eon.swf"), gravity:0.5, width:50, height:100,group:2});
			_hero.offsetY = -30;
			_hero.hurtVelocityX = 1;
			_hero.hurtVelocityY = 1;
			_hero.killVelocity = 1;
			_hero.acceleration = 5;
			_hero.maxVelocity = 5;
			_hero.skidFriction = 1;
			add(_hero);
			_hero.x = 200;
			_hero.y = stage.stageHeight - 200;

			_ground = new Platform("Platform1", {width:stage.stageWidth * 2, height:20});
			add(_ground);
			_ground.y = stage.stageHeight - _ground.height;

			view.cameraTarget = _hero;
			view.cameraOffset = new MathVector(50, 200);
			view.cameraEasing.y = 0;

			_timer = new PerfectTimer(2000, 0);
			_timer.addEventListener(TimerEvent.TIMER, _onTick);
			_timer.start();

			_currentFg = new CitrusSprite("Foreground", {view:PATHS.LEVELS_ASSETS + "level1/fg.swf", parallax:1, group:3});
			add(_currentFg);
		}

		private function _onTick(event : TimerEvent) : void
		{
			_ennemi = new _ennemyArray[Math.round(Math.random())]("Ennemi" + _timer.currentCount + 1);
			add(_ennemi);
			_ennemi.x = _hero.x + stage.stageWidth;
			_ennemi.y = stage.stageHeight - 200;

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
			if(_bg != null && (_hero.x > view.getArt(_bg).x + view.getArt(_bg).width)){
				trace("REMOVED Background");
				remove(_bg);
				_bg.destroy();
				_bg = null;
			}
			if(_hero.x > (view.getArt(_currentBg).x + view.getArt(_currentBg).width) - (stage.stageWidth * 2)){
				trace("ADDED Background");
				_bg = _currentBg;
				_currentBg = new CitrusSprite("Background"+_timer.currentCount, {view:PATHS.LEVELS_ASSETS + "level1/bg.swf", x:view.getArt(_bg).x + view.getArt(_bg).width, parallax:1, group:0});
				add(_currentBg);
			}
			
			// Roulement des Foregrounds
			if(_fg != null && (_hero.x > view.getArt(_fg).x + view.getArt(_fg).width)){
				trace("REMOVED Foreground");
				remove(_fg);
				_fg.destroy();
				_fg = null;
			}
			if(_hero.x > (view.getArt(_currentFg).x + view.getArt(_currentFg).width) - (stage.stageWidth * 2)){
				trace("ADDED Foreground");
				_fg = _currentFg;
				_currentFg = new CitrusSprite("Foreground"+_timer.currentCount, {view:PATHS.LEVELS_ASSETS + "level1/fg.swf", x:view.getArt(_fg).x + view.getArt(_fg).width, parallax:1, group:3});
				add(_currentFg);
			}
		}
		override public function update(timeDelta : Number) : void
		{
			for each (var ennemi : AHurtingObject in _ennemyStock) {
				if(ennemi != null && !ennemi.passed && (ennemi.x < _hero.x)){
					
					if(!ennemi.touched)
						ScoreManager.getInstance().add(1);
					else
						ScoreManager.getInstance().remove(1);
					ennemi.passed = true;

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
			_timer.pause();
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
			_timer.start();
		}
	}
}

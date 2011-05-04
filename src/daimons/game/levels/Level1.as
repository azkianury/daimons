package daimons.game.levels
{
	import Box2DAS.Dynamics.ContactEvent;

	import daimons.core.PATHS;
	import daimons.game.characters.Defender;

	import com.citrusengine.core.State;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.platformer.Platform;
	import com.citrusengine.objects.platformer.Sensor;
	import com.citrusengine.physics.Box2D;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author lbineau
	 */
	public class Level1 extends State
	{
		private var _hero : Defender;
		// private var _ennemi:Trap;
		private var _timer : Timer;

		public function Level1()
		{
			super();
		}

		override public function initialize() : void
		{
			var box2D : Box2D = new Box2D("Box2D");
			add(box2D);
			box2D.visible = true;

			_hero = new Defender("Hero", {view:(PATHS.CHARACTER_ASSETS + "hero.swf")});
			// _hero = new GoodHero("Hero");
			_hero.offsetY = -20;
			_hero.hurtVelocityX = 1;
			_hero.hurtVelocityY = 1;
			_hero.killVelocity = 1;
			_hero.maxVelocity = 3;
			_hero.skidFriction = 1;
			add(_hero);
			_hero.x = 200;
			_hero.y = stage.stageHeight - 200;
			// _hero.onTakeDamage.add(_hurt);

			// var background:CitrusSprite = new CitrusSprite("Background", {view:BackgroundArt, parallax:0.5});
			// add(background);

			var platform1 : Platform = new Platform("Platform1", {width:10000, height:20});
			add(platform1);
			platform1.x = 0;
			platform1.y = stage.stageHeight - platform1.height;

			var sensor : Sensor = new Sensor("Reset Sensor", {width:2000, height:20});
			add(sensor);
			sensor.onBeginContact.add(_resetLevel);
			sensor.x = 0;
			sensor.y = stage.stageHeight;

			view.cameraTarget = _hero;
			view.cameraOffset = new MathVector(50, 200);
			view.cameraEasing.y = 0;

			_timer = new Timer(2000, 0);
			_timer.addEventListener(TimerEvent.TIMER, _onTick);
			_timer.start();
		}

		private function _onTick(event : TimerEvent) : void
		{
			// _ennemi = new Trap("Ennemi"+_timer.currentCount + 1);
			// add(_ennemi);
			// _ennemi.x = _hero.x + 800;
			// _ennemi.y = stage.stageHeight-200;
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
	}
}

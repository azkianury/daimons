package daimons.game.hurtingobjects.abstract
{
	import flash.utils.setTimeout;
	import Box2DAS.Dynamics.ContactEvent;

	import com.citrusengine.objects.PhysicsObject;

	import flash.utils.clearTimeout;

	/**
	 * This is a common example of a side-scrolling bad guy. He has limited logic, basically
	 * only turning around when he hits a wall.
	 * 
	 * When controlling collision interactions between two objects, such as a Horo and Baddy,
	 * I like to let each object perform its own actions, not control one object's action from the other object.
	 * For example, the Hero doesn't contain the logic for killing the Baddy, and the Baddy doesn't contain the
	 * logic for making the hero "Spring" when he kills him. 
	 */
	public class AHurtingObject extends PhysicsObject
	{
		public var speed : Number = 1.3;
		protected var _hurtAction : String;
		protected var _killed : Boolean;
		public var enemyKillVelocity : Number = 3;
		public var hurtDuration : Number = 400;
		protected var _hurtTimeoutID : Number = 0;
		protected var _hurt : Boolean = false;
		protected var _prevAnimation : String = "idle";
		protected var _touched : Boolean = false;
		protected var _passed : Boolean = false;

		public function AHurtingObject(name : String, params : Object = null)
		{
			super(name, params);
		}

		override public function destroy() : void
		{
			//trace(this + ":Destroyed");
			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, _handleBeginContact);
			clearTimeout(_hurtTimeoutID);
			super.destroy();
		}

		override protected function createBody() : void
		{
			super.createBody();
			_body.SetFixedRotation(true);
		}

		override protected function createFixture() : void
		{
			super.createFixture();
			_fixture.m_reportBeginContact = true;
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, _handleBeginContact,false,0,true);
		}

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);
			_updateAnimation();
		}

		public function hurt() : void
		{
			_hurt = true;
			_touched = false;
			_hurtTimeoutID = setTimeout(endHurtState, hurtDuration);
		}

		protected function _handleBeginContact(e : ContactEvent) : void
		{
		}

		protected function _updateAnimation() : void
		{
			//if (_hurt)
				//_animation = "die";
			//else
				//_animation = "idle";
		}

		protected function endHurtState() : void
		{
			_hurt = false;
			kill = true;
		}

		public function changeAnimation(anim : String) : void
		{
			_prevAnimation = _animation;
			_animation = anim;
		}

		public function get prevAnimation() : String
		{
			return _prevAnimation;
		}

		public function get killed() : Boolean
		{
			return _killed;
		}

		public function get touched() : Boolean
		{
			return _touched;
		}

		public function get passed() : Boolean
		{
			return _passed;
		}

		public function set passed(passed : Boolean) : void
		{
			_passed = passed;
		}

		public function get hurtAction() : String
		{
			return _hurtAction;
		}
	}
}
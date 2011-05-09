package daimons.game.hurtObjects.abstract
{
	import daimons.game.characters.Defender;

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import com.citrusengine.objects.PhysicsObject;

	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;

	/**
	 * This is a common example of a side-scrolling bad guy. He has limited logic, basically
	 * only turning around when he hits a wall.
	 * 
	 * When controlling collision interactions between two objects, such as a Horo and Baddy,
	 * I like to let each object perform its own actions, not control one object's action from the other object.
	 * For example, the Hero doesn't contain the logic for killing the Baddy, and the Baddy doesn't contain the
	 * logic for making the hero "Spring" when he kills him. 
	 */
	public class Trap extends PhysicsObject
	{
		public var speed : Number = 1.3;
		public var enemyClass : Class = Defender;
		protected var _hurtActions : Array;
		public var enemyKillVelocity : Number = 3;
		public var hurtDuration : Number = 400;
		private var _hurtTimeoutID : Number = 0;
		private var _hurt : Boolean = false;

		public function Trap(name : String, params : Object = null)
		{
			super(name, params);
		}

		override public function destroy() : void
		{
			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
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
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
		}

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);

			_updateAnimation();
		}

		public function hurt() : void
		{
			_hurt = true;
			_hurtTimeoutID = setTimeout(endHurtState, hurtDuration);
		}

		private function handleBeginContact(e : ContactEvent) : void
		{
			var colliderBody : b2Body = e.other.GetBody();
			// var enemyClassClass:Class = flash.utils.getDefinitionByName(enemyClass) as Class;
			var enemyClass : Class = enemyClass;

			if (colliderBody.GetUserData() is enemyClass){
				e.contact.Disable();
			}
		}

		protected function _updateAnimation() : void
		{
			if (_hurt)
				_animation = "die";
			else
				_animation = "walk";
		}

		private function endHurtState() : void
		{
			_hurt = false;
			kill = true;
		}
	}
}
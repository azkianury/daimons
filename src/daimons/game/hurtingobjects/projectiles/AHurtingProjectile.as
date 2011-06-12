package daimons.game.hurtingobjects.projectiles
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import daimons.game.hurtingobjects.AHurtingObject;


	/**
	 * @author lbineau
	 */
	public class AHurtingProjectile extends AHurtingObject
	{
		protected var _linearVelocity : V2;

		public function AHurtingProjectile(name : String, params : Object = null)
		{
			super(name, params);
		}

		override protected function defineBody() : void
		{
			super.defineBody();
			_bodyDef.bullet = true;
		}

		override protected function defineFixture() : void
		{
			super.defineFixture();
			_fixtureDef.density = 0.1;
			_fixtureDef.restitution = 0;
		}

		override protected function createFixture() : void
		{
			super.createFixture();
			_fixture.m_reportBeginContact = true;
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, _handleBeginContact);
		}

		override public function destroy() : void
		{
			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, _handleBeginContact);
			super.destroy();
		}

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);
			_body.SetLinearVelocity(_linearVelocity);
		}

		override protected function _handleBeginContact(e : ContactEvent) : void
		{
			super._handleBeginContact(e);
		}

		protected function _destroyMe() : void
		{
			kill = true;
		}
	}
}

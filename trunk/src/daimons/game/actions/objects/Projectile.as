package daimons.game.actions.objects
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import daimons.game.hurtingobjects.Wall;

	import com.citrusengine.objects.platformer.Crate;

	import flash.utils.setTimeout;

	/**
	 * @author lbineau
	 */
	public class Projectile extends Crate
	{
		private var _linearVelocity : V2;

		public function Projectile(name : String, params : Object = null)
		{
			_animation = "create";
			super(name, params);
			_linearVelocity = _body.GetLinearVelocity();
			_linearVelocity.x = 10;
			var pHitVector : V2 = new V2(this.x, this.y);
			var appForce : V2 = new V2(pHitVector.x * .1, pHitVector.y * .1);
			_body.ApplyImpulse(appForce, _body.GetWorldCenter());
			// _body.ApplyImpulse(new b2Vec2(0.5) as V2, new V2(this.x,this.y))
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

		protected function _handleBeginContact(e : ContactEvent) : void
		{
			var colliderBody : b2Body = e.other.GetBody();

			if (colliderBody.GetUserData() is Wall)
			{
				if (!(colliderBody.GetUserData() as Wall).killed)
				{
					_linearVelocity.x = 0;
					e.contact.Disable();
					setTimeout(_destroyMe, 500);
					_animation = "destroy";
				}else{
					e.contact.Disable();					
				}
			}
			else
			{
				_linearVelocity.x = 0;
				_destroyMe();
			}
		}

		private function _destroyMe() : void
		{
			//CitrusEngine.getInstance().state.remove(this);
			kill = true;
		}
	}
}

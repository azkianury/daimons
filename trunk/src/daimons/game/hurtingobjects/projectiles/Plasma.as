package daimons.game.hurtingobjects.projectiles
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import daimons.game.hurtingobjects.statics.Wall;

	import flash.utils.setTimeout;

	/**
	 * @author lbineau
	 */
	public class Plasma extends AHurtingProjectile
	{
		public function Plasma(name : String, params : Object = null)
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

		override protected function _handleBeginContact(e : ContactEvent) : void
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
				}
				else
				{
					e.contact.Disable();
				}
			}
			else
			{
				_linearVelocity.x = 0;
				_animation = "destroy";
				setTimeout(_destroyMe, 300);
				// _destroyMe();
			}
			super._handleBeginContact(e);
		}
	}
}

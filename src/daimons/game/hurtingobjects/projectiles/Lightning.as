package daimons.game.hurtingobjects.projectiles
{
	import daimons.game.actions.Actions;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import daimons.game.actions.ActionManager;
	import daimons.game.characters.Defender;

	/**
	 * @author lbineau
	 */
	public class Lightning extends AHurtingProjectile
	{
		public var enemyClass : Class = Defender;

		public function Lightning(name : String, params : Object = null)
		{
			_initialHeight = 100;
			_hurtAction = Actions.CROUCH;
			super(name, params);
			_linearVelocity = _body.GetLinearVelocity();
			_linearVelocity.x = -10;
			var pHitVector : V2 = new V2(this.x, this.y);
			var appForce : V2 = new V2(pHitVector.x * .1, pHitVector.y * .1);
			_body.ApplyImpulse(appForce, _body.GetWorldCenter());
		}

		override public function reset() : void
		{
			super.reset();
			_touched = false;
		}

		override protected function _handleBeginContact(e : ContactEvent) : void
		{
			super._handleBeginContact(e);
			var colliderBody : b2Body = e.other.GetBody();

			if (colliderBody.GetUserData() is enemyClass)
			{
				if (ActionManager.getInstance().currentAction.name == Actions.CROUCH)
				{
					_touched = false;
				}
				else
				{
					_touched = true;
					onTouched.dispatch();
				}
			}
		}
	}
}

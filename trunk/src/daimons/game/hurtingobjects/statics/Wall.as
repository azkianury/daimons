package daimons.game.hurtingobjects.statics
{
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	import daimons.game.actions.ActionManager;
	import daimons.game.characters.Defender;
	import daimons.game.hurtingobjects.projectiles.Plasma;
	import flash.utils.setTimeout;



	/**
	 * @author lbineau
	 */
	public class Wall extends AHurtingObject
	{
		public var enemyClass : Class = Defender;

		public function Wall(name : String, params : Object = null)
		{
			_hurtAction = ActionManager.PUNCH;
			_touched = true;
			super(name, params);
		}

		override public function reset() : void
		{
			super.reset();
			_touched = true;
		}

		override protected function _handleBeginContact(e : ContactEvent) : void
		{
			super._handleBeginContact(e);
			var colliderBody : b2Body = e.other.GetBody();

			if (colliderBody.GetUserData() is enemyClass)
			{
				e.contact.Disable();
				if (ActionManager.getInstance().currentAction.name == _hurtAction && _touched)
				{
					_touched = false;
					_animation = "destroy";
					onDestroyed.dispatch();
				}
				else if (_touched)
				{
					onTouched.dispatch();
				}
			}
			if (!_killed && colliderBody.GetUserData() is Plasma)
			{
				e.contact.Disable();
				_touched = false;
				setTimeout(_destroyMe, 100);

				_animation = "destroy";
				onDestroyed.dispatch();
			}
		}

		private function _destroyMe() : void
		{
			_killed = true;
		}
	}
}

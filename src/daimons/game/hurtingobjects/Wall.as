package daimons.game.hurtingobjects
{
	import flash.utils.setTimeout;

	import org.osflash.signals.Signal;

	import daimons.game.actions.objects.Projectile;

	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import daimons.core.consts.PATHS;
	import daimons.game.actions.ActionManager;
	import daimons.game.characters.Defender;
	import daimons.game.hurtingobjects.abstract.AHurtingObject;

	/**
	 * @author lbineau
	 */
	public class Wall extends AHurtingObject
	{
		public var enemyClass : Class = Defender;

		public function Wall(name : String, params : Object = null)
		{
			if (params == null)
			{
				params = new Object();
				params.width = 10;
				params.height = 200;
				params.view = PATHS.HURTING_OBJECTS_ASSETS + "mur.swf";
			}
			_hurtAction = ActionManager.PUNCH;
			_touched = true;
			super(name, params);
		}

		override protected function _handleBeginContact(e : ContactEvent) : void
		{
			var colliderBody : b2Body = e.other.GetBody();

			if (colliderBody.GetUserData() is enemyClass)
			{
				e.contact.Disable();
				if (ActionManager.getInstance().currentAction.name == _hurtAction)
				{
					_touched = false;

					// hurt();
				}
			}
			if (!_killed && colliderBody.GetUserData() is Projectile)
			{
				e.contact.Disable();
				_touched = false;
				// hurt();
			}
		}
	}
}

package daimons.game.hurtingobjects
{
	import flash.ui.Keyboard;
	import daimons.core.KeyManager;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import daimons.core.PATHS;
	import daimons.game.hurtingobjects.abstract.AHurtingObject;

	/**
	 * @author lbineau
	 */
	public class Wall extends AHurtingObject
	{
		public function Wall(name : String, params : Object = null)
		{
			if (params == null)
			{
				params = new Object();
				params.view = PATHS.CHARACTER_ASSETS + "hero.swf";
			}
			super(name, params);
		}

		override protected function _handleBeginContact(e : ContactEvent) : void
		{
			var colliderBody : b2Body = e.other.GetBody();

			if (colliderBody.GetUserData() is enemyClass)
			{
				trace(KeyManager.getInstance().curentKeyDown);
				if(KeyManager.getInstance().curentKeyDown == Keyboard.A){
					hurt();
					KeyManager.getInstance().resetKeyDown();
				}
			}
			super._handleBeginContact(e);
		}
	}
}

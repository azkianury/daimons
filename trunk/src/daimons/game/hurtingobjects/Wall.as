package daimons.game.hurtingobjects
{
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
				params.view = PATHS.CHARACTER_ASSETS + "hero.swf";
			}
			super(name, params);
		}

		override protected function _handleBeginContact(e : ContactEvent) : void
		{
			var colliderBody : b2Body = e.other.GetBody();
			// var enemyClassClass:Class = flash.utils.getDefinitionByName(enemyClass) as Class;

			if (colliderBody.GetUserData() is enemyClass)
			{
				e.contact.Disable();
				if (ActionManager.getInstance().currentAction.name == "plasma")
				{
					hurt();
				}
			}
		}
	}
}

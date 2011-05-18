package daimons.game.hurtingobjects
{
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import daimons.game.actions.ActionManager;
	import daimons.game.characters.Defender;
	import daimons.game.hurtingobjects.abstract.AHurtingObject;

	/**
	 * @author lbineau
	 */
	public class Spikes extends AHurtingObject
	{
		public var enemyClass : Class = Defender;

		public function Spikes(name : String, params : Object = null)
		{
			if (params == null)
			{
				params = new Object();
				params.width = 100;
				params.height = 50;
				//params.view = PATHS.HURTING_OBJECTS_ASSETS + "rocher.swf";
			}
			_hurtAction = ActionManager.JUMP;
			super(name, params);
		}

		override protected function _handleBeginContact(e : ContactEvent) : void
		{
			var colliderBody : b2Body = e.other.GetBody();

			if (colliderBody.GetUserData() is enemyClass)
			{
				e.contact.Disable();
				_touched = true;
			}
		}

		override protected function createShape() : void
		{
			_shape = new b2PolygonShape();
			b2PolygonShape(_shape).SetAsBox(_width / 2, _height / 2);
		}
	}
}

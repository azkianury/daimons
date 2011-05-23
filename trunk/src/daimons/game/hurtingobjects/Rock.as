package daimons.game.hurtingobjects
{
	import daimons.core.consts.PATHS;
	import Box2DAS.Collision.Shapes.b2CircleShape;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import daimons.game.actions.ActionManager;
	import daimons.game.characters.Defender;
	import daimons.game.hurtingobjects.abstract.AHurtingObject;

	/**
	 * @author lbineau
	 */
	public class Rock extends AHurtingObject
	{
		private var _radius : Number;
		public var enemyClass : Class = Defender;

		public function Rock(name : String, params : Object = null)
		{
			if (params == null)
			{
				params = new Object();
				params.radius = 70;
				params.offsetX = -70;
				params.view = PATHS.HURTING_OBJECTS_ASSETS + "rocher.swf";
			}
			_hurtAction = ActionManager.SHIELD;
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
				}
			}
		}

		override protected function createShape() : void
		{
			_shape = new b2CircleShape();
			b2CircleShape(_shape).m_radius = _radius;
		}

		public function get radius() : Number
		{
			return _radius * _box2D.scale;
		}

		public function set radius(radius : Number) : void
		{
			_radius = radius / _box2D.scale;
		}
	}
}

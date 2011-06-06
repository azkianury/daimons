package daimons.game.hurtingobjects.statics
{
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	import daimons.game.actions.ActionManager;
	import daimons.game.characters.Defender;


	/**
	 * @author lbineau
	 */
	public class Spikes extends AHurtingObject
	{
		public var enemyClass : Class = Defender;

		public function Spikes(name : String, params : Object = null)
		{
			_hurtAction = ActionManager.JUMP;
			super(name, params);
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
				e.contact.Disable();
				_touched = true;
				onTouched.dispatch();
			}
		}

		override protected function createShape() : void
		{
			_shape = new b2PolygonShape();
			b2PolygonShape(_shape).SetAsBox(_width / 2, _height / 2);
		}
	}
}

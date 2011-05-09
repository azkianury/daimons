package daimons.game.hurtObjects
{
	import Box2DAS.Collision.Shapes.b2CircleShape;

	import daimons.game.hurtObjects.abstract.Trap;

	/**
	 * @author lbineau
	 */
	public class Rock extends Trap
	{
		private var _radius : Number;

		public function Rock(name : String, params : Object = null)
		{
			if(params == null){
				params = new Object();
				params.radius = 50;
			}
			super(name, params);
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

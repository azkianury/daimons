package daimons.game.sensors
{
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import com.citrusengine.objects.platformer.Sensor;

	/**
	 * @author lbineau
	 */
	public class DestroyerSensor extends Sensor
	{
		public function DestroyerSensor(name : String, params : Object = null)
		{
			super(name, params);
		}

		override protected function handleBeginContact(e : ContactEvent) : void
		{
			super.handleBeginContact(e);
			var colliderBody : b2Body = e.other.GetBody();
			colliderBody.GetUserData().kill = true;
			trace("DestroyerSensor has killed " + colliderBody.GetUserData());
		}
	}
}

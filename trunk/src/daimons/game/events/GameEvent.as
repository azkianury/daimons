package daimons.game.events
{
	import flash.events.Event;

	/**
	 * @author lbineau
	 */
	public class GameEvent extends Event
	{
		public static const CALIBRATED : String = 'calibrated';
		public function GameEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}

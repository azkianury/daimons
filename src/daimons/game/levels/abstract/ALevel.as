package daimons.game.levels.abstract
{
	import org.osflash.signals.Signal;

	import com.citrusengine.core.State;

	/**
	 * @author lbineau
	 */
	public class ALevel extends State
	{
		public var lvlEnded : Signal;

		public function ALevel()
		{
			super();
			init();
		}

		public function init() : void
		{
			lvlEnded = new Signal();
		}

		override public function destroy() : void
		{
			lvlEnded.removeAll();
			super.destroy();
		}
	}
}

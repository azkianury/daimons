package daimons.game.levels.abstract
{
	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.State;

	import org.osflash.signals.Signal;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	/**
	 * @author lbineau
	 */
	public class ALevel extends State implements ILevel
	{
		public var lvlEnded : Signal;
		protected var _timer : PerfectTimer;

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

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);
		}

		public function pause() : void
		{
		}

		public function resume() : void
		{
		}
	}
}

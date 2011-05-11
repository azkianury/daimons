package daimons.core
{
	import flash.utils.clearTimeout;
	import flash.trace.Trace;
	import com.citrusengine.core.CitrusEngine;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	public final class KeyManager
	{
		private static var instance : KeyManager = new KeyManager();
		private var _curentKeyDown : uint = 0;
		private var _timeOutRest:uint;

		public function KeyManager()
		{
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}

		public static function getInstance() : KeyManager
		{
			return instance;
		}

		private function _onKeyDown(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.A:
				case Keyboard.Z:
					trace("Keyb : "+ event.keyCode);
					_curentKeyDown = event.keyCode;
					_timeOutRest = setTimeout(resetKeyDown, 1000);
					break;
			}
		}

		public function resetKeyDown() : void
		{
			_curentKeyDown = 0;
			clearTimeout(_timeOutRest);
		}

		public function get curentKeyDown() : uint
		{
			return _curentKeyDown;
		}
	}
}
package daimons.game.actions
{
	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author lbineau
	 */
	public class AAction
	{
		protected var _view : DisplayObject;
		protected var _name : String;
		protected var _persistence : Number;
		protected var _idleGameDelay : Number;
		protected var _active : Boolean;
		protected var _busy : Boolean;
		protected var _keyCode : uint;

		public function AAction($view : DisplayObject, $name : String, $keyCode : uint, $persistence : Number, $idleGameDelay : Number, $active : Boolean = false)
		{
			_view = $view;
			_name = $name;
			_persistence = $persistence;
			_idleGameDelay = $idleGameDelay;
			_active = $active;
			_keyCode = $keyCode;
		}

		public function startBusy() : void
		{
			_busy = true;
			var t : Timer = new Timer(_idleGameDelay, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, _onEndBusy, false, 0, true);
			t.start();
			TweenLite.to((view as MovieClip), idleGameDelay / 1000, {frameLabel:"_disabled"});

		}

		private function _onEndBusy(event : TimerEvent) : void
		{
			(event.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, _onEndBusy);
			(view as MovieClip).gotoAndStop("idle");
			_busy = false;
		}

		public function get name() : String
		{
			return _name;
		}

		public function set name(name : String) : void
		{
			_name = name;
		}

		public function get persistence() : Number
		{
			return _persistence;
		}

		public function get active() : Boolean
		{
			return _active;
		}

		public function set active(active : Boolean) : void
		{
			_active = active;
		}

		public function get view() : DisplayObject
		{
			return _view;
		}

		public function get idleGameDelay() : Number
		{
			return _idleGameDelay;
		}

		public function set idleGameDelay(idleGameDelay : Number) : void
		{
			_idleGameDelay = idleGameDelay;
		}

		public function get busy() : Boolean
		{
			return _busy;
		}

		public function set busy(busy : Boolean) : void
		{
			_busy = busy;
		}

		public function get keyCode() : uint
		{
			return _keyCode;
		}
	}
}

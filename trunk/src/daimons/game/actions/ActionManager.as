package daimons.game.actions
{
	import daimons.game.actions.abstract.AAction;
	import org.osflash.signals.Signal;

	import daimons.game.actions.objects.DefenseAction;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.core.CitrusEngine;

	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;

	public final class ActionManager
	{
		private static var instance : ActionManager = new ActionManager();
		private var _busy : Boolean = false;
		private var _defendArray : Array;
		private var _currentAction : AAction;
		private var _timerBusy : PerfectTimer;
		
		public var onAction : Signal;
		public static const NONE : String = "none";
		public static const PUNCH : String = "punch";
		public static const SHIELD : String = "shield";
		public static const JUMP : String = "jump";

		public function ActionManager()
		{
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_defendArray = [];
			_defendArray[NONE] = new DefenseAction(NONE, 100);
			_defendArray[PUNCH] = new DefenseAction(PUNCH, 1000);
			_defendArray[SHIELD] = new DefenseAction(SHIELD, 1000);
			_defendArray[JUMP] = new DefenseAction(JUMP, 1000);
			_currentAction = _defendArray[NONE];
			onAction = new Signal(AAction);
		}

		public static function getInstance() : ActionManager
		{
			return instance;
		}

		private function _onKeyDown(event : KeyboardEvent) : void
		{
			if (!_busy)
			{
				var delay : Number;
				switch(event.keyCode)
				{
					case Keyboard.NUMBER_1:
						_currentAction = _defendArray[PUNCH];
						_busy = true;
						break;
					case Keyboard.NUMBER_2:
						_currentAction = _defendArray[SHIELD];
						_busy = true;
						break;
					case Keyboard.SPACE:
						_currentAction = _defendArray[JUMP];
						break;
				}
				onAction.dispatch(_currentAction);
				if (_busy)
				{
					_clearTimer();
					delay = _currentAction.persistence;
					_timerBusy = new PerfectTimer(delay, 1);
					_timerBusy.addEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);
					_timerBusy.start();
				}
			}
		}

		private function _clearTimer() : void
		{
			if (_timerBusy != null)
			{
				_timerBusy.removeEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);
				_timerBusy = null;
			}
		}

		private function _endBusy(event : TimerEvent) : void
		{
			_timerBusy.removeEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);
			trace("_endBusy : " + _currentAction.name);
			_currentAction = _defendArray[NONE];
			// Reset the action to none
			_busy = false;
		}

		public function get currentAction() : AAction
		{
			return _currentAction;
		}

		public function get busy() : Boolean
		{
			return _busy;
		}
	}
}
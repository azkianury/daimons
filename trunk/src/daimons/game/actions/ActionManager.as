package daimons.game.actions
{
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
		private var _defendArray : Vector.<DefenseAction>;
		private var _currentAction : DefenseAction;
		private var _timerBusy:PerfectTimer;

		public function ActionManager()
		{
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_defendArray = new Vector.<DefenseAction>(4, true);
			_currentAction = _defendArray[0] = new DefenseAction("none", 100);
			_defendArray[1] = new DefenseAction("plasma", 1000);
			_defendArray[2] = new DefenseAction("shield", 1000);
			_defendArray[3] = new DefenseAction("jump", 1000);
		}

		public static function getInstance() : ActionManager
		{
			return instance;
		}

		private function _onKeyDown(event : KeyboardEvent) : void
		{
			if(!_busy){
				var delay:Number;
				switch(event.keyCode)
				{
					case Keyboard.A:
						_currentAction = _defendArray[1];
						_busy = true;
						break;
					case Keyboard.Z:
						_currentAction = _defendArray[2];
						_busy = true;
						break;
					case Keyboard.SPACE:
						_currentAction = _defendArray[3];
						_busy = true;
						break;
				}
				if(_busy){
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
			if(_timerBusy != null){
				_timerBusy.removeEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);
				_timerBusy = null;
			}
		}

		private function _endBusy(event : TimerEvent) : void
		{
			_timerBusy.removeEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);
			trace("_endBusy : "+_currentAction.name);
			_currentAction = _defendArray[0]; // Reset the action to none
			_busy = false;
		}

		public function get currentAction() : DefenseAction
		{
			return _currentAction;
		}
	}
}
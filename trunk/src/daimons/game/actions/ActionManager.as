package daimons.game.actions
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	import daimons.game.actions.abstract.AAction;
	import daimons.game.actions.objects.DefenseAction;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.core.CitrusEngine;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;

	public final class ActionManager
	{
		private static var instance : ActionManager = new ActionManager();
		private var _view : MovieClip;
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
			_defendArray[NONE] = new DefenseAction(new Sprite(), NONE, 100, true);
			_defendArray[PUNCH] = new DefenseAction(new PunchAction(), PUNCH, 1000, true);
			_defendArray[SHIELD] = new DefenseAction(new ShieldAction(), SHIELD, 1000, true);
			_defendArray[JUMP] = new DefenseAction(new JumpAction(), JUMP, 1000, true);

			_currentAction = _defendArray[NONE];

			_timerBusy = new PerfectTimer(1000, 1);
			_timerBusy.addEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);

			onAction = new Signal(AAction);
		}

		public function activateAction(name : String) : void
		{
			(_defendArray[name] as AAction).active = true;
			_updateUI();
		}

		private function _updateUI() : void
		{
			var i : uint;
			for each (var action : AAction in _defendArray)
			{
				if (action.active)
				{
					action.view.x = i;
					_view.addChild(action.view);
					i += 200;
				}
			}
			TweenLite.to(_view["bg"], 1, {width:_view.width});
			TweenLite.to(_view, 1, {x:((_view.stage.stageWidth - _view.width) / 2),y:_view.stage.stageHeight - _view.height});
		}

		public function deactivateAction(name : String) : void
		{
			(_defendArray[name] as AAction).active = false;
			_updateUI();
		}

		public function init(view : MovieClip) : void
		{
			_view = view;
			_view.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event : Event) : void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_updateUI();
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
					case Keyboard.F1:
						_currentAction = _defendArray[PUNCH];
						_busy = true;
						break;
					case Keyboard.F2:
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
					delay = _currentAction.persistence;
					_timerBusy.delay = delay;
					_timerBusy.reset();
					_timerBusy.start();
				}
			}
		}

		private function _clearTimer() : void
		{
			if (_timerBusy != null)
			{
				_timerBusy.removeEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);
			}
		}

		private function _endBusy(event : TimerEvent) : void
		{
			// Reset the action to none
			_currentAction = _defendArray[NONE];
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

		public function get view() : MovieClip
		{
			return _view;
		}
	}
}
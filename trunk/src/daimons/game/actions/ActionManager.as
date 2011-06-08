package daimons.game.actions
{
	import com.greensock.TimelineLite;

	import flash.display.Graphics;

	import daimons.core.consts.CONFIG;

	import fr.lbineau.utils.PerfectTimer;

	import com.citrusengine.core.CitrusEngine;
	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;

	public final class ActionManager
	{
		private static var instance : ActionManager = new ActionManager();
		private var _view : MovieClip;
		private var _busy : Boolean = false;
		private var _defendArray : Object, _attackArray : Object;
		private var _defendArrayLength : uint, _attackArrayLength : uint;
		private var _timerBusy : PerfectTimer, _timerAnim : PerfectTimer;
		private var _currentAction : AAction;
		public var onAction : Signal;
		private var addAction : Signal;
		private var removeAction : Signal;

		public function ActionManager()
		{
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			switch(CONFIG.PLAYER_TYPE)
			{
				case CONFIG.DEFENDER:
					_defendArray = [];
					_defendArray.none = new DefenseAction(new MovieClip(), Actions.NONE, 100, 100, true);
					_defendArray.punch = new DefenseAction(new PunchAction(), Actions.PUNCH, 900, 900, true);
					_defendArray.shield = new DefenseAction(new ShieldAction(), Actions.SHIELD, 2000, 2000, true);
					_defendArray.jump = new DefenseAction(new JumpAction(), Actions.JUMP, 500, 500, true);
					_defendArray.crouch = new DefenseAction(new CrouchAction(), Actions.CROUCH, 1000, 1000, true);
					_defendArray.bubble = new DefenseAction(new BubbleAction(), Actions.BUBBLE, 1300, 1300, true);
					_currentAction = _defendArray[Actions.NONE];
					for each (var a : AAction in _defendArray)
						if ((a as AAction).active) _defendArrayLength++;
					break;
				case CONFIG.ATTACKER:
					_attackArray = [];
					_attackArray.none = new AttackAction(new MovieClip(), Actions.NONE, 100, 100, true);
					_attackArray.punch = new AttackAction(new PunchAction(), Actions.PUNCH, 1000, 1000, true);
					_attackArray.shield = new AttackAction(new ShieldAction(), Actions.SHIELD, 1500, 1500, true);
					_attackArray.jump = new AttackAction(new JumpAction(), Actions.JUMP, 500, 500, true);
					_currentAction = _attackArray[Actions.NONE];
					for each (var a : AAction in _attackArray)
						if ((a as AAction).active) _attackArrayLength++;
					break;
				default:
			}

			_timerBusy = new PerfectTimer(1000, 1);
			_timerBusy.addEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);

			onAction = new Signal(AAction);
			addAction = new Signal(AAction);
			removeAction = new Signal(AAction);
		}

		public function deactivateAction(name : String) : void
		{
			(_defendArray[name] as AAction).active = false;
			removeAction.dispatch(_defendArray[name] as AAction);
			_defendArrayLength--;
			_updateUI();
		}

		public function activateAction(name : String) : void
		{
			(_defendArray[name] as AAction).active = true;
			addAction.dispatch(_defendArray[name] as AAction);
			_defendArrayLength++;
			_updateUI();
		}

		private function _updateUI() : void
		{
			var i : uint = 40;
			var nb : uint = _defendArrayLength - 2;
			trace(nb)
			var graph : Graphics = (view as Sprite).graphics;
			graph.clear();
			graph.lineStyle(2, 0x606060, 0.4, true);
			for each (var action : AAction in _defendArray)
			{
				if (action != _defendArray[Actions.NONE])
				{
					if (action.active)
					{
						action.view.x = i + 10;
						action.view.y = 10;
						_view.addChild(action.view);
						i = action.view.x + action.view.width + 20;
						if (nb > 0)
						{
							graph.moveTo(i, 20);
							graph.lineTo(i, 125);
							graph.endFill();
							nb--;
						}
					}
					else
					{
						if (_view.contains(action.view))
							_view.removeChild(action.view);
					}
				}
			}
			i -= 20;
			var tl : TimelineLite = new TimelineLite();
			tl.append(TweenLite.to(_view["bg"], 0.5, {width:i + 50}));
			tl.append(TweenLite.to(_view, 0.5, {x:((_view.stage.stageWidth - _view.width) / 2 - 200), y:_view.stage.stageHeight - _view.height}));
		}

		public function init(view : MovieClip) : void
		{
			_view = view;
			_view.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event : Event) : void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_view.y = _view.stage.stageHeight;
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
						if ((_defendArray[Actions.PUNCH] as AAction).active)
						{
							_currentAction = _defendArray[Actions.PUNCH];
							_busy = true;
						}
						break;
					case Keyboard.F2:
						if ((_defendArray[Actions.SHIELD] as AAction).active)
						{
							_currentAction = _defendArray[Actions.SHIELD];
							_busy = true;
						}
						break;
					case Keyboard.F3:
						if ((_defendArray[Actions.BUBBLE] as AAction).active)
						{
							_currentAction = _defendArray[Actions.BUBBLE];
							_busy = true;
						}
						break;
					case Keyboard.SPACE:
						if ((_defendArray[Actions.JUMP] as AAction).active)
						{
							_currentAction = _defendArray[Actions.JUMP];
							_busy = true;
						}
						break;
					case Keyboard.DOWN:
						if ((_defendArray[Actions.CROUCH] as AAction).active)
						{
							_currentAction = _defendArray[Actions.CROUCH];
							_busy = true;
						}
						break;
					case Keyboard.F12:
						activateAction(Actions.BUBBLE);
						break;
				}
				for each (var action : AAction in _defendArray)
				{
					if (action.active && action === _currentAction)
						(action.view as MovieClip).gotoAndPlay("active");
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
			(_currentAction.view as MovieClip).gotoAndPlay("idle");
			// Reset the action to none
			_currentAction = _defendArray[Actions.NONE];
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
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
		public static const NONE : String = "none";
		public static const PUNCH : String = "punch";
		public static const SHIELD : String = "shield";
		public static const JUMP : String = "jump";
		public static const CROUCH : String = "crouch";

		public function ActionManager()
		{
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);

			switch(CONFIG.PLAYER_TYPE)
			{
				case CONFIG.DEFENDER:
					_defendArray = [];
					_defendArray.none = new DefenseAction(new MovieClip(), NONE, 100, 100, true);
					_defendArray.punch = new DefenseAction(new PunchAction(), PUNCH, 900, 900, true);
					_defendArray.shield = new DefenseAction(new ShieldAction(), SHIELD, 1500, 1500, true);
					_defendArray.jump = new DefenseAction(new JumpAction(), JUMP, 500, 500, true);
					_defendArray.crouch = new DefenseAction(new CrouchAction(), CROUCH, 1000, 1000, true);
					_currentAction = _defendArray[NONE];
					for (var sd:String in _defendArray) _defendArrayLength++;
					break;
				case CONFIG.ATTACKER:
					_attackArray = [];
					_attackArray.none = new AttackAction(new MovieClip(), NONE, 100, 100, true);
					_attackArray.punch = new AttackAction(new PunchAction(), PUNCH, 1000, 1000, true);
					_attackArray.shield = new AttackAction(new ShieldAction(), SHIELD, 1500, 1500, true);
					_attackArray.jump = new AttackAction(new JumpAction(), JUMP, 500, 500, true);
					_currentAction = _attackArray[NONE];
					for (var sa:String in _defendArray) _attackArrayLength++;
					break;
				default:
			}

			_timerBusy = new PerfectTimer(1000, 1);
			_timerBusy.addEventListener(TimerEvent.TIMER_COMPLETE, _endBusy);

			onAction = new Signal(AAction);
		}

		public function deactivateAction(name : String) : void
		{
			(_defendArray[name] as AAction).active = false;

			_updateUI();
		}

		public function activateAction(name : String) : void
		{
			(_defendArray[name] as AAction).active = true;
			_updateUI();
		}

		private function _updateUI() : void
		{
			var i : uint = 40;
			var graph:Graphics = (view as Sprite).graphics;
			graph.clear();
			graph.lineStyle(2, 0x606060, 0.4, true);
			for each (var action : AAction in _defendArray)
			{
				if (action != _defendArray[NONE])
				{
					if(action.active){
						action.view.x = i + 20;
						action.view.y = 10;
						_view.addChild(action.view);
						i = action.view.x + action.view.width + 40;
						graph.moveTo(i, 20);
						graph.lineTo(i, 125);
						graph.endFill();
					}else{
						for (var j : int = 0; j < view.numChildren; j++) {
							if(view.getChildAt(j) == action.view)
								_view.removeChild(action.view);
						}
					}
				}
			}
			var tl : TimelineLite = new TimelineLite();
			tl.append(TweenLite.to(_view["bg"], 0.5, {width:i+50}));
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
						_currentAction = _defendArray[PUNCH];
						_busy = true;
						break;
					case Keyboard.F2:
						_currentAction = _defendArray[SHIELD];
						_busy = true;
						break;
					case Keyboard.SPACE:
						_currentAction = _defendArray[JUMP];
						_busy = true;
						break;
					case Keyboard.DOWN:
						_currentAction = _defendArray[CROUCH];
						_busy = true;
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
			deactivateAction(ActionManager.JUMP);
			(_currentAction.view as MovieClip).gotoAndPlay("idle");
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
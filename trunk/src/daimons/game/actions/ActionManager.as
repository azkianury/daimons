package daimons.game.actions
{
	import daimons.core.consts.CONFIG;

	import com.citrusengine.core.CitrusEngine;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	public final class ActionManager
	{
		private static var instance : ActionManager = new ActionManager();
		private var _view : MovieClip;
		private var _busyDefender : Boolean = false, _animBusyDefender : Boolean = false;
		private var _busyAttacker : Boolean = false, _animBusyAttacker : Boolean = false;
		private var _defendArray : Object, _attackArray : Object;
		private var _defendArrayLength : uint, _attackArrayLength : uint;
		private var _timerBusy : Timer, _timerAnim : Timer;
		private var _currentAction : AAction;
		public var onAction : Signal;
		private var addAction : Signal;
		private var removeAction : Signal;
		public var onEndedAnim : Signal;
		private var _currentKey : uint;

		public function ActionManager()
		{
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);

			_defendArray = [];
			_defendArray.none = new DefenseAction(new MovieClip(), Actions.NONE, 100, 100, false);
			_defendArray.punch = new DefenseAction(new PunchAction(), Actions.PUNCH, 1000, 900, true);
			_defendArray.shield = new DefenseAction(new ShieldAction(), Actions.SHIELD, 2000, 1300, true);
			_defendArray.jump = new DefenseAction(new JumpAction(), Actions.JUMP, 1000, 200, true);
			_defendArray.crouch = new DefenseAction(new CrouchAction(), Actions.CROUCH, 1200, 1000, true);
			_defendArray.bubble = new DefenseAction(new BubbleAction(), Actions.BUBBLE, 3000, 2000, true);
			_currentAction = _defendArray[Actions.NONE];
			for each (var d : AAction in _defendArray)
				if ((d as AAction).active) _defendArrayLength++;

			_attackArray = [];
			_attackArray.wall = new AttackAction(new WallAction(), Actions.WALL, 1000, 1000, true);
			_attackArray.rock = new AttackAction(new RockAction(), Actions.ROCK, 1500, 1500, true);
			_attackArray.spikes = new AttackAction(new SpikesAction(), Actions.SPIKES, 500, 500, true);
			_attackArray.lightning = new AttackAction(new LightningAction(), Actions.LIGHTNING, 1000, 1000, true);
			_attackArray.thunder = new AttackAction(new ThunderAction(), Actions.THUNDER, 1500, 1500, true);
			for each (var a : AAction in _attackArray)
				if ((a as AAction).active) _attackArrayLength++;

			onEndedAnim = new Signal();
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
			var nb : uint;
			var graph : Graphics = (view as Sprite).graphics;
			graph.clear();
			graph.lineStyle(2, 0x606060, 0.4, true);
			if (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER)
			{
				nb = _defendArrayLength - 1;
				for each (var d : AAction in _defendArray)
				{
					if (d.active)
					{
						d.view.x = i + 10;
						d.view.y = 10;
						_view.addChild(d.view);
						i = d.view.x + d.view.width + 20;
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
						if (_view.contains(d.view))
							_view.removeChild(d.view);
					}
				}
			}
			else if (CONFIG.PLAYER_TYPE == CONFIG.ATTACKER)
			{
				nb = _attackArrayLength - 1;
				for each (var a : AAction in _attackArray)
				{
					if (a.active)
					{
						a.view.x = i + 10;
						a.view.y = 10;
						_view.addChild(a.view);
						i = a.view.x + a.view.width + 20;
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
						if (_view.contains(a.view))
							_view.removeChild(a.view);
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
			_currentKey = event.keyCode;
			if (!_busyDefender)
			{
				switch(event.keyCode)
				{
					case Keyboard.F1:
						if ((_defendArray[Actions.PUNCH] as AAction).active)
						{
							_currentAction = _defendArray[Actions.PUNCH];
							_busyDefender = true;
						}
						break;
					case Keyboard.F2:
						if ((_defendArray[Actions.SHIELD] as AAction).active)
						{
							_currentAction = _defendArray[Actions.SHIELD];
							_busyDefender = true;
						}
						break;
					case Keyboard.F3:
						if ((_defendArray[Actions.BUBBLE] as AAction).active)
						{
							_currentAction = _defendArray[Actions.BUBBLE];
							_busyDefender = true;
						}
						break;
					case Keyboard.SPACE:
						if ((_defendArray[Actions.JUMP] as AAction).active)
						{
							_currentAction = _defendArray[Actions.JUMP];
							_busyDefender = true;
						}
						break;
					case Keyboard.DOWN:
						if ((_defendArray[Actions.CROUCH] as AAction).active)
						{
							_currentAction = _defendArray[Actions.CROUCH];
							_busyDefender = true;
						}
						break;
				}
				if (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER)
				{
					for each (var d : AAction in _defendArray)
					{
						if (d.active && d === _currentAction)
							(d.view as MovieClip).gotoAndPlay("active");
					}
				}
				if (_busyDefender)
				{
					_timerBusy = null;
					_timerBusy = new Timer(_currentAction.idleGameDelay, 1);
					_timerBusy.addEventListener(TimerEvent.TIMER_COMPLETE, _endBusyDefender, false, 0, true);
					_timerBusy.start();

					_timerAnim = null;
					_timerAnim = new Timer(_currentAction.persistence, 1);
					_timerAnim.addEventListener(TimerEvent.TIMER_COMPLETE, _endAnimBusy, false, 0, true);
					_timerAnim.start();

					_animBusyDefender = _busyDefender;

					onAction.dispatch(_currentAction);
				}
			}
			if (!_busyAttacker)
			{
				switch(event.keyCode)
				{
					case Keyboard.F12:
						if ((_attackArray[Actions.WALL] as AAction).active)
						{
							_currentAction = _attackArray[Actions.WALL];
							_busyAttacker = true;
						}
						break;
					case Keyboard.F11:
						if ((_attackArray[Actions.ROCK] as AAction).active)
						{
							_currentAction = _attackArray[Actions.ROCK];
							_busyAttacker = true;
						}
						break;
					case Keyboard.F10:
						if ((_attackArray[Actions.SPIKES] as AAction).active)
						{
							_currentAction = _attackArray[Actions.SPIKES];
							_busyAttacker = true;
						}
						break;
					case Keyboard.F9:
						if ((_attackArray[Actions.LIGHTNING] as AAction).active)
						{
							_currentAction = _attackArray[Actions.LIGHTNING];
							_busyAttacker = true;
						}
						break;
					case Keyboard.F8:
						if ((_attackArray[Actions.THUNDER] as AAction).active)
						{
							_currentAction = _attackArray[Actions.THUNDER];
							_busyAttacker = true;
						}
						break;
				}
				if (CONFIG.PLAYER_TYPE == CONFIG.ATTACKER)
				{
					for each (var a : AAction in _attackArray)
					{
						if (a.active && a === _currentAction)
							(a.view as MovieClip).gotoAndPlay("active");
					}
				}
				if (_busyAttacker)
				{
					_timerBusy = null;
					_timerBusy = new Timer(_currentAction.idleGameDelay, 1);
					_timerBusy.addEventListener(TimerEvent.TIMER_COMPLETE, _endBusyAttacker, false, 0, true);
					_timerBusy.start();
					
					onAction.dispatch(_currentAction);
				}
			}
		}

		private function _endBusyAttacker(event : TimerEvent) : void
		{
			_timerBusy.removeEventListener(TimerEvent.TIMER_COMPLETE, _endBusyAttacker);
			(_currentAction.view as MovieClip).gotoAndPlay("idle");
			_busyAttacker = false;
		}

		private function _endBusyDefender(event : TimerEvent) : void
		{
			_timerBusy.removeEventListener(TimerEvent.TIMER_COMPLETE, _endBusyDefender);
			(_currentAction.view as MovieClip).gotoAndPlay("idle");
			_busyDefender = false;
		}

		private function _endAnimBusy(event : TimerEvent) : void
		{
			trace('_endAnimBusy: ' + (_endAnimBusy));
			_timerAnim.removeEventListener(TimerEvent.TIMER_COMPLETE, _endAnimBusy);
			// Reset the action to none
			_currentAction = _defendArray[Actions.NONE];
			_animBusyDefender = false;
			onEndedAnim.dispatch();
		}

		public function get currentAction() : AAction
		{
			return _currentAction;
		}

		public function get busyDefender() : Boolean
		{
			return _busyDefender;
		}

		public function get view() : MovieClip
		{
			return _view;
		}

		public function get animBusyDefender() : Boolean
		{
			return _animBusyDefender;
		}
	}
}
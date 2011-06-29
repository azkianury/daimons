package daimons.game.actions
{
	import daimons.game.core.consts.CONFIG;
	import daimons.game.events.GameEvent;

	import com.citrusengine.core.CitrusEngine;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	public final class ActionManager extends EventDispatcher
	{
		private static var instance : ActionManager = new ActionManager();
		private var _view : MovieClip;
		private var _busyDefender : Boolean = false, _animBusyDefender : Boolean = false;
		private var _defendArray : Object, _attackArray : Object;
		private var _defendArrayLength : uint, _attackArrayLength : uint;
		private var _timerBusy : Timer, _timerAnim : Timer;
		private var _currentActionDefender : DefenseAction;
		private var _currentActionAttacker : AttackAction;
		public var onAction : Signal;
		// Position du l'utilisateur
		public var onPositionChanged : Signal;
		public var onEndedAnim : Signal;

		public function ActionManager()
		{
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onDefenderKeyDown);
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onAttackerKeyDown);
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);

			_defendArray = [];
			_defendArray.none = new DefenseAction(new MovieClip(), Actions.NONE, Keyboard.AUDIO, 100, 100, false);
			_defendArray.punch = new DefenseAction(new PunchAction(), Actions.PUNCH, Keyboard.F1, 1000, 900, true);
			_defendArray.shield = new DefenseAction(new ShieldAction(), Actions.SHIELD, Keyboard.F2, 2000, 800, true);
			_defendArray.jump = new DefenseAction(new JumpAction(), Actions.JUMP, Keyboard.SPACE, 1000, 200, true);
			_defendArray.crouch = new DefenseAction(new CrouchAction(), Actions.CROUCH, Keyboard.DOWN, 1200, 800, true);
			_defendArray.bubble = new DefenseAction(new BubbleAction(), Actions.BUBBLE, Keyboard.F3, 3000, 800, false);
			_currentActionDefender = _defendArray[Actions.NONE];
			for each (var d : AAction in _defendArray)
				if ((d as AAction).active) _defendArrayLength++;

			_attackArray = [];
			_attackArray.wall = new AttackAction(new WallAction(), Actions.WALL, Keyboard.P, 1500, 1500, true);
			_attackArray.rock = new AttackAction(new RockAction(), Actions.ROCK, Keyboard.O, 1500, 1500, true);
			_attackArray.spikes = new AttackAction(new SpikesAction(), Actions.SPIKES, Keyboard.I, 2000, 2000, true);
			_attackArray.lightning = new AttackAction(new LightningAction(), Actions.LIGHTNING, Keyboard.U, 3000, 3000, true);
			_attackArray.thunder = new AttackAction(new ThunderAction(), Actions.THUNDER, Keyboard.Y, 1500, 1500, false);
			for each (var a : AAction in _attackArray)
				if ((a as AAction).active) _attackArrayLength++;

			onPositionChanged = new Signal(uint);
			onEndedAnim = new Signal();
			onAction = new Signal(AAction);
		}

		public function deactivateAction(name : String) : void
		{
			(_defendArray[name] as AAction).active = false;
			_defendArrayLength--;
			_updateUI();
		}

		public function activateAction(name : String) : void
		{
			(_defendArray[name] as AAction).active = true;
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
			tl.append(TweenLite.to(_view, 0.5, {x:((CONFIG.APP_WIDTH - _view.width) / 2 + ((CONFIG.PLAYER_TYPE == CONFIG.DEFENDER) ? -200 : 100)), y:CONFIG.APP_HEIGHT - _view.height}));
		}

		public function init(view : MovieClip) : void
		{
			_view = view;
			_view.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event : Event) : void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_view.y = CONFIG.APP_HEIGHT;
			_updateUI();
		}

		public static function getInstance() : ActionManager
		{
			return instance;
		}

		private function _onDefenderKeyDown(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.K) dispatchEvent(new GameEvent(GameEvent.CALIBRATED));
			// On passe sur une nouvelle position
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.UP)
			{
				onPositionChanged.dispatch(event.keyCode);
				return;
			}
			for each (var d : AAction in _defendArray)
			{
				if (d.active && d.keyCode == event.keyCode)
				{
					if (d.busy) return;

					d.startBusy();

					_currentActionDefender = d as DefenseAction;

					if(_timerAnim != null) _timerAnim.removeEventListener(TimerEvent.TIMER_COMPLETE, _endAnimBusy);
					_timerAnim = new Timer(_currentActionDefender.persistence, 1);
					_timerAnim.addEventListener(TimerEvent.TIMER_COMPLETE, _endAnimBusy, false, 0, true);
					_timerAnim.start();

					_animBusyDefender = true;

					onAction.dispatch(_currentActionDefender);
				}
			}
		}

		private function _onAttackerKeyDown(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.K) dispatchEvent(new GameEvent(GameEvent.CALIBRATED));
			for each (var a : AAction in _attackArray)
			{
				if (a.active && a.keyCode == event.keyCode)
				{
					if (a.busy) return;

					a.startBusy();

					_currentActionAttacker = a as AttackAction;

					onAction.dispatch(_currentActionAttacker);
				}
			}
		}

		private function _onKeyUp(event : KeyboardEvent) : void
		{
			// On revient en position initiale
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.UP)
				onPositionChanged.dispatch(Keyboard.UP);
		}

		private function _endBusyDefender(event : TimerEvent) : void
		{
			(event.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, _endBusyDefender);
			(_currentActionDefender.view as MovieClip).gotoAndPlay("idle");
			_busyDefender = false;
		}

		private function _endAnimBusy(event : TimerEvent) : void
		{
			_timerAnim.removeEventListener(TimerEvent.TIMER_COMPLETE, _endAnimBusy);
			// Reset the action to none
			_currentActionDefender = _defendArray[Actions.NONE];
			_animBusyDefender = false;
			onEndedAnim.dispatch();
		}

		public function pause() : void
		{
			CitrusEngine.getInstance().stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onAttackerKeyDown);
			CitrusEngine.getInstance().stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onDefenderKeyDown);
			CitrusEngine.getInstance().stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
		}

		public function resume() : void
		{
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onAttackerKeyDown);
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onDefenderKeyDown);
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
		}

		public function get currentActionDefender() : DefenseAction
		{
			return _currentActionDefender;
		}

		public function get currentActionAttacker() : AttackAction
		{
			return _currentActionAttacker;
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
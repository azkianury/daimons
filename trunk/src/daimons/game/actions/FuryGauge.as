package daimons.game.actions
{
	import com.desuade.partigen.emitters.IDEEmitter;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author lbineau
	 */
	public class FuryGauge extends EventDispatcher
	{
		private var _view : MovieClip;
		private var _fury : uint;
		private var _maxFury : uint;
		private var _timer : Timer;

		public function FuryGauge($view : MovieClip, $initialFury : uint = 0, $maxFury : uint = 300)
		{
			_fury = $initialFury;
			_maxFury = $maxFury;
			_view = $view;
			_timer = new Timer(100);
		}

		public function add($num : uint, $multiplier : uint) : void
		{
			_fury += $num * $multiplier;
			_fury = Math.min(_fury, _maxFury);
			_update();
		}

		public function remove($num : uint, $multiplier : uint) : void
		{
			_fury -= $num * $multiplier;
			_update();
		}

		private function _update() : void
		{
			var posX : uint = _fury;
			TweenLite.to(view['arrow'], 0.3, {x:posX});
			TweenLite.to(view['mc_mask'], 0.3, {width:posX});
			if (_fury < _maxFury)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
				_timer = new Timer(100);
				_timer.addEventListener(TimerEvent.TIMER, _onTimer, false, 0, true);
				_timer.start();
			}
			else
			{
				dispatchEvent(new Event(Event.DEACTIVATE));
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				_timer = new Timer(5000, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete, false, 0, true);
				_timer.start();
			}
		}

		private function _onTimerComplete(event : TimerEvent) : void
		{
			dispatchEvent(new Event(Event.ACTIVATE));
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_fury = 0;
			view['mc_mask'].width = _fury;
			TweenLite.to(view['arrow'], 0.3, {x:0});
			_update();
		}

		private function _onTimer(event : TimerEvent) : void
		{
			if (_fury > 0)
			{
				_fury--;
				view['arrow'].x = _fury;
				view['mc_mask'].width = _fury;
			}
			else{
				_timer.stop();
			}
		}

		public function get view() : MovieClip
		{
			return _view;
		}

		public function set maxFury(maxFury : uint) : void
		{
			_maxFury = maxFury;
		}

		public function get fury() : uint
		{
			return _fury;
		}

		public function set fury(fury : uint) : void
		{
			_fury = fury;
		}
	}
}

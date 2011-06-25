package daimons.game.time
{
	import daimons.game.core.consts.CONFIG;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import fr.lbineau.utils.PerfectTimer;



	/**
	 * @author lbineau
	 */
	public class CountdownManager extends EventDispatcher
	{
		private var _view : MovieClip;
		protected var _timerSec : PerfectTimer;
		private var _startDate : Date;
		private var _timelapseCount : uint;
		private var _timelapse : Timer;

		public function CountdownManager(view : MovieClip, target : IEventDispatcher = null)
		{
			_view = view;
			super(target);
			_view.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event : Event) : void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_view.x = int(CONFIG.APP_WIDTH - _view.width) / 2;
		}

		public function init(countMinutes : uint) : void
		{
			var repeatCountDown : uint = countMinutes * 60 - 2;
			_timelapse = new Timer(1000);
			_timerSec = new PerfectTimer(1000, repeatCountDown);
			_timerSec.addEventListener(TimerEvent.TIMER, _onSecond);
			_timerSec.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			_startDate = new Date();
			_startDate.minutes += countMinutes;
			start();
		}

		private function _onTimerComplete(event : TimerEvent) : void
		{
			_timerSec.stop();
			_timerSec.removeEventListener(TimerEvent.TIMER, _onSecond);
			_timerSec.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function start() : void
		{
			_timerSec.start();
		}

		public function pause() : void
		{
			_timerSec.pause();
			_timelapseCount = 0;
			_timelapse.reset();
			_timelapse.addEventListener(TimerEvent.TIMER, _onTimelapse);
			_timelapse.start();
		}

		public function resume() : void
		{
			_timerSec.resume();
			_timelapse.removeEventListener(TimerEvent.TIMER, _onTimelapse);
			_timelapse.stop();
			_startDate.seconds += _timelapseCount;
		}

		private function _onTimelapse(event : TimerEvent) : void
		{
			_timelapseCount++;
		}

		private function _onSecond(event : TimerEvent) : void
		{
			var ms : Number = _startDate.getTime() - (new Date()).getTime();
			var sec : Number = Math.floor(ms / 1000);
			var min : Number = Math.floor(sec / 60);

			sec = sec % 60;
			if (sec < 0) sec = 0;
			min = min % 60;
			if (min < 0) min = 0;

			update(min.toString() + ":" + _digit2String(sec));
		}

		public function get view() : MovieClip
		{
			return _view;
		}

		private function _digit2String(digit : Number) : String
		{
			return digit.toString().length == 1 ? "0" + digit.toString() : digit.toString();
		}

		public function update(countdown : String) : void
		{
			_view["mc_countdown"]["tf"].text = countdown.toString();
		}
	}
}

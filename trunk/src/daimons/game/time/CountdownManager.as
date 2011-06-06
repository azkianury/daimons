package daimons.game.time
{
	import fr.lbineau.utils.PerfectTimer;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;

	/**
	 * @author lbineau
	 */
	public class CountdownManager extends EventDispatcher
	{
		private var _view : MovieClip;
		protected var _timerSec : PerfectTimer;
		private var _startDate : Date;

		public function CountdownManager(view : MovieClip, target : IEventDispatcher = null)
		{
			_view = view;
			super(target);
			_view.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event : Event) : void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_view.x = int(_view.stage.stageWidth - _view.width) / 2;
		}
		public function init(repeatCountDown : uint) : void
		{
			_timerSec = new PerfectTimer(1000, repeatCountDown);
			_timerSec.addEventListener(TimerEvent.TIMER, _onSecond);
			_startDate = new Date();
			_startDate.minutes += 5;
			start();
		}

		public function start() : void
		{
			_timerSec.start();
		}

		public function pause() : void
		{
			_timerSec.pause();
		}

		public function resume() : void
		{
			_timerSec.resume();
		}

		private function _onSecond(event : TimerEvent) : void
		{
			var ms : Number = _startDate.getTime() - (new Date()).getTime();
			var sec : Number = Math.floor(ms / 1000);
			var min : Number = Math.floor(sec / 60);

			sec = sec % 60;
			min = min % 60;

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

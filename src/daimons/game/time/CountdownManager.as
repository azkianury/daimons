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
		private var _timelapse : Timer;
		private var _now : Date;
		private var _cible : Date;
		private var _tempsActuel : Number;
		private var _tempsCible : Number;
		private var _nbrSecondes : Number;
		private var _minutes : Number;
		private var _secondes : Number;

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
			_now = new Date();
			_tempsActuel = _now.getTime();
			_cible = new Date();
			_cible.minutes += countMinutes;
			_tempsCible = _cible.getTime();
			start();
		}

		private function calcul(evt : Event) : void
		{
			if (_minutes <= 0 && _secondes <= 0)
			{
				_timeIsUp();
				return;
			}
			_now = new Date();
			_tempsActuel = _now.getTime();
			_nbrSecondes = (_tempsCible - _tempsActuel) / 1000;

			_minutes = uint(_nbrSecondes / 60 % 60);
			_secondes = uint(_nbrSecondes % 60);
			update(_minutes.toString() + ":" + _digit2String(_secondes));
		}

		private function _timeIsUp() : void
		{
			view.removeEventListener(Event.ENTER_FRAME, calcul);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function start() : void
		{
			view.addEventListener(Event.ENTER_FRAME, calcul);
		}

		public function pause() : void
		{
			view.removeEventListener(Event.ENTER_FRAME, calcul);
			_timelapse = new Timer(1000);
			_timelapse.addEventListener(TimerEvent.TIMER, _onTimelapse);
			_timelapse.start();
		}

		public function resume() : void
		{
			view.addEventListener(Event.ENTER_FRAME, calcul);
			_timelapse.removeEventListener(TimerEvent.TIMER, _onTimelapse);
			_timelapse.stop();
		}

		private function _onTimelapse(event : TimerEvent) : void
		{
			_tempsCible+=1000;
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

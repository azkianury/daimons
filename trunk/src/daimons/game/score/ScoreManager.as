package daimons.game.score
{
	import daimons.game.core.consts.CONFIG;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.system.Security;

	public final class ScoreManager
	{
		private static var instance : ScoreManager = new ScoreManager();
		private var _percentage : Number = 50;
		private var _nbHuringObject : Number = 0;
		private var _avoidHurtingObject : Number = 0;
		private var _view : MovieClip;
		private var _scoreSO : SharedObject;

		public function ScoreManager()
		{
			Security.allowDomain("*"); 
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
		}

		public static function getInstance() : ScoreManager
		{
			return instance;
		}

		public function init(view : MovieClip) : void
		{
			_view = view;
			updateUI(_percentage);
			_view.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_scoreSO = SharedObject.getLocal("score_"+CONFIG.PLAYER_TYPE,'/');
		}

		private function _onAddedToStage(event : Event) : void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_view.x = (CONFIG.APP_WIDTH) / 2 + 180;
			_view.y = 40;
		}

		public function add(ponderation : Number) : void
		{
			_nbHuringObject++;
			if (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER)
			{
				_avoidHurtingObject++;
				_percentage = int((_avoidHurtingObject / _nbHuringObject) * 100);
			}
			else
			{
				_percentage = int((_avoidHurtingObject / _nbHuringObject) * 100);
			}
			updateUI(_percentage);
		}

		public function remove(ponderation : Number) : void
		{
			_nbHuringObject++;
			if (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER)
				_percentage = int((_avoidHurtingObject / _nbHuringObject) * 100);
			else
			{
				_avoidHurtingObject++;
				_percentage = int((_avoidHurtingObject / _nbHuringObject) * 100);
			}
			updateUI(_percentage);
		}

		public function updateUI(percent : Number) : void
		{
			_view.gotoAndStop(percent);
			// _view["mc_percentage"]["tf"].text = percent + "%";
			_view["mc_percentage"]["tf"].text = _avoidHurtingObject + "/" + _nbHuringObject;
			// _view["mc_percentage"].x = _view["mc_mask"].x + _view["mc_mask"].width;
		}

		public function saveScore() : void
		{
			_scoreSO.data.percentage = percentage.toString();
			_scoreSO.data.teamPercentage = (CONFIG.PLAYER_TYPE == CONFIG.DEFENDER) ? '55' : '65';
			_scoreSO.flush();
		}

		public function get view() : MovieClip
		{
			return _view;
		}

		public function get percentage() : Number
		{
			return _percentage;
		}

		public function get scoreSO() : SharedObject
		{
			return _scoreSO;
		}
	}
}
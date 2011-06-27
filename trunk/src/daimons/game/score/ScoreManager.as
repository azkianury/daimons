package daimons.game.score
{
	import flash.events.IOErrorEvent;

	import daimons.game.core.consts.CONFIG;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;

	public final class ScoreManager
	{
		private static var instance : ScoreManager = new ScoreManager();
		private var _percentage : Number = 50;
		private var _nbHuringObject : Number = 0;
		private var _avoidHurtingObject : Number = 0;
		private var _view : MovieClip;

		public function ScoreManager()
		{
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
			try
			{
				_sendScoreToServer('http://lbineau.com/projects/daimons/');
			}
			catch(error : Error)
			{
			}
		}

		private function _sendScoreToServer(baseURL : String) : void
		{
			Security.loadPolicyFile(baseURL + 'crossdomain.xml');

			var request : URLRequest = new URLRequest(baseURL + 'scripts/addScore.php');
			request.method = URLRequestMethod.POST;

			var variables : URLVariables = new URLVariables();

			variables.score = _percentage;
			request.data = variables;

			var loader : URLLoader = new URLLoader(request);
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(IOErrorEvent.IO_ERROR, _onSendingError);
			loader.load(request);
		}

		private function _onSendingError(event : IOErrorEvent) : void
		{
			try
			{
				_sendScoreToServer('http://localhost/daimons/');
			}
			catch(error : Error)
			{
			}
		}

		public function get view() : MovieClip
		{
			return _view;
		}

		public function get percentage() : Number
		{
			return _percentage;
		}
	}
}
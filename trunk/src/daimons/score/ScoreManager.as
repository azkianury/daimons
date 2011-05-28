package daimons.score
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public final class ScoreManager
	{
		private static var instance : ScoreManager = new ScoreManager();
		private var _percentage : Number = 50;
		private var _nbHuringObject : Number = 0;
		private var _avoidHuringObject : Number = 0;
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
			trace(_view.stage.stageWidth, _view.width);
			_view.x = (_view.stage.stageWidth) / 2;
			_view.y = _view.height;
		}
		
		public function add(ponderation:Number) : void
		{
			_avoidHuringObject++;
			_nbHuringObject++;
			_percentage = int((_avoidHuringObject / _nbHuringObject) * 100);
			updateUI(_percentage);
		}

		public function remove(ponderation:Number) : void
		{
			_nbHuringObject++;
			_percentage = int((_avoidHuringObject / _nbHuringObject) * 100);
			updateUI(_percentage);
		}
		
		public function updateUI(percent:Number):void
		{
			_view.gotoAndStop(percent);
			_view["mc_percentage"]["tf"].text = percent + "%";			
			//_view["mc_percentage"].x = _view["mc_mask"].x + _view["mc_mask"].width;
		}
		public function get view() : MovieClip
		{
			return _view;
		}
	}
}
package daimons.score
{
	import daimons.ui.ScoreUI;
	import flash.display.DisplayObject;

	public final class ScoreManager
	{
		private static var instance : ScoreManager = new ScoreManager();
		private var _percentage : Number = 50;
		private var _nbHuringObject : Number = 0;
		private var _avoidHuringObject : Number = 0;
		private var _view : DisplayObject;

		public function ScoreManager()
		{
			if ( instance ) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
		}

		public static function getInstance() : ScoreManager
		{
			return instance;
		}

		public function init(view : DisplayObject) : void
		{
			_view = view;
		}

		public function add(ponderation:Number) : void
		{
			_avoidHuringObject++;
			_nbHuringObject++;
			_percentage = int((_avoidHuringObject / _nbHuringObject) * 100);
			(_view as ScoreUI).updateUI(_percentage);
		}

		public function remove(ponderation:Number) : void
		{
			_nbHuringObject++;
			_percentage = int((_avoidHuringObject / _nbHuringObject) * 100);
			(_view as ScoreUI).updateUI(_percentage);
		}

		public function get view() : DisplayObject
		{
			return _view;
		}
	}
}
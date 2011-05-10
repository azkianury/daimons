package daimons.game.levels
{
	import flash.utils.Timer;
	import daimons.game.levels.abstract.ALevel;
	import org.osflash.signals.Signal;

	/**
	 * @author lbineau
	 */
	public class LevelManager
	{
		private var _levels : Array = [Level1];
		private var _currentIndex : uint;
		private var _currentLevel : ALevel;
		public var onLevelChanged : Signal;
		private var _timer:Timer;

		public function LevelManager()
		{
			onLevelChanged = new Signal(ALevel);
		}

		public function destroy() : void
		{
			onLevelChanged.removeAll();
		}

		public function nextLevel() : void
		{
			if (_currentIndex < _levels.length - 1)
				_currentIndex++;

			gotoLevel(_currentIndex);
		}

		public function prevLevel() : void
		{
			if (_currentIndex > 0)
				_currentIndex--;

			gotoLevel(_currentIndex);
		}

		public function gotoLevel(lvl : uint) : void
		{
			if(_currentLevel != null)
				_currentLevel.lvlEnded.remove(_onLevelEnded);
			_currentLevel = ALevel(new _levels[_currentIndex]());
			_currentLevel.lvlEnded.add(_onLevelEnded);
			onLevelChanged.dispatch(currentLevel);
		}

		private function _onLevelEnded() : void
		{
			
		}

		public function init(level : uint = 0) : void
		{
			gotoLevel(0);
		}

		public function get currentLevel() : ALevel
		{
			return _currentLevel;
		}

		public function set currentLevel(currentLevel : ALevel) : void
		{
			_currentLevel = currentLevel;
		}
	}
}

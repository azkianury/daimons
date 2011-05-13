package daimons.game.levels
{
	import daimons.game.levels.abstract.ALevel;
	import daimons.score.ScoreManager;

	import com.citrusengine.core.CitrusEngine;

	import org.osflash.signals.Signal;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author lbineau
	 */
	public class LevelManager
	{
		private var _levels : Array = [Level1];
		private var _currentIndex : uint;
		private var _currentLevel : ALevel;
		public var onLevelChanged : Signal;

		public function LevelManager()
		{
			onLevelChanged = new Signal(ALevel);
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}

		private function _onKeyDown(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.ESCAPE:
					_togglePause();
					break;
			}
		}

		private function _togglePause() : void
		{
			if (CitrusEngine.getInstance().playing)
			{
				_currentLevel.pause();
				CitrusEngine.getInstance().playing = false;
			}
			else
			{
				_currentLevel.resume();
				CitrusEngine.getInstance().playing = true;
			}
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
			if (_currentLevel != null)
				_currentLevel.lvlEnded.remove(_onLevelEnded);
			_currentLevel = ALevel(new _levels[_currentIndex]());
			_currentLevel.lvlEnded.add(_onLevelEnded);
			onLevelChanged.dispatch(_currentLevel);
		}

		private function _onLevelEnded() : void
		{
		}

		public function init(level : uint = 0) : void
		{
			gotoLevel(0);			
		}
	}
}

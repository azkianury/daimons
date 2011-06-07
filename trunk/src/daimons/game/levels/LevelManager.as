package daimons.game.levels
{
	import daimons.core.consts.PATHS;

	import com.citrusengine.core.CitrusEngine;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import org.osflash.signals.Signal;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;

	/**
	 * @author lbineau
	 */
	public class LevelManager
	{
		private var _imports : Array = [Level1]; // Importer les classe pour pouvoir créer des instances dynamiquement
		private var _levels : Array;
		private var _currentIndex : uint;
		private var _loader : LoaderMax;
		private var _currentLevel : ALevel;
		public var onLevelChanged : Signal;
		public var onLevelLoaded : Signal;

		public function LevelManager($lvls : Array)
		{
			_levels = $lvls;
			onLevelChanged = new Signal(ALevel);
			onLevelLoaded = new Signal(ALevel);
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_loader = new LoaderMax({onComplete:_onComplete});
			_loader.append(new SWFLoader(PATHS.CHARACTER_ASSETS + "hero.swf", {name:"hero"}));
			_loader.append(new SWFLoader(PATHS.HURTING_OBJECTS_ASSETS + "hurtingObjects.swf", {name:"hurtingObjects1"}));
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
			onLevelLoaded.removeAll();
			onLevelLoaded = null;
			onLevelChanged.removeAll();
			onLevelChanged = null;
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
			{
				_currentLevel.destroy();
				_currentLevel = null;
			}
			var num : uint = _currentIndex + 1;
			_loader.append(new SWFLoader(PATHS.LEVELS_ASSETS + "level" + num + "/decor.swf", {name:"decors" + num}));
			_loader.load();
		}

		private function _onComplete(event : LoaderEvent) : void
		{
			var C : Class = getDefinitionByName(_levels[_currentIndex].lvlname) as Class;
			_currentLevel = ALevel(new C(_levels[_currentIndex].duration));
			_currentLevel.lvlEnded.add(_onLevelEnded);
			onLevelChanged.dispatch(_currentLevel);
			onLevelLoaded.dispatch(_currentLevel);
		}

		private function _onLevelEnded() : void
		{
			_currentLevel.pause();
		}

		public function init(level : uint) : void
		{
			gotoLevel(level);
		}

		public function get currentLevel() : ALevel
		{
			return _currentLevel;
		}
	}
}

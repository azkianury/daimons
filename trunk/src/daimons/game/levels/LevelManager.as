package daimons.game.levels
{
	import daimons.game.MainGame;
	import daimons.game.actions.ActionManager;
	import daimons.game.core.consts.CONFIG;
	import daimons.game.core.consts.PATHS;
	import daimons.game.events.GameEvent;

	import com.citrusengine.core.CitrusEngine;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;

	/**
	 * @author lbineau
	 */
	public class LevelManager extends EventDispatcher
	{
		private var _imports : Array = [Level1];
		// Import des classes pour pouvoir créer des instances dynamiquement
		private var _levels : Array;
		private var _currentIndex : uint;
		private var _cache : Sprite;
		private var _calibration : Sprite;
		private var _counter : Sprite;		
		private var _loader : LoaderMax;
		private var _currentLevel : ALevel;
		public var onLevelChanged : Signal;
		public var onLevelEnded : Signal;
		public var onLevelLoaded : Signal;

		public function LevelManager($lvls : Array)
		{
			_levels = $lvls;
			onLevelChanged = new Signal(ALevel);
			onLevelEnded = new Signal(ALevel);
			onLevelLoaded = new Signal(ALevel);
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_loader = new LoaderMax({onComplete:_onComplete});
			_loader.append(new SWFLoader(PATHS.CHARACTER_ASSETS + "hero.swf", {name:"hero"}));
			_loader.append(new SWFLoader(PATHS.HURTING_OBJECTS_ASSETS + "hurtingObjects.swf", {name:"hurtingObjects1"}));
			_cache = new Cache();
			_cache.cacheAsBitmap = true;

			MainGame.STAGE.addEventListener(Event.RESIZE, _onResize);
		}

		private function _onResize(event : Event = null) : void
		{
			_cache.x = MainGame.STAGE.stageWidth / 2;
			_cache.y = MainGame.STAGE.stageHeight / 2;
			if (_currentLevel != null)
			{
				_currentLevel.x = (MainGame.STAGE.stageWidth - CONFIG.APP_WIDTH) / 2;
				_currentLevel.y = (MainGame.STAGE.stageHeight - CONFIG.APP_HEIGHT) / 2;
			}
			if (_calibration != null)
			{
				_calibration.x = (MainGame.STAGE.stageWidth) / 2;
				_calibration.y = (MainGame.STAGE.stageHeight) / 2;
			}
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
			MainGame.STAGE.addChild(_cache);
		}

		private function _onComplete(event : LoaderEvent) : void
		{
			var C : Class = getDefinitionByName(_levels[_currentIndex].lvlname) as Class;
			_currentLevel = ALevel(new C(_levels[_currentIndex].duration));
			_currentLevel.lvlEnded.add(_onLevelEnded);
			onLevelChanged.dispatch(_currentLevel);
			onLevelLoaded.dispatch(_currentLevel);

			_currentLevel.addEventListener(Event.INIT, _onLevelInited);

			_calibration = new CalibPageUI();
			_calibration.alpha = 0;
			MainGame.STAGE.addChild(_calibration);
			TweenLite.to(_calibration, 1, {alpha:1});
			ActionManager.getInstance().addEventListener(GameEvent.CALIBRATED, _onCalibrated);
			_onResize();
		}

		private function _onLevelInited(event : Event) : void
		{
			_currentLevel.pause();
		}

		public function launchGame() : void
		{
			_counter = new CounterUIAsset();
			_counter['youare'].gotoAndStop(CONFIG.PLAYER_TYPE);
			_counter.addEventListener(Event.COMPLETE, _onStartCountComplete);
			MainGame.STAGE.addChild(_counter);
			_counter.x = (MainGame.STAGE.stageWidth - _counter.width) / 2;
			_counter.y = (MainGame.STAGE.stageHeight - _counter.height) / 2;
		}

		private function _onCalibrated(event : GameEvent) : void
		{
			MainGame.STAGE.removeChild(_calibration);
			ActionManager.getInstance().removeEventListener(GameEvent.CALIBRATED, _onCalibrated);
			dispatchEvent(new GameEvent(GameEvent.CALIBRATED));
		}

		private function _onStartCountComplete(event : Event) : void
		{
			_counter.removeEventListener(Event.COMPLETE, _onStartCountComplete);
			MainGame.STAGE.removeChild(_counter);
			_currentLevel.resume();
		}

		private function _onLevelEnded() : void
		{
			_currentLevel.pause();
			onLevelEnded.dispatch(_currentLevel);
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

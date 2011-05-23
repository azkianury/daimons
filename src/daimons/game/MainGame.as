package daimons.game
{
	import flash.display.Stage;
	import flash.events.Event;
	import daimons.core.consts.PATHS;
	import daimons.game.levels.LevelManager;
	import daimons.game.levels.abstract.ALevel;

	import com.citrusengine.core.CitrusEngine;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author lbineau
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="1024", height="768")]
	public class MainGame extends CitrusEngine
	{
		private var _levelManager : LevelManager;
		public static var STAGE : Stage;

		public function MainGame()
		{
			STAGE = stage;
			super();
			this.scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			// stage.addChild(new Stats());
			console.openKey = Keyboard.F;
			console.enabled = false;

			// var objects : Array = [Platform, Hero, CitrusSprite, Sensor, Coin, Baddy, Crate];

			var loader : LoaderMax = new LoaderMax({onComplete:_onComplete});
			loader.append(new SWFLoader(PATHS.LEVELS_ASSETS + "level1/decor.swf", {name:"decor1"}));
			loader.load();
		}

		private function _onComplete(event : LoaderEvent) : void
		{
			_levelManager = new LevelManager();
			_levelManager.onLevelChanged.add(_onLevelChanged);
			_levelManager.init(0);

			// this.enabled = false;
		}

		private function _onLevelChanged(lvl : ALevel) : void
		{
			state = lvl;
		}
	}
}
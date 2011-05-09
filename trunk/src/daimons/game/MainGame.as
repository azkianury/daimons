package daimons.game
{
	import daimons.game.levels.abstract.ALevel;
	import flash.ui.Keyboard;
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.Baddy;
	import com.citrusengine.objects.platformer.Coin;
	import com.citrusengine.objects.platformer.Crate;
	import com.citrusengine.objects.platformer.Hero;
	import com.citrusengine.objects.platformer.MovingPlatform;
	import com.citrusengine.objects.platformer.Platform;
	import com.citrusengine.objects.platformer.Sensor;

	import daimons.core.PATHS;
	import daimons.game.levels.Level1;
	import daimons.game.levels.LevelManager;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author lbineau
	 */
	public class MainGame extends CitrusEngine
	{
		private var _levelManager : LevelManager;

		public function MainGame()
		{
			super();
			console.openKey = Keyboard.F;
			console.enabled = false;

			var objects : Array = [Platform, Hero, CitrusSprite, Sensor, Coin, Baddy, Crate];

			// Create audio assets
			/*sound.addSound("Collect", "sounds/collect.mp3");
			sound.addSound("Hurt", "sounds/hurt.mp3");
			sound.addSound("Jump", "sounds/jump.mp3");
			sound.addSound("Kill", "sounds/kill.mp3");
			sound.addSound("Skid", "sounds/skid.mp3");
			sound.addSound("Song", "sounds/song.mp3");
			sound.addSound("Walk", "sounds/walk.mp3");*/

			var loader : Loader = new Loader();
			loader.load(new URLRequest(PATHS.LEVELS_ASSETS + "layout.swf"));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSWFLoadComplete, false, 0, true);
		}

		private function handleSWFLoadComplete(e : Event) : void
		{
			e.target.removeEventListener(Event.COMPLETE, handleSWFLoadComplete);
			var levelObjectsMC : MovieClip = e.target.loader.content;

			_levelManager = new LevelManager();
			_levelManager.onLevelChanged.add(_onLevelChanged);
			_levelManager.init(0);

			e.target.loader.unloadAndStop();
			//this.enabled = false;
		}

		private function _onLevelChanged(lvl:ALevel) : void
		{
			state = _levelManager.currentLevel;
		}
	}
}
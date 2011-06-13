package daimons.game
{
	import daimons.core.consts.CONFIG;
	import daimons.core.consts.PATHS;
	import daimons.game.levels.ALevel;
	import daimons.game.levels.LevelManager;

	import fr.lbineau.utils.Stats;

	import com.citrusengine.core.CitrusEngine;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.XMLLoader;

	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author lbineau
	 */
	[SWF(backgroundColor="#000000", frameRate="31", width="1280", height="768")]
	public class MainGame extends CitrusEngine
	{
		private var _levelManager : LevelManager;
		public static var STAGE : Stage;

		public function MainGame()
		{
			STAGE = stage;
			super();
//			this.scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			stage.addChild(new Stats());
			console.openKey = Keyboard.TAB;
			console.enabled = true;

			var loader : LoaderMax = new LoaderMax({onComplete:_onComplete});
			loader.append(new MP3Loader(PATHS.SOUND_ASSETS + "music.mp3", {name:"introMusic", autoPlay:false, repeat:-1, volume:0.5}));
			loader.append(new MP3Loader(PATHS.SOUND_ASSETS + "music.mp3", {name:"gameMusic", autoPlay:false, repeat:-1, volume:0.5}));
			loader.append(new XMLLoader(PATHS.XML_CONFIG + "config.xml", {name:"xmlConfig"}));
			loader.load();
		}

		private function _onComplete(event : LoaderEvent) : void
		{
			_initConfig();
			var arr : Array = [];
			var xml : XML = LoaderMax.getContent("xmlConfig") as XML;
			for each (var lvl : * in xml.levels.level)
			{
				var o : Object = new Object();
				o.lvlname = "daimons.game.levels.Level" + lvl.@id;
				o.duration = lvl.duration;
				arr.push(o);
			}
			_levelManager = new LevelManager(arr);
			_levelManager.onLevelChanged.add(_onLevelChanged);
			_levelManager.onLevelEnded.add(_onLevelEnd);
			_levelManager.init(0);

			// this.enabled = false;
		}

		private function _initConfig() : void
		{
			var xml : XML = LoaderMax.getContent("xmlConfig") as XML;
			CONFIG.BOX2D = String(xml.configuration.box2D) == "true";
			CONFIG.ENNEMI_AUTO = String(xml.configuration.ennemiAuto) == "true";
			CONFIG.ENNEMI_INTERVAL = uint(xml.configuration.ennemiInterval);
			CONFIG.PLAYER_TYPE = String(xml.configuration.playerType);
		}

		private function _onLevelChanged(lvl : ALevel) : void
		{
			trace("_onLevelChanged" + lvl);
			state = lvl;
		}

		private function _onLevelEnd(lvl : ALevel) : void
		{
			trace("_onLevelEnded" + lvl);
		}
	}
}
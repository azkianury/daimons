package daimons.game
{
	import com.citrusengine.core.CitrusEngine;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	import daimons.game.core.consts.CONFIG;
	import daimons.game.core.consts.PATHS;
	import daimons.game.levels.ALevel;
	import daimons.game.levels.LevelManager;
	import daimons.game.pages.ScorePage;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import fr.lbineau.utils.Stats;




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
			stage.addChild(new Stats());
			console.openKey = Keyboard.TAB;
			console.enabled = true;

			var loader : LoaderMax = new LoaderMax({onComplete:_onComplete});
			loader.append(new MP3Loader(PATHS.SOUND_ASSETS + "intro.mp3", {name:"introMusic", autoPlay:true, repeat:-1, volume:0.5}));
			loader.append(new MP3Loader(PATHS.SOUND_ASSETS + "music.mp3", {name:"gameMusic", autoPlay:false, repeat:-1, volume:0.5}));
			loader.append(new XMLLoader(PATHS.XML_CONFIG + "config.xml", {name:"xmlConfig"}));
			loader.load();
		}

		private function _onComplete(event : LoaderEvent) : void
		{
			_initConfig();
			var arr : Array = new Array();
			var tut : Array = new Array();
			var xml : XML = LoaderMax.getContent("xmlConfig") as XML;
			var o : Object;
			var personnes : XMLList = xml.levels.elements();
			for each (var lvl : XML in xml.levels.level)
			{
				o = new Object();
				o.lvlname = "daimons.game.levels.Level" + lvl.@id;
				o.duration = lvl.duration;
				arr.push(o);
				for each (var tuto : XML in (lvl.tutorial.elements()))
				{
					o = new Object();
					o.action = tuto;
					o.time = tuto.@time;
					CONFIG.TUTORIAL.push(o);
				}
			}
			_levelManager = new LevelManager(arr);
			_levelManager.onLevelChanged.add(_onLevelChanged);
			_levelManager.onLevelEnded.add(_onLevelEnd);
			
			stage.addEventListener(MouseEvent.CLICK, _onClick);
			// this.enabled = false;
			stage.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		private function _onClick(event : MouseEvent) : void
		{
			stage.removeEventListener(MouseEvent.CLICK, _onClick);
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			_startGame();
		}

		private function _startGame() : void
		{
			_levelManager.init(0);
			TweenLite.to(LoaderMax.getLoader('introMusic') as MP3Loader, 1, {volume:0});
			(LoaderMax.getLoader('gameMusic') as MP3Loader).playSound();
			(LoaderMax.getLoader('gameMusic') as MP3Loader).volume = 0;
			TweenLite.to(LoaderMax.getLoader('gameMusic') as MP3Loader, 1, {delay:1, volume:1});
			(LoaderMax.getLoader('introMusic') as LoaderCore).unload();
			(LoaderMax.getLoader('xmlConfig') as LoaderCore).unload();
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
			var sp : ScorePage = new ScorePage(new ScorePageUI());
			sp.view.x = stage.stageWidth / 2;
			sp.view.y = stage.stageHeight / 2;
			addChild(sp.view);
		}
	}
}
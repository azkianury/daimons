package daimons.game.tutorial
{
	import com.greensock.TweenMax;
	import com.greensock.TweenLite;

	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.MovieClip;

	/**
	 * @author lbineau
	 */
	public class Tutorial extends EventDispatcher
	{
		private var _view : MovieClip;
		private var _busy : Boolean = false;

		public function Tutorial()
		{
		}
		
		public function init(view : MovieClip) : void
		{
			_view = view;
			_view.alpha = 0;
			_view.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event : Event) : void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_view.x = int(_view.stage.stageWidth - _view.width) / 2;
			_view.y = _view.height + 10;
		}

		public function displayPicto($name : String) : void
		{
			if (_view.currentLabel != $name)
				_view.gotoAndPlay($name);
		}

		public function hide() : void
		{
			if (!_busy)
			{
				TweenMax.to(_view, 0.5, {alpha:0, onComplete:_endBusy});
				_busy = true;
			}
		}

		private function _endBusy() : void
		{
			_busy = false;
		}

		public function show() : void
		{
			if (!_busy)
			{
				TweenMax.to(_view, 0.5, {alpha:1, onComplete:_endBusy});
				_busy = true;
			}
		}

		public function get view() : MovieClip
		{
			return _view;
		}
	}
}

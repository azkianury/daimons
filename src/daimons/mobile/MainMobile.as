package daimons.mobile
{
	import com.greensock.TweenNano;

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class MainMobile extends MovieClip
	{
		private var _currentTile : Number = 1;
		private var _totalTiles : Number = 3;
		private var _currentPage : MovieClip;
		private var _backBTN : MovieClip;

		public function MainMobile()
		{
			_backBTN = this['backBTN'];
			_backBTN.alpha = 0;
			_backBTN.addEventListener(MouseEvent.MOUSE_DOWN, _gotoHome);
			_currentPage = this['page_home'];
			this['menu'].addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			init();
		}

		private function _gotoHome(event : MouseEvent) : void
		{
			var prevPage : MovieClip = _currentPage;
			_currentPage = this['page_home'];
			if (_currentPage != prevPage)
			{
				_backBTN.mouseEnabled = false;
				_currentPage.x = -320;
				this['menu'].mouseEnabled = this['menu'].mouseChildren = true;
				TweenNano.to(_backBTN, 0.5, {alpha:0});
				TweenNano.to(prevPage, 0.5, {x:-320});
				TweenNano.to(this['menu'], 0.5, {alpha:1});
				TweenNano.to(_currentPage, 0.5, {x:0});
			}
		}

		private function _onMouseDown(event : MouseEvent) : void
		{
			this.stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, _handleSwipe);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			var prevPage : MovieClip = _currentPage;
			switch(event.target.name)
			{
				case "last_episode":
					_currentPage = this['page_last_episode'];
					_startSwipe(3);
					break;
				case "compte":
					_currentPage = this['page_compte'];
					_startSwipe(3);
					break;
			}
			if (_currentPage != prevPage)
			{
				_backBTN.mouseEnabled = true;
				_currentPage.x = -320;
				this['menu'].mouseEnabled = this['menu'].mouseChildren = false;
				TweenNano.to(_backBTN, 0.5, {alpha:1});
				TweenNano.to(prevPage, 0.5, {x:-320});
				TweenNano.to(this['menu'], 0.3, {alpha:0});
				TweenNano.to(_currentPage, 0.5, {x:0});
			}
		}

		private function _startSwipe(nbSlides:uint) : void
		{
			_totalTiles = nbSlides;
			_currentTile = 1;
			_currentPage.y = 480;
			this.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, _handleSwipe);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_updateSlides();
		}


		private function init() : void
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
		}

		private function _onKeyDown(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					_handleSwipe(new TransformGestureEvent(TransformGestureEvent.GESTURE_SWIPE, true, false, null, 0, 0, 1, 1, 0, 0, -1));
					break;
				case Keyboard.RIGHT:
					_handleSwipe(new TransformGestureEvent(TransformGestureEvent.GESTURE_SWIPE, true, false, null, 0, 0, 1, 1, 0, 0, 1));
					break;
			}
		}

		private function _handleSwipe(event : TransformGestureEvent) : void
		{
			if (event.offsetY == -1)
			{
				if (_currentTile > 1)
				{
					_currentTile--;
					_updateSlides();
				}
			}
			else if (event.offsetY == 1)
			{
				if (_currentTile < _totalTiles)
				{
					_currentTile++;
					_updateSlides();
				}
			}
		}

		private function _updateSlides() : void
		{
			var posY : uint = _currentTile * 480;
			TweenNano.to(_currentPage, 0.5, {y:posY});
		}
	}
}

package daimons.game.actions.objects
{
	import flash.display.DisplayObject;

	/**
	 * @author lbineau
	 */
	public class AAction
	{
		protected var _view : DisplayObject;
		protected var _name : String;
		protected var _persistence : Number;
		protected var _idleGameDelay : Number;
		protected var _active : Boolean;

		public function AAction($view : DisplayObject, $name : String, $persistence : Number,$idleGameDelay:Number, $active : Boolean = false)
		{
			_view = $view;
			_name = $name;
			_persistence = $persistence;
			_persistence = $idleGameDelay;
			_active = $active;
		}

		public function get name() : String
		{
			return _name;
		}

		public function set name(name : String) : void
		{
			_name = name;
		}

		public function get persistence() : Number
		{
			return _persistence;
		}

		public function get active() : Boolean
		{
			return _active;
		}

		public function set active(active : Boolean) : void
		{
			_active = active;
		}

		public function get view() : DisplayObject
		{
			return _view;
		}

		public function get idleGameDelay() : Number
		{
			return _idleGameDelay;
		}

		public function set idleGameDelay(idleGameDelay : Number) : void
		{
			_idleGameDelay = idleGameDelay;
		}
	}
}

package daimons.game.actions.abstract
{
	/**
	 * @author lbineau
	 */
	public class AAction
	{
		protected var _name : String;
		protected var _persistence : Number;

		public function AAction($name : String, $persistence : Number)
		{
			_name = $name;
			_persistence = $persistence;
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
	}
}

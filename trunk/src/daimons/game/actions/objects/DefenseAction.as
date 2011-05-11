package daimons.game.actions.objects
{
	/**
	 * @author lbineau
	 */
	public class DefenseAction
	{
		private var _name : String;
		private var _persistence : Number;

		public function DefenseAction($name : String, $persistence : Number)
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

package daimons.game.actions.objects
{
	/**
	 * @author lbineau
	 */
	public class AttackAction
	{
		private var _name : String;

		public function AttackAction($name : String)
		{
			_name = $name;
		}

		public function get name() : String
		{
			return _name;
		}

		public function set name(name : String) : void
		{
			_name = name;
		}
	}
}

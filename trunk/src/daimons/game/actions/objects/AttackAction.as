package daimons.game.actions.objects
{
	import flash.display.DisplayObject;

	import daimons.game.actions.abstract.AAction;

	/**
	 * @author lbineau
	 */
	public class AttackAction extends AAction
	{
		public function AttackAction($view : DisplayObject, $name : String, $persistence : Number, $active : Boolean = false)
		{
			super($view, $name, $persistence, $active);
		}
	}
}

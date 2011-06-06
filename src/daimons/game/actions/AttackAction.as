package daimons.game.actions
{
	import flash.display.DisplayObject;

	/**
	 * @author lbineau
	 */
	public class AttackAction extends AAction
	{
		public function AttackAction($view : DisplayObject, $name : String, $persistence : Number, $idleGameDelay : Number, $active : Boolean = false)
		{
			super($view, $name, $persistence, $idleGameDelay, $active);
		}
	}
}

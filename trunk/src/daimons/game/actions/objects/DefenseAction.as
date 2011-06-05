package daimons.game.actions.objects
{
	import flash.display.DisplayObject;

	/**
	 * @author lbineau
	 */
	public class DefenseAction extends AAction
	{
		public function DefenseAction($view : DisplayObject, $name : String, $persistence : Number, $idleGameDelay : Number, $active : Boolean = false)
		{
			super($view, $name, $persistence, $idleGameDelay, $active);
		}
	}
}

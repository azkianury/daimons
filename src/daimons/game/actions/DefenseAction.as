package daimons.game.actions
{
	import flash.display.DisplayObject;

	/**
	 * @author lbineau
	 */
	public class DefenseAction extends AAction
	{
		public function DefenseAction($view : DisplayObject, $name : String, $keyCode : uint, $persistence : Number, $idleGameDelay : Number, $active : Boolean = false)
		{
			super($view, $name, $keyCode, $persistence, $idleGameDelay, $active);
		}
	}
}

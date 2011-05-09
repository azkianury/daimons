package daimons.game.hurtObjects
{
	import daimons.core.PATHS;
	import daimons.game.hurtObjects.abstract.Trap;

	/**
	 * @author lbineau
	 */
	public class Wall extends Trap
	{
		public function Wall(name : String, params : Object = null)
		{
			if(params == null){
				params = new Object();
				params.view = PATHS.CHARACTER_ASSETS + "hero.swf";
			}
			super(name, params);
		}
		
	}
}

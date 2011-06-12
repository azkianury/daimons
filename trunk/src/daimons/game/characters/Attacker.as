package daimons.game.characters
{
	import daimons.game.actions.AAction;
	import daimons.game.actions.ActionManager;
	import daimons.game.actions.Actions;
	import daimons.game.hurtingobjects.AHurtingObject;
	import daimons.game.hurtingobjects.projectiles.Lightning;
	import daimons.game.hurtingobjects.statics.Rock;
	import daimons.game.hurtingobjects.statics.Spikes;
	import daimons.game.hurtingobjects.statics.Wall;

	import com.citrusengine.objects.PhysicsObject;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;

	import org.osflash.signals.Signal;

	/**
	 * @author lbineau
	 */
	public class Attacker extends PhysicsObject
	{
		public var onAttack : Signal;

		/**
		 * Creates a new hero object.
		 */
		public function Attacker(name : String, params : Object = null)
		{
			super(name, params);
			onAttack = new Signal(AHurtingObject);
			ActionManager.getInstance().onAction.add(_onAction);
		}

		private function _onAction(action : AAction) : void
		{
			trace(this,action.name)
			switch(action.name)
			{
				case Actions.ROCK:
					onAttack.dispatch(new Rock("rock" + (new Date()).toDateString(), {view:(LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Rock"), radius:80, offsetX:- 100, offsetY:- 100}));
					break;
				case Actions.SPIKES:
					onAttack.dispatch(new Spikes("spikes" + (new Date()).toDateString(), {view:(LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Spike"), width:90, height:40, offsetX:-220, offsetY:-80}));
					break;
				case Actions.WALL:
					onAttack.dispatch(new Wall("wall" + (new Date()).toDateString(), {view:(LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Wall"), width:20, height:220, offsetX:- 40, offsetY:- 280}));
					break;
				case Actions.LIGHTNING:
					onAttack.dispatch(new Lightning("lightning" + (new Date()).toDateString(), {view:((LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Lightning")), gravity:0, width:250, height:20}));
					break;
				case Actions.THUNDER:
					onAttack.dispatch(new Rock("rock1", {view:(LoaderMax.getLoader("hurtingObjects1") as SWFLoader).getClass("Rock"), radius:80, offsetX:- 100, offsetY:- 100}));
					break;
				default:
			}
		}

		override public function destroy() : void
		{
		}

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);
			updateAnimation();
		}

		private function updateAnimation() : void
		{
		}
	}
}
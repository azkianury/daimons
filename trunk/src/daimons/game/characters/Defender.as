package daimons.game.characters
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.PhysicsObject;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import daimons.game.actions.AAction;
	import daimons.game.actions.ActionManager;
	import daimons.game.hurtingobjects.AHurtingObject;
	import daimons.game.hurtingobjects.Projectile;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;





	/**
	 * @author lbineau
	 */
	public class Defender extends PhysicsObject
	{
		// properties
		/**
		 * This is the rate at which the hero speeds up when you move him left and right. 
		 */
		public var acceleration : Number = 1;
		/**
		 * This is the fastest speed that the hero can move left or right. 
		 */
		public var maxVelocity : Number = 8;
		/**
		 * This is the initial velocity that the hero will move at when he jumps.
		 */
		public var jumpHeight : Number = 10;
		/**
		 * This is the amount of "float" that the hero has when the player holds the jump button while jumping. 
		 */
		public var jumpAcceleration : Number = 0;
		/**
		 * This is the amount of friction that the hero will have when he's not running. 
		 */
		public var skidFriction : Number = 0.55;
		/**
		 * This is the y velocity that the hero must be travelling in order to kill a Baddy.
		 */
		public var killVelocity : Number = 3;
		/**
		 * The y velocity that the hero will spring when he kills an enemy. 
		 */
		public var enemySpringHeight : Number = 10;
		/**
		 * The y velocity that the hero will spring when he kills an enemy while pressing the jump button. 
		 */
		public var enemySpringJumpHeight : Number = 12;
		/**
		 * How long the hero is in hurt mode for. 
		 */
		public var hurtDuration : Number = 1000;
		/**
		 * Whether or not the player can move and jump with the hero. 
		 */
		public var controlsEnabled : Boolean = true;
		/**
		 * The amount of kick-back that the hero jumps when he gets hurt. 
		 */
		public var hurtVelocityX : Number = 30;
		/**
		 * The amount of kick-back that the hero jumps when he gets hurt. 
		 */
		public var hurtVelocityY : Number = 10;
		// events
		/**
		 * Dispatched whenever the hero jumps. 
		 */
		public var onJump : Signal;
		/**
		 * Dispatched whenever the hero gives damage to an enemy. 
		 */
		public var onGiveDamage : Signal;
		/**
		 * Dispatched whenever the hero takes damage from an enemy. 
		 */
		public var onTakeDamage : Signal;
		/**
		 * Dispatched whenever the hero's animation changes. 
		 */
		public var onAnimationChange : Signal;
		private var _groundContacts : Array = [];
		// Used to determine if he's on ground or not.
		private var _enemyClass : Class = AHurtingObject;
		private var _onGround : Boolean = false;
		private var _springOffEnemy : Number = -1;
		private var _hurtTimeoutID : Number;
		private var _hurt : Boolean = false;
		private var _prevAnimation : String = "idle";
		private var _actionManager : ActionManager;
		private var _theMc : MovieClip;

		/**
		 * Creates a new hero object.
		 */
		public function Defender(name : String, params : Object = null)
		{
			super(name, params);

			onJump = new Signal();
			onGiveDamage = new Signal();
			onTakeDamage = new Signal();
			onAnimationChange = new Signal();
			_actionManager = ActionManager.getInstance();
			_actionManager.onAction.add(_onAction);
			MonsterDebugger.initialize(this);
		}

		private function _onAction(action : AAction) : void
		{
			if (action.name == ActionManager.PUNCH)
			{
				var proj : Projectile = new Projectile("projectile" + (new Date()).toTimeString(), {view:((LoaderMax.getLoader("hero") as SWFLoader).getClass("Boule")),x:this.x + 50, y:this.y - 50, gravity:0});
				CitrusEngine.getInstance().state.add(proj);
			}
			else if (action.name == ActionManager.SHIELD)
			{
			}
			_animation = action.name;
			onAnimationChange.dispatch();
		}

		override public function destroy() : void
		{
			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			_fixture.removeEventListener(ContactEvent.END_CONTACT, handleEndContact);
			clearTimeout(_hurtTimeoutID);
			onJump.removeAll();
			onGiveDamage.removeAll();
			onTakeDamage.removeAll();
			onAnimationChange.removeAll();
			super.destroy();
		}

		/**
		 * Returns true if the hero is on the ground and can jump. 
		 */
		public function get onGround() : Boolean
		{
			return _onGround;
		}

		/**
		 * The Hero uses the enemyClass parameter to know who he can kill (and who can kill him).
		 * Use this setter to to pass in which base class the hero's enemy should be, in String form
		 * or Object notation.
		 * For example, if you want to set the "Baddy" class as your hero's enemy, pass
		 * "com.citrusengine.objects.platformer.Baddy", or Baddy (with no quotes). Only String
		 * form will work when creating objects via a level editor.
		 */
		public function set enemyClass(value : *) : void
		{
			if (value is String)
				_enemyClass = getDefinitionByName(value as String) as Class;
			else if (value is Class)
				_enemyClass = value;
		}

		override public function update(timeDelta : Number) : void
		{
			super.update(timeDelta);

			var velocity : V2 = _body.GetLinearVelocity();
			velocity.x += (acceleration);

			if (controlsEnabled)
			{
				var moveKeysPressed : Boolean = false;

				if (_ce.input.isDown(Keyboard.RIGHT))
				{
					// velocity.x += (acceleration);
					moveKeysPressed = true;
				}

				if (_ce.input.isDown(Keyboard.LEFT))
				{
					velocity.x -= (acceleration);
					moveKeysPressed = true;
				}

				if (_onGround && _ce.input.justPressed(Keyboard.SPACE) && _actionManager.currentAction.name == "jump")
				{
					velocity.y = -jumpHeight;
					onJump.dispatch();
				}

				if (_ce.input.isDown(Keyboard.SPACE) && !_onGround && velocity.y < 0 && _actionManager.currentAction.name == "jump")
				{
					velocity.y -= jumpAcceleration;
				}

				if (_springOffEnemy != -1)
				{
					y = _springOffEnemy;
					if (_ce.input.isDown(Keyboard.SPACE) && _actionManager.currentAction.name == "jump")
						velocity.y = -enemySpringJumpHeight;
					else
						velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}
			}

			// Cap velocities
			if (velocity.x > (maxVelocity))
				velocity.x = maxVelocity;
			else if (velocity.x < (-maxVelocity))
				velocity.x = -maxVelocity;

			// dampen
			if (_onGround && !moveKeysPressed)
			{
				velocity.x *= skidFriction;
			}

			// update physics with new velocity
			_body.SetLinearVelocity(velocity);

			updateAnimation();
		}

		/**
		 * Hurts the hero, disables his controls for a little bit, and dispatches the onTakeDamage signal. 
		 */
		public function hurt() : void
		{
			
			controlsEnabled = false;
			var timer : Timer = new Timer(100, 10);
			timer.addEventListener(TimerEvent.TIMER, _clignote);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, _finClignote);
			timer.start();
			_hurtTimeoutID = setTimeout(endHurtState, hurtDuration);
			onTakeDamage.dispatch();
			
		}

		private function _finClignote(event : TimerEvent) : void
		{
			_theMc.visible = true;
			MonsterDebugger.trace(this, _view);
			event.currentTarget.removeEventListener(TimerEvent.TIMER, _clignote);
			event.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, _finClignote);
		}

		private function _clignote(event : TimerEvent) : void
		{
			_theMc.visible = !_theMc.visible;
		}

		private function _onClignote() : void
		{
			_view.visible = false;
		}

		override protected function defineBody() : void
		{
			super.defineBody();
			_bodyDef.fixedRotation = true;
			_bodyDef.allowSleep = false;
		}

		override protected function defineFixture() : void
		{
			super.defineFixture();
			_fixtureDef.friction = 0;
			_fixtureDef.restitution = 0;
		}

		override protected function createFixture() : void
		{
			super.createFixture();
			_fixture.m_reportBeginContact = true;
			_fixture.m_reportEndContact = true;
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			_fixture.addEventListener(ContactEvent.END_CONTACT, handleEndContact);
		}

		private function handleBeginContact(e : ContactEvent) : void
		{
			var colliderBody : b2Body = e.other.GetBody();

			if (_enemyClass && colliderBody.GetUserData() is _enemyClass)
			{
				if (_body.GetLinearVelocity().y < killVelocity && !_hurt && colliderBody.GetUserData().touched)
				{
					// hurt();
				}
			}

			// Collision angle
			if (e.normal) // The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				var collisionAngle : Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				if (collisionAngle > 45 && collisionAngle < 135)
				{
					_groundContacts.push(e.other);
					_onGround = true;
				}
			}
		}

		private function handleEndContact(e : ContactEvent) : void
		{
			// Remove from ground contacts, if it is one.
			var index : int = _groundContacts.indexOf(e.other);
			if (index != -1)
			{
				_groundContacts.splice(index, 1);
				if (_groundContacts.length == 0)
					_onGround = false;
			}
		}

		private function endHurtState() : void
		{
			_hurt = false;
			controlsEnabled = true;
		}

		private function updateAnimation() : void
		{
			var prevAnimation : String = _animation;

			var velocity : V2 = _body.GetLinearVelocity();
			if (!_actionManager.busy)
			{
				if (_hurt)
				{
					_animation = "hurt";
				}
				else if (!_onGround)
				{
					if (velocity.y < 5)
						_animation = "jump";
					else
						_animation = "land";
				}
				else
				{
					if (velocity.x > .5)
					{
						_inverted = false;
						_animation = "walk";
					}
					else
					{
						_animation = "idle";
					}
				}
			}

			if (prevAnimation != _animation)
			{
				onAnimationChange.dispatch();
			}
		}

		public function changeAnimation(anim : String) : void
		{
			_prevAnimation = _animation;
			_animation = anim;
			trace(_animation)
		}

		public function set theMc(theMc : MovieClip) : void
		{
			_theMc = theMc;
		}
	}
}
package com.citrusengine.objects.platformer
{
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	
	import com.citrusengine.objects.PhysicsObject;
	
	public class Platform extends PhysicsObject
	{
		private var _oneWay:Boolean = false;
		
		public function Platform(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override public function destroy():void
		{
			_fixture.removeEventListener(ContactEvent.PRE_SOLVE, handlePreSolve);
			super.destroy();
		}
		
		public function get oneWay():Boolean
		{
			return _oneWay;
		}
		
		public function set oneWay(value:Boolean):void
		{
			if (_oneWay == value)
				return;
			
			_oneWay = value;
			
			if (!_fixture)
				return;
			
			if (_oneWay)
			{
				_fixture.m_reportPreSolve = true;
				_fixture.addEventListener(ContactEvent.PRE_SOLVE, handlePreSolve);
			}
			else
			{
				_fixture.m_reportPreSolve = false;
				_fixture.removeEventListener(ContactEvent.PRE_SOLVE, handlePreSolve);
			}
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.type = b2Body.b2_staticBody;
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.density = 0.1;
			_fixtureDef.restitution = 0;
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			if (_oneWay)
			{
				_fixture.m_reportPreSolve = true;
				_fixture.addEventListener(ContactEvent.PRE_SOLVE, handlePreSolve);
			}
		}
		
		private function handlePreSolve(e:ContactEvent):void
		{
			//Get the y position of the top of the platform
			var platformTop:Number = _body.GetPosition().y - _height / 2;
			
			//Get the half-height of the collider, if we can guess what it is (we are hoping the collider extends PhysicsObject).
			var colliderHalfHeight:Number = 0;
			if (e.other.GetBody().GetUserData().height)
				colliderHalfHeight = e.other.GetBody().GetUserData().height / _box2D.scale / 2;
			else
				return;
			
			//Get the y position of the bottom of the collider
			var colliderBottom:Number = e.other.GetBody().GetPosition().y + colliderHalfHeight;
			
			//Find out if the collider is below the platform
			if (platformTop < colliderBottom)
				e.contact.Disable();
		}
	}
}
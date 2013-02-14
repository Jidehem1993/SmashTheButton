package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/*
	 * Character
	 */
	public class JeanFrancois extends FlxSprite
	{
		[Embed(source='../assets/gfx/avatar.png')]
		protected var ImgAvatar:Class;
		
		private var jumpDuration:Number;
		
		public function JeanFrancois(gravity:Number)
		{
			super(C.JF_INIT_X, C.JF_INIT_Y, ImgAvatar);
			this.loadGraphic(ImgAvatar, true, false, 36, 49);
			this.addAnimation('run', [6], 25, true);
			this.addAnimation('jump', [5], 3, true);
			this.addAnimation('fall', [3], 3, true);
			this.addAnimation('land', [4, 1], 3, false);
			this.addAnimation('death', [0], 3, false);
			this.addAnimation('deathSproutch', [1], 3, false);
			this.addAnimation('deathSplat', [2], 3, false);
			
			this.play('run');
			this.velocity.x = C.JF_SPEED;
			
			maxVelocity.y = gravity;
			jumpDuration = 0;
		}
		
		override public function update():void
		{
			if (jumpDuration > 0)
			{
				jumpDuration--;
			}
			else
			{
				this.velocity.y = maxVelocity.y;
			}
		}
		
		public function jump(power:Number):void
		{
			if (jumpDuration <= 0)
			{
				jumpDuration = power;
				this.velocity.y = -maxVelocity.y;
			}
		}
		
		public function setSpeed(speed:Number):void
		{
			this.velocity.x = speed;
		}
	
	}

}
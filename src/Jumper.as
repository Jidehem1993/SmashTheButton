package
{
	import org.flixel.FlxSprite;
	
	/*
	 * The jumper basic class
	 */
	public class Jumper extends FlxSprite
	{
		[Embed(source='../assets/gfx/jumper.png')]
		protected var ImgJumper:Class;
		
		private var type:String;
		private var duration:Number;
		private var left:Number;
		private var power:Number;
		private var up:Boolean;
		private var canActivate:Boolean;
		
		public function Jumper(x:uint, y:uint, type:String, duration:Number, power:Number)
		{
			super(x, y, ImgJumper);
			this.loadGraphic(ImgJumper, false, false, 72, 32);
			this.addAnimation('inaction', [0], 0, false);
			this.addAnimation('action', [1], 0, false);
			
			this.type = type;
			up = false;
			canActivate = false;
			
			this.duration = duration;
			left = 0;
			
			this.power = power;
		}
		
		override public function update():void
		{
			super.update();
			
			//Check if the jumper can be activated or not
			if (canActivate)
			{
				canActivate = false;
				
				if (left <= 0)
				{
					left = this.duration;
				}
				up = true;
				this.play('action');
			}
			else if (left > 0)
			{
				if (--left <= 0)
				{
					up = false;
					this.play('inaction');
				}
			}
			
			canActivate = false;
		}
		
		public function isUp():Boolean
		{
			return this.up;
		}
		
		public function activable(canActivate:Boolean = true):void
		{
			this.canActivate = canActivate;
		}
		
		public function getType():String
		{
			return this.type;
		}
		
		public function getPower():Number
		{
			return this.power;
		}
	
	}

}
package
{
	
	/**
	 * Constants for quick settings
	 */
	public class C
	{
		//Game
		public static const FRAMERATE:Number = 65; //Framerate of the game. Higher framerate means more updates, but costs  performances
		
		//Jean-Francois
		public static const JF_INIT_X:int = -30; //X of the starting point of JF in each room
		public static const JF_INIT_Y:int = 367; //Y of the starting point of JF in each room
		public static const JF_SPEED:Number = 300; //Speed of JF in pixels per second
		
		//Rooms
		public static const ROOM_DEFAULT_GRAVITY:Number = 300;
		
		//Objects
		public static const JUMPER_DEFAULT_DURATION:Number = FRAMERATE * 0.3; //Jumper up duration in seconds
		public static const JUMPER_DEFAULT_POWER:Number = FRAMERATE * 1; //Jumper power (duration of the jump in second)
	}

}
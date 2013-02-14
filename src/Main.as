package
{
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	
	[SWF(width=800,height=600,backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	/**
	 * Starting point of the game application
	 */
	public class Main extends FlxGame
	{
		public function Main()
		{
			//Function to call to create the game at a specified screen size and display the first state (MenuState)
			super(800, 600, MainMenu);
			
			FlxG.framerate = C.FRAMERATE;
		}
	
	}

}
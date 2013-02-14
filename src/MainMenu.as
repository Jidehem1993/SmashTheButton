package
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	/**
	 * Main menu of the game
	 */
	public class MainMenu extends FlxState
	{
		
		override public function create():void
		{
			FlxG.bgColor = 0xaaffffff;
			
			var title:FlxText = new FlxText(FlxG.width / 2 - 50, FlxG.height / 2 - 200, 100, "Welcome");
			title.setFormat("", 16, 0x123fff);
			add(title);
			
			var instruction:FlxText = new FlxText(FlxG.width / 2 - 100, FlxG.height / 2 + 100, 200, "Press Benjamin to continue.");
			instruction.setFormat("", 12, 0x123fff);
			add(instruction);
		}
		
		/**
		 * Update the state
		 */
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.pressed("SPACE"))
			{
				FlxG.switchState(new Zone(12, 0, 2, true));
			}
		}
	}
}

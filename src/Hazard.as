package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	public class Hazard extends FlxGroup
	{
		
		//Embed all tilesets
		[Embed(source='../assets/gfx/rooms/tilesets/hazards.png')]
		protected var ImgHazard:Class;
		
		private var tiles:Array;
		
		public function Hazard(x:uint, y:uint, width:uint, type:String)
		{
			tiles = new Array();
			for (var numTiles:uint = 0; numTiles < width / 32; numTiles++)
			{
				tiles[numTiles] = new FlxSprite(x + 32 * numTiles, y, ImgHazard);
				tiles[numTiles].loadGraphic(ImgHazard, false, false, 32, 32);
				
				//Adding animation to choose the tile used for this hazard
				if (type == 'Spikes')
				{
					tiles[numTiles].addAnimation('default', [0], 0, false);
				}
				
				tiles[numTiles].play('default');
				
				this.add(tiles[numTiles]);
			}
		}
	}

}
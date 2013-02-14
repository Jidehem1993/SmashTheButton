package
{
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxMap;
	import net.pixelpracht.tmx.TmxObject;
	import org.flixel.FlxTilemap;
	
	/*
	 * Loading tilemaps as rooms
	 */
	public class Room
	{
		//Embed all rooms
		[Embed(source="../assets/gfx/rooms/room0.tmx",mimeType="application/octet-stream")]
		private var Room0:Class;
		[Embed(source="../assets/gfx/rooms/room1.tmx",mimeType="application/octet-stream")]
		private var Room1:Class;
		[Embed(source="../assets/gfx/rooms/room2.tmx",mimeType="application/octet-stream")]
		private var Room2:Class;
		
		//Embed all rooms tilesets
		[Embed(source='../assets/gfx/rooms/tilesets/floor.png')]
		protected var FloorTileSet:Class;
		
		private var allRooms:Array;
		
		private var tmx:TmxMap;
		private var tilemap:FlxTilemap;
		private var xml:XML;
		private var csv:String;
		
		private var jumpers:Array;
		private var sliders:Array;
		private var sproutchers:Array;
		private var hazards:Array;
		
		private var gravity:Number;
		private var tmxloaded:Boolean;
		
		public function Room(roomToLoad:uint)
		{
			tmxloaded = false;
			gravity = C.ROOM_DEFAULT_GRAVITY;
			
			allRooms = new Array();
			//Putting all rooms inside the array
			allRooms[0] = new Room0();
			allRooms[1] = new Room1();
			allRooms[2] = new Room2();
			
			xml = new XML(allRooms[roomToLoad].readUTFBytes(allRooms[roomToLoad].length));
			tmx = new TmxMap(xml);
			
			tilemap = new FlxTilemap();
			
			csv = tmx.getLayer('Room').toCsv(tmx.getTileSet('Smash'));
			
			//Getting custom gravity if it is set for the room
			if (tmx.properties != null && tmx.properties.hasOwnProperty('gravity'))
			{
				gravity = tmx.properties['gravity'];
			}
			
			//Loading map with csv and tileset
			tilemap.loadMap(csv, FloorTileSet, tmx.tileWidth, tmx.tileHeight);
			
			var currentObject:TmxObject;
			if (tmx.objectGroups != null) {
				//Setting jumpers
				jumpers = new Array();
				if (tmx.objectGroups.hasOwnProperty('Jumpers'))
				{
					for (var numJumpers:uint = 0; numJumpers < tmx.getObjectGroup('Jumpers').objects.length; numJumpers++)
					{
						currentObject = tmx.getObjectGroup('Jumpers').objects[numJumpers];
						jumpers[numJumpers] = new Jumper(currentObject.x, currentObject.y, currentObject.type, (currentObject.custom != null && !isNaN(currentObject.custom['duration'])) ? currentObject.custom['duration'] * C.FRAMERATE : C.JUMPER_DEFAULT_DURATION, (currentObject.custom != null && !isNaN(currentObject.custom['power'])) ? currentObject.custom['power'] : C.JUMPER_DEFAULT_POWER);
					}
				}
				//TODO Setting sliders
				sliders = new Array();
				//TODO Setting sproutchers
				sproutchers = new Array();
				//Setting hazards
				hazards = new Array();
				if (tmx.objectGroups.hasOwnProperty('Hazards'))
				{
					for (var numHazards:uint = 0; numHazards < tmx.getObjectGroup('Hazards').objects.length; numHazards++)
					{
						currentObject = tmx.getObjectGroup('Hazards').objects[numHazards];
						hazards[numHazards] = new Hazard(currentObject.x, currentObject.y, currentObject.width, currentObject.type);
					}
				}
			}
		}
		
		public function getGravity():Number
		{
			return this.gravity;
		}
		
		public function getTilemap():FlxTilemap
		{
			return this.tilemap;
		}
		
		public function getJumpers():Array
		{
			return this.jumpers;
		}
		
		public function getSliders():Array
		{
			return this.sliders;
		}
		
		public function getSproutchers():Array
		{
			return this.sproutchers;
		}
		
		public function getHazards():Array
		{
			return this.hazards;
		}
	}
}
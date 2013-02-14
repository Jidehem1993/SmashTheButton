package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	/*
	 * The game screen
	 */
	public class Zone extends FlxState
	{
		private var toDo:uint;
		private var start:uint;
		private var end:uint;
		private var random:Boolean;
		private var roomSet:Array;
		
		private var currentRoom:uint;
		private var allRooms:Array;
		
		private var currentJf:uint;
		private var allJfs:Array;
		
		public function Zone(toDo:uint, start:uint = 0, end:uint = 2, random:Boolean = true, roomSet:Array = null)
		{
			this.toDo = toDo;
			
			this.start = start;
			this.end = end;
			this.random = random;
			this.roomSet = roomSet;
		}
		
		override public function create():void
		{
			
			currentRoom = 0;
			allRooms = new Array();
			
			currentJf = 0;
			allJfs = new Array();
			
			this.selectRooms();
			this.loadRoom(true);
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(allJfs[currentJf], allRooms[currentRoom].getTilemap());
			
			//Try jumpers
			for (var numJumpers:uint = 0; numJumpers < allRooms[currentRoom].getJumpers().length; numJumpers++)
			{
				var currentJumper:Jumper = allRooms[currentRoom].getJumpers()[numJumpers];
				
				if (currentJumper.getType() == 'Follow')
				{
					currentJumper.x = allJfs[currentJf].x - (currentJumper.width - allJfs[currentJf].width) / 2;
				}
				
				if (isAnyKeyJustPressed())
				{
					currentJumper.activable();
				}
				
				if (currentJumper.isUp() && isInRange(allJfs[currentJf], currentJumper) && allJfs[currentJf].y + allJfs[currentJf].height == currentJumper.y)
				{
					allJfs[currentJf].jump(currentJumper.getPower());
				}
			}
			
			//TODO Try sliders
			//TODO Try sproutchers
			
			//Try deaths
			if (isJfDead())
			{
				this.resetJf();
			}
			
			//Change room
			if (allJfs[currentJf].x > FlxG.width)
			{
				if (--toDo > 0)
				{
					if (allRooms[currentRoom + 1] == null)
					{
						
						this.selectRooms();
					}
					this.loadRoom();
				}
				else
				{
					FlxG.switchState(new MainMenu());
				}
			}
		}
		
		//Select rooms for the zone
		private function selectRooms():void
		{
			var roomId:uint;
			
			//If it is a defined set of rooms
			if (roomSet != null)
			{
				for (roomId = 0; roomId < roomSet.length; roomId++)
				{
					allRooms.push(new Room(roomSet[roomId]));
				}
			}
			else
			{
				//If it is not a random selection
				if (!random)
				{
					for (roomId = start; roomId <= end; roomId++)
					{
						allRooms.push(new Room(roomId));
					}
				}
				else
				{
					var outed:Array = new Array;
					
					for (var rangeRoom:uint = start; rangeRoom <= end - start; rangeRoom++)
					{
						//Shuffling rooms
						do
						{
							roomId = uint(Math.random() * (end + 1)) + start;
						} while (outed.indexOf(roomId) != -1)
						
						outed.push(roomId);
						allRooms.push(new Room(roomId));
					}
				}
			}
		}
		
		private function loadRoom(first:Boolean = false):void
		{
			
			if (!first)
			{
				currentRoom++;
			}
			
			//Load the room's map
			add(allRooms[currentRoom].getTilemap());
			
			//Removing previous rooms objects
			if (!first)
			{
				remove(allRooms[currentRoom - 1].getTilemap());
				//Jumpers
				for (var numToDeleteJumpers:uint = 0; numToDeleteJumpers < allRooms[currentRoom - 1].getJumpers().length; numToDeleteJumpers++)
				{
					remove(allRooms[currentRoom - 1].getJumpers()[numToDeleteJumpers]);
				}
				//Sliders
				for (var numToDeleteSliders:uint = 0; numToDeleteSliders < allRooms[currentRoom - 1].getSliders().length; numToDeleteSliders++)
				{
					remove(allRooms[currentRoom - 1].getSliders()[numToDeleteSliders]);
				}
				//Sproutchers
				for (var numToDeleteSproutchers:uint = 0; numToDeleteSproutchers < allRooms[currentRoom - 1].getSproutchers().length; numToDeleteSproutchers++)
				{
					remove(allRooms[currentRoom - 1].getSproutchers()[numToDeleteSproutchers]);
				}
				//Hazards
				for (var numToDeleteHazards:uint = 0; numToDeleteHazards < allRooms[currentRoom - 1].getHazards().length; numToDeleteHazards++)
				{
					remove(allRooms[currentRoom - 1].getHazards()[numToDeleteHazards]);
				}
			}
			
			//Creating a JF for the room
			add(allJfs[currentJf] = new JeanFrancois(allRooms[currentRoom].getGravity()));
			
			//Adding objects
			//Jumpers
			for (var numJumpers:uint = 0; numJumpers < allRooms[currentRoom].getJumpers().length; numJumpers++)
			{
				add(allRooms[currentRoom].getJumpers()[numJumpers]);
			}
			//TODO Sliders
			//TODO Sproutchers
			//Hazards
			for (var numHazards:uint = 0; numHazards < allRooms[currentRoom].getHazards().length; numHazards++)
			{
				add(allRooms[currentRoom].getHazards()[numHazards]);
			}
		}
		
		//Check if any key has been pressed recently
		private function isAnyKeyJustPressed():Boolean
		{
			if (FlxG.keys.record() != null)
			{
				for (var totalKeysPressed:uint = 0; totalKeysPressed < FlxG.keys.record().length; totalKeysPressed++)
				{
					if (FlxG.keys.record()[totalKeysPressed]['value'] == 2)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		//Check if the current JF encountered death and animate him accordingly
		private function isJfDead():Boolean
		{
			//JF hits a wall
			if (allJfs[currentJf].velocity.x == 0)
			{
				allJfs[currentJf].play('deathSplat');
				return true;
			}
			//JF falls in a pit
			if (allJfs[currentJf].y > FlxG.height)
			{
				return true;
			}
			//JF encounters a hazard
			for (var numHazards:uint = 0; numHazards < allRooms[currentRoom].getHazards().length; numHazards++)
			{
				if (FlxG.overlap(allJfs[currentJf], allRooms[currentRoom].getHazards()[numHazards]))
				{
					allJfs[currentJf].play('deathSproutch');
					return true;
				}
			}
			return false;
		}
		
		//If the last JF is dead, a new one is spawned
		private function resetJf():void
		{
			allJfs[++currentJf] = new JeanFrancois(allRooms[currentRoom].getGravity());
			add(allJfs[currentJf]);
		}
		
		//Check if object1 is over or under object2
		public function isInRange(object1:FlxSprite, object2:FlxSprite):Boolean
		{
			return object1.x >= object2.x && object1.x <= object2.x + object2.width;
		}
	
	}

}
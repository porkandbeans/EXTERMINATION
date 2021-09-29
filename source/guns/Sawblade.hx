package guns;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Sawblade extends FlxSprite
{
	var _parent:SawbladeSpawner;
	var _spawnPoint:FlxPoint;

	public function new(parent:SawbladeSpawner)
	{
		super();
		_parent = parent;

		// calculates the the X and Y co-ordinates to respawn at
		_spawnPoint = new FlxPoint(_parent.getMidpoint().x - (width / 2), _parent.getMidpoint().y - (height / 2));

		makeGraphic(12, 12);
	}

	override public function kill()
	{
		// makes it teleport instead of dying when it hits the walls
		x = _spawnPoint.x;
		y = _spawnPoint.y;
	}

	public function shoot(_v:Float)
	{
		x = _spawnPoint.x;
		y = _spawnPoint.y;
		velocity.x = _v;
		trace("a sawblade was fired");
	}
}
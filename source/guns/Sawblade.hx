package guns;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class Sawblade extends FlxSprite
{
	var _parent:SawbladeSpawner;
	var _spawnPoint:FlxPoint;
	var _speed:Float;
	var _firedRecently:Bool = false;
	var _teleporting:Bool;

	public function new(parent:SawbladeSpawner, speed:Float)
	{
		super();

		_parent = parent;
		_speed = speed;

		loadGraphic("assets/images/misc/sawblade.png", false, 12, 12);

		// calculates the the X and Y co-ordinates to respawn at
		_spawnPoint = new FlxPoint(_parent.getMidpoint().x - (width / 2), _parent.getMidpoint().y - (height / 2));


	}

	override public function kill()
	{
		// makes it teleport instead of dying when it hits the walls
		_teleporting = true;
		shoot();
		var timer = new FlxTimer().start(0.01, reset ->
		{
			_teleporting = false;
		});

		/**
			so this is really interesting

			when the sawblade gets teleported back to its spawn point in kill(), HaxeFlixel sees that as it travelling and not
			an instant teleportation. If the player is standing between the collision point and the spawn point, they'll take damage
			as if it passed over them.
		**/
	}

	public function shoot()
	{
		x = _spawnPoint.x;
		y = _spawnPoint.y;
		velocity.x = _speed;
		trace("a sawblade was fired");
	}
	public function hurtPlayer(player:Player)
	{
		if (!_firedRecently && !_teleporting)
		{
			_firedRecently = true;
			player.takeDmg(6);
			var timer = new FlxTimer().start(0.4, reset ->
			{
				_firedRecently = false;
			});
		}
	}

	override public function update(elapsed:Float)
	{
		angle -= 6;
		super.update(elapsed);
	}
	


}
package guns;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class SawbladeSpawner extends FlxSprite
{
	var _spawnTimer:FlxTimer;

	public var sawblade:Sawblade;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		makeGraphic(16, 16, FlxColor.TRANSPARENT);

		sawblade = new Sawblade(this);

		shootBlade();
	}

	function shootBlade()
	{
		sawblade.shoot(4);
	}
}
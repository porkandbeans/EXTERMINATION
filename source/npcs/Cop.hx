package npcs;

import flixel.group.FlxGroup.FlxTypedGroup;
import guns.Bullet;
import guns.Pistol;

class Cop extends NPC
{
	public var pistol:Pistol;

	override public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic("assets/images/NPCs/cop.png", true, 32, 32);

		init();
		animation.add("shoot", [16]);
	}

	override public function triggered()
	{
		// stand still and shoot at the player's direction
		acceleration.x = 0;
		animation.play("shoot");
		if (_playerPos.x > x)
		{
			flipX = false;
		}
		else
		{
			flipX = true;
		}

		pistol.shoot(getMidpoint().x, getMidpoint().y, flipX);
		super.triggered();
	}

	/**
		Declares the cop's Pistol class (pass it a FlxTypedGroup<Bullet>)
	**/
	public function initPistol(bulls:FlxTypedGroup<Bullet>)
	{
		pistol = new Pistol(bulls, 1);
	}
}

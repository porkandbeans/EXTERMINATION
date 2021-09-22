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

		// pistol.initBullets(10); past charlie, no. not gonna work.

		loadGraphic("assets/images/NPCs/cop.png", true, 32, 32);

		init();
	}

	override public function triggered()
	{
		// stand still and shoot at the player's direction
		acceleration.x = 0;
		animation.play("idle");
		if (_playerPos.x > x)
		{
			flipX = false;
		}
		else
		{
			flipX = true;
		}

		pistol.shoot(getMidpoint().x, getMidpoint().y, flipX);
		pistol.addAmmo(pistol.getMaxAmmo()); // TODO: I am lazy and should create a new kind of class for this or at least an enum
		super.triggered();
	}

	/**
		Declares the cop's Pistol class (pass it a FlxTypedGroup<Bullet>)
	**/
	public function initPistol(bulls:FlxTypedGroup<Bullet>)
	{
		pistol = new Pistol(bulls);
	}
}

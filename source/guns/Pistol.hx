package guns;

import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

class Pistol extends Gun
{
	var _bullets:FlxTypedGroup<Bullet>;

	/**
		@param	bullets	The bullets that are add()ed in PlayState, so that this class can control them.
		@param	type	0 = player, 1 = cop (cops shoot slower and have infinite ammo)
	**/
	public function new(bullets:FlxTypedGroup<Bullet>, type:Int)
	{
		super(type);
		_MAX_AMMO = 36;
		ammo = 12;

		_bullets = bullets;

		_canShoot = true;
		loadSound("assets/sounds/sound_effects/guns/pistol.wav");
	}

	override public function shoot(x:Float, y:Float, f:Bool)
	{
		super.shoot(x, y, f);
		if (_canShoot)
		{ // if the gun is not on cooldown
			_canShoot = false;

			if (_type == PLAYER && ammo > 0)
			{ // if gun has ammo
				// determines the direction the bullet travels
				_timer.start(0.4, doneShooting, 1);
				f ? _bullets.recycle(Bullet.new).shoot(x, y, -240) : _bullets.recycle(Bullet.new).shoot(x, y, 240);
				trace("player shot");
			}
			else if (_type == COP)
			{
				_timer.start(0.8, doneShooting, 1);
				f ? _bullets.recycle(Bullet.new).copShoot(x, y - 9, -240) : _bullets.recycle(Bullet.new).copShoot(x, y - 9, 240);
				trace("cop shot");
			}
		}
	}

	function doneShooting(timer:FlxTimer)
	{
		_canShoot = true;
	}
}

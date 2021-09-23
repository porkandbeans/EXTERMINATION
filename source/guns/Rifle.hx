package guns;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;

class Rifle extends Gun
{
	var _bullets:FlxTypedGroup<Bullet>;

	public function new(bullets:FlxTypedGroup<Bullet>)
	{
		super();
		_MAX_AMMO = 12;
		ammo = 6;
		_bullets = bullets;
		_canShoot = true;
		_timer = new FlxTimer();
		loadSound("assets/sounds/sound_effects/guns/rifle.wav");
	}

	override public function shoot(x:Float, y:Float, f:Bool)
	{
		super.shoot(x, y, f);
		if (_canShoot && !_empty)
		{ // if the gun is NOT on cooldown and HAS ammo
			_canShoot = false;
			_timer.start(2, doneShooting, 1);
			if (f)
			{ // determines direction bullet will travel
				_bullets.recycle(PlayerBullet.new).shoot(x, y, -960);
			}
			else
			{
				_bullets.recycle(PlayerBullet.new).shoot(x, y, 960);
			}
		}
	}

	function doneShooting(timer:FlxTimer)
	{
		_canShoot = true;
	}

	// TODO: maybe give the bullet a little gravity so that it arcs downward
}

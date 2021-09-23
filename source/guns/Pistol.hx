package guns;

import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

class Pistol extends Gun
{
	var _bullets:FlxTypedGroup<PlayerBullet>;
	var _copBullets:FlxTypedGroup<CopBullet>;

	/**
		@param	bullets	Dynamic type that can be either Cop bullets or Player bullets. The primary difference being that Cop classes don't worry about ammo.
	**/
	public function new(bullets:Dynamic)
	{
		super();
		_MAX_AMMO = 36;
		ammo = 12;
		if (bullets is PlayerBullet)
		{
			_type = PLAYER;
			_bullets = bullets;
		}
		else
		{
			// pass CopBullets in this situation, ALWAYS
			_type = COP;
			_copBullets = bullets;
		}

		_canShoot = true;
		loadSound("assets/sounds/sound_effects/guns/pistol.wav");
	}

	override public function shoot(x:Float, y:Float, f:Bool)
	{
		super.shoot(x, y, f);
		if (_canShoot)
		{ // if the gun is not on cooldown
			_canShoot = false;
			_timer.start(0.4, doneShooting, 1);
			if (_type == PLAYER && ammo > 0)
			{ // if gun has ammo
				// determines the direction the bullet travels
				f ? _bullets.recycle(PlayerBullet.new).shoot(x, y, -240) : _bullets.recycle(PlayerBullet.new).shoot(x, y, 240);
			}
			else if (_type == COP)
			{
				f ? _copBullets.recycle(CopBullet.new).shoot(x, y, -240) : _copBullets.recycle(CopBullet.new).shoot(x, y, 240);
			}
		}
	}

	function doneShooting(timer:FlxTimer)
	{
		_canShoot = true;
	}
}

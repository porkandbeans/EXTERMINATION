package guns;

import flixel.FlxSprite;

class Bullet extends FlxSprite
{
	var _dmg:Float;

	public function new()
	{
		super();
		// makeGraphic(4, 4, FlxColor.WHITE);
		loadGraphic("assets/images/misc/bullet.png", false, 4, 4);
	}

	public function shoot(_x:Float, _y:Float, _v:Float)
	{
		super.x = _x;
		super.y = _y;
		velocity.x = _v;
	}

	public function copShoot(_x:Float, _y:Float, _v:Float)
	{
		setDmg(2);
		shoot(_x, _y, _v);
	}

	public function setDmg(_d:Float)
	{
		_dmg = _d;
	}

	public function getDmg()
	{
		return _dmg;
	}

	public function hurtPlayer(player:Player)
	{
		// trace("hurty?");
		player.takeDmg(_dmg);
		kill();
	}
}

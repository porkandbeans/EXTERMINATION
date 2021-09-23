package guns;

import flixel.FlxSprite;

enum BulletType
{
	PLAYER;
	COP;
}

class Bullet extends FlxSprite
{
	var _type:BulletType;
	var _dmg:Float;

	/**
		@param  type    0 = PLAYER, 1 = COP
	**/
	public function new(type:Int)
	{
		super();
		// makeGraphic(4, 4, FlxColor.WHITE);
		loadGraphic("assets/images/misc/bullet.png", false, 4, 4);
		switch (type)
		{
			case 0:
				_type = PLAYER;
			case 1:
				_type = COP;
		}
	}

	public function shoot(_x:Float, _y:Float, _v:Float)
	{
		super.x = _x;
		super.y = _y;
		velocity.x = _v;
	}

	public function getType()
	{
		return _type;
	}

	public function setDmg(_d:Float)
	{
		_dmg = _d;
	}

	public function hurtPlayer(player:Player)
	{
		player.takeDmg(_dmg);
		kill();
	}
}

package guns;

class CopBullet extends Bullet
{
	var dmg:Float = 2;

	public function hurtPlayer(player:Player)
	{
		player.health -= dmg;
	}

	public function setDmg(_d:Float)
	{
		dmg = _d;
	}
}

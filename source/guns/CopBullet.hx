package guns;

class CopBullet extends Bullet
{
	override public function new()
	{
		setDmg(2);
		super(1);
	}
}

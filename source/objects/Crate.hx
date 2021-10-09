package objects;

import flixel.FlxSprite;

class Crate extends FlxSprite
{
	var _stayHere:Float;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic("assets/images/misc/box.png");

		acceleration.y = 300;
		_stayHere = x;
		elasticity = 0;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		x = _stayHere;
	}
}
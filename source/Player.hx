package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
    var _jumpForce:Float = 120;
    var _weight:Float = 200;
    var _grounded:Bool = true;
    public var floatyPower:Float = 100;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x,y); // passes x and y to FlxSprite
        
        maxVelocity.set(200, 200);
        acceleration.y = _weight;
        drag.x = maxVelocity.x * 5;

		loadGraphic("assets/images/Player/player.png", true, 32, 32);
		animation.add("idle", [0]);
		animation.add("run", [1, 2, 3, 4, 5, 6, 7, 8], 9, true);
		// makeGraphic(16, 16, FlxColor.BLUE);
    }

    public function setWeight(x:Float){
        _weight = x;
        acceleration.y = _weight;
    }

    public function setGrounded(x:Bool){
        _grounded = x;
    }

	override public function update(elapsed:Float)
	{
		acceleration.x = 0;
        acceleration.y = _weight;
        
		keyListeners();

		if (velocity.x == 0)
		{
			animation.play("idle");
		}
		else if (velocity.x > 0)
		{
			flipX = false;
			animation.play("run");
		}
		else
		{
			flipX = true;
			animation.play("run");
		}

		super.update(elapsed);
	}

	function keyListeners()
	{
		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			acceleration.x = -maxVelocity.x * 7;
		}

		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			acceleration.x = maxVelocity.x * 7;
		}

		if (FlxG.keys.anyPressed([SPACE, W, UP]) && isTouching(FlxObject.FLOOR))
		{
			velocity.y = -_jumpForce;
		}
		else if (FlxG.keys.anyPressed([SPACE, W, UP]) && floatyPower > 0 && velocity.y > 0) // is moving down?
		{
			_weight = 50;
			floatyPower -= 1;
		}
		else
		{
			_weight = 200;
		}

		if (isTouching(FlxObject.FLOOR))
		{ // magic
			floatyPower = 100;
		}
    }
}
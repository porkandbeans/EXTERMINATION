package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
    var _jumpForce:Float = 80;
	var _jumpHold:Int;
    var _weight:Float = 300;
    var _grounded:Bool = true;
	var _canJump:Bool;

	var MAX_JUMPHOLD = 20;
    //public var floatyPower:Float = 100;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x,y); // passes x and y to FlxSprite
        
        maxVelocity.set(160, 200);
        acceleration.y = _weight;
        drag.x = maxVelocity.x * 5;

		_jumpHold = MAX_JUMPHOLD;


		loadGraphic("assets/images/Player/player.png", true, 32, 32);
		animation.add("idle", [0]);
		animation.add("run", [1, 2, 3, 4, 5, 6, 7, 8], 9, true);
		animation.add("jump", [9, 10], 4, false);
		animation.add("fall", [11, 12], 9, true);
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
		if(isTouching(FlxObject.FLOOR)){
			_jumpHold = MAX_JUMPHOLD;
		}

		acceleration.x = 0;
        acceleration.y = _weight;
        
		keyListeners();

		if(velocity.y == 0){
			if (velocity.x == 0)
			{
				animation.play("idle");
			}
			else if (velocity.x > 0)
			{
				animation.play("run");
			}
			else
			{
				animation.play("run");
			}
		}else{
			if(velocity.y > -0.7){
				animation.play("fall");
			}else if(isTouching(FlxObject.FLOOR)){
				animation.play("jump");
			}
		}

		if(velocity.x > 0){
			flipX = false;
		}else if(velocity.x < 0){
			flipX = true;
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
		
		if(FlxG.keys.anyJustReleased([SPACE, W, UP]) && !isTouching(FlxObject.FLOOR)){
			_canJump = false;
		}

		if(isTouching(FlxObject.FLOOR)){
			_canJump = true;
		}

		if (FlxG.keys.anyPressed([SPACE, W, UP]) && velocity.y <= 0 && _canJump){
			if(_jumpHold > 0){
				_jumpHold -= 1;
				velocity.y = -_jumpForce;
			}
		}
    }
}
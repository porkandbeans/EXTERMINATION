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

        makeGraphic(16, 16, FlxColor.BLUE);
    }

    public function setWeight(x:Float){
        _weight = x;
        acceleration.y = _weight;
    }

    public function setGrounded(x:Bool){
        _grounded = x;
    }

    override public function update(elapsed:Float){
        
        acceleration.x = 0;
        acceleration.y = _weight;
        
        if(FlxG.keys.anyPressed([LEFT, A])){
            acceleration.x = -maxVelocity.x * 7;
        }
        
        if (FlxG.keys.anyPressed([RIGHT, D])){
			acceleration.x = maxVelocity.x * 7;
		}
        
        if (FlxG.keys.anyPressed([SPACE, W, UP]) && isTouching(FlxObject.FLOOR)){
            velocity.y = -_jumpForce;
        }else if(
            FlxG.keys.anyPressed([SPACE, W, UP]) && 
            floatyPower > 0 &&
            velocity.y > 0) // is moving down?
            {
                _weight = 50;
                floatyPower -= 1;
        }else{
            _weight = 200;
        }

        if(isTouching(FlxObject.FLOOR)){ // magic
            floatyPower = 100;
        }

        super.update(elapsed);
    }
}
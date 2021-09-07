package npcs;

import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.FlxSprite;

class NPC extends FlxSprite {
    var _random:FlxRandom;
    var _painSound01:FlxSound;
    var _painSound02:FlxSound;
    var _painSound03:FlxSound;
    var _painSounds:Array<FlxSound>;
    var _currentAction:Int;
    var _newAction:Bool;
    var _canJump:Bool;
    var _weight:Float = 300;
    var _touchingFloor:Bool; // debugging only


    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        _newAction = true;
        _canJump = true;

        _random = new FlxRandom();

        maxVelocity.set(60, 200);
        acceleration.y = _weight;
        drag.x = maxVelocity.x * 5;
    }

    override public function update(elapsed:Float){
        physics();
        
        if(alive){
            decideAction();
            doAction();
        }

        _touchingFloor = isTouching(FlxObject.FLOOR);
        super.update(elapsed);
    }

    function physics(){
        acceleration.y = _weight;
    }

    function decideAction(){
        if(_newAction){
            _newAction = false;
            new FlxTimer().start(_random.float(0,3), newAction, 1); // random float between 0 and 3 amount of seconds before choosing next action to take
            _currentAction = _random.int(0,2);
        }
    }

    function newAction(timer:FlxTimer){
        _newAction = true;
    }

    function doAction(){
        switch(_currentAction){
            case 0:
                animation.play("walk");
                acceleration.x = -60; // walk left
                flipX = true;
                if(isTouching(FlxObject.WALL) && isTouching(FlxObject.FLOOR)){
                    jump();
                }
                return;
            case 1:
                animation.play("walk");
                acceleration.x = 60; // walk right 
                flipX = false;
                if(isTouching(FlxObject.WALL) && isTouching(FlxObject.FLOOR)){
                    jump();
                }
                return;
            case 2:
                acceleration.x = 0;
                animation.play("idle");
                return; // stand still for a bit
        }
    }

    function jump(){
        velocity.y = -100;
    }

    public function getStabbed(){
        if(health > 0){
            animation.play("stabbed");
            switch(_random.int(0, _painSounds.length - 1)){
                case 0:
                    _painSound01.play(true);
                case 1:
                    _painSound02.play(true);
                case 2:
                    _painSound03.play(true);
            }
            
            die();
        }
    }

    function die(){
        alive = false;
        acceleration.x = 0;
        health = 0;

        new FlxTimer().start(3, finalDeath);
    }

    function finalDeath(obj:FlxTimer){
        kill();// 死ね

        //TODO: fade-out animation maybe?
    }
}
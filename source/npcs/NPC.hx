package npcs;

/*
I've no more fucks to give
my fucks have all dissolved
I plan many projects but my fucks won't be involved
I've no more fucks to give
my fucks have all been  spent
they've fucked off from the building and I don't know where they went
*/

import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxSprite;

class NPC extends FlxSprite {
    var _random:FlxRandom;
    var _painSound01:FlxSound;
    var _painSound02:FlxSound;
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
        health = 10;

        loadGraphic("assets/images/NPCs/NPC1.png", true, 32, 32);
        setSize(16, 32);
        offset.set(8, 0);

        maxVelocity.set(60, 200);
        acceleration.y = _weight;
        drag.x = maxVelocity.x * 5;
        
        _painSound01 = FlxG.sound.load("assets/sounds/Flapstick_pain_grunts/FS_pain_01.wav");
        _painSound01.volume = FlxG.sound.volume;
        _painSound02 = FlxG.sound.load("assets/sounds/Flapstick_pain_grunts/FS_pain_02.wav");
        _painSound02.volume = FlxG.sound.volume;

        _painSounds = [_painSound01, _painSound02];

        animation.add("idle", [0]);
        animation.add("stabbed", [1,2,3,4], 4, false);
        FlxG.watch.add(this, "_touchingFloor");
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
            _currentAction = _random.int(0,1);
        }
    }

    function newAction(timer:FlxTimer){
        _newAction = true;
    }

    function doAction(){
        switch(_currentAction){
            case 0:
                acceleration.x = -60;
                flipX = true;
                if(isTouching(FlxObject.WALL) && isTouching(FlxObject.FLOOR)){
                    jump();
                }
                return;
            case 1:
                acceleration.x = 60;
                flipX = false;
                if(isTouching(FlxObject.WALL) && isTouching(FlxObject.FLOOR)){
                    jump();
                }
                return;
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
            }
            
            die();
        }
    }

    function die(){
        alive = false;
        acceleration.x = 0;
        health = 0;
    }
}
package npcs;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.FlxSprite;

enum State{ // gonna declare this new state enum so I can tell the code when the NPC is supposed to be idle, and if it's not idle it will have behaviour to follow in child classes
    IDLE;
    TRIGGERED;
}

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
    var _state(default, null):State;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        _state = IDLE;

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
            if(_state == IDLE){
                decideAction();
                doAction();
            }else if(_state == TRIGGERED){
                triggered();
            }
        }   
        _touchingFloor = isTouching(FlxObject.FLOOR);
        super.update(elapsed);
    }

    function triggered(){
        //override this in child classes
        // peds are gonna run away, cops are gonna shoot the player
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
            // TODO: this exists because the sounds don't
            for(sound in _painSounds){
                if(sound == null){
                    die();
                    return; // don't play sounds that don't exist
                }
            }
            
            _painSounds[_random.int(0, _painSounds.length - 1)].play(true);
            /*switch(_random.int(0, _painSounds.length - 1)){
                case 0:
                    _painSound01.play(true);
                case 1:
                    _painSound02.play(true);
                case 2:
                    _painSound03.play(true);
            }*/
            
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

    /*
        Whenever a new NPC type is being declared, this function should be called
        kinda towards the end of new(). Basically it assigns the hitbox, the volumes,
        animations, all the stuff that NPCs should just globally have.
    */
    function init(){
        setSize(16, 24);
        offset.set(8, 8);

        _painSounds = [_painSound01, _painSound02, _painSound03];

        for(sound in _painSounds){
            if(sound != null){ // TODO: this is only here because I don't have death sounds for the cops yet
                sound.volume = FlxG.sound.volume;
            }
        }

        animation.add("idle", [0]);
        animation.add("stabbed", [1,2,3,4], 4, false);
        animation.add("walk", [8,9,10,11,12,13,14,15], 8, true);
    }
}
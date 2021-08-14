package npcs;

import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxSprite;

class NPC extends FlxSprite {
    var _randomSounds:FlxRandom;
    var _painSound01:FlxSound;
    var _painSound02:FlxSound;
    var _painSounds:Array<FlxSound>;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        _randomSounds = new FlxRandom();
        health = 10;

        loadGraphic("assets/images/NPCs/NPC1.png", true, 32, 32);

        maxVelocity.set(160, 200);
        drag.x = maxVelocity.x * 5;
        
        _painSound01 = FlxG.sound.load("assets/sounds/Flapstick_pain_grunts/FS_pain_01.wav");
        _painSound02 = FlxG.sound.load("assets/sounds/Flapstick_pain_grunts/FS_pain_02.wav");

        _painSounds = [_painSound01, _painSound02];

        animation.add("idle", [0]);
        animation.add("stabbed", [1,2,3,4], 4, false);
    }

    public function getStabbed(){
        if(health > 0){
            animation.play("stabbed");
            switch(_randomSounds.int(0, _painSounds.length - 1)){
                case 0:
                    _painSound01.play(true);
                case 1:
                    _painSound02.play(true);
            }
            
            die();
        }
    }

    function die(){
        health = 0;
    }
}
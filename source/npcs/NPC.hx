package npcs;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxSprite;

class NPC extends FlxSprite {
    var _painSound:FlxSound;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        health = 10;

        loadGraphic("assets/images/NPCs/NPC1.png", true, 32, 32);

        maxVelocity.set(160, 200);
        drag.x = maxVelocity.x * 5;
        
        _painSound = FlxG.sound.load("assets/sounds/Flapstick_pain_grunts/FS_pain_01.wav");

        animation.add("idle", [0]);
        animation.add("stabbed", [1,2,3,4], 4, false);
    }

    public function getStabbed(){
        if(health > 0){
            animation.play("stabbed");
            _painSound.play(true);
            die();
        }
    }

    function die(){
        health = 0;
    }
}
package npcs;

import flixel.FlxSprite;

class Pedestrian extends FlxSprite {
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic("assets/images/NPCs/NPC1.png", true, 32, 32);

        maxVelocity.set(160, 200);
        drag.x = maxVelocity.x * 5;

        animation.add("idle", [0]);
        animation.add("stabbed", [1,2,3,4], 4, false);
    }

    public function getStabbed(){
        animation.play("stabbed");
    }
}
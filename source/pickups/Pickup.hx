package pickups;

import flixel.FlxSprite;

class Pickup extends FlxSprite {

    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);
    }

    public function get(player:Player){
        player.updateHUD();
    }
}
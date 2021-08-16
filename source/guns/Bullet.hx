package guns;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Bullet extends FlxSprite{
    public function new(){
        super();
        makeGraphic(4, 4, FlxColor.WHITE);
    }

    public function shoot(x:Float, y:Float, v:Float){
        super.x = x;
        super.y = y;
        velocity.x = v;
    }
}
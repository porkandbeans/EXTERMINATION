package guns;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Bullet extends FlxSprite{
    public function new(){
        super();
        //makeGraphic(4, 4, FlxColor.WHITE);
        loadGraphic("assets/images/misc/bullet.png", false, 4, 4);
    }

    public function shoot(_x:Float, _y:Float, _v:Float){
        super.x = _x;
        super.y = _y;
        velocity.x = _v;
    }
}
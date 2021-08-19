package pickups;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Pickup extends FlxSprite {

    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);
        tweenDown(null);
    }

    public function get(player:Player){
        player.updateHUD();
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
    }

    function tweenUp(_){
        FlxTween.tween(this, {y: y - 4}, 0.66, {ease: FlxEase.linear, onComplete: tweenDown});
    }

    function tweenDown(_){
        FlxTween.tween(this, {y: y + 4}, 0.66, {ease: FlxEase.linear, onComplete: tweenUp});
    }
}
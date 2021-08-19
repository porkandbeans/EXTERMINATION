package pickups.ammo;

import flixel.util.FlxColor;

class RifleAmmo extends Pickup{
    override public function new(x:Float = 0,y:Float = 0){
        super(x,y);
        loadGraphic("assets/images/pickups/rifleammo.png", false, 16, 16);
        //makeGraphic(8, 8, FlxColor.YELLOW);
    }

    override public function get(player:Player){
        super.get(player);

        if(player.rifle.ammo >= player.rifle.getMaxAmmo()){
            return;
        }
        player.rifleRestock(4);
        kill();
    }
}
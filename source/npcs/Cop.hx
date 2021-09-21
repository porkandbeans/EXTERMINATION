package npcs;

import guns.Pistol;

class Cop extends NPC{
    public var pistol:Pistol;
    
    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);

        pistol.initBullets(10);

        loadGraphic("assets/images/NPCs/cop.png", true, 32, 32);
        
        init();
    }

    override public function triggered(){
        // stand still and shoot at the player's direction
        acceleration.x = 0;
        animation.play("idle");
        if(_playerPos.x > x){
            flipX = false;
        }else{
            flipX = true;
        }
        super.triggered();
    }
}
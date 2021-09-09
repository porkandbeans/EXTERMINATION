package npcs;

import flixel.FlxG;

enum PedType{
    FLAPSTICK;
    GOOAYGAR; // my voice actors
}

class Ped01 extends NPC{

    var _type(default, null):PedType; // copying my homework, idk why it takes default and null
    var _xy:Int; // like an X or Y chromosome

    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);
        health = 10; // this is still here for some reason
        
        // determines which version of the pedestrian will spawn
        genderAssign();

        // load sounds from directory
        sounds();
        
        // perform all the necessary stuff to make this NPC a walking, dying, thingamajigger
        init();
    }

    // assigns type specifics
    public function chromosome(type:PedType){
        _type = type;
        if(type == FLAPSTICK){
            loadGraphic("assets/images/NPCs/NPC1.png", true, 32, 32);
        }else if(type == GOOAYGAR){
            loadGraphic("assets/images/NPCs/NPC2.png", true, 32, 32);
        }
    }

    // determines which type of pedestrian this will spawn as
    function genderAssign(){
        _xy = _random.int(0, 1);
        switch(_xy){
            case 0:
                chromosome(FLAPSTICK);
            case 1:
                chromosome(GOOAYGAR);
        }
    }

    function sounds(){
        if(_type == FLAPSTICK){
            _painSound01 = FlxG.sound.load("assets/sounds/NPC_deaths/FlapStick/FS_pain_01.wav");
            _painSound02 = FlxG.sound.load("assets/sounds/NPC_deaths/FlapStick/FS_pain_02.wav");
            _painSound03 = FlxG.sound.load("assets/sounds/NPC_deaths/FlapStick/FS_pain_03.wav");
        }else if(_type == GOOAYGAR){
            _painSound01 = FlxG.sound.load("assets/sounds/NPC_deaths/Gooaygar/goo_death_01.wav");
            _painSound02 = FlxG.sound.load("assets/sounds/NPC_deaths/Gooaygar/goo_death_02.wav");
            if(_random.int(0,30) == 1){
                _painSound03 = FlxG.sound.load("assets/sounds/NPC_deaths/Gooaygar/dies.wav");
            }else{
                _painSound03 = FlxG.sound.load("assets/sounds/NPC_deaths/Gooaygar/goo_death_03.wav");
            }
        }
    }
}
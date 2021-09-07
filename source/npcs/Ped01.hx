package npcs;

import flixel.FlxG;

enum PedType{
    FLAPSTICK;
    GOOAYGAR;
}

class Ped01 extends NPC{

    var _type(default, null):PedType; // copying my homework, idk why it takes default and null
    var _xy:Int; // like an X or Y chromosome

    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);
        health = 10;
        
        genderAssign();

        setSize(16, 24);
        offset.set(8, 8);

        sounds();
        _painSound01.volume = FlxG.sound.volume;
        _painSound02.volume = FlxG.sound.volume;
        _painSound03.volume = FlxG.sound.volume;

        _painSounds = [_painSound01, _painSound02, _painSound03];

        animation.add("idle", [0]);
        animation.add("stabbed", [1,2,3,4], 4, false);
        animation.add("walk", [8,9,10,11,12,13,14,15], 8, true);
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
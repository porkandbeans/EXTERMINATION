package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
    var _playButton:FlxButton;
    var _menuMusic:FlxSound;

	override public function create()
	{
        FlxG.autoPause = true;
        _playButton = new FlxButton(0,0,"poo poo", clickPlay);
        _playButton.screenCenter();
        add(_playButton);

        _menuMusic = FlxG.sound.load(
            "assets/music/menu.mp3", 
            1, // volume
            true, // looped
            null, // group 
            false//, // destroy when finished
            //true); // autoplay
        );

        FlxG.sound.music = _menuMusic;
        FlxG.sound.music.play();

		super.create();
	}

    function clickPlay(){
        FlxG.sound.music.pause();
        FlxG.switchState(new PlayState());
    }
}
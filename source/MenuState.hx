package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIButton;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.util.FlxSave;

class MenuState extends FlxState
{
	var _musicVolume:Int;
	var _gameVolume:Int;
	var _mainMenu:FlxTypedGroup<FlxUIButton>;
	var _startButton:FlxUIButton;
	var _newgameButton:FlxUIButton;
	var _optionsButton:FlxUIButton;
	var _continueButton:FlxUIButton;
	var _levelsButton:FlxUIButton;

	var _optionsMenu:FlxGroup;
	var _optionsCloseButton:FlxUIButton;
	var _volumeText:FlxUIButton;
	var _volUpButton:FlxUIButton;
	var _volDownButton:FlxUIButton;
	var _fullscreenButton:FlxUIButton;

	var _menuMusic:FlxSound;

	var _screenWidth:Float;
	var _screenHeight:Float;
	var _buttonWidth:Float;

	var save:FlxSave;

	override public function create()
	{
		_screenWidth = FlxG.width;
		_screenHeight = FlxG.height;

		_buttonWidth = _screenWidth - 200;

		FlxG.autoPause = true;
		_startButton = new FlxUIButton(0, 0, "begin", clickPlay);
		_startButton.screenCenter();
		add(_startButton);

		_newgameButton = new FlxUIButton(_buttonWidth, 0, "New Game", newGame);
		add(_newgameButton);
		_continueButton = new FlxUIButton(_buttonWidth, 60, "Continue", continueGame);
		add(_continueButton);
		_levelsButton = new FlxUIButton(_buttonWidth, 120, "Level Select", levelsMenu);
		add(_levelsButton);
		_optionsButton = new FlxUIButton(_buttonWidth, 180, "Options", optionsMenu);
		add(_optionsButton);

		_mainMenu = new FlxTypedGroup<FlxUIButton>();
		_mainMenu.add(_newgameButton);
		_mainMenu.add(_continueButton);
		_mainMenu.add(_levelsButton);
		_mainMenu.add(_optionsButton);
		_mainMenu.forEach(loadButtonGraphic);

		_optionsCloseButton = new FlxUIButton(0, FlxG.height / 2, "Back", closeOptions);
		add(_optionsCloseButton);
		_volUpButton = new FlxUIButton(_buttonWidth, 90, '+', volumeUp);
		add(_volUpButton);
		_volDownButton = new FlxUIButton(_buttonWidth - 80, 90, '-', volumeDown);
		add(_volDownButton);
		_fullscreenButton = new FlxUIButton(_buttonWidth, 180, "Fullscreen", fullscreenToggle);
		add(_fullscreenButton);

		_optionsMenu = new FlxGroup();
		_optionsMenu.add(_optionsCloseButton);
		_optionsMenu.add(_volUpButton);
		_optionsMenu.add(_volDownButton);
		_optionsMenu.add(_fullscreenButton);

		_mainMenu.forEach(hideButton);
		_optionsMenu.forEach(hideButton);

		_menuMusic = FlxG.sound.load("assets/music/menu.mp3", 1, // volume
			true, // looped
			null, // group
			false // , // destroy when finished
			// true); // autoplay
		);

		FlxG.sound.music = _menuMusic;
		FlxG.sound.music.play();

		save = new FlxSave();
		save.bind("exterminationVolumes");

		FlxG.sound.music.volume = save.data.musicVolume;

		super.create();
	}

	// called in a loop
	function hideButton(button:FlxBasic)
	{
		button.visible = false;
	}

	// called in a loop
	function showButton(button:FlxBasic)
	{
		button.visible = true;
	}

	// displays the main menu
	function clickPlay()
	{
		_startButton.visible = false;
		_mainMenu.forEach(showButton);
	}

	// switches to PlayState.hx
	function newGame()
	{
		save.close();
		FlxG.sound.music.pause();
		FlxG.switchState(new PlayState());
	}

	// hides main menu and displays the options menu
	function optionsMenu()
	{
		_mainMenu.forEach(hideButton);
		_optionsMenu.forEach(showButton);
	}

	// hides options menu and displays the main menu
	function closeOptions()
	{
		_optionsMenu.forEach(hideButton);
		_mainMenu.forEach(showButton);
	}

	function continueGame()
	{
		// this doesn't do anything right now
	}

	function levelsMenu()
	{
		// this doesn't do anything right now
	}

	function volumeUp()
	{
		FlxG.sound.music.volume += 0.1;
		save.data.musicVolume = FlxG.sound.music.volume;
	}

	function volumeDown()
	{
		FlxG.sound.music.volume -= 0.1;
		save.data.musicVolume = FlxG.sound.music.volume;
	}

	// assigns the graphic to use for the menu buttons
	function loadButtonGraphic(button:FlxUIButton)
	{
		button.loadGraphic("assets/images/ui/bloodbutton.png");
		/*button.setSize(110, 58);
			button.setLabel(new FlxUIText(
				50, 10, 100, button.label.text
			)); */

		button.label.offset.set(25, -25);
		// button.label.setBorderStyle(OUTLINE,FlxColor.TRANSPARENT,40);

		// button.getLabel().y += 10;

		/*button.setLabel(new FlxUIText(
				50, 
				50,
				button.getLabel().width,
				button.getLabel().text)
			); */
	}

	function fullscreenToggle()
	{
		FlxG.fullscreen = !FlxG.fullscreen;
	}
}

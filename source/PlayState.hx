package;

import guns.Bullet;
import npcs.NPC;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var _map:FlxOgmo3Loader;
	var _tilemap:FlxTilemap;
	var _player:Player;
	var _hud:HUD;
	var _backdrop:FlxBackdrop;
	var _npcs:FlxTypedGroup<NPC>;
	var _pistolBullets:FlxTypedGroup<Bullet>;
	
	override public function create()
	{
		_backdrop = new FlxBackdrop("assets/images/Backgrounds/backdrop.png", 0.5, 0.5, true, 0, 0);
		add(_backdrop);

		

		_map = new FlxOgmo3Loader(
			"assets/levels/hworld.ogmo", 
			"assets/levels/NewLevel0.json");
		_tilemap = _map.loadTilemap("assets/data/tilewall.png", "walls");
		_tilemap.follow();
		_tilemap.setTileProperties(1, FlxObject.NONE);
		_tilemap.setTileProperties(2, FlxObject.ANY);
		add(_tilemap);
		_npcs = new FlxTypedGroup<NPC>();
		add(_npcs);
		_player = new Player();
		_map.loadEntities(placeEntities, "entities");
		_player.declarePeds(_npcs);
		add(_player);

		_pistolBullets = new FlxTypedGroup<Bullet>(20);
		_player.declarePistolBullets(_pistolBullets);
		add(_pistolBullets);
		
		_hud = new HUD();
		add(_hud);

		super.create();
	}

	function placeEntities(entity:EntityData){
		switch(entity.name){
			case "player":
				_player.setPosition(entity.x, entity.y);
			case "NPC":
				_npcs.add(new NPC(entity.x - 16, entity.y -16));
		}
	}

	override public function update(elapsed:Float){
		collisions();
		FlxG.camera.follow(_player, PLATFORMER, 1);
		_hud.updateGun(_player.current_weapon);
		super.update(elapsed);
	}

	function collisions(){
		FlxG.collide(_tilemap, _player);
		FlxG.collide(_npcs, _tilemap);
	}
}

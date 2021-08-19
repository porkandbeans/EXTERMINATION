package;

import pickups.ammo.RifleAmmo;
import pickups.Pickup;
import pickups.ammo.PistolAmmo;
import flixel.group.FlxGroup;
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
	// === PRIVATE VARS ===
	var _map:FlxOgmo3Loader;
	var _tilemap:FlxTilemap;
	var _player:Player;
	var _hud:HUD;
	var _backdrop:FlxBackdrop;
	var _npcs:FlxTypedGroup<NPC>;
	var _pistolBullets:FlxTypedGroup<Bullet>;
	var _rifleBullets:FlxTypedGroup<Bullet>;
	
	// pickups
	var _pistolAmmo:FlxTypedGroup<PistolAmmo>;
	var _rifleAmmo:FlxTypedGroup<RifleAmmo>;

	// helper groups
	var _objects:FlxGroup;
	var _pickups:FlxGroup;
	
	override public function create()
	{
		// set the background image
		_backdrop = new FlxBackdrop(
			"assets/images/Backgrounds/backdrop.png", 
			0.5, 0.5, true, 0, 0);

		// load the level data
		_map = new FlxOgmo3Loader(
			"assets/levels/hworld.ogmo", 
			"assets/levels/NewLevel0.json");
		_tilemap = _map.loadTilemap("assets/data/tilewall.png", "walls");
		_tilemap.follow();

		// declare which blocks are solid and collide with stuff
		_tilemap.setTileProperties(1, FlxObject.NONE);
		_tilemap.setTileProperties(2, FlxObject.ANY);
		
		_npcs = new FlxTypedGroup<NPC>();
		
		_player = new Player();
		
		_player.declarePeds(_npcs);
		
		_pistolBullets = new FlxTypedGroup<Bullet>(20);
		_rifleBullets = new FlxTypedGroup<Bullet>(12);
		_player.declareBullets(_pistolBullets, _rifleBullets);
		
		_pistolAmmo = new FlxTypedGroup<PistolAmmo>();
		_rifleAmmo = new FlxTypedGroup<RifleAmmo>();
		
		_hud = new HUD();
		_player.hud = _hud;
		_player.updateHUD();

		_objects = new FlxGroup();
		_objects.add(_player);
		_objects.add(_pistolBullets);
		_objects.add(_rifleBullets);
		_objects.add(_tilemap);
		_objects.add(_npcs);

		_pickups = new FlxGroup();
		_pickups.add(_pistolAmmo);
		_pickups.add(_rifleAmmo);

		_map.loadEntities(placeEntities, "entities");
		add(_backdrop);
		add(_tilemap);
		add(_npcs);
		add(_player);
		add(_pistolBullets);
		add(_rifleBullets);
		add(_hud);
		add(_pistolAmmo);
		add(_rifleAmmo);
		super.create();
	}

	function placeEntities(entity:EntityData){
		switch(entity.name){
			case "player":
				_player.setPosition(entity.x, entity.y);
			case "NPC":
				_npcs.add(new NPC(entity.x - 16, entity.y -16));
			case "pistolammo":
				_pistolAmmo.add(new PistolAmmo(entity.x, entity.y - 4));
			case "rifleammo":
				_rifleAmmo.add(new RifleAmmo(entity.x, entity.y - 4));
		}
	}

	override public function update(elapsed:Float){
		collisions();
		FlxG.camera.follow(_player, PLATFORMER, 1);
		super.update(elapsed);
	}

	function collisions(){
		//FlxG.collide(_tilemap, _player);
		FlxG.collide(_objects, _tilemap, objectCollide);
		FlxG.overlap(_npcs, _pistolBullets, npcShot);
		FlxG.overlap(_npcs, _rifleBullets, riflenpcShot);
		FlxG.overlap(_player, _pickups, pickupItem);
	}

	// callback when NPCs are shot
	function npcShot(sprite1:NPC, sprite2:FlxObject){
		if(sprite1.health > 0){
			sprite2.kill();
			sprite1.getStabbed();
		}
	}
	
	// unique callback for penetrating shots
	function riflenpcShot(sprite1:NPC, sprite2:Bullet){
		if(sprite1.health > 0){
			sprite1.getStabbed();
		}
	}

	function objectCollide(obj1:FlxObject, tmap:FlxTilemap){
		if(obj1 is Bullet){
			obj1.kill();
		}
	}

	function pickupItem(player:Player, item:Pickup){
		item.get(player);
		player.updateHUD();
	}
}

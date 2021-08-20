package;

import guns.Rifle;
import guns.Bullet;
import guns.Pistol;
import npcs.NPC;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	// === PRIVATE VARS ===
    var _jumpForce:Float = 80;
	var _jumpHold:Int;
    var _weight:Float = 300;
    var _grounded:Bool = true;
	var _canJump:Bool;
	var _canAttack:Bool;
	var _attacking:Bool;
	var _pedestrians:FlxTypedGroup<NPC>;
	var _heldWeapons:Array<Int>;
	
	// weapons
	var _wep_names:Array<String>;
	
	var _pBullets:FlxTypedGroup<Bullet>;
	var _rBullets:FlxTypedGroup<Bullet>;

	// === PUBLIC VARS ===
	public var hud:HUD;
	public var current_weapon:Int;
	public var pistol:Pistol;
	public var rifle:Rifle;
	public var hasRifle:Bool;
	public var hasPistol:Bool;

	// === CONSTANTS ===
	var MAX_JUMPHOLD = 20;
	var	MAX_WEAPONS:Int;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x,y);

		// === WEAPON DECLARATION STUFF ===
		_wep_names = ["none", "pistol", "rifle"];
		current_weapon = 0;
		MAX_WEAPONS = _wep_names.length - 1;
		_canAttack = true;
		_heldWeapons = [0]; // append to this with ints so it becomes [0, 1] and [0, 1, 2]
		hasRifle = false;

		// === PHYSICS STUFF ===
        maxVelocity.set(160, 200);
        acceleration.y = _weight;
        drag.x = maxVelocity.x * 5;
		_jumpHold = MAX_JUMPHOLD;

		loadGraphic("assets/images/Player/player.png", true, 32, 32);
		setSize(16, 32); // makes the hitbox better
		offset.set(8, 0);

		// === ANIMATIONS ===
		animation.add("idle", [0]);
		animation.add("run", [1,2,3,4,5,6,7,8], 9, true);
		animation.add("jump", [9,10], 4, false);
		animation.add("fall", [11,12], 9, true);
		animation.add("melee", [13,14,15], 12, false); 
		animation.add("idlePistol", [16]);
		animation.add("runPistol", [17, 18, 19, 20, 21, 22, 23, 24], 9, true);
    }

	public function declareBullets(pBulls:FlxTypedGroup<Bullet>, rBulls:FlxTypedGroup<Bullet>){
		_pBullets = pBulls;
		pistol = new Pistol(_pBullets);
		_rBullets = rBulls;
		rifle = new Rifle(_rBullets);
	}

	override public function update(elapsed:Float)
	{
		frameInit();
		keyListeners();
		animations();
		super.update(elapsed);
	}

	function frameInit(){
		if(isTouching(FlxObject.FLOOR)){
			_jumpHold = MAX_JUMPHOLD;
		}

		acceleration.x = 0;
        acceleration.y = _weight;
	}

	public function updateHUD(){
		switch (_heldWeapons[current_weapon]){
			case 0:
				hud.updateGun(_heldWeapons[current_weapon], 0);
				return;
			case 1:
				hud.updateGun(_heldWeapons[current_weapon], pistol.ammo);
				return;
			case 2:
				hud.updateGun(_heldWeapons[current_weapon], rifle.ammo);
				return;
		}
	}

	function keyListeners(){
		if(!_attacking){
			if (FlxG.keys.anyPressed([LEFT, A])){
				acceleration.x = -maxVelocity.x * 7;
			}

			if (FlxG.keys.anyPressed([RIGHT, D])){
				acceleration.x = maxVelocity.x * 7;
			}
			
			// fixes being able to spam jump while in the air
			if(FlxG.keys.anyJustReleased([SPACE, W, UP]) && !isTouching(FlxObject.FLOOR)){
				_canJump = false;
			}

			if(isTouching(FlxObject.FLOOR)){
				_canJump = true;
			}
	
			if (FlxG.keys.anyPressed([SPACE, W, UP]) && velocity.y <= 0 && _canJump){
				if(_jumpHold > 0){
					_jumpHold -= 1;
					velocity.y = -_jumpForce;
				}
			}

			if(FlxG.keys.pressed.ENTER && _canAttack){
				attack();
				updateHUD();
			}

			if(FlxG.keys.justPressed.RBRACKET){
				current_weapon++;
				cycleWeps();
				updateHUD();
			}
			
			if (FlxG.keys.justPressed.LBRACKET){
				current_weapon--;
				cycleWeps();
				updateHUD();
			}
		}
    }

	function cycleWeps(){
		if(current_weapon > _heldWeapons.length - 1){
			current_weapon = 0;
		}else if(current_weapon < 0){
			current_weapon = _heldWeapons.length - 1;
		}
	}

	function animations(){
		if(!_attacking){
			if(velocity.y == 0){
				if (velocity.x == 0){
					idle(); 
					//animation.play("idle");
				}
				else{
					run();
				}
			}else{
				if(velocity.y > -0.7){
					animation.play("fall");
				}else if(isTouching(FlxObject.FLOOR)){
					animation.play("jump");
				}
			}
		}

		if (FlxG.keys.anyPressed([LEFT, A])){
			flipX = true;
		}

		if (FlxG.keys.anyPressed([RIGHT, D])){
			flipX = false;
		}

		if(animation.curAnim == animation.getByName("melee") && animation.finished){
			_attacking = false;
		}
	}

	// === ANIMATION FUNCTIONS ===
	function idle(){
		switch(_heldWeapons[current_weapon]){
			case 0:
				animation.play("idle");
				return;
			case 1:
				animation.play("idlePistol");
				return;
			case 2:
				animation.play("idle");
				return;
		}
	}

	function run(){
		switch(_heldWeapons[current_weapon]){
			case 0:
				animation.play("run");
				return;
			case 1:
				animation.play("runPistol");
				return;
		}
	}

	function finishAttacking(timer:FlxTimer):Void {
		_canAttack = true;
	}

	function attack(){
		switch(_heldWeapons[current_weapon]){
			case 0:
				stab();
				return;
			case 1:
				pistol.shoot(getMidpoint().x, getMidpoint().y, flipX);
				updateHUD();
				return;
			case 2:
				rifle.shoot(getMidpoint().x, getMidpoint().y, flipX);
				updateHUD();
				return;
		}
	}

	function stab(){
		_attacking = true;
		_canAttack = false;
		animation.play("melee");
		new FlxTimer().start(0.5, finishAttacking, 1);
		FlxG.overlap(this, _pedestrians, pedGetStabbed);
	}

	public function declarePeds(peds:FlxTypedGroup<NPC>){
		_pedestrians = peds;
	}

	function pedGetStabbed(me:Player, ped:NPC){
		ped.getStabbed();
	}

	public function pistolRestock(qty:Int){
		pistol.ammo += qty;
		if(pistol.ammo > pistol.getMaxAmmo()){
			pistol.ammo = pistol.getMaxAmmo();
		}
	}

	public function rifleRestock(qty:Int){
		rifle.ammo += qty;
		if(rifle.ammo > rifle.getMaxAmmo()){
			rifle.ammo = rifle.getMaxAmmo();
		}
	}

	public function pickupRifle(){
		_heldWeapons = _heldWeapons.concat([2]);
		hasRifle = true;
	}

	public function pickupPistol(){
		_heldWeapons = _heldWeapons.concat([1]);
		hasPistol = true;
	}
}
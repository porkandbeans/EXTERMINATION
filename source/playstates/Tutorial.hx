package playstates;

import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import objects.Crate;
import objects.Levelgoal;
import playstates.tutorial_assets.Tutorial_goal;
import playstates.tutorial_assets.Tutorial_target;

class Tutorial extends PlayState
{
	var spawnPoint1:FlxPoint;
	var spawnPoint2:FlxPoint;
	var spawnPoint3:FlxPoint;
	var spawnPoint4:FlxPoint;
	var tut_goals:FlxTypedGroup<Tutorial_goal>;
	var tut_targets:FlxTypedGroup<Tutorial_target>;
	var melee_target:Tutorial_target;
	var pistol_target:Tutorial_target;
	var rifle_target:Tutorial_target;
	var _levelGoals:FlxTypedGroup<Levelgoal>; // triggers a new Playstate to load when the player overlaps this extended FlxSprite, lets keep these level-specific though

	override public function create()
	{
		tut_goals = new FlxTypedGroup<Tutorial_goal>();
		tut_targets = new FlxTypedGroup<Tutorial_target>();
		_levelGoals = new FlxTypedGroup<Levelgoal>();

		super.create();
		add(tut_goals);
		add(tut_targets);
		add(melee_target);
		add(pistol_target);
		add(rifle_target);
		add(_levelGoals);
		pistol_target.setPoint(spawnPoint3);
		rifle_target.setPoint(spawnPoint4);

		_hud.showDialogue(["This is the tutorial", "This is string 2 of tutorial dialogue"]);
		// add(_player);
		/**
			TODO:
				figure out how layers work
				and put that damn target behind the player
				idk what to do with this and I have no internet
				so I can't look it up
		**/
	}

	override public function placeEntities(entity:EntityData)
	{
		super.placeEntities(entity);
		switch (entity.name)
		{
			case "tutspawn1":
				spawnPoint1 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutspawn2":
				spawnPoint2 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutspawn3":
				spawnPoint3 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutspawn4":
				spawnPoint4 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutorial_goal":
				tut_goals.add(new Tutorial_goal(entity.x, entity.y));
				return;
			case "tutorial_target1":
				melee_target = new Tutorial_target(entity.x, entity.y);
				tut_targets.add(melee_target);
				return;
			case "tutorial_target2":
				pistol_target = new Tutorial_target(entity.x, entity.y);
				tut_targets.add(pistol_target);
				return;
			case "tutorial_target3":
				rifle_target = new Tutorial_target(entity.x, entity.y);
				tut_targets.add(rifle_target);
				return;
			case "level_goal":
				_levelGoals.add(new Levelgoal(entity.x, entity.y));
				return;

		}
	}

	override public function collisions()
	{
		super.collisions();
		FlxG.overlap(_player, tut_goals, advanceTut1);
		FlxG.overlap(_player.hitreg, tut_targets, breakTarget);
		FlxG.overlap(_bullets, tut_targets, advanceTut);
		FlxG.overlap(_player, _levelGoals, nextLevel);
	}

	function advanceTut1(obj:Dynamic, obj0:Dynamic) // I don't actually want the params
	{
		_player.x = spawnPoint1.x;
		_player.y = spawnPoint1.y - 16;
		new FlxTimer().start(0.1, (timer:FlxTimer) ->
		{
			_hud.showDialogue(["I am now testing", "this dialogue window", "hopefully it works!"]);
		});
		
	}

	function advanceTut(obj:Dynamic, targ:Tutorial_target)
	{
		_player.x = targ.advanceTutorial().x;
		_player.y = targ.advanceTutorial().y;
	}

	function breakTarget(obj:Dynamic, obj0:Dynamic)
	{
		_player.x = spawnPoint2.x;
		_player.y = spawnPoint2.y - 16;
	}
	function nextLevel(obj1:Player, obj2:Levelgoal)
	{
		FlxG.switchState(new PlayState("assets/levels/NewLevel1.json"));
	}
}
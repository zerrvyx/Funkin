package;

import editors.CharacterEditorState;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import editors.ChartingState;
import editors.DialogueCharacterEditorState;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = [ 
		//Made this (And the other menu option sets) vertical to better visualize how it will look in game.
		'Resume', 
		'Restart Song', 
		'Options',
		'Editors', 
		'Exit to menu'
	];
	var optionChoices:Array<String> = [
	    'Settings',	
	    'Change Difficulty',
		'Practice Mode',
		'Botplay'
	];
	var difficultyChoices = [
		'Easy', 
		'Normal', 
		'Hard', 
		/*'Crazy' 
		(Not allowing this yet cuz i haven't done many crazy charts and knowing me I'll accidentally hit this button like 
		a dumbass)*/
	];
	var quickSettings:Array<String> = [
		'Downscroll',
	    'Middlescroll',
	    'Ghost Tapping',
	    'Info Bar Bounces', 
	    'Max Optimization',
		'Dad Notes Do Damage'
	];
	var editors:Array<String> = [
		'Chart Editor', 
		'Character Editor'
	];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var botplayText:FlxText;

	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();
		menuItems = menuItemsOG;

		/*for (i in 0...CoolUtil.difficultyStuff.length) {
				var diff:String = '' + CoolUtil.difficultyStuff[i][0];
				difficultyChoices.push(diff);
			}
		difficultyChoices.push('BACK');*/
		// this caused Linux crashes if you're wondering

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var ControlInfo:FlxText = new FlxText();

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var deathTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		deathTxt.text = "DEATH COUNT: " + PlayState.deathCounter;
		// Changed Blueballed to Death Count so it can apply to any character.
		deathTxt.scrollFactor.set();
		deathTxt.setFormat(Paths.font('vcr.ttf'), 32);
		deathTxt.updateHitbox();
		add(deathTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.practiceMode;
		add(practiceText);

		botplayText = new FlxText(20, FlxG.height - 572, 0, "BOTPLAY", 32);
		// Changed the location of this cuz I thought it was weird for it to be on the bottom.
		botplayText.scrollFactor.set();
		botplayText.setFormat(Paths.font('vcr.ttf'), 32);
		botplayText.x = FlxG.width - (botplayText.width + 20);
		botplayText.updateHitbox();
		botplayText.visible = PlayState.cpuControlled;
		add(botplayText);

		deathTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		deathTxt.x = FlxG.width - (deathTxt.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(deathTxt, {alpha: 1, y: deathTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var back = controls.BACK;
		var scroll; /*Come back to it later. Trying to allow scrolling for menu navigation.
		Seems like it's a bit unnesscessary tbh- Given that it's the pause menu. idk I'll think about it more.*/ 
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (back)
        {
		menuItems = menuItemsOG;
		regenMenu();
		}
		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			for (i in 0...difficultyChoices.length-1) {
				if(difficultyChoices[i] == daSelected) {
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.cpuControlled = false;
					return;
				}
			}

			switch (daSelected)
			{
				case 'Resume':
					close();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				case 'Practice Mode':
					PlayState.practiceMode = !PlayState.practiceMode;
					PlayState.usedPractice = true;
					practiceText.visible = PlayState.practiceMode;
				case 'Restart Song':
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
				case 'Botplay':
					PlayState.cpuControlled = !PlayState.cpuControlled;
					PlayState.usedPractice = true;
					botplayText.visible = PlayState.cpuControlled;
				case 'Options':
					menuItems = optionChoices;
					regenMenu();
				case 'Editors':
				    menuItems = editors;
					regenMenu();
				case 'Settings':
					menuItems = quickSettings;
					regenMenu();
				case 'Middlescroll':
					ClientPrefs.middleScroll = !ClientPrefs.middleScroll;
					MusicBeatState.switchState(new PlayState());
				case 'Downscroll':
					ClientPrefs.downScroll = !ClientPrefs.downScroll;
					MusicBeatState.switchState(new PlayState());
				case 'Ghost Tapping':
					ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;
					MusicBeatState.switchState(new PlayState());
				case 'Info Bar Bounces':
					ClientPrefs.infoBarBounces = !ClientPrefs.infoBarBounces;
					MusicBeatState.switchState(new PlayState());
				case 'Max Optimization':
					ClientPrefs.maxOptimization = !ClientPrefs.maxOptimization;
					MusicBeatState.switchState(new PlayState());
				case 'Dad Notes Do Damage':
					ClientPrefs.dadNotesDoDamage = !ClientPrefs.dadNotesDoDamage;
					MusicBeatState.switchState(new PlayState());
				case 'Chart Editor':
				    MusicBeatState.switchState(new ChartingState());
				case 'Character Editor':
					MusicBeatState.switchState(new CharacterEditorState());
				case 'Exit to menu':
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					CustomFadeTransition.nextCamera = transCamera;
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.usedPractice = false;
					PlayState.changedDifficulty = false;
					PlayState.cpuControlled = false;
				case 'Easy':
					PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + "-easy", PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = 0;

					FlxG.switchState(new PlayState());
				case 'Normal':
					PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase(), PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = 1;

					FlxG.switchState(new PlayState());
				case 'Hard':
					PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + "-hard", PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = 2;
				case 'Crazy':
					PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + "-crazy", PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = 3;
                    FlxG.switchState(new PlayState());
			}
			var daText:String = '';
			switch(menuItemsOG[curSelected]) {
				case 'Resume':
				daText = "Resume the song from the current point.";
				case 'Restart':
				daText = "Restart the song from the beginning.";
				case 'Options':
				daText = "See various things you can change or toggle.";
				case 'Editors':
				daText = "View editors that you can use to chart and make custom characters!";
			}
			var descText:FlxText;
			descText = new FlxText(50, 600, 1180, "", 32);
			descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			descText.scrollFactor.set();
			descText.borderSize = 2.4;
			descText.text = daText;
			//add(descText); Doesn't work properly ;-;
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
		}
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
	}
}

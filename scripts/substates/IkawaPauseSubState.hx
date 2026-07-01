import funkin.visuals.objects.Alphabet;

@:typedef JsonPause = {
	var cameraOffset:Point;
	var optionsSpacing:Point;
	var cameraSpeed:Float;
	var infoCorner:String;
};

final config:JsonPause = Paths.json('data/menus/pause');
final play:PlayState = PlayState.instance;

var options:FlxTypedGroup<Alphabet>;
var timeText:FlxText;
var selInt:Int = 0;

function postCreate()
{
	final bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	bg.scrollFactor.set();
	bg.alpha = 0;
	add(bg);

	FlxTween.tween(bg, {alpha: 0.5}, 0.5, {ease: FlxEase.cubeOut});

	add(options = new FlxTypedGroup<Alphabet>());

	for (index => opt in ['resume', 'restart', 'exit'])
	{
		final text:Alphabet = new Alphabet(0, 0, opt);
		options.add(text);

		FlxTween.tween(text, {x: index * config.optionsSpacing.x, y: index * config.optionsSpacing.y}, config.cameraSpeed, {ease: FlxEase.cubeOut});
	}

	for (index => txt in ['Song: ' + play.song, 'Difficulty: ' + play.difficulty, play.type == 'story' ? 'Story Mode' : 'Freeplay'])
	{
		final text:FlxText = new FlxText(FlxG.width, 10 + 30 * index, 0, txt, 30);
		text.font = Paths.font('vcr.ttf');
		text.camera = subCamera;
		text.scrollFactor.set();
		text.alpha = 0;

		add(text);

		FlxTween.tween(text, {x: FlxG.width - 19 - text.width, alpha: 1}, 0.5, {ease: FlxEase.cubeOut, startDelay: index * 0.1});
	}

	timeText = new FlxText(FlxG.width, 100, 0, '', 30);
	timeText.font = Paths.font('vcr.ttf');
	timeText.camera = subCamera;
	timeText.scrollFactor.set();
	timeText.alpha = 0;
	add(timeText);
	updateTimeText();
	FlxTween.tween(timeText, {x: FlxG.width - 19 - timeText.width, alpha: 1}, 0.5, {ease: FlxEase.cubeOut, startDelay: 0.3});

	for (obj in members)
		obj.camera = subCamera;

	changeOption();
}

function formatTime(ms:Float):String
{
	final totalSeconds:Int = Math.max(0, Math.floor(ms / 1000));
	final minutes:Int = Math.floor(totalSeconds / 60);
	final seconds:Int = totalSeconds % 60;

	return StringTools.lpad(Std.string(minutes), '0', 2) + ':' + StringTools.lpad(Std.string(seconds), '0', 2);
}

function updateTimeText()
{
	final current:Float = Math.max(0, Conductor.songPosition);
	final total:Float = Conductor.music != null ? Conductor.music.length : current;

	timeText.text = formatTime(current) + ' / ' + formatTime(total);
	timeText.x = FlxG.width - 19 - timeText.width;
}

function changeOption(?change:Int = 0)
{
	selInt += change;

	if (selInt < 0)
		selInt = options.members.length - 1;

	if (selInt > options.members.length - 1)
		selInt = 0;

	for (index => opt in options)
		opt.alpha = selInt == index ? 1 : 0.5;
}

function onUpdate(elapsed:Float)
{
	updateTimeText();

	subCamera.scroll.x = CoolUtil.fpsLerp(subCamera.scroll.x, selInt * config.optionsSpacing.x + config.cameraOffset.x, config.cameraSpeed);
	subCamera.scroll.y = CoolUtil.fpsLerp(subCamera.scroll.y, selInt * config.optionsSpacing.y + config.cameraOffset.y, config.cameraSpeed);

	if (Controls.UI_DOWN_P || Controls.UI_UP_P)
	{
		changeOption(Controls.UI_DOWN_P ? 1 : -1);
		CoolUtil.playSound('scroll');
	}

	if (Controls.ACCEPT)
	{
		switch (options.members[selInt].text)
		{
			case 'restart':
				play.restart();

			case 'exit':
				play.exit();

			default:
				play.resume();
		}

		close();
	}
}

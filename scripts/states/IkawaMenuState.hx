import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.group.FlxTypedSpriteGroup;

using StringTools;

var buildingBlur:FlxSprite;
var pole:FlxSprite;
var yukira:FlxSprite;

var menuGroup:FlxTypedSpriteGroup<FlxText>;

var selectedSomething:Bool = false;
var cameraTime:Float = 0;
var resetX:Float = -3000;

function onCreate()
{
    if (Conductor.music == null)
        Conductor.play(Paths.music('ikawaMenu'), 122, 4, 4);

    FlxG.mouse.visible = true;

    addTitleSprite('sky', -100, -100, 0.2, 1);

    addTitleSprite('clouds', 100, -170, 0.2, 1);
    addTitleSprite('mountain', 800, 230, 0.3, 0.5);
    addTitleSprite('building', 180, 110, 0.3, 0.5);

    buildingBlur = addTitleSprite('buildingBlur', 1485, -50, 0.8, 1);
    buildingBlur.velocity.set(-4835, -310);

    pole = addTitleSprite('pole', 1485, -50, 0.9, 1);
    pole.velocity.set(-5785, -310);

    addTitleSprite('train', -100, -20, 0.8, 1);

    yukira = addTitleSprite('yukira', 760, 75, 0.8, 1);

    addTitleSprite('logo', 80, 60, 1, 0.5);

    menuGroup = new FlxTypedSpriteGroup<FlxText>();
    add(menuGroup);

    for (i => opt in ['start', 'options', 'quit'])
    {
        var text = new FlxText(175 + i * 10, 470 + i * 65, 0, opt.toUpperCase() + ' ');
        text.setFormat(Paths.font('utendo.ttf'), 62, FlxColor.WHITE, null, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
        text.borderSize = 5;
        text.angle = 2;

        menuGroup.add(text);
    }

    changeSelection(0);
}

function addTitleSprite(name, x, y, scroll, scale)
{
    var spr = new FlxSprite(x, y, Paths.image('menus/titlescreen/' + name));
    spr.scrollFactor.set(scroll, scroll);
    spr.scale.set(scale, scale);
    spr.updateHitbox();
    add(spr);

    return spr;
}

var curSelected:Int = 0;

function changeSelection(change)
{
    curSelected = FlxMath.wrap(curSelected + change, 0, menuGroup.members.length - 1);

    for (index => opt in menuGroup.members)
    {
        FlxTween.cancelTweensOf(opt.scale);
        FlxTween.tween(opt.scale, {x: index == curSelected ? 1.05 : 1, y: index == curSelected ? 1.05 : 1}, 0.25, {ease: FlxEase.cubeOut});

        opt.borderColor = index == curSelected ? 0xFFB83158 : 0xFF182E60;
    }
}

function selectMenu()
{
    selectedSomething = true;

    CoolUtil.playSound('confirm');

    switch (menuGroup.members[curSelected].text.toLowerCase().trim())
    {
        case 'start':
            CoolUtil.switchState(new PlayState('freeplay', ['kirakira'], 'hard'));
            
        case 'options':
            CoolUtil.switchState(new CustomState(CoolVars.meta.optionsState));
            
        case 'quit':
            window.close();
    }
}

function onUpdate(elapsed)
{
    cameraTime += elapsed * 5;

    camGame.scroll.set(
        Math.sin(cameraTime * 0.8) * 1.5 + FlxG.mouse.screenX / 100,
        Math.cos(cameraTime * 0.6) * 1.5 + FlxG.mouse.screenY / 100
    );

    if (buildingBlur.x < resetX)
    {
        buildingBlur.setPosition(1485, -50);

        resetX = FlxG.random.float(-2000, -7000);
    }

    if (pole.x < -2000)
        pole.setPosition(1485, -50);

    if (selectedSomething)
        return;

    if (Controls.UI_UP_P || Controls.UI_DOWN_P)
    {
        changeSelection(Controls.UI_DOWN_P ? 1 : -1);

        CoolUtil.playSound('scroll');
    }

    if (Controls.ACCEPT)
        selectMenu();
}

function onBeatHit(beat:Int)
{
    FlxTween.cancelTweensOf(yukira);

    yukira.y = 80;

    FlxTween.tween(yukira, {y: 75}, Conductor.secCrochet, {ease: FlxEase.cubeOut});
}
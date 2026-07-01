import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.group.FlxTypedSpriteGroup;

var sky:FlxSprite;
var clouds:FlxSprite;
var mountain:FlxSprite;
var building:FlxSprite;
var buildingBlur:FlxSprite;
var pole:FlxSprite;
var trainBG:FlxSprite;
var yukira:FlxSprite;
var logo:FlxSprite;
var menuGroup:FlxTypedSpriteGroup<FlxText>;
var options:Array<String> = ['start', 'options', 'quit'];
var curSelected:Int = 0;
var selectedSomething:Bool = false;
var cameraTime:Float = 0;
var resetX:Float = -3000;

function onCreate()
{
    if (Conductor.music == null)
        Conductor.play(Paths.music('ikawaMenu'), 122, 4, 4);

    FlxG.mouse.visible = true;
    addTitleSprite('sky', -100, -100, 0.2, 1);
    clouds = addTitleSprite('clouds', 100, -170, 0.2, 1);
    mountain = addTitleSprite('mountain', 800, 230, 0.3, 0.5);
    building = addTitleSprite('building', 180, 110, 0.3, 0.5);
    buildingBlur = addTitleSprite('buildingBlur', 1485, -50, 0.8, 1);
    pole = addTitleSprite('pole', 1485, -50, 0.9, 1);
    trainBG = addTitleSprite('train', -100, -20, 0.8, 1);
    yukira = addTitleSprite('yukira', 760, 75, 0.8, 1);
    logo = addTitleSprite('logo', 80, 60, 1, 0.5);

    buildingBlur.velocity.set(-4838, -310);
    pole.velocity.set(-5784, -310);

    menuGroup = new FlxTypedSpriteGroup<FlxText>();
    add(menuGroup);

    for (i in 0...options.length)
    {
        var text = new FlxText(175 + i * 10, 470 + i * 65, 0, options[i].toUpperCase() + ' ');
        text.ID = i;
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
    spr.antialiasing = true;
    spr.scale.set(scale, scale);
    spr.updateHitbox();
    add(spr);
    return spr;
}

function onUpdate(elapsed)
{
    cameraTime += elapsed * 5;
    camGame.scroll.set(
        Math.sin(cameraTime * 0.8) * 1.5 + FlxG.mouse.screenX / 100,
        Math.cos(cameraTime * 0.6) * 1.5 + FlxG.mouse.screenY / 100
    );

    yukira.y = FlxMath.lerp(yukira.y, 75, elapsed * 10);

    if (buildingBlur.x < resetX)
    {
        buildingBlur.setPosition(1485, -50);
        resetX = FlxG.random.float(-2000, -7000);
    }

    if (pole.x < -2000)
        pole.setPosition(1485, -50);

    for (txt in menuGroup)
    {
        var targetScale = txt.ID == curSelected ? 1.05 : 1;
        txt.scale.set(FlxMath.lerp(txt.scale.x, targetScale, 0.2), FlxMath.lerp(txt.scale.y, targetScale, 0.2));
        txt.borderColor = txt.ID == curSelected ? 0xFFB83158 : 0xFF182E60;
    }

    if (selectedSomething)
        return;

    if (Controls.UI_UP_P || Controls.UI_DOWN_P)
        changeSelection(Controls.UI_DOWN_P ? 1 : -1);

    if (Controls.ACCEPT)
        selectMenu();
}

function changeSelection(change)
{
    curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);
    CoolUtil.playSound('scroll');
}

function selectMenu()
{
    selectedSomething = true;
    CoolUtil.playSound('confirm');

    switch (options[curSelected])
    {
        case 'start':
            CoolUtil.switchState(new PlayState('freeplay', ['kirakira'], 'hard'));
        case 'options':
            CoolUtil.switchState(new CustomState(CoolVars.meta.optionsState));
        case 'quit':
            window.close();
    }
}

function onBeatHit(beat)
{
    if (yukira != null)
        yukira.y += 5;
}

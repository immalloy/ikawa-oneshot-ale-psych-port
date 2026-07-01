import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import funkin.visuals.objects.FunkinSprite;

var ikawaStageReady:Bool = false;
var leafGroup:FlxGroup;
var vehicleGroup:FlxGroup;
var cameoGroup:FlxGroup;

var bicycleSprite:FunkinSprite;
var motorcycleSprite:FunkinSprite;
var carSprite:FunkinSprite;
var rendemAppear:Bool = false;

var agawaSprite:FunkinSprite;
var nigoSprite:FunkinSprite;
var supxrSprite:FunkinSprite;
var wallScrollX:Float = 0.65;
var wallScrollY:Float = 0.95;

function currentSong()
{
    return game != null && game.song != null ? game.song : '';
}

function postStageChange(id)
{
    if (id != 'kawazoi' || ikawaStageReady)
        return;

    ikawaStageReady = true;

    cameoGroup = new FlxGroup();
    addBehindDad(cameoGroup);
    addCameo('sha', 194, 75, 'sha bump');
    addCameo('ilusion', 448, 245, 'ilusi bump');
    addCameo('jookz', 1327, 175, 'jo bump');
    agawaSprite = addCameo('agawa', -320, 225, 'gawa bump', currentSong() != 'kirakira');
    nigoSprite = addCameo('nigo', 1436, 205, 'nigo bump', currentSong() != 'kirakira');
    supxrSprite = addSupxrCameo();

    vehicleGroup = new FlxGroup();
    var wall = game.stage.get('wall');
    if (wall != null)
    {
        wallScrollX = wall.scrollFactor.x;
        wallScrollY = wall.scrollFactor.y;
        addBehind(wall, vehicleGroup);
    }
    else
        addBehindDad(vehicleGroup);

    if (gf != null)
    {
        remove(gf);
        addBehindBF(gf);
    }

    leafGroup = new FlxGroup();
    add(leafGroup);
    for (i in 0...3)
        createLeaf();
}

function postUpdate(elapsed)
{
    if (!ikawaStageReady)
        return;

    for (leaf in leafGroup)
        if (leaf != null && leaf.y > 1550)
            resetLeaf(leaf);

    bicycleSprite = updateVehicle(bicycleSprite, 'bicycle');
    motorcycleSprite = updateVehicle(motorcycleSprite, 'motorcycle');
    carSprite = updateVehicle(carSprite, 'car');

    if (supxrSprite != null && supxrSprite.animation.curAnim != null && supxrSprite.animation.curAnim.name == 'walk')
    {
        var currentBeat = Conductor.songPosition / Conductor.crochet;
        supxrSprite.offset.y = Math.abs(Math.sin(currentBeat / 2 * Math.PI) * 5);
        supxrSprite.x = FlxMath.bound(-1200 + ((currentBeat / 36) * 2228), -1200, 1028);
    }
}

function onBeatHit(beat)
{
    if (!ikawaStageReady)
        return;

    if (FlxG.random.bool(10) && leafGroup.length < 12)
        createLeaf();

    if (FlxG.random.bool(1))
        spawnVehicle('bicycle');

    if (FlxG.random.bool(0.7))
        spawnVehicle('motorcycle');

    if (FlxG.random.bool(0.2))
        spawnVehicle('car');

    if (currentSong() == 'kirakira')
    {
        if (beat == 64 && agawaSprite != null)
            agawaSprite.visible = true;

        if (beat == 80 && nigoSprite != null)
            nigoSprite.visible = true;
    }

    if (supxrSprite != null && supxrSprite.animation.curAnim != null)
    {
        var animName = supxrSprite.animation.curAnim.name;

        if (animName == 'walk')
        {
            supxrSprite.animation.curAnim.curFrame = (beat + 1) % 4;

            if (beat >= 36)
            {
                supxrSprite.setPosition(1028, 175);
                supxrSprite.animation.play('look', true);
                supxrSprite.offset.set(0, 10);
            }
        }
        else if (animName == 'look' && beat >= 42)
        {
            supxrSprite.animation.play('bump', true);
            supxrSprite.offset.set(2, 5);
        }
    }

    for (cameo in cameoGroup)
        if (cameo != null && cameo.animation.curAnim != null && cameo.animation.curAnim.name == 'bump' && beat % 2 == 0)
            cameo.animation.play('bump', true);
}

function addCameo(name, x, y, anim, ?visible:Bool = true)
{
    var spr = new FunkinSprite();
    spr.frames = Paths.getSparrowAtlas('stages/kawazoi/cameos/' + name);
    spr.animation.addByPrefix('bump', anim, 24, false);
    spr.animation.play('bump');
    spr.setPosition(x, y);
    spr.antialiasing = true;
    spr.scrollFactor.set(wallScrollX, wallScrollY);
    spr.visible = visible;
    cameoGroup.add(spr);
    return spr;
}

function addSupxrCameo()
{
    var spr = new FunkinSprite();
    spr.frames = Paths.getSparrowAtlas('stages/kawazoi/cameos/supxr');
    spr.animation.addByPrefix('walk', 'xr walkin', 0, false);
    spr.animation.addByPrefix('look', 'xr look', 24, false);
    spr.animation.addByPrefix('bump', 'xr bump', 24, false);
    spr.setPosition(currentSong() == 'kirakira' ? -1200 : 1028, 175);
    spr.antialiasing = true;
    spr.scrollFactor.set(wallScrollX + 0.05, wallScrollY + 0.05);
    spr.animation.play(currentSong() == 'kirakira' ? 'walk' : 'bump');
    cameoGroup.add(spr);
    return spr;
}

function createLeaf()
{
    var leaf = new FunkinSprite();
    leaf.frames = Paths.getSparrowAtlas('stages/kawazoi/leaf');
    for (i in 1...5)
        leaf.animation.addByPrefix('y' + i, 'leaf' + i, 0, false);
    leaf.moves = true;
    leaf.antialiasing = true;
    leafGroup.add(leaf);
    resetLeaf(leaf);
}

function resetLeaf(leaf)
{
    leaf.angularVelocity = FlxG.random.float(-25, 65);
    leaf.velocity.x = FlxG.random.float(-15, 125);
    leaf.velocity.y = FlxG.random.float(125, 250);
    leaf.animation.play('y' + FlxG.random.int(1, 4), true);
    leaf.x = FlxG.random.float(22, 1500);
    leaf.y = FlxG.random.float(-250, -220);
    leaf.scale.set(FlxG.random.float(0.55, 0.75), FlxG.random.float(0.55, 0.75));
    leaf.scrollFactor.set(FlxG.random.float(0.9, 1.1), FlxG.random.float(0.9, 1.1));
}

function spawnVehicle(kind)
{
    if ((kind == 'bicycle' && bicycleSprite != null) || (kind == 'motorcycle' && motorcycleSprite != null) || (kind == 'car' && carSprite != null))
        return;

    var spr = new FunkinSprite();
    var flip = FlxG.random.bool(10);
    spr.moves = true;
    spr.flipX = flip;
    spr.scrollFactor.set(0.5, 0.8);
    spr.antialiasing = true;

    switch (kind)
    {
        case 'bicycle':
            spr.frames = Paths.getSparrowAtlas('stages/kawazoi/vehicles/bicycle');
            spr.animation.addByPrefix('cycling', 'cycling', 12, true);
            spr.animation.play('cycling');
            spr.setPosition(flip ? -900 : 2000, 30);
            spr.velocity.x = FlxG.random.float(270, 440) * (flip ? 1 : -1);
            bicycleSprite = spr;
        case 'motorcycle':
            var path = !rendemAppear && FlxG.random.bool(0.5) ? 'motorcycle-rendem' : 'motorcycle';
            spr.loadGraphic(Paths.image('stages/kawazoi/vehicles/' + path));
            spr.setPosition(flip ? -900 : 2000, path.indexOf('rendem') != -1 ? 5 : 15);
            spr.velocity.x = FlxG.random.float(370, 440) * (flip ? 1 : -1);
            if (path.indexOf('rendem') != -1)
                rendemAppear = true;
            motorcycleSprite = spr;
        default:
            spr.loadGraphic(Paths.image('stages/kawazoi/vehicles/car'));
            spr.setPosition(flip ? -1200 : 2000, -30);
            spr.velocity.x = FlxG.random.float(430, 670) * (flip ? 1 : -1);
            carSprite = spr;
    }

    vehicleGroup.add(spr);
}

function updateVehicle(spr, kind)
{
    if (spr == null)
        return null;

    spr.offset.set(0, FlxG.random.int(0, kind == 'bicycle' ? 1 : 2));

    var outOfBounds = switch (kind)
    {
        case 'bicycle' | 'motorcycle': (spr.flipX && spr.x > 2100) || spr.x < -1000;
        default: (spr.flipX && spr.x > 2400) || spr.x < -1300;
    };

    if (!outOfBounds)
        return spr;

    spr.kill();
    vehicleGroup.remove(spr, true);
    spr.destroy();
    return null;
}

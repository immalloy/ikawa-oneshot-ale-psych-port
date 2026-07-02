spawnNotes = false;



var leaves:FlxTypedGroup<FlxSprite>;

function postCreate()
{
    add(leaves = new FlxTypedGroup<FlxSprite>());

    camHUD.alpha = false;

}

var timer:Float = 0.1;

function onUpdate(elapsed:Float)
{
    if (leaves.members.length <= 15)
        if (timer > 0)
        {
            timer -= elapsed;
        } else {
            timer = 0.1;

            final leaf:FlxSprite = CoolUtil.spriteFromJson(null, {
                type: 'sheet',
                images: [
                    'leaf'
                ]
            }, stageRoute + '/');

            resetLeaf(leaf);

            leaves.add(leaf);
        }

    for (index => leaf in leaves)
        if (leaf.y > 1400)
            resetLeaf(leaf);

    camGame.position.set(Math.sin(Conductor.secTime * 2) * 400 + 700, 500);
    // camGame.snapToTarget();
}

function resetLeaf(leaf:FlxSprite)
{
    leaf.x = FlxG.random.float(-1000, 2000);
    leaf.y = -300;

    leaf.scale.x = leaf.scale.y = FlxG.random.float(0.5, 2);
    leaf.updateHitbox();

    leaf.angularVelocity = 1 / leaf.scale.x * 100;

    leaf.velocity.x = FlxG.random.float(50, 100);
    leaf.velocity.y = FlxG.random.float(50, 200);

    leaf.scrollFactor.x = leaf.scrollFactor.y = leaf.scale.x * 2;

    leaves.members.sort((a, b) -> b.scale.x - a.scale.x);
}

startTime = Conductor.beatToTime(7);

HotReloading.add('data/stages/kawazoi.json');
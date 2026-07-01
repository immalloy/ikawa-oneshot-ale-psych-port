import flixel.math.FlxPoint;

var ikawaCameraTarget:Int = 0;

function onEventHit(id, target, locked, duration, style, easeDir, p5, p6, p7)
{
    if (id != 'Camera Movement')
        return;

    ikawaCameraTarget = Std.int(target ?? 0);
    game.moveCamera(ikawaCameraTarget, true);
}

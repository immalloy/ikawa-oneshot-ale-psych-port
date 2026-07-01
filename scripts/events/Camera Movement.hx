var ikawaCameraTarget:Int = 0;

function getIkawaCameraCharacter(target:Int)
{
    return switch (target)
    {
        case 1: bf;
        case 2: gf;
        default: dad;
    };
}

function onEventHit(id, target, tweenMovement, duration, style, easeDir, p5, p6, p7)
{
    if (id != 'Camera Movement')
        return;

    ikawaCameraTarget = Std.int(target ?? 0);

    var character = getIkawaCameraCharacter(ikawaCameraTarget);

    if (character != null)
        game.moveCamera(character, true);
}

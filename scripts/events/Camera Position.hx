function onEventHit(id, x, y, tweenMovement, duration, ease, direction, isOffset, unused)
{
    if (id != 'Camera Position')
        return;

    camGame.cancelPositionTween();

    final nextX:Float = (isOffset == true ? camGame.position.x : 0) + (x ?? 0);
    final nextY:Float = (isOffset == true ? camGame.position.y : 0) + (y ?? 0);

    final isClassic:Bool = ease == null || Std.string(ease).toUpperCase() == 'CLASSIC';

    if (tweenMovement == false || isClassic)
    {
        camGame.position.set(nextX, nextY);
    }
    else
    {
        final tweenEase = CoolUtil.easeFromString(Std.string(ease ?? '') + Std.string(direction ?? ''));
        camGame.tweenPosition(nextX, nextY, Conductor.stepCrochet / 1000 * (duration ?? 4), {
            ease: tweenEase
        });
    }
}

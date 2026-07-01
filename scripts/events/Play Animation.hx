function onEventHit(id, target, anim, force, mode, p4, p5, p6, p7)
{
    if (id != 'Play Animation' || anim == null)
        return;

    final index = Std.int(target ?? 0);
    if (game.charactersArray[index] != null && game.charactersArray[index][0] != null)
        game.charactersArray[index][0].playSpecialAnim(anim, force ?? true, true, Conductor.secCrochet);
}

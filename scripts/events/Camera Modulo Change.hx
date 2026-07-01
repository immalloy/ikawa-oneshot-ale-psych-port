function onEventHit(id, modulo, zoom, unit, offset, p4, p5, p6, p7)
{
    if (id != 'Camera Modulo Change')
        return;

    game.bopModulo = Std.int(modulo ?? 4);
    game.bopZoom = zoom ?? 1;
}

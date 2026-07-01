function onEventHit(id, amount, p1, p2, p3, p4, p5, p6, p7)
{
    if (id == 'Camera Bop')
        camGame.zoom += 0.015 * (amount ?? 1);
}

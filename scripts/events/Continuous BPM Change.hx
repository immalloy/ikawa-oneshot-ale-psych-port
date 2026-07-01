function onEventHit(id, bpm, duration, p2, p3, p4, p5, p6, p7)
{
    if (id == 'Continuous BPM Change' && bpm != null)
        Conductor.bpm = bpm;
}

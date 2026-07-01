import utils.cool.StringUtil;

function onEventHit(id, enabled, zoom, cameraName, duration, easeName, direction, mode, direct)
{
    if (id != 'Camera Zoom' || zoom == null)
        return;

    final cam = cameraName == 'camHUD' ? camHUD : camGame;
    final time = Conductor.stepCrochet / 1000 * (duration ?? 4);
    final baseZoom = cameraName == 'camHUD' || mode == 'direct' ? zoom : game.stage.config.zoom * zoom;
    final nextZoom = direct == true ? cam.zoom * baseZoom : baseZoom;
    final tweenEase = StringUtil.easeFromString(Std.string(easeName ?? '') + Std.string(direction ?? ''));

    if (enabled == false)
    {
        cam.zoom = nextZoom;
    }
    else
    {
        cam.tweenZoom(nextZoom, time, {
            ease: tweenEase
        }, true);
    }
}

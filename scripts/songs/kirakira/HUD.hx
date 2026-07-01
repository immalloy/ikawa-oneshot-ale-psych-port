import flixel.text.FlxText.FlxTextBorderStyle;

function postHudInit()
{
    scoreText.setFormat(Paths.font('utendo.ttf'), 18, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    scoreText.borderSize = 1.5;
    scoreText.y = healthBar.y + (ClientPrefs.data.downScroll ? -34 : 34);
}

function onScoreTextUpdate()
{
    scoreText.text = botplay ? 'BOTPLAY' : 'Score: ' + score + ' | Misses: ' + misses + ' | Accuracy: ' + CoolUtil.floorDecimal(accuracy, 2) + '%';
    return CoolVars.Function_Stop;
}

function postUpdate(elapsed)
{
    for (icon in icons)
    {
        final target = 150;
        final width = FlxMath.lerp(icon.width, target, elapsed * 4.8);
        setIconSize(icon, width, width);
        icon.y = healthBar.y - icon.height / 2;
        if (ClientPrefs.data.downScroll)
            icon.y += healthBar.height;
    }
}

function onBeatHit(beat)
{
    for (icon in icons)
    {
        setIconSize(icon, 180, 180);
    }
}

function setIconSize(icon, width, height)
{
    if (icon.width > icon.height)
        icon.setGraphicSize(Std.int(width), 0);
    else
        icon.setGraphicSize(0, Std.int(height));

    icon.updateHitbox();
}

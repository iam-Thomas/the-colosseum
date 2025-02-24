function SetUnitAnimationByIndexAfterDelay(unit, index, delay)
    local animationTimer = CreateTimer()
    TimerStart(animationTimer, delay, false, function()
        SetUnitAnimationByIndex( unit, index )
        DestroyTimer(animationTimer)
    end)
end
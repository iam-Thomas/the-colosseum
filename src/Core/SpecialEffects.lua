function CreateEffectAtPoint(point, effect, duration)
    AddSpecialEffectLocBJ(point, effect)
    udg_SFXDurationArg = duration
    TriggerExecute(gg_trg_SFX_Cleanup)
    return GetLastCreatedEffectBJ()
end

function CreateEffectOnUnit(attachPointName, unit, effect, duration)
    AddSpecialEffectTargetUnitBJ(attachPointName, unit, effect)
    local effect = GetLastCreatedEffectBJ()
    if duration < 0.01 then
        DestroyEffect(effect)
    else
        local timer = CreateTimer()
        TimerStart(timer, duration, false, function()
            DestroyEffect(effect)
        end)
    end
    
    return effect
end

function CreateEffectOnUnitByBuff(attachPointName, unit, effect, buffcode)
    AddSpecialEffectTargetUnitBJ(attachPointName, unit, effect)
    local sfx = GetLastCreatedEffectBJ()
    local timer = CreateTimer()
    TimerStart(timer, 0.12, true, function()
        if not IsUnitAliveBJ(whichUnit) then
            DestroyTimer(timer)
            DestroyEffect(sfx)
            return
        end

        if not UnitHasBuffBJ(unit, buffcode) then
            DestroyTimer(timer)
            DestroyEffect(sfx)
            return
        end
    end)
    return sfx
end

function DangerAreaAt(point, time, radius)
    local scaleFactor = math.max(1.00, radius / 100.00)
    local effect = AddSpecialEffectLoc("buildings\\other\\CircleOfPower\\CircleOfPower", point)
    BlzSetSpecialEffectColor(effect, 255, 0, 0)
    BlzSetSpecialEffectAlpha(effect, 180)
    BlzSetSpecialEffectScale(effect, scaleFactor)
    local timer = CreateTimer()
    TimerStart(timer, time, false, function()
        DestroyTimer(timer)
        DestroyEffect(effect)
    end)
    return effect
end

function DangerAreaAtUntimed(point, radius)
    local scaleFactor = math.max(1.00, radius / 100.00)
    local effect = AddSpecialEffectLoc("buildings\\other\\CircleOfPower\\CircleOfPower", point)
    BlzSetSpecialEffectColor(effect, 255, 0, 0)
    BlzSetSpecialEffectAlpha(effect, 180)
    BlzSetSpecialEffectScale(effect, scaleFactor)
    return effect
end

function DangerCountdownAt(point, time)
    local integer n = time

    if (n < 1) then
        return
    end

    while n == 0 do
        MessageToAll(I2S(n))
        CreateTextTagLocBJ( I2S(n) + "!", PolarProjectionBJ(point, GetRandomReal(0.00, 0.00), GetRandomReal(0, 0)), 0, 16.00, 100, 20, 20, 20 )
        SetTextTagPermanentBJ( GetLastCreatedTextTag(), false )
        SetTextTagLifespanBJ( GetLastCreatedTextTag(), 1.20 )
        SetTextTagVelocityBJ( GetLastCreatedTextTag(), 32.00, 90.00 )
        PolledWait( 1 )
        n = n - 1
    end
end
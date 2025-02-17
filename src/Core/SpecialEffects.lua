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
        if not IsUnitAliveBJ(unit) then
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
    local scaleFactor = math.max(0.10, radius / 98.00)
    local effect = AddSpecialEffectLoc("buildings\\other\\CircleOfPower\\CircleOfPower", point)
    BlzSetSpecialEffectColor(effect, 255, 0, 0)
    BlzSetSpecialEffectAlpha(effect, 70)
    BlzSetSpecialEffectScale(effect, scaleFactor)
    BlzSetSpecialEffectZ(effect, GetLocationZ(point) + 10.00)
    local timer = CreateTimer()
    TimerStart(timer, time, false, function()
        DestroyTimer(timer)
        DestroyEffect(effect)
    end)
    return effect
end

function DangerAreaAtUntimed(point, radius)
    local scaleFactor = math.max(1.00, radius / 98.00)
    local effect = AddSpecialEffectLoc("buildings\\other\\CircleOfPower\\CircleOfPower", point)
    BlzSetSpecialEffectColor(effect, 255, 0, 0)
    BlzSetSpecialEffectAlpha(effect, 70)
    BlzSetSpecialEffectScale(effect, scaleFactor)
    BlzSetSpecialEffectZ(effect, GetLocationZ(point) + 10.00)
    return effect
end

function DangerCountdownAt(point, time)
    local textFunc = function(msg, pntt, tt)
        local x = GetLocationX(pntt)
        local y = GetLocationY(pntt)
        local z = GetLocationZ(pntt)
        local floatingText = CreateTextTag()
        SetTextTagTextBJ(floatingText, msg, 18)
        SetTextTagPos(floatingText, x, y, z)
        SetTextTagColor(floatingText, 255, 0, 0, 255)
        SetTextTagPermanent(floatingText, false)
        SetTextTagLifespan(floatingText, tt)
        SetTextTagVelocity(floatingText, 0.0, 0.03)
        SetTextTagVisibility(floatingText, true)
    end

    local n = time

    if (n < 1) then
        return
    end

    textFunc(tostring(n) .. "!", point, 1.11)
    
    local timer = CreateTimer()
    TimerStart(timer, 1.00, true, function()
        n = n - 1
        if n < 1 then
            DestroyTimer(timer)
            return
        end

        textFunc(tostring(n) .. "!", point, 1.11)
    end)
end
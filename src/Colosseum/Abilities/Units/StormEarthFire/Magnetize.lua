RegInit(function()
    AddAbilityCastTrigger('A0AM', AbilityTrigger_Sef_Magnetize)
end)

function AbilityTrigger_Sef_Magnetize()
    local caster = GetSpellAbilityUnit()
    local dps = 15.00
    local target = GetSpellTargetUnit()
    
    local pullSpeed = 175.0

    local lLoc1 = GetUnitLoc(caster)
    local lLoc2 = GetUnitLoc(target)
    local lightningEffect = AddLightningLoc( "CLPB", lLoc1, lLoc2)
    
    local time = 0.00
    local interval = 0.03
    local damageInterval = 0.33
    ChannelAbility(caster, interval, 10.0, "frostarmor", function()
        time = time + interval
        if not IsUnit_Targetable(target) or IsUnitElusive(target) then
            return true
        end

        if time > damageInterval and IsUnitEnemy(target, GetOwningPlayer(caster)) then
            time = time - damageInterval
            CauseMagicDamage(caster, target, dps * damageInterval)
        end

        local casterLoc = GetUnitLoc(caster)
        local targetLoc = GetUnitLoc(target)        
        local angle = AngleBetweenPoints(targetLoc, casterLoc)
        local moveLoc = PolarProjectionBJ(targetLoc, pullSpeed * interval, angle)
        local validMoveLoc = GetUnitValidLoc(moveLoc)

        MoveLightningLoc(lightningEffect, casterLoc, targetLoc)

        SetUnitX(target, GetLocationX(validMoveLoc))
        SetUnitY(target, GetLocationY(validMoveLoc))

        RemoveLocation(casterLoc)
        RemoveLocation(targetLoc)
        RemoveLocation(moveLoc)
        RemoveLocation(validMoveLoc)
    end, function()
        DestroyLightning(lightningEffect)
    end)

    RemoveLocation(lLoc1)
    RemoveLocation(lLoc2)
end

function ChannelAbility(caster, interval, maxTime, orderString, periodicCallback, endChannelCallback)
    local time = 0.00
    local timer = CreateTimer()
    TimerStart(timer, interval, true, function()
        time = time + interval
        local stop = false
        if GetUnitCurrentOrder(caster) ~= String2OrderIdBJ(orderString) then
            stop = true
        end

        if time >= maxTime then
            OrderStop(caster)
            stop = true
        end

        if not stop then
            if periodicCallback(time) then
                stop = true
            end
        end

        if stop then
            DestroyTimer(timer)
            endChannelCallback(time)
            return
        end
    end)
end
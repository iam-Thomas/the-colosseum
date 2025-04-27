AbilityTrigger_Lich_ConfrontWithDeath_Hashtable = nil
AbilityTrigger_Lich_ConfrontWithDeath_Kill = nil

RegInit(function()
    AbilityTrigger_Lich_ConfrontWithDeath_Hashtable = InitHashtable()
    AbilityTrigger_Lich_ConfrontWithDeath_Kill = AddKillEventTrigger_KillerHasAbility(FourCC('A06P'), AbilityTrigger_Lich_ConfrontWithDeath_Kill_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_Lich_ConfrontWithDeath_Kill, FourCC('U000'))
end)

function AbilityTrigger_Lich_ConfrontWithDeath_Kill_Actions()
    local caster = GetKillingUnit()
    local dyingUnit = GetDyingUnit()
    local id = GetHandleId(caster)
    local mana = GetUnitState(caster, UNIT_STATE_MANA)
    SetUnitState(caster, UNIT_STATE_MANA, mana + 15.00)

    local killCount = LoadInteger(AbilityTrigger_Lich_ConfrontWithDeath_Hashtable, id, 0)
    if killCount + 1 < 11 then
        SaveInteger(AbilityTrigger_Lich_ConfrontWithDeath_Hashtable, id, 0, killCount + 1)
        return
    end
    SaveInteger(AbilityTrigger_Lich_ConfrontWithDeath_Hashtable, id, 0, 0)

    local dieLoc = GetUnitLoc(dyingUnit)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A06P'))
    local damage = 2.00 + (abilityLevel * 2.00)

    local inProgress = true
    AbilityTrigger_Lich_ConfrontWithDeath_Circlies(dieLoc, function()
        return not inProgress
    end)

    -- fear using fear aoe ability function
    AbilityTrigger_Lich_Fear_InflictFearAoE(caster, dieLoc, 400)

    local ticks = 8
    local timer = CreateTimer()
    TimerStart(timer, 1.0, true, function()
        ticks = ticks - 1
        if not IsUnitAliveBJ(caster) or ticks < 0 then
            DestroyTimer(timer)
            RemoveLocation(dieLoc)
            inProgress = false
            return
        end

        local targets = GetUnitsInRange_EnemyTargetable(caster, dieLoc, 400.00)

        for i = 1, #targets do
            local target = targets[i]
            local isFacing = AbilityTrigger_Lich_ConfrontWithDeath_IsUnitFacingCaster(target, caster, 60.00)
            local dmgFinal = damage
            if not isFacing then
                dmgFinal = damage * 3
            end

            CauseMagicDamage(caster, target, dmgFinal)
        end
    end)

    CreateEffectAtPoint(dieLoc, "Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl", 2.0)
end

function AbilityTrigger_Lich_ConfrontWithDeath_IsUnitFacingCaster(target, caster, threshold)
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local casterX = GetUnitX(caster)
    local casterY = GetUnitY(caster)

    -- Calculate the angle between the target and the caster
    local angleToCaster = Atan2(casterY - targetY, casterX - targetX) * bj_RADTODEG

    -- Get the facing angle of the target
    local targetFacing = GetUnitFacing(target)

    -- Calculate the difference between the angles
    local angleDifference = math.abs(angleToCaster - targetFacing)

    -- Normalize the angle difference to be within 0 to 180 degrees
    if angleDifference > 180 then
        angleDifference = 360 - angleDifference
    end

    -- Check if the angle difference is within the threshold
    return angleDifference <= threshold
end

function AbilityTrigger_Lich_ConfrontWithDeath_Circlies(location, cancelationFunction)
    local loc = Location(GetLocationX(location), GetLocationY(location))
    if cancelationFunction() then
        return
    end

    local effectA = AddSpecialEffectLoc("Abilities\\Weapons\\ZigguratMissile\\ZigguratMissile.mdl", loc)
    local effectB = AddSpecialEffectLoc("Abilities\\Weapons\\ZigguratMissile\\ZigguratMissile.mdl", loc)
    BlzSetSpecialEffectZ(effectA, GetLocationZ(loc) + 30.00)
    BlzSetSpecialEffectZ(effectB, GetLocationZ(loc) + 30.00)

    local t = 0.00
    local timer = CreateTimer()
    TimerStart(timer, 0.03, true, function()
        t = t + 0.03
        if cancelationFunction() then
            DestroyEffect(effectA)
            DestroyEffect(effectB)
            DestroyTimer(timer)
            RemoveLocation(loc)
            return
        end

        local tOffsetA = t * 0.3
        local pointA = PolarProjectionBJ(loc, 400, tOffsetA * 360)
        local pointB = PolarProjectionBJ(loc, 400, (tOffsetA * 360) + 180)

        BlzSetSpecialEffectPosition(effectA, GetLocationX(pointA), GetLocationY(pointA), GetLocationZ(pointA) + 30.00)
        BlzSetSpecialEffectPosition(effectB, GetLocationX(pointB), GetLocationY(pointB), GetLocationZ(pointB) + 30.00)

        RemoveLocation(pointA)
        RemoveLocation(pointB)
    end)
end
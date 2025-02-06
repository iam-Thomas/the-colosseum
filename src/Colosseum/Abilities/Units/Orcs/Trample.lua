AbilityTrigger_Kodo_Trample = nil

RegInit(function()
    AbilityTrigger_Kodo_Trample = AddAbilityCastTrigger('A045', AbilityTrigger_Kodo_Trample_Actions)
end)

function AbilityTrigger_Kodo_Trample_Actions()
    local caster = GetSpellAbilityUnit()
    local loc = GetUnitLoc(caster)
    
    local units = GetUnitsInRange_EnemyGroundTargetable(caster, loc, 200)
    CreateEffectAtPoint(loc, "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", 2.0)
    for i = 1, #units do
        CastDummyAbilityOnTarget(caster, units[i], FourCC('A046'), 1, "slow")
        CauseMagicDamage(caster, units[i], 40.00)
    end

    local timer = CreateTimer()
    local ticks = 0
    TimerStart(timer, 1.00, true, function()
        ticks = ticks + 1
        if ticks > 20 then
            DestroyTimer(timer)
            return
        end

        local order = OrderId2String(GetUnitCurrentOrder(caster))
        if order ~= "move" and order ~= "smart" then
            return
        end

        local trampleLoc = GetUnitLoc(caster)
        local trampleUnits = GetUnitsInRange_EnemyGroundTargetable(caster, trampleLoc, 180)
        local effect = AddSpecialEffectLoc("abilities\\weapons\\catapult\\catapultmissile.mdl", trampleLoc)
        DestroyEffect(effect)
        for i = 1, #trampleUnits do
            CastDummyAbilityOnTarget(caster, trampleUnits[i], FourCC('A046'), 1, "slow")
            CauseMagicDamage(caster, trampleUnits[i], 40.00)
        end

        RemoveLocation(trampleLoc)
    end)

    RemoveLocation(loc)
end
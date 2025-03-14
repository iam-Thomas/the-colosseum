RegInit(function()
    AddAbilityCastTrigger('A0AK', AbilityTrigger_Sef_Firestorm)
end)

function AbilityTrigger_Sef_Firestorm()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local casterLoc = GetUnitLoc(caster)
    
    local damage = 40.00
    SetUnitInvulnerable(caster, true)
    
    local soakEffect = SoakAreaAtUntimed(casterLoc, 500)

    local effectTimer = CreateTimer()
    TimerStart(effectTimer, 0.03, true, function()
        BlzSetSpecialEffectPositionLoc(soakEffect, casterLoc)
    end)

    local interval = 1.2
    local time = 0.0
    local timer = CreateTimer()
    TimerStart(timer, interval, true, function()
        time = time + interval
        local stop = false
        if GetUnitCurrentOrder(caster) ~= String2OrderIdBJ("deathanddecay") then
            stop = true
            DestroyTimer(timer)
            DestroyEffect(soakEffect)
        end

        if time >= 18.00 then
            OrderStop(caster)
            stop = true
            MakeReckless(caster, 15.0)
            ApplyManagedBuff(caster, FourCC('S00F'), FourCC('B02A'), 15.0, nil, nil)
            -- give buff to caster
        end

        if stop then
            SetUnitInvulnerable(caster, false)
            DestroyTimer(timer)
            DestroyTimer(effectTimer)
            DestroyEffect(soakEffect)
            return
        end

        local units = GetUnitsInRange_Predicate(caster, casterLoc, 500, function(caster, target) return IsUnitEnemy(target, GetOwningPlayer(caster)) end)

        if #units < 1 then
            units = GetUnitsInRange_Predicate(caster, casterLoc, 3500, function(caster, target) return IsUnitEnemy(target, GetOwningPlayer(caster)) end)
        end

        -- TODO: this function is currently ver specific for GMSelections namespace
        local indeces = GMSelections_GetSelectRandomBossIndexArray(#units, 20)

        for i = 1, #indeces do
            FireHomingProjectile_PointToUnit(casterLoc, units[indeces[i]], "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl", 1100, 0.15, function()
                CauseMagicDamage_Fire(caster, units[indeces[i]], 50)
                MakeBurnt(units[indeces[i]], 3)
            end)
        end
    end)
end
RegInit(function()
    AddAbilityCastTrigger('A0AR', AbilityTrigger_Sef_Rumble)
end)

function AbilityTrigger_Sef_Rumble()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()

    local damage = 20.00

    local effect = AddSpecialEffectLoc("Abilities\\Spells\\Orc\\EarthQuake\\EarthQuakeTarget.mdl", targetLoc)
    local time = 0.00
    local timer = CreateTimer()
    TimerStart(timer, 0.66, true, function()
        time = time + 0.66
        if time >= 12.0 then
            DestroyEffect(effect)
            DestroyTimer(timer)
            return
        end
        
        local units = GetUnitsInRange_EnemyTargetable(caster, targetLoc, 400)
        for i = 1, #units do
            CauseMagicDamage(caster, units[i], damage)
            CastDummyAbilityOnTarget(caster, units[i], FourCC('A0AQ'), 1, "slow", 1.0)
        end
    end)
end
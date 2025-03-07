AbilityTrigger_Spikey_Spikes = nil

RegInit(function()
    AbilityTrigger_Spikey_Spikes = AddPeriodicPassiveAbility_Interval_CasterHasAbility(FourCC(SpikeySpikesSID), 0.05, AbilityTrigger_Spikey_Spikes_Callback)
end)

function AbilityTrigger_Spikey_Spikes_Callback(caster, tick)
    local casterPoint = GetUnitLoc(caster)
    
    local units = GetUnitsInRange_EnemyTargetable(caster, casterPoint, 150)
    for i = 1, #units do
        local unit = units[i]
        if Knockback_Stop(unit) then
            if IsPillarBossRound then
                CauseNormalDamage(caster, unit, 300)
                CauseStun3s(caster, unit)
            else
                CauseNormalDamage(caster, unit, 200)
                CauseStun2s(caster, unit)
            end
        end
    end

    RemoveLocation(casterPoint)
end

AbilityTrigger_Spikey_Spikes = nil

RegInit(function()
    AbilityTrigger_Spikey_Spikes = AddPeriodicPassiveAbility_Interval_CasterHasAbility(FourCC(SpikeySpikesSID), 0.1, AbilityTrigger_Spikey_Spikes_Callback(caster, tick))
end)


function AbilityTrigger_Spikey_Spikes_Callback(caster, tick)
    local casterPoint = GetUnitLoc(caster)
    
    local units = GetUnitsInRange_EnemyGroundTargetable(caster, casterPoint, 100)
    for i = 1, #units do
        if Knockback_Stop(units[i]) then
            if IsPillarBossRound then
                CauseNormalDamage(caster, units[i], 300)
                CauseStun3s(caster, units[i])
            else
                CauseNormalDamage(caster, units[i], 200)
                CauseStun2s(caster, units[i])
            end
        end
    end
end



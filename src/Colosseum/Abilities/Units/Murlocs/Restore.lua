AbilityTrigger_Murloc_Restore = nil
AbilityTrigger_Murloc_Restore_Hashtable = nil

RegInit(function()
    AbilityTrigger_Murloc_Restore_Hashtable = InitHashtable()
    AbilityTrigger_Murloc_Restore = AddPeriodicPassiveAbility_CasterHasAbility(FourCC('A07Q'), AbilityTrigger_Murloc_Restore_Functions)
    AbilityTrigger_Murloc_Restore_Damaged = AddDamagedEventTrigger_TargetHasAbility(FourCC('A07Q'), AbilityTrigger_Murloc_Restore_Damaged_Functions)
end)

function AbilityTrigger_Murloc_Restore_Functions(caster, tick)
    local id = GetHandleId(caster)

    local damagedTime = LoadReal(AbilityTrigger_Murloc_Restore_Hashtable, id, 0)

    if udg_ElapsedTime < damagedTime then
        return
    end
    
    local lifePercent = GetUnitLifePercent(caster)
    if lifePercent == 100 then
        return
    end

    local maxLife = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
    CauseHealUnscaled(caster, caster, maxLife * 0.08)
end

function AbilityTrigger_Murloc_Restore_Damaged_Functions(caster, tick)
    local caster = BlzGetEventDamageTarget()
    local id = GetHandleId(caster)
    SaveReal(AbilityTrigger_Murloc_Restore_Hashtable, id, 0, udg_ElapsedTime + 5.00)
end
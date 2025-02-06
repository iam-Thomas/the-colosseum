AbilityTrigger_Undead_Infest_Hashtable = nil

RegInit(function()
    AbilityTrigger_Undead_Infest_Hashtable = InitHashtable()
end)

function AbilityFunction_Undead_InfestTarget(caster, target, infestStrength)
    local id = GetHandleId(target)

    ApplyManagedBuff(target, FourCC('A04J'), FourCC('B00W'), 11.00, nil, nil)

    local storedCaster = LoadUnitHandle(AbilityTrigger_Undead_Infest_Hashtable, id, 0)
    if storedCaster == nil then
        SaveUnitHandle(AbilityTrigger_Undead_Infest_Hashtable, id, 0, caster)
        SaveReal(AbilityTrigger_Undead_Infest_Hashtable, id, 1, 0.00)

        PeriodicCallback(1.00, function()
            if not IsUnitAliveBJ(target) then
                FlushChildHashtable(AbilityTrigger_Undead_Infest_Hashtable, id)
                return true
            end
    
            if not UnitHasBuffBJ(target, FourCC('B00W')) then
                FlushChildHashtable(AbilityTrigger_Undead_Infest_Hashtable, id)
                return true
            end
    
            local infestCasterDamager = LoadUnitHandle(AbilityTrigger_Undead_Infest_Hashtable, id, 0)
            if infestCasterDamager == nil then
                infestCasterDamager = target
            end
            local dotDamage = LoadReal(AbilityTrigger_Undead_Infest_Hashtable, id, 1)
            CauseMagicDamage(infestCasterDamager, target, dotDamage)
        end)
    end

    local damagePerSecond = LoadReal(AbilityTrigger_Undead_Infest_Hashtable, id, 1)
    damagePerSecond = damagePerSecond + infestStrength
    SaveReal(AbilityTrigger_Undead_Infest_Hashtable, id, 1, damagePerSecond)
end
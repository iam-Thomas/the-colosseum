AbilityTrigger_BS_Bloodlust = nil
AbilityTrigger_BS_Bloodlust_Damaged = nil
AbilityTrigger_BS_Bloodlust_Hashtable = nil

RegInit(function()
    AbilityTrigger_BS_Bloodlust_Hashtable = InitHashtable()
    AbilityTrigger_BS_Bloodlust = AddAbilityCastTrigger('A024', AbilityTrigger_BS_Bloodlust_Actions)
    AbilityTrigger_BS_Bloodlust_Damaged = AddDamagingEventTrigger_TargetHasBuff(FourCC('B00P'), AbilityTrigger_BS_Bloodlust_Damaged_Actions)
end)

function AbilityTrigger_BS_Bloodlust_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local id = GetHandleId(caster)
    local currentTarget = LoadUnitHandle(AbilityTrigger_BS_Bloodlust_Hashtable, id, 0)
    SaveUnitHandle(AbilityTrigger_BS_Bloodlust_Hashtable, id, 0, target)

    if currentTarget == nil then
        return
    end

    if caster == currentTarget then
        return
    end

    if UnitHasBuffBJ(currentTarget, FourCC('B00P')) then
        UnitRemoveBuffBJ(FourCC('B00P'), currentTarget)
    end
end

function AbilityTrigger_BS_Bloodlust_Damaged_Actions()
    local damage = GetEventDamage()
    BlzSetEventDamage(damage * 1.15)
end
AbilityTrigger_Lich_Fear = nil
AbilityTrigger_Lich_Fear_Attacked = nil

RegInit(function()
    AbilityTrigger_Lich_Fear = AddAbilityCastTrigger('A05C', AbilityTrigger_Lich_Fear_Actions)
    AbilityTrigger_Lich_Fear_Attacked = CreateTrigger()
    TriggerAddAction(AbilityTrigger_Lich_Fear_Attacked, AbilityTrigger_Lich_Fear_Attacked_Actions)
    TriggerAddCondition(AbilityTrigger_Lich_Fear_Attacked, Condition(function() return 0 < GetUnitAbilityLevel(GetAttacker(), FourCC('A05C')) end))
    TriggerAddCondition(AbilityTrigger_Lich_Fear_Attacked, Condition(function() return UnitHasBuffBJ(GetAttackedUnitBJ(), FourCC('B00X')) end))
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_Lich_Fear_Attacked, EVENT_PLAYER_UNIT_ATTACKED)
    
    RegisterTriggerEnableById(AbilityTrigger_Lich_Fear, FourCC('U000'))
    RegisterTriggerEnableById(AbilityTrigger_Lich_Fear_Attacked, FourCC('U000'))
end)

function AbilityTrigger_Lich_Fear_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local targetLoc = GetUnitLoc(target)

    AbilityTrigger_Lich_Fear_InflictFearAoE(caster, targetLoc, 220)

    RemoveLocation(targetLoc)
end

function AbilityTrigger_Lich_Fear_InflictFearAoE(caster, loc, range, callback)
    CreateEffectAtPoint(loc, "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", 2.0)
    
    local targets = GetUnitsInRange_EnemyTargetable(caster, loc, range)
    for i = 1, #targets do
        AbilityTrigger_Lich_Fear_Actions_OrderMove(caster, targets[i])
        ApplyManagedBuff_Magic(targets[i], FourCC('A05D'), FourCC('B00X'), 11.00, "overhead", "Abilities\\Spells\\Other\\HowlOfTerror\\HowlTarget.mdl")
        if callback ~= nil then
            callback(caster, targets[i])
        end
    end
end

function AbilityTrigger_Lich_Fear_Attacked_Actions()
    local caster = GetAttacker()
    local target = GetAttackedUnitBJ()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetUnitLoc(target)
    local dist = DistanceBetweenPoints(casterLoc, targetLoc)

    if dist < 350.00 then
        AbilityTrigger_Lich_Fear_Actions_OrderMove(caster, target)
    end
end

function AbilityTrigger_Lich_Fear_Actions_OrderMove(caster, target)
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetUnitLoc(target)
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local offset = PolarProjectionBJ(casterLoc, 4000.00, angle)
    IssuePointOrderLoc(target, "move", offset)
    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
end
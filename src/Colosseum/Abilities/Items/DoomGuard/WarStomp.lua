AbilityTrigger_Item_Summon_WarStomp = nil

RegInit(function()
    AbilityTrigger_Item_Summon_WarStomp = AddAbilityCastTrigger('A080', AbilityTrigger_Item_Summon_WarStomp_Actions)
end)

function AbilityTrigger_Item_Summon_WarStomp_Actions()
    local caster = GetSpellAbilityUnit()
    local loc = GetUnitLoc(caster)
    
    local units = GetUnitsInRange_EnemyGroundTargetable(caster, loc, 240)
    CreateEffectAtPoint(loc, "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", 2.0)
    for i = 1, #units do
        CauseStun3s(caster, units[i])
    end

    RemoveLocation(loc)
end
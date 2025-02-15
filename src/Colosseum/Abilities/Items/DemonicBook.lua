ItemTrigger_DemonicBook = nil

RegInit(function()
    ItemTrigger_DemonicBook = AddAbilityCastTrigger('A07Y', ItemTrigger_DemonicBook_Actions)
end)

function ItemTrigger_DemonicBook_Actions()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()

    local summonLoc = GetUnitValidLoc(targetLoc)
    
    local unit = CreateUnitAtLoc(GetOwningPlayer(caster), FourCC('n00V'), summonLoc, bj_UNIT_FACING)
    ApplySummonPowerMultipliers(caster, unit)
    local unitLoc = GetUnitLoc(unit)
    CreateEffectAtPoint(unitLoc, "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", 2.00)

    UnitApplyTimedLife(unit, FourCC('BTLF'), 15.00)

    RemoveLocation(summonLoc)
    RemoveLocation(unitLoc)
end
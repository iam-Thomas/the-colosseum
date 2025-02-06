AbilityTrigger_BEST_Taunt = nil

RegInit(function()
    AbilityTrigger_BEST_Taunt = AddAbilityCastTrigger('A02I', AbilityTrigger_BEST_Taunt_Actions)
end)

function AbilityTrigger_BEST_Taunt_Actions()
    local caster = GetSpellAbilityUnit()
    local manaGained = 20.00

    GrantTempArmor(caster, 10, 10)
    local currentMana = GetUnitState(caster, UNIT_STATE_MANA)
    SetUnitState(caster, UNIT_STATE_MANA, currentMana + manaGained)

    local loc = GetUnitLoc(caster)
    AddSpecialEffectLocBJ(loc, "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
    udg_SFXDurationArg = 2
    TriggerExecute(gg_trg_SFX_Cleanup)
    RemoveLocation(loc)
end
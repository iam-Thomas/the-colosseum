AbilityTrigger_Kodo_Chomp = nil

RegInit(function()
    AbilityTrigger_Kodo_Chomp = AddAbilityCastTrigger('A047', AbilityTrigger_Kodo_Chomp_Actions)
    AbilityTrigger_Kodo_Chomp_Damaged = AddDamagedEventTrigger_TargetHasAbility(FourCC('A047'), AbilityTrigger_Kodo_Chomp_Damaged_Function)
end)

function AbilityTrigger_Kodo_Chomp_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local damage = 250.00
    CauseMagicDamage(caster, target, damage)
    CauseStun3s(caster, target)
end

function AbilityTrigger_Kodo_Chomp_Damaged_Function()
    local target = BlzGetEventDamageTarget()
    local damage = GetEventDamage()
    
    local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    -- every 15% of life loss, will grant the kodo a total of 200 mana
    local damageFor200Mana = maxLife * 0.075
    local manaGained = (damage / damageFor200Mana) * 200
    local currentMana = GetUnitState(target, UNIT_STATE_MANA)

    SetUnitState(target, UNIT_STATE_MANA, currentMana + manaGained)
end
AbilityTrigger_VP_Judgement = nil

RegInit(function()
    AbilityTrigger_VP_Judgement = AddAbilityCastTrigger('A032', AbilityTrigger_VP_Judgement_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_VP_Judgement, FourCC('H00S'))
end)

function AbilityTrigger_VP_Judgement_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local factor = 1.00
    local doHeal = false
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A032'))
    local str = GetHeroStr(caster, true)
    local damage = 80.00 + (30.00 * abilityLevel) + (str * 0.90)

    local targetCurrentLife = GetUnitState(target, UNIT_STATE_LIFE)
    local targetMaxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    local targetPercentageLife = (targetCurrentLife / targetMaxLife) * 100

    local targetCurrentMana = GetUnitState(target, UNIT_STATE_MANA)
    local targetMaxMana = GetUnitState(target, UNIT_STATE_MAX_MANA)
    local targetPercentageMana = (targetCurrentMana / targetMaxMana) * 100

    local casterCurrentLife = GetUnitState(caster, UNIT_STATE_LIFE)
    local casterMaxLife = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
    local casterPercentageLife = (casterCurrentLife / casterMaxLife) * 100

    if (targetPercentageLife <= 30.00) then
        factor = factor + 0.50
    end

    if (targetPercentageLife > casterPercentageLife) then
        doHeal = true
    end
    
    damage = damage * factor

    CauseMagicDamage(caster, target, damage)
    OrderStop(target)
    local lifeAfterDamage = GetUnitState(target, UNIT_STATE_LIFE)
    local damageDealt = targetCurrentLife - lifeAfterDamage
    if lifeAfterDamage <= 0.00 then
        damageDealt = math.max(damageDealt, damage)
    end
    local loc = GetUnitLoc(target)
    local units = GetUnitsInRange_EnemyGroundTargetable(caster, loc, 200.00)
    for i = 1, #units do
        if target ~= units[i] then
            CauseMagicDamage(caster, units[i], damageDealt * 0.30)    
        end
    end
    RemoveLocation(loc)

    if doHeal then
        CauseHealUnscaled(caster, caster, damageDealt * 0.35)
    end
end
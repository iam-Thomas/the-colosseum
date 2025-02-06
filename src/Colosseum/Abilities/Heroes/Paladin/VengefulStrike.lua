AbilityTrigger_VP_VengefulStrike = nil

RegInit(function()
    AbilityTrigger_VP_VengefulStrike = CreateTrigger()
    TriggerAddCondition(AbilityTrigger_VP_VengefulStrike, Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), FourCC('A034')) > 0 end))
    TriggerAddAction(AbilityTrigger_VP_VengefulStrike, AbilityTrigger_VP_VengefulStrike_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_VP_VengefulStrike, EVENT_PLAYER_UNIT_DAMAGING)
end)

function AbilityTrigger_VP_VengefulStrike_Actions()
    local isAttack = BlzGetEventIsAttack()
    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local damage = GetEventDamage()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A034'))

    local manaCost = 6
    local damageFactor = 1.20
    local damageFactorPerMissingLifePercent = 0.002

    if abilityLevel > 1 then
        manaCost = 5
    end

    if abilityLevel > 2 then
        damageFactorPerMissingLifePercent = 0.004
    end

    if abilityLevel > 3 then
        damageFactor = 1.35
    end

    local currentLife = GetUnitState(caster, UNIT_STATE_LIFE)
    local maxLife = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
    local percentageLife = (currentLife / maxLife) * 100
    local missing = 100.00 - percentageLife

    local missingFactor = missing * damageFactorPerMissingLifePercent
    local factor = damageFactor + missingFactor

    BlzSetEventDamage(damage * factor)

    CauseManaBurnUnscaled(caster, manaCost)
end
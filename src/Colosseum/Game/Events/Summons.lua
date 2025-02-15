CombatEventTrigger_SummonMultiplier = nil

RegInit(function()
    -- CombatEventTrigger_SummonMultiplier = CreateTrigger()
    -- TriggerAddAction(CombatEventTrigger_SummonMultiplier, CombatEventTrigger_SummonMultiplier_Actions)
    -- TriggerRegisterAnyUnitEventBJ(CombatEventTrigger_SummonMultiplier, EVENT_PLAYER_UNIT_SUMMON)
end)

function CombatEventTrigger_SummonMultiplier_Actions()
    -- local summoner = GetSummoningUnit()
    -- local summoned = GetSummonedUnit()
    
    --ApplySummonPowerMultipliers(summoner, summoned)
end

function ApplySummonPowerMultipliers(caster, target)
    local hp = BlzGetUnitMaxHP(target)
    local factor = GetUnitStrMultiplier(caster)
    BlzSetUnitMaxHP(target, math.floor((hp * factor) + 0.5))
    
    local armor = BlzGetUnitArmor(target)
    factor = GetUnitAgiMultiplier(caster)
    BlzSetUnitArmor(target, armor * factor)

    local dmg = BlzGetUnitBaseDamage(target, 0)
    factor = GetUnitIntMultiplier(caster)
    BlzSetUnitBaseDamage(target, math.floor((dmg * factor) + 0.5), 0)

    SetUnitLifePercentBJ(target, 100)
end

-- set udg_FloatA = ( ( 100.00 + ( I2R(GetHeroStatBJ(bj_HEROSTAT_INT, GetSummoningUnit(), true)) * 2.00 ) ) / 100.00 )
-- set udg_IntA = R2I(( I2R(BlzGetUnitMaxHP(GetSummonedUnit())) * udg_FloatA ))
-- call BlzSetUnitMaxHP( GetSummonedUnit(), udg_IntA )
-- set udg_IntA = R2I(( I2R(BlzGetUnitBaseDamage(GetSummonedUnit(), 0)) * udg_FloatA ))
-- call BlzSetUnitBaseDamage( GetSummonedUnit(), udg_IntA, 0 )
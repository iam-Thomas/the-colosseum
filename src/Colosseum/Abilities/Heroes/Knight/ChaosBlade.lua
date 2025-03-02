AbilityTrigger_Knight_ChaosBlade_Damaging = nil

RegInit(function()
    AbilityTrigger_Knight_ChaosBlade_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A09H'), AbilityTrigger_Knight_ChaosBlade_Damaging_Actions)
end)

function AbilityTrigger_Knight_ChaosBlade_Damaging_Actions()
    local damageType = BlzGetEventDamageType()
    if not IsDamageType_Physical(damageType) then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    if not IsUnitBurnt(target) and not UnitHasBuffBJ(caster, FourCC('B020')) then
        return
    end

    local damage = GetHeroDamageTotal(caster) * 0.18
    damage = damage * GetFactorToExcludeMultiplierFactor(DAMAGE_TYPE_FIRE, caster, target)

    local targetLoc = GetUnitLoc(target)
    local affectedUnits = GetUnitsInRange_EnemyTargetable(caster, targetLoc, 140)
    for i = 1, #affectedUnits do
        local unit = affectedUnits[i]
        CauseMagicDamage_Fire(caster, unit, damage)    
    end
    
    local effect = AddSpecialEffectLoc("Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl", targetLoc)
    BlzSetSpecialEffectScale(effect, 1.2)
    BlzSetSpecialEffectZ(effect, GetLocationZ(targetLoc) + 40)
    DestroyEffect(effect)

    RemoveLocation(targetLoc)
end
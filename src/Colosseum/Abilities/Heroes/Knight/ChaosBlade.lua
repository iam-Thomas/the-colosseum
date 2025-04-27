AbilityTrigger_Knight_ChaosBlade_Damaging = nil

RegInit(function()
    AbilityTrigger_Knight_ChaosBlade_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A09H'), AbilityTrigger_Knight_ChaosBlade_Damaging_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_Knight_ChaosBlade_Damaging, FourCC('H012'))
end)

function AbilityTrigger_Knight_ChaosBlade_Damaging_Actions()
    local damageType = BlzGetEventDamageType()
    if not IsDamageType_Physical(damageType) then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    if (not IsUnitBurnt(caster)) and (not UnitHasBuffBJ(caster, FourCC('B020'))) then
        return
    end

    local unitLevel = GetHeroLevel(caster)
    local damage = GetHeroDamageTotal(caster) * 0.50
    damage = damage * GetFactorToExcludeMultiplierFactor(DAMAGE_TYPE_FIRE, caster, target) -- this part is offset by the intelligence factor, as if it was a normal damage type
    damage = damage + 20.00 -- this 20.00 is increased by intelligence

    
    CauseMagicDamage_Fire(caster, target, damage)
    
    local effect = AddSpecialEffectTarget("Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl", target, "chest")
    BlzSetSpecialEffectScale(effect, 1.2)
    DestroyEffect(effect)
end
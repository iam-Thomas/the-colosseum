AbilityTrigger_Pyro_Cauterize = nil

RegInit(function()
    AbilityTrigger_Pyro_Cauterize = AddAbilityCastTrigger('A03K', AbilityTrigger_Pyro_Cauterize_Actions)
end)

function AbilityTrigger_Pyro_Cauterize_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local casterOwner = GetOwningPlayer(caster)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A03K'))

    local heroLevel = GetHeroLevel(caster)
    local healing = 50.00 + (40.0 * abilityLevel)
    local damage = 35.00 + (35.0 * abilityLevel)

    local isCauterized = UnitHasBuffBJ(target, FourCC('B00Q'))
    MakeBurnt(target, 22.00)
    if IsUnitEnemy(target, casterOwner) then
        CauseMagicDamage_Fire(caster, target, damage)
    else
        if not isCauterized then
            CauseHeal(caster, target, healing)
        else
            CauseMagicDamage_Fire(caster, target, damage)
        end
    end
end
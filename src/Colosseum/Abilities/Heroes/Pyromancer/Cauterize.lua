AbilityTrigger_Pyro_Cauterize = nil

RegInit(function()
    AbilityTrigger_Pyro_Cauterize = AddAbilityCastTrigger('A03K', AbilityTrigger_Pyro_Cauterize_Actions)
end)

function AbilityTrigger_Pyro_Cauterize_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local casterOwner = GetOwningPlayer(caster)

    local baseHealing = 100.00
    local baseDamage = 75.00
    local bonusFromLevels = 6.00
    local heroLevel = GetHeroLevel(caster)
    local healing = baseHealing + (bonusFromLevels * heroLevel)
    local damage = baseDamage + (bonusFromLevels * heroLevel)

    local isCauterized = UnitHasBuffBJ(target, FourCC('B00Q'))
    ApplyManagedBuff_Magic(target, FourCC('A03N'), FourCC('B00Q'), 22.00, "overhead", "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl")
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
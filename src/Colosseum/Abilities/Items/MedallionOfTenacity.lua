-- This function should be called in AbilitiesCore.CauseStunByAbility
function ItemFunction_MedallionOfTenacity_Function(caster, target)
    if not IsUnitType(target, UNIT_TYPE_HERO) then
        return false
    end

    if not UnitHasItemOfTypeBJ(target, FourCC('I010')) then -- Medallion of Tenacity
        return false
    end

    local cooldownRemaining = BlzGetUnitAbilityCooldownRemaining(caster, FourCC('A097'))
    if cooldownRemaining > 0 then
        return false
    end

    MakeTenacious(target, 6.00)
    BlzStartUnitAbilityCooldown(target, FourCC('A097'), 40.00)
    return true
end
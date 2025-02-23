AbilityTrigger_Dragon_Flintlock = nil

RegInit(function()
    AbilityTrigger_Dragon_Flintlock = AddAbilityCastTrigger('A08N', AbilityTrigger_Dragon_Flintlock_Actions)
end)

function AbilityTrigger_Dragon_Flintlock_Actions()
    local caster = GetSpellAbilityUnit()
    local castPoint = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()

    if (IsUnitEnemy(target, GetOwningPlayer(caster))) then
        CastDummyAbilityFromPointOnTarget(GetOwningPlayer(caster), target, FourCC('A08O'), 1, 'thunderbolt', castPoint)
    else
        if (FourCC('o00H') == GetUnitTypeId(target)) then
            CastDummyAbilityFromPointOnTarget(GetOwningPlayer(caster), target, FourCC('A08O'), 2, 'thunderbolt', castPoint)
        end
    end

    RemoveLocation(castPoint)
    
end

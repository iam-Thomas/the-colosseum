RegInit(function()
    AddAbilityCastTrigger('A03F', AbilityTrigger_Vagabond_Shackleshot)
end)

function AbilityTrigger_Vagabond_Shackleshot()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetUnit = GetSpellTargetUnit()

    FireHomingProjectile_PointToUnit(casterLoc, targetUnit, "Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl", 600, 0.0, function()

        print("projectile hit")
        ApplyManagedBuff_MagicElusive(target, FourCC('A03C'), nil, 5.0)
        print("managed buff ability applied")
        ApplyEnsnareByManagedBuffMarker(caster, target, FourCC('A03C'), FourCC('A00U'), FourCC('B027'))
        print("ensnare by buff marker ability applied")
        CreateEffectOnUnitByBuff("chest", unit, "Abilities\\Spells\\Orc\\Ensnare\\ensnare_AirTarget.mdl", FourCC('B027'))
        print("effect created")

    end)

    RemoveLocation(casterLoc)
end
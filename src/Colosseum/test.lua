RegInit(function()
    local trg = AddAbilityCastTrigger('A0A7', function()
        local caster = GetSpellAbilityUnit()
        AddUnitAnimationProperties(caster, "alternate", true)
        BlzSetUnitWeaponBooleanField(caster, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, false)
        BlzSetUnitWeaponBooleanField(caster, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, true)
        
    end)
end)
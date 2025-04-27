RegInit(function()
    local trigger = AddAbilityCastTrigger('A03F', AbilityTrigger_Vagabond_Shackleshot)
    
    RegisterTriggerEnableById(trigger, FourCC('H00U'))
end)

function AbilityTrigger_Vagabond_Shackleshot()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()
    local targetLoc = GetUnitLoc(target)

    local abilityLevel = GetUnitAbilityLevel(caster, 'A03F')
    local duration = 2.00 + (1.00 * abilityLevel)

    local units = GetUnitsInRange_EnemyTargetable(caster, targetLoc, 350)    

    for i = 1, #units do        
        FireHomingProjectile_PointToUnit(casterLoc, units[i], "Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl", 950, 0.0, function()
            if IsUnitResistant(unit) then
                ApplyEnsnare(caster, units[i], duration * 0.5)
            else
                ApplyEnsnare(caster, units[i], duration)
            end
        end)
    end

    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
end
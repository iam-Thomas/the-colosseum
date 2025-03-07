RegInit(function()
    AddAbilityCastTrigger('A03F', AbilityTrigger_Vagabond_Shackleshot)
end)

function AbilityTrigger_Vagabond_Shackleshot()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()
    local targetLoc = GetUnitLoc(target)

    local units = GetUnitsInRange_EnemyTargetable(caster, targetLoc, 350)
    for i = 1, #units do        
        FireHomingProjectile_PointToUnit(casterLoc, units[i], "Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl", 950, 0.0, function()
            if IsUnitResistant(unit) then
                ApplyEnsnare(caster, units[i], 3.0)
            else
                ApplyEnsnare(caster, units[i], 9.0)
            end
        end)
    end

    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
end
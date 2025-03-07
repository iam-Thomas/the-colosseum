RegInit(function()
    local trigger = AddAbilityCastTrigger('A09U', Webber_Web)
end)

function Webber_Web()
    local caster = GetTriggerUnit()
    local target = GetSpellTargetUnit()
    local startLoc = GetUnitLoc(caster)

    FireHomingProjectile_PointToUnit(startLoc, target, "Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl", 750, 0.0, function()
        local duration = 9.0
        if IsUnitResistant(storedTarget) then
            duration = 3.5
        end
        ApplyEnsnare(caster, target, duration)
    end)

    RemoveLocation(startLoc)
end
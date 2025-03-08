RegInit(function()
    local trig = AddAbilityCastTrigger('A0A6', AbilityTrigger_Warden_FanOfKnives)
end)

function AbilityTrigger_Warden_FanOfKnives()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A0A6'))
    
    local attackDamage = GetHeroDamageTotal(caster)
    local abilityDamage = 30.00 + (10.00 * abilityLevel)
    local damage = abilityDamage + (attackDamage * 0.5)

    --Abilities\Spells\NightElf\FanOfKnives\FanOfKnivesCaster.mdl
    --Abilities\Spells\NightElf\FanOfKnives\FanOfKnivesMissile.mdl
    local targets = GetUnitsInRange_EnemyTargetablePhysical(caster, casterLoc, 450)

    -- TODO: this function is currently ver specific for GMSelections namespace
    local indeces = GMSelections_GetSelectRandomBossIndexArray(#targets, 4)

    --CreateEffectAtPoint(casterLoc, "Abilities\\Spells\\NightElf\\FanOfKnives\\FanOfKnivesCaster.mdl", 3.0)
    for i = 1, #indeces do
        local index = indeces[i]
        local target = targets[index]
        local castLoc = Location(GetLocationX(casterLoc), GetLocationY(casterLoc))
        FireHomingProjectile_PointToUnit(casterLoc, target, "Abilities\\Spells\\NightElf\\FanOfKnives\\FanOfKnivesMissile.mdl", 900, 0.03, function()
            CausePhysicalDamage_Hero(caster, target, damage)
        end)
        RemoveLocation(castLoc)
    end

    RemoveLocation(casterLoc)
end
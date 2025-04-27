AbilityTrigger_Undead_BreathOfFrost = nil

RegInit(function()
    AbilityTrigger_Undead_BreathOfFrost = AddAbilityCastTrigger('A06Q', AbilityTrigger_Undead_BreathOfFrost_Functions)
end)

function AbilityTrigger_Undead_BreathOfFrost_Functions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()
    local distance = DistanceBetweenPoints(casterLoc, targetLoc)
    local projectDistance = math.max(0, 600 - distance)
    local angle = AngleBetweenPoints(casterLoc, targetLoc)
    local sourceLoc = PolarProjectionBJ(casterLoc, 80, angle)
    local areaLoc = PolarProjectionBJ(targetLoc, projectDistance, angle)

    local nProjectiles = 8
    for i = 1,nProjectiles do
        local projectileTargetLoc = PolarProjectionBJ(areaLoc, math.random(25, 370), math.random(0, 360))
        local dangerEffect = DangerAreaAtUntimed(projectileTargetLoc, 125)
        FireProjectile_PointHeightToPoint(sourceLoc, 120.00, projectileTargetLoc, "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl", 410, 0.17, function()
            local units = GetUnitsInRange_EnemyTargetable(caster, projectileTargetLoc, 140)
            CreateEffectAtPoint(projectileTargetLoc, "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", 3.0)
            for i = 1, #units do
                print("bof hit")
                ApplyFrozen(caster, units[i], 5.0)
                print("bof applied frozen")
                CauseMagicDamage(caster, units[i], 125)
                print("bof applied")
            end
            RemoveLocation(projectileTargetLoc)
            DestroyEffect(dangerEffect)
        end)
    end

    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
    RemoveLocation(sourceLoc)
    RemoveLocation(areaLoc)
end
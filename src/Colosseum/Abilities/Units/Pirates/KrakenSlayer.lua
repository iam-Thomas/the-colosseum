AbilityTrigger_Kraken_Slayer = nil

RegInit(function()
    AbilityTrigger_Kraken_Slayer = AddAbilityCastTrigger('A08R', AbilityTrigger_Kraken_Slayer_Actions)
end)

function AbilityTrigger_Kraken_Slayer_Actions()
    local caster = GetSpellAbilityUnit()
    local facing = GetUnitFacing(caster)
    local targetPoint = GetSpellTargetLoc()
    local casterPoint = GetUnitLoc(caster)
    local startPoint = PolarProjectionBJ(casterPoint, 70, facing)
    local flyingHeight = GetUnitFlyHeight(caster)
    local startingPitch = -(math.pi/2)
    local pitchRotation = (3*math.pi)/2 + startingPitch - 0.05

    --the speed is the maximum speed if cast at maximum cast range, and minimum speed if cast directly next to the unit
    local maximumSpeed = 250
    local minimumSpeed = 30
    local maximumCastRange = 1000
    local distance = DistanceBetweenPoints(targetPoint, startPoint)
    local speed = ((distance/maximumCastRange) * (maximumSpeed - minimumSpeed)) + minimumSpeed

    local dangerEffect = DangerAreaAtUntimed(projectileTargetLoc, 250)
    local afterProjectile = FireProjectile_PointHeightToPoint(startPoint, flyingHeight, targetPoint, "Abilities\\Weapons\\Mortar\\MortarMissile.mdl", speed, 0.6, function(projectileData)
        DestroyEffect(dangerEffect)

        local effect = projectileData.projectileEffect
        BlzSetSpecialEffectScale(effect, 1.7);
        BlzSetSpecialEffectOrientation( effect, facing, 0, 0 )
        BlzSetSpecialEffectTimeScale( effect, 0.15)

        CastDummyAbilityOnPoint(GetOwningPlayer(caster), targetPoint, FourCC('A090'), 1, "flamestrike", targetPoint, 5)

        RemoveLocation(casterPoint)
        RemoveLocation(targetPoint)
        RemoveLocation(startPoint)
    end, startingPitch, pitchRotation)


    local afterEffect = afterProjectile.projectileEffect
    BlzSetSpecialEffectScale(afterEffect, 3.5);

end

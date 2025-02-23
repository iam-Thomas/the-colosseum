AbilityTrigger_Barrel_Of_Royal_Rum = nil

RegInit(function()
    AbilityTrigger_Barrel_Of_Royal_Rum = AddAbilityCastTrigger('A08L', AbilityTrigger_Barrel_Of_Royal_Rum_Actions)
    AbilityTrigger_Barrel_Of_Royal_Rum = AddAbilityCastTrigger('A08V', AbilityTrigger_Barrel_Of_Royal_Rum_Actions)
end)

function AbilityTrigger_Barrel_Of_Royal_Rum_Actions()
    local caster = GetSpellAbilityUnit()
    local targetPoint = GetSpellTargetLoc()
    local startPoint = GetUnitLoc(caster)
    local facing = GetUnitFacing(caster)

    if (GetUnitTypeId(caster) == FourCC('n00X')) then
        SetUnitAnimationByIndex( caster, 4 )
    elseif (GetUnitTypeId(caster) == FourCC('h014')) then
        SetUnitAnimationByIndex( caster, 2 )
    end

    local projectile = FireProjectile_PointToPoint(startPoint, targetPoint, "Buildings\\Other\\BarrelsUnit\\BarrelsUnit.mdl", 550, 0.5, function()

        local finalPoint = GetUnitLonelyLoc(targetPoint, 28)
        
        CreateUnitAtLoc(GetOwningPlayer(caster), FourCC('o00H'), finalPoint, facing)

        RemoveLocation(finalPoint)
        RemoveLocation(targetPoint)
        RemoveLocation(startPoint)
    end)


    -- local effect = projectile.projectileEffect --
    -- BlzSetSpecialEffectScale(effect, 1); --

end

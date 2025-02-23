AbilityTrigger_Boatswain_Anchor = nil

RegInit(function()
    AbilityTrigger_Boatswain_Anchor = AddAbilityCastTrigger('A08W', AbilityTrigger_Boatswain_Anchor_Actions)
end)

function AbilityTrigger_Boatswain_Anchor_Actions()
    local anchorDuration = 15

    local caster = GetTriggerUnit()
    local targetPoint = GetSpellTargetLoc()
    local startPoint = GetUnitLoc(caster)
    local facing = GetUnitFacing(caster)

    if (GetUnitTypeId(caster) == FourCC('n00X')) then
        SetUnitAnimationByIndexAfterDelay(caster, 3 , 0.03)
    end

    local afterProjectile = FireProjectile_PointToPoint_NoPitch(startPoint, targetPoint, "war3mapImported\\Sunken Anchor.mdl", 550, 0.5, function(projectile)
        BlzSetSpecialEffectScale(projectile.projectileEffect, 0.01)
        
        local createdUnit = CreateUnitAtLoc(GetOwningPlayer(caster), FourCC('o00G'), targetPoint, facing)

        local effect = CreateEffectAtPoint(targetPoint, "Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl", anchorDuration)
        BlzSetSpecialEffectScale(effect, 3)

        UnitApplyTimedLife(createdUnit, FourCC('BTLF'), (anchorDuration - 3))

        RemoveLocation(targetPoint)
        RemoveLocation(startPoint)
    end)

    BlzSetSpecialEffectScale(afterProjectile.projectileEffect, 1.7)

end

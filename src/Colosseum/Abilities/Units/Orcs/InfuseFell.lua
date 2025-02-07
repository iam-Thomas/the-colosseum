AbilityTrigger_OrcWarlock_InfuseFel = nil

RegInit(function()
    AbilityTrigger_OrcWarlock_InfuseFel = AddAbilityCastTrigger('A05Z', AbilityTrigger_OrcWarlock_InfuseFel_Actions)
end)

function AbilityTrigger_OrcWarlock_InfuseFel_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local startPoint = GetUnitLoc(caster)
    FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Spells\\Undead\\DarkSummoning\\DarkSummonMissile.mdl", 400.00, 0.08, function()
        if not IsUnitAliveBJ(target) then
            return
        end

        local maxhp = GetUnitState(target, UNIT_STATE_MAX_LIFE)
        local damage = BlzGetUnitBaseDamage(target, 0)
        local targetHp = maxhp * 2.25
        local targetDamage = damage * 2.25
        local targetLoc = GetUnitLoc(target)
        local targetLifePercent = GetUnitLifePercent(target)
        
        local hitEffect = CreateEffectAtPoint(targetLoc, "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", 2.0)
        BlzSetSpecialEffectScale(hitEffect, 1.5)

        local hasBuff = UnitHasBuffBJ(target, FourCC('B010'))
        if hasBuff then
            local percent = GetUnitLifePercent(target)
            SetUnitLifePercentBJ(target, math.min(100, percent + 50))
        else
            SetUnitLifePercentBJ(target, 100)
        end

        local doTransform = (not hasBuff) and (targetLifePercent <= 25)
        if doTransform then
            BlzSetUnitMaxHP(target, math.ceil(targetHp))
            BlzSetUnitBaseDamage(target, math.ceil(targetDamage), 0)
            UnitAddAbility(target, FourCC('A060'))
        end

        if doTransform then
            local scaleFactor = 1.25
            if UnitHasBuffBJ(target, FourCC('Bblo')) then
                scaleFactor = scaleFactor * 1.225
            end

            local currentScaleX = BlzGetUnitRealField(target, UNIT_RF_SCALING_VALUE)
            local currentScaleY = BlzGetUnitRealField(target, UNIT_RF_SCALING_VALUE)
            local currentScaleZ = BlzGetUnitRealField(target, UNIT_RF_SCALING_VALUE)    
            -- Increase the scale by 25%
            local newScaleX = currentScaleX * 1.25
            local newScaleY = currentScaleY * 1.25
            local newScaleZ = currentScaleZ * 1.25    
            -- Set the new scale for the unit
            SetUnitScale(target, newScaleX, newScaleY, newScaleZ)
            SetUnitVertexColor(target, 100, 255, 100, 255)
            -- local unitId = GetUnitTypeId(target)
            -- if unitId == FourCC('o006') then
            --     print("try change model")
            --     local us = BlzGetUnitSkin(target)
            --     print("skin gotten")
            --     print(us)
            --     BlzSetUnitSkin(target, 1865429046)
            -- elseif unitId == FourCC('o007') then
            --     BlzSetUnitSkin(target, "OrcWarlockFelSkin")
            -- end
        end

        RemoveLocation(targetLoc)
        RemoveLocation(startPoint)
    end)    
end
AbilityTrigger_Knight_WrathOfSargeras = nil

RegInit(function()
    AbilityTrigger_Knight_WrathOfSargeras = AddAbilityCastTrigger('A08K', AbilityTrigger_Knight_WrathOfSargeras_Actions)
end)

function AbilityTrigger_Knight_WrathOfSargeras_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local casterFacing = GetUnitFacing(caster)
    local targetLoc = GetSpellTargetLoc()

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A08K'))
    local bonusDamagePerTick = 4
    local castBaseDamage = 100.00 + (50.00 * abilityLevel)
    local baseAttackDamageFactor = 1.5
    local minDamageFactor = 1.0
    local maxDamageFactor = 2.0
    local duration = 20.00 + (5.00 * abilityLevel)

    local maxAoE = 600.0
    local minAoE = 130.0

    local currentChannelTime = 0.00
    local maxChannelTime = 7.00

    ApplyManagedBuff(caster, FourCC('S008'), FourCC('B01P'), duration, nil, nil)
    GrantTempDamageByBuff(caster, bonusDamagePerTick, FourCC('B01P'))

    local timer = CreateTimer()
    TimerStart(timer, 0.5, true, function()
        if GetUnitCurrentOrder(caster) == String2OrderIdBJ("divineshield") then
            GrantTempDamageByBuff(caster, bonusDamagePerTick, FourCC('B01P'))
            return
        end
        DestroyTimer(timer)
    end)

    local minWarnEffectScale = minAoE / 45
    local maxWarEffectScale = maxAoE / 45
    local minEffectScale = 0.8
    local maxEffectScale = 2.0
    local warnEffect = AddSpecialEffectLoc("UI\\Feedback\\TargetPreSelected\\TargetPreSelected.mdl", targetLoc)
    BlzSetSpecialEffectColor(warnEffect, 255, 220, 0)
    BlzSetSpecialEffectScale(warnEffect, minWarnEffectScale)

    local swordTimer = CreateTimer()
    TimerStart(swordTimer, 0.03, true, function()
        currentChannelTime = currentChannelTime + 0.03
        local progress = math.min(currentChannelTime / maxChannelTime, 1.00)
        local aoeWarnEffectScale = AbilityTrigger_Knight_WrathOfSargeras_Lerp(minWarnEffectScale, maxWarEffectScale, progress)
        local effectScale = AbilityTrigger_Knight_WrathOfSargeras_Lerp(minEffectScale, maxEffectScale, progress)
        local damageProgress = AbilityTrigger_Knight_WrathOfSargeras_Lerp(minDamageFactor, maxDamageFactor, progress)
        if GetUnitCurrentOrder(caster) == String2OrderIdBJ("divineshield") then
            BlzSetSpecialEffectScale(warnEffect, aoeWarnEffectScale)
            return
        end
        DestroyTimer(swordTimer)

        local heroDamage = GetHeroDamageTotal(caster)
        local damage = castBaseDamage + (heroDamage * baseAttackDamageFactor)
        local startLoc = PolarProjectionBJ(targetLoc, 10.0, casterFacing + 180)

        local projectileData = FireProjectile_PointHeightToPoint(startLoc, 1500, targetLoc, "war3mapImported\\HauntedSwordAttach.mdl", 20.0, 0, function(callbackData)
            BlzSetSpecialEffectScale(callbackData.projectileEffect, 0.01)
            BlzSetSpecialEffectScale(warnEffect, 0.1)
            local thunderEffect = CreateEffectAtPoint(targetLoc, "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", 4.0)
            BlzSetSpecialEffectScale(thunderEffect, effectScale)
            local flameStrikeEffect = CreateEffectAtPoint(targetLoc, "war3mapImported\\Flamestrike II.mdl", 4.0)
            --local flameStrikeEffect = CreateEffectAtPoint(targetLoc, "war3mapImported\\Kingdom Come_opt.mdl", 6.0)
            BlzSetSpecialEffectScale(flameStrikeEffect, effectScale)
            BlzSetSpecialEffectTimeScale(flameStrikeEffect, 0.6)
            --BlzSetSpecialEffectAlpha(flameStrikeEffect, 120)
            --BlzSetSpecialEffectYaw(flameStrikeEffect, 90.0 / 57.29)
            DestroyEffect(warnEffect)

            local targets = GetUnitsInRange_EnemyTargetablePhysical(caster, targetLoc, AbilityTrigger_Knight_WrathOfSargeras_Lerp(minAoE, maxAoE, progress))
            for i = 1, #targets do
                MakeBurnt(targets[i], 9.0)
                CausePhysicalDamage_Hero(caster, targets[i], damage * damageProgress)
                CauseStun3s(caster, targets[i])
            end

            RemoveLocation(casterLoc)
            RemoveLocation(targetLoc)
            RemoveLocation(startLoc)
        end, (math.pi/2), 0)

        BlzSetSpecialEffectScale(projectileData.projectileEffect, 1.5 + effectScale)
    end)

    SetRoundCooldown_R(caster, 1)
end

function AbilityTrigger_Knight_WrathOfSargeras_Lerp(min, max, t)
    return min + (max - min) * t
end
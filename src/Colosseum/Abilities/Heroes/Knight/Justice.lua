AbilityTrigger_Knight_Justice = nil

RegInit(function()
    AbilityTrigger_Knight_Justice = AddAbilityCastTrigger('A08K', AbilityTrigger_Knight_Justice_Actions)
end)

function AbilityTrigger_Knight_Justice_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local casterFacing = GetUnitFacing(caster)
    local targetLoc = GetSpellTargetLoc()

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A08K'))
    local bonusDamagePerTick = 4
    local castBaseDamage = 100.00 + (50.00 * abilityLevel)
    local attackDamageFactor = 1.5
    local duration = 20.00 + (5.00 * abilityLevel)

    local warnEffect = AddSpecialEffectLoc("Abilities\\Spells\\Undead\\Possession\\PossessionCaster.mdl", targetLoc)
    BlzSetSpecialEffectScale(warnEffect, 3.5)

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

    local swordTimer = CreateTimer()
    TimerStart(swordTimer, 2.0, false, function()
        local baseDamage = BlzGetUnitBaseDamage(caster, 0)
        local bonusDamage = GetHeroBonusDamageFromItemsAndTempBonus(caster)
        local damage = castBaseDamage + ((baseDamage + bonusDamage) * attackDamageFactor)

        local startLoc = PolarProjectionBJ(targetLoc, 10.0, casterFacing + 180)

        local projectileData = FireProjectile_PointHeightToPoint(startLoc, 1500, targetLoc, "war3mapImported\\HauntedSwordAttach.mdl", 20.0, 0, function(callbackData)
            BlzSetSpecialEffectScale(callbackData.projectileEffect, 0.01)
            local thunderEffect = CreateEffectAtPoint(targetLoc, "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", 4.0)
            BlzSetSpecialEffectScale(thunderEffect, 2.2)
            local flameStrikeEffect = CreateEffectAtPoint(targetLoc, "war3mapImported\\Flamestrike II.mdl", 4.0)
            --local flameStrikeEffect = CreateEffectAtPoint(targetLoc, "war3mapImported\\Kingdom Come_opt.mdl", 6.0)
            BlzSetSpecialEffectScale(flameStrikeEffect, 1.15)
            BlzSetSpecialEffectTimeScale(flameStrikeEffect, 0.6)
            BlzSetSpecialEffectAlpha(flameStrikeEffect, 120)
            BlzSetSpecialEffectYaw(flameStrikeEffect, 90.0 / 57.29)
            DestroyEffect(warnEffect)

            local targets = GetUnitsInRange_EnemyTargetablePhysical(caster, targetLoc, 380)
            for i = 1, #targets do
                CausePhysicalDamage_Hero(caster, targets[i], damage)
                CauseStun3s(caster, targets[i])
            end

            RemoveLocation(casterLoc)
            RemoveLocation(targetLoc)
            RemoveLocation(startLoc)
        end, (math.pi/2), 0)

        BlzSetSpecialEffectScale(projectileData.projectileEffect, 3)

        DestroyTimer(swordTimer)
    end)

    SetRoundCooldown_R(caster, 1)
end
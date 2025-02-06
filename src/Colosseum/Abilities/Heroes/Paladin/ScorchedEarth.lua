AbilityTrigger_VP_ScorchedEarth = nil

RegInit(function()
    AbilityTrigger_VP_ScorchedEarth = AddAbilityCastTrigger('A05W', AbilityTrigger_VP_ScorchedEarth_Actions)
end)

function AbilityTrigger_VP_ScorchedEarth_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local point = GetSpellTargetLoc()
    local angle = AngleBetweenPoints(casterLoc, point)
    local endPoint = PolarProjectionBJ(casterLoc, 900.00, angle)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A05W'))
    
    local str = GetHeroStr(caster, true)
    local damage = 50.00 + (40.00 * abilityLevel) + (1.20 * str)
    local patchDamage = 6.00 + (2.00 * abilityLevel)

    local patchTime = 0.00

    SetRoundCooldown_E(caster, 1)

    FireShockwaveProjectile(caster, casterLoc, endPoint, "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl", 780, 160.00, function(target)
        if target == caster then
            return
        end

        local unitLoc = GetUnitLoc(target)
        CreateEffectAtPoint(unitLoc, "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", 2.00)
        CauseMagicDamage_Fire(caster, target, damage)
        CauseStun1s(caster, target)
        CastDummyAbilityOnTarget(caster, target, FourCC('A05X'), 1, "curse")
        RemoveLocation(unitLoc)
    end, function(point)
        patchTime = patchTime + 0.03
        if patchTime < 0.06 then
            return
        end
        patchTime = 0.00

        local tempPoint = Location(GetLocationX(point), GetLocationY(point))
        local localPoint = PolarProjectionBJ(tempPoint, math.random(30, 210), math.random(0, 360))
        RemoveLocation(tempPoint)
        local localPatchTime = 0.00
        CreateEffectAtPoint(localPoint, "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl", 10.00)
        local timer = CreateTimer()
        TimerStart(timer, 1.00, true, function()
            localPatchTime = localPatchTime + 1.00
            if localPatchTime > 10.0 then
                DestroyTimer(timer)
                RemoveLocation(localPoint)
            end

            local patchUnits = GetUnitsInRange_Targetable(caster, localPoint, 60.00)
            for i = 1, #patchUnits do
                CauseMagicDamage_Fire(caster, patchUnits[i], patchDamage)
            end
        end)
    end)
end
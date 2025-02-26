AbilityTrigger_Knight_Executioner = nil

RegInit(function()
    AbilityTrigger_Knight_Executioner = AddAbilityCastTrigger('A08J', AbilityTrigger_Knight_Executioner_Actions)
end)

function AbilityTrigger_Knight_Executioner_Actions()
    local caster = GetSpellAbilityUnit()

    local baseDamage = BlzGetUnitBaseDamage(caster, 0)
    local bonusDamage = GetHeroBonusDamageFromItemsAndTempBonus(caster)

    local damage = (baseDamage + bonusDamage) * 1.6

    AbilityTrigger_Knight_Executioner_AoEDamage(caster, damage)

    local timer = CreateTimer()
    TimerStart(timer, 0.36, false, function()
        if GetUnitCurrentOrder(caster) == String2OrderIdBJ("thunderbolt") then
            AbilityTrigger_Knight_Executioner_AoEDamage(caster, damage)
        end        
        DestroyTimer(timer)
    end)
end

function AbilityTrigger_Knight_Executioner_AoEDamage(caster, damage)
    local angle = GetUnitFacing(caster)
    local casterLoc = GetUnitLoc(caster)
    local aoeLoc = PolarProjectionBJ(casterLoc, 120, angle)
    local targets = GetUnitsInRange_EnemyTargetablePhysical(caster, aoeLoc, 140)
    local damageTotal = damage * (0.5 + (0.5 * #targets))
    local damagePerTarget = damageTotal / #targets
    for i = 1, #targets do
        CausePhysicalDamage_Hero(caster, targets[i], damagePerTarget)
        CreateEffectOnUnit("chest", targets[i], "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", 2.00)
    end

    -- if #target > 0 then
    --     CreateSound(fileName, looping, is3D, stopwhenoutofrange, fadeInRate, fadeOutRate, eaxSetting)
    --     --MetalHeavySliceMetal1
    --     local sound = CreateSound("Abilities\\Spells\\Other\\Stampede\\StampedeHit1.flac", false, true, true, 10, 10, "DefaultEAXON")
    --     SetSoundPosition(sound, GetLocationX(aoeLoc), GetLocationY(aoeLoc), GetLocationZ(aoeLoc))
    --     StartSound(sound)
    --     KillSoundWhenDone(sound)
    --     print("hjere")
    -- end

    RemoveLocation(casterLoc)
    RemoveLocation(aoeLoc)
end
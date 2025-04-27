AbilityTrigger_Knight_Sweep = nil

RegInit(function()
    AbilityTrigger_Knight_Sweep = AddAbilityCastTrigger('A08J', AbilityTrigger_Knight_Sweep_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_Knight_Sweep, FourCC('H012'))
end)

function AbilityTrigger_Knight_Sweep_Actions()
    local caster = GetSpellAbilityUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A08J'))

    local attackDamage = GetHeroDamageTotal(caster)

    local damage = (10.00 + (10.00 * abilityLevel)) + (attackDamage * 1.2)

    AbilityTrigger_Knight_Sweep_AoEDamage(caster, damage)

    local timer = CreateTimer()
    TimerStart(timer, 0.36, false, function()
        if GetUnitCurrentOrder(caster) == String2OrderIdBJ("thunderbolt") then
            AbilityTrigger_Knight_Sweep_AoEDamage(caster, damage)
        end        
        DestroyTimer(timer)
    end)
end

function AbilityTrigger_Knight_Sweep_AoEDamage(caster, damage)
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
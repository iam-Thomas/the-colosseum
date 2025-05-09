RegInit(function()
    AddAbilityCastTrigger('A0AL', AbilityTrigger_Sef_Pyroblast)
end)

function AbilityTrigger_Sef_Pyroblast()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetSpellTargetLoc()

    local damage = 75.00    
    local radius = 320.00

    local speed = 300 + (DistanceBetweenPoints(casterLoc, targetLoc) * 0.4)
    local dangerAreaEffect = DangerAreaAtUntimed(targetLoc, radius)
    local data = FireProjectile_PointToPoint(casterLoc, targetLoc, "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", speed, 0.35, function()
        DestroyEffect(dangerAreaEffect)
        local units = GetUnitsInRange_EnemyTargetable(caster, targetLoc, radius)
        for i = 1, #units do
            CauseMagicDamage_Fire(caster, units[i], damage)
        end

        local pillars = GetUnitsInRange_Predicate(caster, targetLoc, radius, function(caster, target)
            return GetUnitTypeId(target) == FourCC('n017') and not IsUnitEnemy(target, GetOwningPlayer(caster))
        end)
        for i = 1, #pillars do
            AbilityTrigger_Sef_Pyroblast_BeginErupt(pillars[i])
        end

        CreateEffectAtPoint(targetLoc, "war3mapImported\\Flamestrike II.mdl", 5.0)
        RemoveLocation(targetLoc)
    end, 0, 0)
    RemoveLocation(casterLoc)
    BlzSetSpecialEffectScale(data.projectileEffect, 2.0)
end

function AbilityTrigger_Sef_Pyroblast_BeginErupt(earthPillarUnit)
    SetUnitVertexColor(earthPillarUnit, 255, 200, 0, 255)
    BlzSetUnitArmor(earthPillarUnit, 0)

    local time = 0.0
    local timer = CreateTimer()
    TimerStart(timer, 0.03, true, function()
        time = time + 0.03
        if not IsUnitAliveBJ(earthPillarUnit) then
            DestroyTimer(timer)
            return
        end

        if GetRandomReal(0.00, 1.00) > 0.95 then
            -- Abilities\Weapons\LavaSpawnMissile\LavaSpawnMissile.mdl
            local sourceLoc = GetUnitLoc(earthPillarUnit)
            local targetLoc = PolarProjectionBJ(sourceLoc, 10 + math.random(0, 170), math.random(0, 360))
            local dist = DistanceBetweenPoints(sourceLoc, targetLoc)
            FireProjectile_PointToPoint(sourceLoc, targetLoc, "Abilities\\Weapons\\LavaSpawnMissile\\LavaSpawnMissile.mdl", dist, 0.95, function()
                -- code
            end, 50, -50)
        end

        if time >= 12.0 then
            DestroyTimer(timer)
            AbilityTrigger_Sef_Pyroblast_Explosion(earthPillarUnit)
        end
    end)
end

function AbilityTrigger_Sef_Pyroblast_Explosion(earthPillarUnit)
    local loc = GetUnitLoc(earthPillarUnit)
    local face = GetUnitFacing(earthPillarUnit)
    local lifePercent = GetUnitLifePercent(earthPillarUnit)
    KillUnit(earthPillarUnit)
    local doomEffect = CreateEffectAtPoint(loc, "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", 5.00)
    --BlzGetSpecialEffectScale(doomEffect)
    local spawn = CreateUnitAtLoc(GetOwningPlayer(earthPillarUnit), FourCC('n018'), loc, face)
    SetUnitLifePercentBJ(spawn, lifePercent)
    RemoveLocation(loc)
end
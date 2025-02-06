AbilityTrigger_Pyro_Supernova = nil

RegInit(function()
    AbilityTrigger_Pyro_Supernova = AddAbilityCastTrigger('A03Z', AbilityTrigger_Pyro_Supernova_Actions)
end)

function AbilityTrigger_Pyro_Supernova_Actions()
    local caster = GetSpellAbilityUnit()
    local baseDamage = 150.00 + (150.00 * GetUnitAbilityLevel(caster, FourCC('A03Z')))

    AddSpecialEffectTargetUnitBJ("origin", caster, "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl")
    local effect = GetLastCreatedEffectBJ()

    local timer = CreateTimer()
    local ticks = 0
    TimerStart(timer, 1.00, true, function()
        if not IsUnitAliveBJ(caster) then
            DestroyTimer(timer)
            DestroyEffect(effect)
        end

        if ticks >= 6 then
            local loc = GetUnitLoc(caster)
            DestroyTimer(timer)
            DestroyEffect(effect)

            local units = GetUnitsInRange_EnemyGroundTargetable(caster, loc, 550)
            for i = 1, #units do
                if caster ~= units[i] then
                    CauseMagicDamage_Fire(caster, units[i], baseDamage)
                    AddSpecialEffectTargetUnitBJ("chest", units[i], "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl")
                    DestroyEffect(GetLastCreatedEffectBJ())
                end
            end

            local doomEffect = CreateEffectAtPoint(loc, "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", 5.00)
            BlzSetSpecialEffectScale(doomEffect, 2.40)
            BlzSetSpecialEffectTimeScale(doomEffect, 0.4)

            for i = 1, 24 do
                local missleSourceLoc = GetUnitLoc(caster)
                local missleLoc = PolarProjectionBJ(loc, math.random(250, 700), math.random(0, 360))
                FireProjectile_PointToPoint(missleSourceLoc, missleLoc, "Abilities\\Weapons\\LordofFlameMissile\\LordofFlameMissile.mdl", 370, 0.38, function()
                    RemoveLocation(missleSourceLoc)
                    RemoveLocation(missleLoc)
                end)
            end

            RemoveLocation(loc)
        end
        ticks = ticks + 1

        local maxLife = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
        local damage = maxLife * 0.04
        CauseMagicDamage_Fire(caster, caster, damage)
    end)

    SetRoundCooldown_R(caster, 2)
end
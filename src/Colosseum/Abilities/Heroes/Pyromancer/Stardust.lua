AbilityTrigger_Pyro_Stardust = nil

RegInit(function()
    AbilityTrigger_Pyro_Stardust = AddAbilityCastTrigger('A03L', AbilityTrigger_Pyro_Stardust_Actions)
end)

function AbilityTrigger_Pyro_Stardust_Actions()
    local caster = GetSpellAbilityUnit()
    local dps = 30.00

    -- every tick is 0.5 seconds
    local tickCount = 4 + (1 + GetUnitAbilityLevel(caster, FourCC('A03L')))

    SetUnitInvulnerable(caster, true)
    SetUnitVertexColor(caster, 255, 220, 30, 130)
    SetUnitPathing(caster, false)

    AddSpecialEffectTargetUnitBJ("origin", caster, "Environment\\LargeBuildingFire\\LargeBuildingFire1.mdl")
    local effect = GetLastCreatedEffectBJ()

    local timer = CreateTimer()
    local ticks = 0
    TimerStart(timer, 0.50, true, function()
        if ticks >= tickCount then
            DestroyTimer(timer)
            SetUnitInvulnerable(caster, false)
            SetUnitVertexColor(caster, 255, 255, 255, 255)
            SetUnitPathing(caster, true)
            DestroyEffect(effect)
        end
        ticks = ticks + 1

        local loc = GetUnitLoc(caster)
        local units = GetUnitsInRange_GroundTargetable(caster, loc, 150)
        for i = 1, #units do
            if caster ~= units[i] then
                CauseMagicDamage_Fire(caster, units[i], dps * 0.50)
                AddSpecialEffectTargetUnitBJ("chest", units[i], "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl")
                DestroyEffect(GetLastCreatedEffectBJ())
            end
        end
    end)
end

-- AbilityTrigger_Pyro_Stardust = nil

-- RegInit(function()
--     AbilityTrigger_Pyro_Stardust = AddAbilityCastTrigger('A03L', AbilityTrigger_Pyro_Stardust_Actions)
-- end)

-- function AbilityTrigger_Pyro_Stardust_Actions()
--     local caster = GetSpellAbilityUnit()
--     local casterLoc = GetUnitLoc(caster)
--     local targetLoc = GetSpellTargetLoc()

--     local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A03L'))
--     local damage = 80.00 + (30.00 * abilityLevel)

--     SetUnitInvulnerable(caster, true)
--     ShowUnit(caster, false)
--     PauseUnit(caster, true)

--     FireProjectile_PointToPoint(casterLoc, targetLoc, "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", 1100, 0.08, function()
--         SetUnitInvulnerable(caster, false)
--         ShowUnit(caster, true)
--         PauseUnit(caster, false)
--         SetUnitPositionLoc(caster, targetLoc)
--         SelectUnit(caster, true)

--         local units = GetUnitsInRange_GroundTargetable(caster, targetLoc, 200)
--         for i = 1, #units do
--             if caster ~= units[i] then
--                 CauseMagicDamage_Fire(caster, units[i], damage)
--                 AddSpecialEffectTargetUnitBJ("chest", units[i], "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl")
--                 DestroyEffect(GetLastCreatedEffectBJ())
--             end
--         end

--         RemoveLocation(targetLoc)        
--     end)
-- end
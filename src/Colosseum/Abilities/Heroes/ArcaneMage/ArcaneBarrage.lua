AbilityTrigger_Mage_ArcaneBarrage = nil

RegInit(function()
    AbilityTrigger_Mage_ArcaneBarrage = CreateTrigger()
    TriggerAddAction(AbilityTrigger_Mage_ArcaneBarrage, AbilityTrigger_Mage_ArcaneBarrage_Function)
    TriggerAddCondition(AbilityTrigger_Mage_ArcaneBarrage, Condition(function() return GetUnitTypeId(GetSummonedUnit()) == FourCC('h011') end))
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_Mage_ArcaneBarrage, EVENT_PLAYER_UNIT_SUMMON)

    RegisterTriggerEnableById(AbilityTrigger_Mage_ArcaneBarrage, FourCC('H010'))
end)

function AbilityTrigger_Mage_ArcaneBarrage_Function()
    local caster = GetSummoningUnit()
    local markerUnit = GetSummonedUnit()

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A083'))
    local damage = 40 + (abilityLevel * 15)

    local timer = CreateTimer()
    local boltTime = 0.33
    TimerStart(timer, 0.03, true, function()
        local order = OrderId2String(GetUnitCurrentOrder(caster))
        if (not (order == "tornado")) then
            DestroyTimer(timer)
            return
        end

        boltTime = boltTime - 0.03
        if boltTime > 0.00 then
            return
        end

        boltTime = 0.20 + (GetRandomReal(0.00, 1.00) * 0.23)

        local casterLoc = GetUnitLoc(caster)
        local markerLoc = GetUnitLoc(markerUnit)
        local targetLoc = PolarProjectionBJ(markerLoc, math.random(0, 140), math.random(0, 360))
        --Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl
        local projectile = FireProjectile_PointToPoint(casterLoc, targetLoc, "war3mapImported\\HolyExplosion.mdl", 1600, 0.18, function()
            AbilityTrigger_Mage_PeekArcane_Resolve(caster)
            local trgts = GetUnitsInRange_EnemyTargetable(caster, targetLoc, 160)
            for i = 1, #trgts do
                CauseMagicDamage(caster, trgts[i], damage)
            end

            RemoveLocation(casterLoc)
            RemoveLocation(markerLoc)
            RemoveLocation(targetLoc)
        end)
    end)

    SetRoundCooldown_R(caster, 3)
end
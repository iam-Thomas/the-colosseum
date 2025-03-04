AbilityTrigger_Lich_FateOfTheLiving = nil

RegInit(function()
    AbilityTrigger_Lich_FateOfTheLiving = AddAbilityCastTrigger('A0A0', AbilityTrigger_Lich_FateOfTheLiving_Actions)
end)

function AbilityTrigger_Lich_FateOfTheLiving_Actions()
    local caster = GetSpellAbilityUnit()
    local startPoint = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A0A0'))
    local damageMax = 300.00 + (200.00 * abilityLevel)

    FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdl", 750, 0, function()
        RemoveLocation(startPoint)

        local point = GetUnitLoc(target)
        local lifeMax = GetUnitState(target, UNIT_STATE_MAX_LIFE)
        local percentDamage = lifeMax * 0.20
        local damage = math.min(percentDamage, damageMax)

        CauseMagicDamage(caster, target, damage)
        AbilityFunction_Undead_InfestTarget(caster, target, 5.0)
        CreateEffectAtPoint(point, "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", 2.0)
        RemoveLocation(point)

        local timerTime = 0.0
        local timer = CreateTimer()
        TimerStart(timer, 0.1, true, function()
            timerTime = timerTime + 0.1
            if timerTime >= 8.0 then
                DestroyTimer(timer)
            end

            if not IsUnitAliveBJ(target) then
                DestroyTimer(timer)
                
                local dieLoc = GetUnitLoc(target)
                AbilityTrigger_Lich_Fear_InflictFearAoE(caster, dieLoc, 600)
            end
        end)
    end, 3.5)

    SetRoundCooldown_R(caster, 0)
end
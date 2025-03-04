AbilityTrigger_Lich_Decay = nil

RegInit(function()
    AbilityTrigger_Lich_Decay = AddAbilityCastTrigger('A05E', AbilityTrigger_Lich_Decay_Actions)
end)

function AbilityTrigger_Lich_Decay_Actions()
    local caster = GetSpellAbilityUnit()
    local sourceUnit = caster
    local target = GetSpellTargetUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A05E'))
    local dps = 6.00 + (3.00 * abilityLevel)
    local maxDps = 12.00 + (6.00 * abilityLevel)

    local nTicksDefault = 20
    local nTicksEmpowered = 10000

    local point = GetUnitLoc(sourceUnit)
    FireHomingProjectile_PointToUnit(point, target, "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl", 850, 0.21, function()
        local ticks = nTicksDefault
        if IsUnitEmpowered(caster) then
            ticks = nTicksEmpowered
        end

        PeriodicCallback(1.0, function()
            if ticks < 1 then
                return true
            end
            ticks = ticks - 1
    
            if not IsUnit_Targetable(target) then
                return true
            end

            local lifePercent = GetUnitLifePercent(target)
            local t = 1.00 - (lifePercent / 100.00)
            local damage = Decay_Lerp(dps, maxDps, t)
    
            CreateEffectOnUnit("chest", target, "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl", 2.00)
            CauseMagicDamage(caster, target, damage)
        end)
    end)
end

function Decay_Lerp(min, max, t)
    return min + (max - min) * t
end

-- decay, old
-- AbilityTrigger_Lich_Decay = nil

-- RegInit(function()
--     AbilityTrigger_Lich_Decay = AddAbilityCastTrigger('A05E', AbilityTrigger_Lich_Decay_Actions)
-- end)

-- function AbilityTrigger_Lich_Decay_Actions()
--     local caster = GetSpellAbilityUnit()
--     local sourceUnit = caster
--     local target = GetSpellTargetUnit()
--     local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A05E'))
--     local damage = 4.00 + (2.00 * abilityLevel)
--     local maxDps = 15.00 + (5.00 * abilityLevel)

--     local nTicksDefault = 16
--     local nTicksEmpowered = 10000

--     AbilityTrigger_Lich_Decay_Recursive(caster, sourceUnit, target, damage, maxDps, nTicksDefault, nTicksEmpowered)
-- end

-- function AbilityTrigger_Lich_Decay_Recursive(caster, sourceUnit, target, damage, maxDps, nTicksDefault, nTicksEmpowered)
--     local point = GetUnitLoc(sourceUnit)
--     FireHomingProjectile_PointToUnit(point, target, "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl", 850, 0.21, function()
--         local ticks = nTicksDefault
--         if IsUnitEmpowered(caster) then
--             ticks = nTicksEmpowered
--         end

--         PeriodicCallback(1.0, function()
--             if ticks < 1 then
--                 return true
--             end
--             ticks = ticks - 1
    
--             if not IsUnitAliveBJ(target) then
--                 local point = GetUnitLoc(target)
--                 local units = GetUnitsInRange_EnemyTargetable(caster, point, 400.00)
--                 if #units > 0 then
--                     sourceUnit = target
--                     target = units[math.random(1, #units)]
--                     -- recursive call
--                     AbilityTrigger_Lich_Decay_Recursive(caster, sourceUnit, target, damage, maxDps, nTicksDefault, nTicksEmpowered)
--                     -- stop this instance of decay
--                     return true
--                 else
--                     return true
--                 end
--             end
    
--             if not IsUnit_Targetable(target) then
--                 return true
--             end
    
--             CreateEffectOnUnit("chest", target, "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl", 2.00)
--             CauseMagicDamage(caster, target, damage)
--             damage = math.min(damage + 1.00, maxDps)
--         end)
--     end)
-- end
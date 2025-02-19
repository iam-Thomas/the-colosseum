AbilityTrigger_Necro_Monstrosity = nil

RegInit(function()
    AbilityTrigger_Necro_Monstrosity = AddAbilityCastTrigger('A08C', AbilityTrigger_Necro_Monstrosity_Actions)
end)

function AbilityTrigger_Necro_Monstrosity_Actions()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()
    local owner = GetOwningPlayer(caster)
    local facing = GetUnitFacing(caster)

    local summonPoint = GetUnitValidLoc(targetLoc)
    local unit = CreateUnitAtLoc(Player(1), FourCC('u00A'), summonPoint, facing)
    --local unit = CreateUnit(owner, FourCC('u006'), GetLocationX(summonPoint), GetLocationY(summonPoint), 0)
    local hp = BlzGetUnitMaxHP(unit)
    local baseDamage = BlzGetUnitBaseDamage(unit, 0)
    local n = 1

    local friendlies = GetUnitsInRange_FriendlyTargetable(caster, summonPoint, 400.00)
    for i = 1, #friendlies do
        local friendly = friendlies[i]
        if (GetUnitTypeId(friendly)) == FourCC('u006') and friendly ~= unit then
            local friendlyLoc = GetUnitLoc(friendly)
            KillUnit(friendly)
            FireHomingProjectile_PointToUnit(friendlyLoc, unit, "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdl", 125, 0.2, function()
                n = n + 1
                if not IsUnitAliveBJ(unit) then
                    return
                end
        
                local currentHp = BlzGetUnitMaxHP(unit)
                local currentDamage = BlzGetUnitBaseDamage(unit, 0)
                local currentHpPercentage = GetUnitLifePercent(unit)
                BlzSetUnitMaxHP(unit, currentHp + hp)
                BlzSetUnitBaseDamage(unit, currentDamage + baseDamage, 0)
                SetUnitLifePercentBJ(unit, currentHpPercentage)
        
                local squareRoot = math.sqrt(n)
                local scale = 1.00 + ((squareRoot - 1) / 2)
                SetUnitScale(unit, scale, scale, scale)
            end)
            RemoveLocation(friendlyLoc)
        end
    end

    local corpses = GetUnitsInRange_Corpse(caster, summonPoint, 400.00)
    for i = 1, #corpses do
        local corpse = corpses[i]
        local corpseLoc = GetUnitLoc(corpse)
        FireHomingProjectile_PointToUnit(corpseLoc, unit, "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdl", 125, 0.2, function()
            n = n + 1
            if not IsUnitAliveBJ(unit) then
                return
            end
    
            local currentHp = BlzGetUnitMaxHP(unit)
            local currentDamage = BlzGetUnitBaseDamage(unit, 0)
            local currentHpPercentage = GetUnitLifePercent(unit)
            BlzSetUnitMaxHP(unit, currentHp + hp)
            BlzSetUnitBaseDamage(unit, currentDamage + baseDamage, 0)
            SetUnitLifePercentBJ(unit, currentHpPercentage)
    
            local squareRoot = math.sqrt(n)
            local scale = 1.00 + ((squareRoot - 1) / 2)
            SetUnitScale(unit, scale, scale, scale)
        end)
        RemoveLocation(corpseLoc)
    end
    
    local rdEffect = CreateEffectAtPoint(summonPoint, "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", 3.00)
    RemoveLocation(summonPoint)
    RemoveLocation(targetLoc)
end

function AbilityTrigger_Necro_Monstrosity_Projectile(target, location, hp, baseDamage)
    FireHomingProjectile_PointToUnit(location, target, "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdl", 125, 0.2, function()
        n = n + 1
        if not IsUnitAliveBJ(target) then
            return
        end

        local currentHp = BlzGetUnitMaxHP(target)
        local currentDamage = BlzGetUnitBaseDamage(target, 0)
        local currentHpPercentage = GetUnitLifePercent(target)
        BlzSetUnitMaxHP(target, currentHp + hp)
        BlzSetUnitBaseDamage(target, currentDamage + baseDamage, 0)
        SetUnitLifePercentBJ(target, currentHpPercentage)

        local squareRoot = math.sqrt(n)
        local scale = 1.00 + ((squareRoot - 1) / 2)
        SetUnitScale(target, scale, scale, scale)
    end)
end
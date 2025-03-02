ItemTrigger_CloakOfFlames = nil

RegInit(function()
    ItemTrigger_CloakOfFlames = AddItemTrigger_Periodic(FourCC('I008'), 1.0, ItemTrigger_CloakOfFlames_Actions)
end)

function ItemTrigger_CloakOfFlames_Actions(hero)
    local loc = GetUnitLoc(hero)
    local units = GetUnitsInRange_EnemyTargetable(hero, loc, 160.0)

    local armor = BlzGetUnitArmor(hero)
    local damage = 5 + (armor * 0.3)

    for i = 1, #units do
        CauseDefensiveDamage(hero, units[i], damage)
    end
end

CombatEventTrigger_Damage = nil

RegInit(function()
    CombatEventTrigger_Damage = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(CombatEventTrigger_Damage, EVENT_PLAYER_UNIT_DAMAGING)
    TriggerAddAction(CombatEventTrigger_Damage, CombatEventTrigger_Damage_Action)
end)

function CombatEventTrigger_Damage_Action() 

    if (BlzGetEventIsAttack()) then
        return
    end

    local damage = GetEventDamage()

    if (damage < 1.00) then
        return
    end

    local source = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local damageType = BlzGetEventDamageType()

    local factor = GetFactorForDamageType(damageType, source, target)

    BlzSetEventDamage(damage * factor)
end

function GetFactorForDamageType(damageType, source, target)
    local factor = 1.00

    if (damageType == DAMAGE_TYPE_DEFENSIVE) then
        return factor
    elseif (damageType == DAMAGE_TYPE_NORMAL) then
        return factor
    elseif (damageType == DAMAGE_TYPE_ENHANCED) then
        return factor
    elseif (damageType == DAMAGE_TYPE_FORCE) then
        --factor = GetUnitIntMultiplier(source)
        return factor
    elseif (damageType == DAMAGE_TYPE_SONIC) then
        --factor = GetUnitIntMultiplier(source)
        return factor
    else
        factor = GetUnitIntMultiplier(source)

        if IsUnitType(target, UNIT_TYPE_HERO) then
            local int = GetHeroInt(target, true)
            local intFactor = 100.00 / (100.00 + (int * 1.2))
            factor = factor * intFactor
        end
    end

    return factor
end

function GetFactorToExcludeMultiplierFactor(damageType, source, target)
    local factor = GetFactorForDamageType(damageType, source, target)
    local newFactor = 1.00 / factor
    return newFactor
end

function IsDamageType_Defensive(damageType)
    return damageType == DAMAGE_TYPE_DEFENSIVE
end

function IsDamageType_Physical(damageType)
    return damageType == DAMAGE_TYPE_NORMAL
end

function IsDamageType_Magic(damageType)
    return (not IsDamageType_Defensive(damageType)) and (not IsDamageType_Physical(damageType))
end
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

    local factor = 1.00

    if (damageType == DAMAGE_TYPE_DEFENSIVE) then
        --print("DAMAGE_TYPE_DEFENSIVE")
        factor = 1.00    
    elseif (damageType == DAMAGE_TYPE_NORMAL) then
        --print("DAMAGE_TYPE_NORMAL")
        --factor = GetUnitStrMultiplier(source)
        --factor = GetUnitIntMultiplier(source)
    elseif (damageType == DAMAGE_TYPE_FORCE) then
        --print("DAMAGE_TYPE_FORCE")
        factor = GetUnitIntMultiplier(source)
    elseif (damageType == DAMAGE_TYPE_ENHANCED) then
        --print("DAMAGE_TYPE_ENHANCED")
        factor = GetUnitIntMultiplier(source)
    elseif (damageType == DAMAGE_TYPE_SONIC) then
        --print("DAMAGE_TYPE_SONIC")
        factor = GetUnitIntMultiplier(source)
    else
        --print("DAMAGE_TYPE_ else")
        factor = GetUnitIntMultiplier(source)

        if IsUnitType(target, UNIT_TYPE_HERO) then
            local int = GetHeroInt(target, true)
            local intFactor = 100.00 / (100.00 + (int * 1.2))
            factor = factor * intFactor
        end
    end

    BlzSetEventDamage(damage * factor)
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
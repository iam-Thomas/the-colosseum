function IsUnit_Targetable(target)
    if ( not ( IsUnitType(target, UNIT_TYPE_STRUCTURE) == false ) ) then
        return false
    elseif ( not ( IsUnitAliveBJ(target) == true ) ) then
        return false
    elseif ( not ( IsUnitHiddenBJ(target) == false ) ) then
        return false
    elseif ( not ( BlzIsUnitSelectable(target) ) ) then
        return false
    elseif ( not ( BlzIsUnitInvulnerable(target) == false ) ) then
        return false
    elseif ( IsUnitType(target, UNIT_TYPE_MAGIC_IMMUNE) ) then
        return false
    end
    return true
end

function IsUnit_TargetablePhysical(target)
    if ( not ( IsUnitType(target, UNIT_TYPE_STRUCTURE) == false ) ) then
        return false
    elseif ( not ( IsUnitAliveBJ(target) == true ) ) then
        return false
    elseif ( not ( IsUnitHiddenBJ(target) == false ) ) then
        return false
    elseif ( not ( BlzIsUnitSelectable(target) ) ) then
        return false
    elseif ( not ( BlzIsUnitInvulnerable(target) == false ) ) then
        return false
    end
    return true
end

function IsUnit_GroundTargetable(target)
    if ( not ( IsUnitType(target, UNIT_TYPE_STRUCTURE) == false ) ) then
        return false
    elseif ( not ( IsUnitAliveBJ(target) == true ) ) then
        return false
    elseif ( not ( IsUnitHiddenBJ(target) == false ) ) then
        return false
    elseif ( not ( BlzIsUnitSelectable(target) ) ) then
        return false
    elseif ( not ( BlzIsUnitInvulnerable(target) == false ) ) then
        return false
    elseif ( not ( IsUnitType(target, UNIT_TYPE_GROUND) == true ) ) then
        return false
    end
    return true
end

-- Returns true if the 'target' is a targetable ground unit and an enemy of 'caster'
function IsUnit_EnemyTargetable(caster, target)
    if ( not ( IsUnit_Targetable(target) ) ) then
        return false
    elseif ( not ( IsUnitEnemy(target, GetOwningPlayer(caster)) == true ) ) then
        return false
    end
    return true
end

function IsUnit_EnemyTargetablePhysical(caster, target)
    if ( not ( IsUnit_TargetablePhysical(target) ) ) then
        return false
    elseif ( not ( IsUnitEnemy(target, GetOwningPlayer(caster)) == true ) ) then
        return false
    end
    return true
end

function IsUnit_ProjectileTargetable(target)
    if ( not ( IsUnit_Targetable(target) ) ) then
        return false
    elseif ( IsUnitElusive(target) ) then
        return false
    end
    return true
end

-- Returns true if the 'target' is a targetable ground unit and an enemy of 'caster'
function IsUnit_EnemyGroundTargetable(caster, target)
    if ( not ( IsUnit_GroundTargetable(target) ) ) then
        return false
    elseif ( not ( IsUnitEnemy(target, GetOwningPlayer(caster)) == true ) ) then
        return false
    end
    return true
end

function IsUnit_FriendlyTargetable(caster, target)
    if ( not ( IsUnit_Targetable(target) ) ) then
        return false
    elseif ( IsUnitEnemy(target, GetOwningPlayer(caster)) == true ) then
        return false
    end
    return true
end

function IsUnit_FriendlyGroundTargetable(caster, target)
    if ( not ( IsUnit_GroundTargetable(target) ) ) then
        return false
    elseif ( IsUnitEnemy(target, GetOwningPlayer(caster)) == true ) then
        return false
    end
    return true
end

function GetUnitsInRange_Targetable(caster, point, range)
    local result = {}
    local group = GetUnitsInRangeOfLocAll(range, point)
    local nextUnit = FirstOfGroup(group)
    while (not (nextUnit == nil)) do
        if (IsUnit_Targetable(nextUnit)) then
            table.insert(result, nextUnit)
        end
        GroupRemoveUnit(group, nextUnit)
        nextUnit = FirstOfGroup(group)
    end

    DestroyGroup(group)
    group = nil
    nextUnit = nil

    return result
end

function GetUnitsInRange_GroundTargetable(caster, point, range)
    local result = {}
    local group = GetUnitsInRangeOfLocAll(range, point)
    local nextUnit = FirstOfGroup(group)
    while (not (nextUnit == nil)) do
        if (IsUnit_GroundTargetable(nextUnit)) then
            table.insert(result, nextUnit)
        end
        GroupRemoveUnit(group, nextUnit)
        nextUnit = FirstOfGroup(group)
    end

    DestroyGroup(group)
    group = nil
    nextUnit = nil

    return result
end

function GetUnitsInRange_EnemyTargetable(caster, point, range)
    local result = {}
    local group = GetUnitsInRangeOfLocAll(range, point)
    local nextUnit = FirstOfGroup(group)
    while (not (nextUnit == nil)) do
        if (IsUnit_EnemyTargetable(caster, nextUnit)) then
            table.insert(result, nextUnit)
        end
        GroupRemoveUnit(group, nextUnit)
        nextUnit = FirstOfGroup(group)
    end

    DestroyGroup(group)
    group = nil
    nextUnit = nil

    return result
end

function GetUnitsInRange_EnemyTargetablePhysical(caster, point, range)
    local result = {}
    local group = GetUnitsInRangeOfLocAll(range, point)
    local nextUnit = FirstOfGroup(group)
    while (not (nextUnit == nil)) do
        if (IsUnit_EnemyTargetablePhysical(caster, nextUnit)) then
            table.insert(result, nextUnit)
        end
        GroupRemoveUnit(group, nextUnit)
        nextUnit = FirstOfGroup(group)
    end

    DestroyGroup(group)
    group = nil
    nextUnit = nil

    return result
end

function GetUnitsInRange_EnemyGroundTargetable(caster, point, range)
    local result = {}
    local group = GetUnitsInRangeOfLocAll(range, point)
    local nextUnit = FirstOfGroup(group)
    while (not (nextUnit == nil)) do
        if (IsUnit_EnemyGroundTargetable(caster, nextUnit)) then
            table.insert(result, nextUnit)
        end
        GroupRemoveUnit(group, nextUnit)
        nextUnit = FirstOfGroup(group)
    end

    DestroyGroup(group)
    group = nil
    nextUnit = nil

    return result
end

function GetUnitsInRange_FriendlyTargetable(caster, point, range)
    local result = {}
    local group = GetUnitsInRangeOfLocAll(range, point)
    local nextUnit = FirstOfGroup(group)
    while (not (nextUnit == nil)) do
        if (IsUnit_FriendlyTargetable(caster, nextUnit)) then
            table.insert(result, nextUnit)
        end
        GroupRemoveUnit(group, nextUnit)
        nextUnit = FirstOfGroup(group)
    end

    DestroyGroup(group)
    group = nil
    nextUnit = nil

    return result
end

function GetUnitsInRange_FriendlyGroundTargetable(caster, point, range)
    local result = {}
    local group = GetUnitsInRangeOfLocAll(range, point)
    local nextUnit = FirstOfGroup(group)
    while (not (nextUnit == nil)) do
        if (IsUnit_FriendlyGroundTargetable(caster, nextUnit)) then
            table.insert(result, nextUnit)
        end
        GroupRemoveUnit(group, nextUnit)
        nextUnit = FirstOfGroup(group)
    end

    DestroyGroup(group)
    group = nil
    nextUnit = nil

    return result
end

function GetClosestUnitInTableFromPoint(table, point)
    local closestUnit = nil
    local closestDistance = 999999.00
    for i = 1, #table do
        print("checking unit: " .. GetUnitName(table[i]))
        local u = table[i]
        local unitLoc = GetUnitLoc(u)
        local distance = DistanceBetweenPoints(point, unitLoc)
        RemoveLocation(unitLoc)
        if (distance < closestDistance) then
            closestUnit = u
            closestDistance = distance
        end
    end
    return closestUnit
end

function GetClosestUnitInTableFromPoint_NotInGroup(table, point, group)
    local closestUnit = nil
    local closestDistance = 999999.00
    for i = 1, #table do
        print("checking unit: " .. GetUnitName(table[i]))
        local u = table[i]
        if (not IsUnitInGroup(u, group)) then
            local unitLoc = GetUnitLoc(u)
            local distance = DistanceBetweenPoints(point, GetUnitLoc(u))
            RemoveLocation(unitLoc)
            if (distance < closestDistance) then
                closestUnit = u
                closestDistance = distance
            end
        end
    end
    return closestUnit
end

function GetUnitsInRange_Corpse(caster, point, range)
    local result = {}
    local group = GetUnitsInRangeOfLocAll(range, point)
    local nextUnit = FirstOfGroup(group)
    while (not (nextUnit == nil)) do
        if (IsUnitType(nextUnit, UNIT_TYPE_DEAD)) then
            table.insert(result, nextUnit)
        end
        GroupRemoveUnit(group, nextUnit)
        nextUnit = FirstOfGroup(group)
    end

    DestroyGroup(group)
    group = nil
    nextUnit = nil

    return result
end
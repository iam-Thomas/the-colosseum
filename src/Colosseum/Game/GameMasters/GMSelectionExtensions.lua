
function GMSelections_PickRandomGroup(groups, callback)
    local rand = math.random()

    local subgroup = nil
    local rarity = 1
    if rand > 0.97 and (#groups.legendaries > 0) then
        subgroup = groups.legendaries
        rarity = 4
    elseif rand > 0.90 and (#groups.epics > 0) then
        subgroup = groups.epics
        rarity = 3
    elseif rand > 0.50 and (#groups.rares > 0) then
        subgroup = groups.rares
        rarity = 2
    else
        subgroup = groups.commons
    end

    local idx = math.random(1, #subgroup)
    local grp = subgroup[idx]

    for j = 1, #grp do
        local nOfType = grp[j].count
        local unitTypeString = grp[j].unitString
        local unitType = GetUnitTypeFromUnitString(unitTypeString)
        callback(unitType, nOfType, rarity)
    end

    return grp
end

function GMSelections_PickRandomGroup_CommonRare(groups, callback)
    local rand = math.random()

    local subgroup = nil
    local rarity = 1
    if rand > 0.70 and (#groups.rares > 0) then
        subgroup = groups.rares
        rarity = 2
    else
        subgroup = groups.commons
    end

    local idx = math.random(1, #subgroup)
    local grp = subgroup[idx]

    for j = 1, #grp do
        local nOfType = grp[j].count
        local unitTypeString = grp[j].unitString
        local unitType = GetUnitTypeFromUnitString(unitTypeString)
        callback(unitType, nOfType, rarity)
    end

    return grp
end

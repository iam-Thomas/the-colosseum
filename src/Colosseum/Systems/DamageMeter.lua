-- Leader board creation through lua code seems a bit buggy, so for now we will instantiate the leaderboard using GUI triggers

DamageMeter_Meter = nil
DamageMeter_Leaderboard = nil

RegInit(function()
    DamageMeter_Meter = {
        isStarted = false,
        startTime = 0.00,
        endTime = 0.00,
        damageTable = {},
        getDps = function(self)
            local result = {}
            local time = math.max(1, self.endTime - self.startTime)
            for i = 1, #self.damageTable do
                local dps = self.damageTable[i] / time
                table.insert(result, dps)
            end
        end,
    }
end)

function DamageMeter_Reset()
    DamageMeter_Meter.isStarted = false
    DamageMeter_Meter.damageTable = {}
end

function DamageMeter_AddDamage(unit, target, damageDealt)
    local owner = GetOwningPlayer(unit)
    local playerIndex = GetPlayerId(owner)

    if not DamageMeter_Meter.isStarted then
        DamageMeter_Meter.isStarted = true
        DamageMeter_Meter.startTime = udg_ElapsedTime
    end

    if DamageMeter_Meter.damageTable[playerIndex + 1] == nil then
        DamageMeter_Meter.damageTable[playerIndex + 1] = damageDealt
    else
        DamageMeter_Meter.damageTable[playerIndex + 1] = DamageMeter_Meter.damageTable[playerIndex + 1] + damageDealt
    end

    DamageMeter_Meter.endTime = udg_ElapsedTime
end

function DamageMeter_GetTotalDamage(player)
    local playerIndex = GetPlayerId(player)
    return math.ceil(DamageMeter_Meter.damageTable[playerIndex + 1])
end

function DamageMeter_GetTotalDps(player)
    local playerIndex = GetPlayerId(player)
    local time = math.max(1, DamageMeter_Meter.endTime - DamageMeter_Meter.startTime)
    local dps = DamageMeter_Meter.damageTable[playerIndex + 1] / time
    return math.ceil(dps)
end
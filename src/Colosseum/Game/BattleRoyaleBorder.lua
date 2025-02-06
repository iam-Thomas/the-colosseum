BattleRoyaleTimer = nil
BattleRoyale_StartTime = 0.00
BattleRoyale_Width = 0.00
BattleRoyale_Height = 0.00
BattleRoyale_TargetWidth = 0.00
BattleRoyale_TargetHeight = 0.00
BattleRoyale_Time = 0.00
BattleRoyale_DamageTime = 0.00

BattleRoyale_LightningTop = nil
BattleRoyale_LightningRight = nil
BattleRoyale_LightningBot = nil
BattleRoyale_LightningLeft = nil

function BattleRoyale_Begin()
    if not (BattleRoyaleTimer == nil) then
        DestroyTimer(BattleRoyaleTimer)
    end

    BattleRoyaleTimer = CreateTimer()
    BattleRoyale_StartTime = udg_ElapsedTime
    BattleRoyale_Width = 2400.00
    BattleRoyale_Height = 3000.00
    BattleRoyale_TargetWidth = 2400.00
    BattleRoyale_TargetHeight = 3000.00
    BattleRoyale_Time = 0.00
    BattleRoyale_DamageTime = 0.00    

    TimerStart(BattleRoyaleTimer, 0.03, true, function()
        BattleRoyale_Update()
    end)
end

function BattleRoyale_End()
    DestroyTimer(BattleRoyaleTimer)
    if BattleRoyale_LightningTop == nil then
        return
    end
    DestroyLightning(BattleRoyale_LightningTop)
    BattleRoyale_LightningTop = nil
    DestroyLightning(BattleRoyale_LightningRight)
    BattleRoyale_LightningRight = nil
    DestroyLightning(BattleRoyale_LightningBot)
    BattleRoyale_LightningBot = nil
    DestroyLightning(BattleRoyale_LightningLeft)
    BattleRoyale_LightningLeft = nil
end

function BattleRoyale_Update()
    BattleRoyale_Time = BattleRoyale_Time + 0.03
    BattleRoyale_DamageTime = BattleRoyale_DamageTime + 0.03

    if BattleRoyale_Time > 180.00 then
        BattleRoyale_TargetWidth = 50.00
        BattleRoyale_TargetHeight = 50.00
    elseif BattleRoyale_Time > 120.00 then
        BattleRoyale_TargetWidth = 600.00
        BattleRoyale_TargetHeight = 600.00
    elseif BattleRoyale_Time > 90.00 then
        BattleRoyale_TargetWidth = 2000.00
        BattleRoyale_TargetHeight = 1500.00
    elseif BattleRoyale_Time > 87.00 then
        if BattleRoyale_LightningTop == nil then
            BattleRoyale_LightningTop = AddLightning("CLPB", true, -BattleRoyale_Width, BattleRoyale_Height, BattleRoyale_Width, BattleRoyale_Height)
            BattleRoyale_LightningRight = AddLightning("CLPB", true, BattleRoyale_Width, -BattleRoyale_Height, BattleRoyale_Width, BattleRoyale_Height)
            BattleRoyale_LightningBot = AddLightning("CLPB", true, -BattleRoyale_Width, -BattleRoyale_Height, BattleRoyale_Width, -BattleRoyale_Height)
            BattleRoyale_LightningLeft = AddLightning("CLPB", true, -BattleRoyale_Width, BattleRoyale_Height, -BattleRoyale_Width, -BattleRoyale_Height)
        end
    end

    if BattleRoyale_Width > BattleRoyale_TargetWidth then
        BattleRoyale_Width = BattleRoyale_Width - 80 * 0.03
    end

    if BattleRoyale_Height > BattleRoyale_TargetHeight then
        BattleRoyale_Height = BattleRoyale_Height - 80 * 0.03
    end
    
    -- update visuals
    MoveLightning(BattleRoyale_LightningTop, true, -BattleRoyale_Width, BattleRoyale_Height, BattleRoyale_Width, BattleRoyale_Height)
    MoveLightning(BattleRoyale_LightningRight, true, BattleRoyale_Width, -BattleRoyale_Height, BattleRoyale_Width, BattleRoyale_Height)
    MoveLightning(BattleRoyale_LightningBot, true, -BattleRoyale_Width, -BattleRoyale_Height, BattleRoyale_Width, -BattleRoyale_Height)
    MoveLightning(BattleRoyale_LightningLeft, true, -BattleRoyale_Width, BattleRoyale_Height, -BattleRoyale_Width, -BattleRoyale_Height)

    if BattleRoyale_DamageTime >= 1.00 then
        BattleRoyale_DamageTime = 0.00
        BattleRoyale_DamageUnits()
    end
end

function BattleRoyale_DamageUnits()
    local groupFunction = function()
        local unit = GetEnumUnit()
        local doDamage = BattleRoyale_ShouldDamageUnitByPosition(unit)
        if doDamage then
            BattleRoyale_DamageUnit(unit)
        end
    end
    
    --udg_GameMasterUnits
    ForGroup(udg_GameMasterUnits, groupFunction)

    --udg_GladiatorHeroes
    ForGroup(udg_GladiatorHeroes, groupFunction)

    --udg_GladiatorUnits
    ForGroup(udg_GladiatorUnits, groupFunction)
end

function BattleRoyale_ShouldDamageUnitByPosition(unit)
    if unit == nil then
        return false
    end

    local unitLoc = GetUnitLoc(unit)
    local x = GetLocationX(unitLoc)
    local y = GetLocationY(unitLoc)

    -- check if the unit is inside the battle royale area
    return (x > BattleRoyale_Width or x < -BattleRoyale_Width or y > BattleRoyale_Height or y < -BattleRoyale_Height)
end

function BattleRoyale_DamageUnit(unit)
    if unit == nil then
        return
    end

    if not IsUnitAliveBJ(unit) then
        return
    end

    local maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE)
    local life = GetUnitState(unit, UNIT_STATE_LIFE)
    local trueDamage = maxLife * 0.10
    local loc = GetUnitLoc(unit)
    SetUnitState(unit, UNIT_STATE_LIFE, life - trueDamage)
    CreateEffectAtPoint(loc, "Abilities\\Weapons\\Bolt\\BoltImpact.mdl", 1.5)
    RemoveLocation(loc)
end
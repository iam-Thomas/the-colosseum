AbilityTrigger_BS_RainDance_Hashtable = nil
AbilityTrigger_BS_RainDance_Summon = nil
AbilityTrigger_BS_RainDance_Damaged = nil
AbilityTrigger_BS_RainDance_HailStorm = nil

RegInit(function()
    AbilityTrigger_BS_RainDance_Hashtable = InitHashtable()

    AbilityTrigger_BS_RainDance_Summon = CreateTrigger()
    TriggerAddAction(AbilityTrigger_BS_RainDance_Summon, AbilityTrigger_BS_RainDance_Summon_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_BS_RainDance_Summon, EVENT_PLAYER_UNIT_SUMMON)

    AbilityTrigger_BS_RainDance_Damaged = CreateTrigger()
    TriggerAddAction(AbilityTrigger_BS_RainDance_Damaged, AbilityTrigger_BS_RainDance_Damaged_Actions)
    TriggerAddCondition(AbilityTrigger_BS_RainDance_Damaged, Condition(function() return GetUnitTypeId(BlzGetEventDamageTarget()) == FourCC('O002') end))
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_BS_RainDance_Damaged, EVENT_PLAYER_UNIT_DAMAGED)
    
    AbilityTrigger_BS_RainDance_HailStorm = AddAbilityCastTrigger('A02D', AbilityTrigger_BS_RainDance_HailStorm)

    RegisterTriggerEnableById(AbilityTrigger_BS_RainDance_Summon, FourCC('O002'))
    RegisterTriggerEnableById(AbilityTrigger_BS_RainDance_Damaged, FourCC('O002'))
    RegisterTriggerEnableById(AbilityTrigger_BS_RainDance_HailStorm, FourCC('O002'))
end)

function AbilityTrigger_BS_RainDance_Summon_Actions()
    local summoned = GetSummonedUnit()

    local utid = GetUnitTypeId(summoned)
    if (not (utid == FourCC('h00Q'))) then
        return
    end

    local summoner = GetSummoningUnit()
    
    SaveUnitHandle(AbilityTrigger_BS_RainDance_Hashtable, GetHandleId(summoner), 0, summoned)

    local abilityLevel = GetUnitAbilityLevel(summoner, FourCC('A02B'))

    if (abilityLevel > 1) then
        UnitAddAbility(summoned, FourCC('A01K'))
    end

    if (abilityLevel > 3) then
        UnitAddAbility(summoned, FourCC('A02D'))
    end

    -- Healing rain
    local rainEffect = AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl", summoned, "origin")    
    local timer = CreateTimer()
    TimerStart(timer, 1, true, function()
        if (not IsUnitAliveBJ(summoned)) then
            DestroyTimer(timer)
            DestroyEffect(rainEffect)
        end
        
        local loc = GetUnitLoc(summoned)
        local unitsToHeal = GetUnitsInRange_FriendlyGroundTargetable(summoned, loc, 500.00)

        local healing = 5.00
        local baseDamage = BlzGetUnitBaseDamage(summoned, 0)
        local multiplier = 1.00 + (baseDamage * 0.02)
        
        for i = 1, #unitsToHeal do
            CauseHealUnscaled(summoner, unitsToHeal[i], healing * multiplier)
        end

        RemoveLocation(loc)
    end)
end

function AbilityTrigger_BS_RainDance_Damaged_Actions()
    local target = BlzGetEventDamageTarget()
    local id = GetHandleId(target)
    local summoned = LoadUnitHandle(AbilityTrigger_BS_RainDance_Hashtable, id, 0)
    
    if summoned == nil then
        return
    end

    if not IsUnitAliveBJ(summoned) then
        return
    end

    local damage = GetEventDamage()
    local life = GetUnitState(summoned, UNIT_STATE_LIFE)
    local target = life - damage
    SetUnitLifeBJ(summoned, target)
end


function AbilityTrigger_BS_RainDance_HailStorm()
    local caster = GetSpellAbilityUnit()
    local targetPoint = GetSpellTargetLoc()
    local data = {}

    local baseDamage = BlzGetUnitBaseDamage(caster, 0)
    local multiplier = (100 + (baseDamage * 2)) / 100.00
    local damage = 10.00 * multiplier

    local t = 0.00
    local tLimit = 12

    local timer = CreateTimer()
    TimerStart(timer, 0.15, true, function()
        t = t + 0.15
        if t > tLimit then
            RemoveLocation(targetPoint)
            DestroyTimer(timer)
        end
        
        for i = 1, #data do
            local instanceT = data[i][1]
            if (instanceT < 0.6) then
                data[i][1] = instanceT + 0.15
            elseif (data[i][4]) then
                local targets = GetUnitsInRange_EnemyGroundTargetable(caster, data[i][2], 110)
                for j = 1, #targets do
                    CauseMagicDamage(caster, targets[j], damage)
                end
                
                data[i][4] = false
                RemoveLocation(data[i][2])
                DestroyEffect(data[i][3])
            end
        end

        if t + 2.00 >= tLimit then
            return
        end

        local effectT = 0
        local effectLoc = PolarProjectionBJ(targetPoint, 420 * math.random(), 360 * math.random())
        local effect = AddSpecialEffectLoc("Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl", effectLoc)
        TriggerExecute(gg_trg_SFX_Cleanup)
        local arr = { effectT, effectLoc, effect, true }
        data[#data + 1] = arr
    end)
end

--GetUnitsInRange_FriendlyGroundTargetable
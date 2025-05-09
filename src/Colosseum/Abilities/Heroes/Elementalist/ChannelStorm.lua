AbilityTrigger_BS_ChannelStorm = nil
AbilityTrigger_BS_ChannelStorm_Damaging = nil
AbilityTrigger_BS_ChannelStorm_Hashtable = nil

RegInit(function()
    AbilityTrigger_BS_ChannelStorm_Hashtable = InitHashtable()
    AbilityTrigger_BS_ChannelStorm = AddAbilityCastTrigger('A05Y', AbilityTrigger_BS_ChannelStorm_Actions)
    AbilityTrigger_BS_ChannelStorm_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A05Y'), AbilityTrigger_BS_ChannelStorm_Damaging_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_BS_ChannelStorm, FourCC('O002'))
    RegisterTriggerEnableById(AbilityTrigger_BS_ChannelStorm_Damaging, FourCC('O002'))
end)

function AbilityTrigger_BS_ChannelStorm_Actions()
    local caster = GetSpellAbilityUnit()
    AbilityTrigger_BS_ChannelStorm_StartRestricted(caster, 20.0)
end

function AbilityTrigger_BS_ChannelStorm_StartRestricted(caster, time)
    local id = GetHandleId(caster)

    -- local sCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 0)
    -- if sCaster ~= nil then
    --     SaveReal(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 1, 0.00)
    -- end

    local eCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 0)
    if eCaster ~= nil then
        SaveReal(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 1, 0.00)
    end

    local fCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelFire_Hashtable, id, 0)
    if fCaster ~= nil then
        SaveReal(AbilityTrigger_BS_ChannelFire_Hashtable, id, 1, 0.00)
    end

    MakeEmpowered(caster, 6)
    AbilityTrigger_BS_ChannelStorm_StartUnrestricted(caster, time)
end

function AbilityTrigger_BS_ChannelStorm_StartUnrestricted(caster, time)
    local id = GetHandleId(caster)

    AddSpecialEffectTargetUnitBJ("origin", caster, "Abilities\\Spells\\Orc\\LightningShield\\LightningShieldTarget.mdl")
    local sfx = GetLastCreatedEffectBJ()

    local t = udg_ElapsedTime + time
    SaveUnitHandle(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 0, caster)
    SaveReal(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 1, t)

    if IsUnitTenacious(caster) then
        local castLoc = GetUnitLoc(caster)
        local slowTargets = GetUnitsInRange_EnemyTargetable(caster, castLoc, 300.00)
        for i = 1, #slowTargets do
            ApplyManagedBuff_MagicElusive(slowTargets[i], FourCC('A0A1'), FourCC('B023'), 3.0, "chest", "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl")
        end
        RemoveLocation(castLoc)
    end

    local interval = 0.2
    local timer = CreateTimer()
    TimerStart(timer, interval, true, function()
        local t = LoadReal(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 1)
        if udg_ElapsedTime > t then
            FlushChildHashtable(AbilityTrigger_BS_ChannelStorm_Hashtable, id)
            DestroyTimer(timer)
            DestroyEffect(sfx)
            return
        end

        if not IsUnitReckless(caster) then
            return
        end

        local casterLoc = GetUnitLoc(caster)
        local chance = 0.1
        local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A05Y'))
        local monsoonDamage = 20.00 + (10.00 * abilityLevel)

        local units = GetUnitsInRange_EnemyTargetable(caster, casterLoc, 450.00)
        local targetIndeces = AbilityTrigger_BS_ChannelStorm_RandomIndeces(#units, 2)
        for i = 1, #targetIndeces do
            local rand = GetRandomReal(0.00, 1.00)
            if rand < chance then
                CauseMagicDamage(caster, units[targetIndeces[i]], monsoonDamage)
                CreateEffectOnUnit("origin", units[targetIndeces[i]], "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", 2.00)
            end            
        end
    end)
end

function AbilityTrigger_BS_ChannelStorm_RandomIndeces(max, n)
    local values = {}
    for i = 1, max do
        table.insert(values, i)
    end
    
    local result = {}
    for i = 1, n do
        if (#values < 1) then
            return result
        end

        local randomIndex = math.random(1, #values)
        local value = values[randomIndex]
        table.insert(result, value)
        table.remove(values, randomIndex)
    end

    return result
end

function AbilityTrigger_BS_ChannelStorm_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local id = GetHandleId(caster)
    local t = LoadReal(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 1)

    if t < udg_ElapsedTime then
        return
    end

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A05Y'))
    local damage = 15.00 + (5.00 * abilityLevel)
    CauseMagicDamage(caster, target, damage)
    CreateEffectOnUnit("chest", target, "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", 0.00)
end

function AbilityTrigger_BS_ChannelStorm_Evoke(caster, location)
    local units = GetUnitsInRange_EnemyTargetable(caster, location, 220.00)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A05Y'))
    local damage = 200.00 + (100.00 * abilityLevel)
    local damageDiff = damage / math.max(1, #units)

    for i = 1, #units do
        CauseMagicDamage(caster, units[i], damageDiff)
    end

    CreateEffectAtPoint(location, "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", 2.0)
    CreateEffectAtPoint(location, "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", 2.0)
end

function AbilityTrigger_BS_ChannelStorm_IsChanneled(caster)
    local id = GetHandleId(caster)
    local t = LoadReal(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 1)
    return udg_ElapsedTime < t
end
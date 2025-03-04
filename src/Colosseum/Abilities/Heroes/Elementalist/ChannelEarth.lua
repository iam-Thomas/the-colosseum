AbilityTrigger_BS_ChannelEarth = nil
AbilityTrigger_BS_ChannelEarth_Damaging_Caster = nil
AbilityTrigger_BS_ChannelEarth_Damaging_Target = nil
AbilityTrigger_BS_ChannelEarth_Hashtable = nil

RegInit(function()
    AbilityTrigger_BS_ChannelEarth_Hashtable = InitHashtable()
    AbilityTrigger_BS_ChannelEarth = AddAbilityCastTrigger('A062', AbilityTrigger_BS_ChannelEarth_Actions)
    AbilityTrigger_BS_ChannelEarth_Damaging_Caster = AddDamagingEventTrigger_CasterHasAbility(FourCC('A062'), AbilityTrigger_BS_ChannelEarth_Damaging_HandleAttacking)
    AbilityTrigger_BS_ChannelEarth_Damaging_Target = AddDamagingEventTrigger_TargetHasAbility(FourCC('A062'), AbilityTrigger_BS_ChannelEarth_Damaging_HandleAttacked)
end)

function AbilityTrigger_BS_ChannelEarth_Actions()
    local caster = GetSpellAbilityUnit()
    AbilityTrigger_BS_ChannelEarth_StartRestricted(caster, 20.00)
end

function AbilityTrigger_BS_ChannelEarth_StartRestricted(caster, time)
    local id = GetHandleId(caster)
    local sCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 0)
    if sCaster ~= nil then
        SaveReal(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 1, 0.00)
    end

    -- local eCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 0)
    -- if eCaster ~= nil then
    --     SaveReal(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 1, 0.00)
    -- end

    local fCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelFire_Hashtable, id, 0)
    if fCaster ~= nil then
        SaveReal(AbilityTrigger_BS_ChannelFire_Hashtable, id, 1, 0.00)
    end

    MakeTenacious(caster, 6)
    AbilityTrigger_BS_ChannelEarth_StartUnrestricted(caster, time)
end

function AbilityTrigger_BS_ChannelEarth_StartUnrestricted(caster, time)
    local id = GetHandleId(caster)

    AddSpecialEffectTargetUnitBJ("origin", caster, "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkTarget.mdl")
    local sfx = GetLastCreatedEffectBJ()
    BlzSetSpecialEffectScale(sfx, 2.0)

    local t = udg_ElapsedTime + time
    SaveUnitHandle(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 0, caster)
    SaveReal(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 1, t)
    SaveInteger(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 2, 5)

    if IsUnitEmpowered(caster) then
        local castLoc = GetUnitLoc(caster)
        AbilityTrigger_BS_ChannelEarth_Evoke(caster, castLoc)
        RemoveLocation(castLoc)
    end

    if IsUnitReckless(caster) then
        local castLoc = GetUnitLoc(caster)
        local targets = GetUnitsInRange_EnemyTargetable(caster, castLoc, 250.00)
        local magmaDamage = 30.00 + (30.00 * GetUnitAbilityLevel(caster, FourCC('A062')))
        for i = 1, 12 do
            local targetMagmaLoc = PolarProjectionBJ(castLoc, math.random(200, 700), math.random(0, 360))
            FireProjectile_PointToPoint_NoPitch(castLoc, targetMagmaLoc, "Abilities\\Weapons\\DemolisherFireMissile\\DemolisherFireMissile.mdl", 450, 0.35, function()
                local magmaTargets = GetUnitsInRange_EnemyTargetable(caster, targetMagmaLoc, 130.00)
                for j = 1, #magmaTargets do
                    CauseMagicDamage_Fire(caster, magmaTargets[j], magmaDamage)
                    MakeBurnt(magmaTargets[j], 8.0)
                end
                RemoveLocation(targetMagmaLoc)
            end)
        end
        RemoveLocation(castLoc)
    end

    local interval = 0.1
    local timer = CreateTimer()
    TimerStart(timer, interval, true, function()
        local t = LoadReal(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 1)
        if udg_ElapsedTime > t then
            FlushChildHashtable(AbilityTrigger_BS_ChannelEarth_Hashtable, id)
            DestroyTimer(timer)
            DestroyEffect(sfx)
            return
        end
    end)
end

function AbilityTrigger_BS_ChannelEarth_Damaging_HandleAttacking(id, caster, target)
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local id = GetHandleId(caster)
    local t = LoadReal(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 1)
    if t < udg_ElapsedTime then
        return
    end

    local attackCount = LoadInteger(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 2)
    if attackCount < 5 then
        local toAdd = 1
        if IsUnitEmpowered(caster) then
            toAdd = 2
        end
        SaveInteger(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 2, attackCount + toAdd)
        return
    end

    SaveInteger(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 2, 0)
    CauseStun1s(caster, target)
end

function AbilityTrigger_BS_ChannelEarth_Damaging_HandleAttacked(id, caster, target)
    local target = GetEventDamageSource()
    local caster = BlzGetEventDamageTarget()
    local id = GetHandleId(caster)
    local t = LoadReal(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 1)
    if t < udg_ElapsedTime then
        return
    end

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A062'))
    local factor = 0.9 - (0.05 * abilityLevel)

    local damage = GetEventDamage()
    BlzSetEventDamage(damage * factor)
end

function AbilityTrigger_BS_ChannelEarth_Evoke(caster, location)
    local units = GetUnitsInRange_EnemyTargetable(caster, location, 250.00)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A062'))
    local damage = 40.00 + (25.00 * abilityLevel)
    local damageDiff = damage / math.max(1, #units)

    for i = 1, #units do
        CauseStun3s(caster, units[i])
        CauseMagicDamage(caster, units[i], damage)
    end

    CreateEffectAtPoint(location, "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", 2.0)
end

function AbilityTrigger_BS_ChannelEarth_IsChanneled(caster)
    local id = GetHandleId(caster)
    local t = LoadReal(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 1)
    return udg_ElapsedTime < t
end
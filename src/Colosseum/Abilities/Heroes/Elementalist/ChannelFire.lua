AbilityTrigger_BS_ChannelFire = nil
AbilityTrigger_BS_ChannelFire_Damaging = nil
AbilityTrigger_BS_ChannelFire_Hashtable = nil

RegInit(function()
    AbilityTrigger_BS_ChannelFire_Hashtable = InitHashtable()
    AbilityTrigger_BS_ChannelFire = AddAbilityCastTrigger('A00Y', AbilityTrigger_BS_ChannelFire_Actions)
    AbilityTrigger_BS_ChannelFire_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A00Y'), AbilityTrigger_BS_ChannelFire_Damaging_Actions)
end)

function AbilityTrigger_BS_ChannelFire_Actions()
    local caster = GetSpellAbilityUnit()
    AbilityTrigger_BS_ChannelFire_StartUnrestricted(caster, 20.00)
end

function AbilityTrigger_BS_ChannelFire_StartRestricted(caster, time)
    local id = GetHandleId(caster)
    local sCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 0)
    if sCaster ~= nil then
        SaveReal(AbilityTrigger_BS_ChannelStorm_Hashtable, id, 1, 0.00)
    end

    local eCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 0)
    print(eCaster)
    if eCaster ~= nil then
        SaveReal(AbilityTrigger_BS_ChannelEarth_Hashtable, id, 1, 0.00)
    end

    -- local fCaster = LoadUnitHandle(AbilityTrigger_BS_ChannelFire_Hashtable, id, 0)
    -- if fCaster ~= nil then
    --     SaveReal(AbilityTrigger_BS_ChannelFire_Hashtable, id, 1, 0.00)
    -- end
end

function AbilityTrigger_BS_ChannelFire_StartUnrestricted(caster, time)
    local id = GetHandleId(caster)
    
    local t = udg_ElapsedTime + time
    SaveUnitHandle(AbilityTrigger_BS_ChannelFire_Hashtable, id, 0, caster)
    SaveReal(AbilityTrigger_BS_ChannelFire_Hashtable, id, 1, t)  

    AddSpecialEffectTargetUnitBJ("hand left", caster, "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl")
    local sfxA = GetLastCreatedEffectBJ()
    AddSpecialEffectTargetUnitBJ("hand right", caster, "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl")
    local sfxB = GetLastCreatedEffectBJ()

    local interval = 0.1
    local timer = CreateTimer()
    TimerStart(timer, interval, true, function()
        local t = LoadReal(AbilityTrigger_BS_ChannelFire_Hashtable, id, 1)
        if udg_ElapsedTime > t then
            FlushChildHashtable(AbilityTrigger_BS_ChannelFire_Hashtable, id)
            DestroyTimer(timer)
            DestroyEffect(sfxA)
            DestroyEffect(sfxB)
            return
        end
    end) 
end

function AbilityTrigger_BS_ChannelFire_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local id = GetHandleId(caster)
    local t = LoadReal(AbilityTrigger_BS_ChannelFire_Hashtable, id, 1)

    if t < udg_ElapsedTime then
        return
    end

    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A00Y'))
    local damage = 30.00 + (10.00 * abilityLevel)
    -- CauseMagicDamage_Fire(caster, target, damage)
    -- CreateEffectOnUnit("chest", target, "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl", 0.0)

    local chance = 0.20
    if IsUnitEmpowered(caster) then
        chance = 0.50
    end

    if (math.random() > chance) then
        return
    end

    local casterLoc = GetUnitLoc(caster)
    local casterFacing = GetUnitFacing(caster)
    local damageLoc = PolarProjectionBJ(casterLoc, 190, casterFacing)
    local effectLoc = PolarProjectionBJ(casterLoc, 270, casterFacing)
    
    local units = GetUnitsInRange_EnemyTargetable(caster, damageLoc, 190)
    for i = 1, #units do
        CauseMagicDamage_Fire(caster, units[i], damage)
    end

    local breathEffect = CreateEffectAtPoint(effectLoc, "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireMissile.mdl", 3.0)
    BlzSetSpecialEffectYaw(breathEffect, casterFacing / 57,2958)
    RemoveLocation(casterLoc)
    RemoveLocation(damageLoc)
    RemoveLocation(effectLoc)
end

function AbilityTrigger_BS_ChannelFire_Evoke(caster, location)
    local locReal = Location(GetLocationX(location), GetLocationY(location))
    local timer = CreateTimer()
    local ticks = 10

    CreateEffectAtPoint(locReal, "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl", 3.0)
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A00Y'))
    local tickDamage = 6.00 + (3.00 * abilityLevel)

    local effects = {}
    for i = 1, 24 do
        local loc = PolarProjectionBJ(locReal, math.random(15, 290), math.random(0, 210))
        AddSpecialEffectLocBJ(loc, "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl")
        table.insert( effects, GetLastCreatedEffectBJ() )
        --table.insert(effects, CreateEffectAtPoint(loc, "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl", 10.0))
        RemoveLocation(loc)
    end

    TimerStart(timer, 1.0, true, function()
        ticks = ticks - 1
        if ticks < 1 then
            for i = 1, #effects do
                DestroyEffect(effects[i])
            end
            RemoveLocation(locReal)
            DestroyTimer(timer)
        end

        local targets = GetUnitsInRange_EnemyTargetable(caster, locReal, 230.00)
        for i = 1, #targets do
            CauseMagicDamage_Fire(caster, targets[i], tickDamage)
        end
    end)
end

function AbilityTrigger_BS_ChannelFire_IsChanneled(caster)
    local id = GetHandleId(caster)
    local t = LoadReal(AbilityTrigger_BS_ChannelFire_Hashtable, id, 1)
    return udg_ElapsedTime < t
end
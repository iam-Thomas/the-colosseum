AbilityTrigger_BEST_Obliterate_Cast = nil
AbilityTrigger_BEST_Obliterate = nil

RegInit(function()
    AbilityTrigger_BEST_Obliterate_Cast = AddAbilityCastTrigger('A02R', AbilityTrigger_BEST_Obliterate_Cast_Actions)

    AbilityTrigger_BEST_Obliterate = CreateTrigger()
    TriggerAddCondition(AbilityTrigger_BEST_Obliterate, Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), FourCC('A02R')) > 0 end))
    TriggerAddAction(AbilityTrigger_BEST_Obliterate, AbilityTrigger_BEST_Obliterate_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_BEST_Obliterate, EVENT_PLAYER_UNIT_DAMAGING)

    RegisterTriggerEnableById(AbilityTrigger_BEST_Obliterate_Cast, FourCC('O004'))
    RegisterTriggerEnableById(AbilityTrigger_BEST_Obliterate, FourCC('O004'))
end)

function AbilityTrigger_BEST_Obliterate_Actions()
    local caster = GetEventDamageSource()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A02R'))

    -- local remainingCooldown = BlzGetUnitAbilityCooldownRemaining(caster, FourCC('A02R'))
    -- if remainingCooldown > 0.00 then
    --     print("remainingCooldown: " .. tostring(remainingCooldown))
    --     local targetCooldown = remainingCooldown + 1.00
    --     targetCooldown = math.min(16.00, targetCooldown)
    --     print("caster: " .. GetUnitName(caster))
    --     print("abilityCode: " .. tostring(FourCC('A02R')))
    --     print("abilityLevel: " .. tostring(abilityLevel))
    --     print("target cd: " .. tostring(targetCooldown))
    --     BlzSetUnitAbilityCooldown(caster, FourCC('A02R'), abilityLevel, targetCooldown)
    --     print("cd set")
    -- end

    if UnitHasBuffBJ(caster, FourCC('B00I')) then
        local strength = GetHeroStr(caster, true)
        local damage = GetEventDamage()
        bonusDamage = strength * 5.00
        BlzSetEventDamage(damage + bonusDamage)
        AddSpecialEffectLocBJ(loc, "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
        udg_SFXDurationArg = 2
        TriggerExecute(gg_trg_SFX_Cleanup)
        -- The buff should be removed here! But since the "Rage" ability needs to detected whether the caster has the buff, the buff is instead removed there!
        if (GetUnitAbilityLevel(GetAttackedUnitBJ(), FourCC('A02S') < 1)) then
            -- If for some (future) reason the caster does not have the rage ability, remove it here as a safeguard
            UnitRemoveBuffBJ(FourCC('B00I'), caster)
        end
    end
end

function AbilityTrigger_BEST_Obliterate_Cast_Actions()
    local caster = GetSpellAbilityUnit()
    UnitAddAbility(caster, FourCC('A004'))    
end
AbilityTrigger_Mage_PeekArcane_Hashtable = nil
AbilityTrigger_Mage_PeekArcane = nil
AbilityTrigger_Mage_PeekArcane_Damaging = nil

RegInit(function()
    AbilityTrigger_Mage_PeekArcane_Hashtable = InitHashtable()
    AbilityTrigger_Mage_PeekArcane = AddAbilityCastTrigger_CasterHasAbility(FourCC('A084'), AbilityTrigger_Mage_PeekArcane_Function)
    AbilityTrigger_Mage_PeekArcane_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A084'), AbilityTrigger_Mage_PeekArcane_Damaging_Resolve)
end)

function AbilityTrigger_Mage_PeekArcane_Function()
    local caster = GetSpellAbilityUnit()
    AbilityTrigger_Mage_PeekArcane_Resolve(caster)
end

function AbilityTrigger_Mage_PeekArcane_Resolve(caster)
    -- removeing this if statement will may cause this ability to trigger event if the caster does not have the ability
    -- since other abilities may trigger this function.
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A084'))
    if abilityLevel < 1 then
        return
    end

    local id = GetHandleId(caster)

    if not (UnitHasBuffBJ(caster, FourCC('B017'))) then
        FlushChildHashtable(AbilityTrigger_Mage_PeekArcane_Hashtable, id)
        local timer = CreateTimer()
        TimerStart(timer, 0.33, true, function()
            if not (UnitHasBuffBJ(caster, FourCC('B017'))) then
                DestroyTimer(timer)
                return
            end
            local nInTimer = LoadInteger(AbilityTrigger_Mage_PeekArcane_Hashtable, id, 0)
            local mana = GetUnitState(caster, UNIT_STATE_MANA)
            local manaDrain = -(0.5 * nInTimer) * 0.33
            if IsUnitEmpowered(caster) then
                manaDrain = manaDrain * -1
            end

            -- negative values have gotten a bit complicated here :/
            if (manaDrain * -1) > mana then
                local manaToDamage = mana + manaDrain
                local maxLife = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
                -- every mana drained, will cause 0.5% of the max life as magic damage
                local manaBurnDamage = maxLife * manaToDamage * 0.005 * -1
                CauseDefensiveDamage(caster, caster, manaBurnDamage)
                CreateEffectOnUnit("origin", caster, "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl", 1.0)
            end
            SetUnitState(caster, UNIT_STATE_MANA, mana + manaDrain)
        end)
    end

    ApplyManagedBuff_Magic(caster, FourCC('S001'), FourCC('B017'), 4.0, nil, nil)
    local n = LoadInteger(AbilityTrigger_Mage_PeekArcane_Hashtable, id, 0)
    SaveInteger(AbilityTrigger_Mage_PeekArcane_Hashtable, id, 0, n + 1)
end

function AbilityTrigger_Mage_PeekArcane_Damaging_Resolve(caster)
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local damageType = BlzGetEventDamageType()
    if not IsDamageType_Magic(damageType) then
        return
    end

    local caster = GetEventDamageSource()
    local id = GetHandleId(caster)
    local n = LoadInteger(AbilityTrigger_Mage_PeekArcane_Hashtable, id, 0)
    local intMutliplier = GetUnitIntMultiplier(caster)
    local peekFactor = (0.05 * n)
    local intPlusPeekFactor = intMutliplier + peekFactor
    local factor = (intPlusPeekFactor / intMutliplier)
    BlzSetEventDamage(GetEventDamage() * factor)
end
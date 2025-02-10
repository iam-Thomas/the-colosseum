ItemTrigger_ArchmagesStaff = nil

RegInit(function()
    ItemTrigger_ArchmagesStaff = AddAbilityCastTrigger_CasterHasItem(FourCC('I00A'), ItemTrigger_ArchmagesStaff_Actions)
end)

function ItemTrigger_ArchmagesStaff_Actions()
    local caster = GetSpellAbilityUnit()
    local cooldownRemaining = BlzGetUnitAbilityCooldownRemaining(caster, FourCC('A074'))

    if cooldownRemaining > 0 then
        return
    end

    local manaToRestore = 40.00
    local manaToRestoreSecondary = 20.00

    local abilityId = GetSpellAbilityId()
    local abilityLevel = GetUnitAbilityLevel(caster, abilityId)
    local manaCost = BlzGetUnitAbilityManaCost(caster, abilityId, abilityLevel - 1)
    local manaAtCast = GetUnitState(caster, UNIT_STATE_MANA)
    local manaAfterCast = manaAtCast - manaCost
    local manaPercentAfterCast = manaAfterCast / GetUnitState(caster, UNIT_STATE_MAX_MANA) * 100

    if manaPercentAfterCast > 25.00 then
        return
    end

    BlzStartUnitAbilityCooldown(caster, FourCC('A074'), 75.00)
    
    local casterLoc = GetUnitLoc(caster)
    local units = GetUnitsInRange_FriendlyTargetable(caster, casterLoc, 400.00)

    local timer = CreateTimer()
    TimerStart(timer, 0.12, false, function()
        local casterLoc = GetUnitLoc(caster)
        local units = GetUnitsInRange_FriendlyTargetable(caster, casterLoc, 400.00)
        for i = 1, #units do
            local t = units[i]
            if IsUnitAliveBJ(t) then
                local uMana = GetUnitState(t, UNIT_STATE_MANA)
                if caster == t then
                    SetUnitState(t, UNIT_STATE_MANA, uMana + manaToRestore)
                else
                    SetUnitState(t, UNIT_STATE_MANA, uMana + manaToRestoreSecondary)
                end
                CreateEffectOnUnit("chest", t, "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", 2.0)
            end
        end
    end)
end
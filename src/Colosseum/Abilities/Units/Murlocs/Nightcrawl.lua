AbilityTrigger_Murloc_Nightcrawl = nil

RegInit(function()
    AbilityTrigger_Murloc_Nightcrawl = AddAbilityCastTrigger('A07W', AbilityTrigger_Murloc_Nightcrawl_Actions)
end)

function AbilityTrigger_Murloc_Nightcrawl_Actions()
    local caster = GetSpellAbilityUnit()
    
    local timer = CreateTimer()
    TimerStart(timer, 1.0, true, function()
        if not IsUnitAliveBJ(caster) then
            DestroyTimer(caster)
            return
        end

        if not UnitHasBuffBJ(caster, FourCC('B016')) then
            DestroyTimer(caster)
            return
        end

        local mana = GetUnitState(caster, UNIT_STATE_MANA)
        SetUnitState(caster, UNIT_STATE_MANA, mana + 5.0)
    end)
end
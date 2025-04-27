AbilityTrigger_VP_ResurgingLight = nil

RegInit(function()
    AbilityTrigger_VP_ResurgingLight = AddAbilityCastTrigger('A030', AbilityTrigger_VP_ResurgingLight_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_VP_ResurgingLight, FourCC('H00S'))
end)

function AbilityTrigger_VP_ResurgingLight_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local healing = 160.00

    local currentLife = GetUnitState(target, UNIT_STATE_LIFE)
    local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    local percentageLife = (currentLife / maxLife) * 100
    -- local missing = 100.00 - percentageLife
    -- local factor = 1 + missing * 2 / 100
    -- healing = healing * factor    

    local factor = 1.00
    if percentageLife <= 30.00 then
        factor = 2.00
    end
    healing = healing * factor
    
    CauseHeal(caster, target, healing)
end
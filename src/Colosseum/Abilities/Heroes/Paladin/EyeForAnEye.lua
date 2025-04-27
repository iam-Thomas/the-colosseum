AbilityTrigger_VP_EyeForAnEye_Damaged = nil

RegInit(function()
    AbilityTrigger_VP_EyeForAnEye_Damaged = CreateTrigger()
    TriggerAddAction(AbilityTrigger_VP_EyeForAnEye_Damaged, AbilityTrigger_VP_EyeForAnEye_Damaged_Actions)
    TriggerAddCondition(AbilityTrigger_VP_EyeForAnEye_Damaged, Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), FourCC('A031')) end))
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_VP_EyeForAnEye_Damaged, EVENT_PLAYER_UNIT_DAMAGED)
    
    RegisterTriggerEnableById(AbilityTrigger_VP_EyeForAnEye_Damaged, FourCC('H00S'))
end)

function AbilityTrigger_VP_EyeForAnEye_Damaged_Actions()
    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local damage = GetEventDamage()

    local casterCurrentLife = GetUnitState(caster, UNIT_STATE_LIFE)
    local casterMaxLife = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
    local casterPercentageLife = (casterCurrentLife / casterMaxLife) * 100

    local lifeThreshold = 25.00
    local factor = 1.35
    if IsUnitEmpowered(caster) then
        lifeThreshold = 50.00
        factor = 1.7
    end

    if casterPercentageLife <= lifeThreshold then
        BlzSetEventDamage(damage * factor)
    end
end
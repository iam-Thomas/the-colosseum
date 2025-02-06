AbilityTrigger_BS_EvokeElements = nil

RegInit(function()
    AbilityTrigger_BS_EvokeElements = AddAbilityCastTrigger('A064', AbilityTrigger_BS_EvokeElements_Actions)
end)

function AbilityTrigger_BS_EvokeElements_Actions()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()
    
    if AbilityTrigger_BS_ChannelStorm_IsChanneled(caster) then
        AbilityTrigger_BS_ChannelStorm_Evoke(caster, targetLoc)
    end
    
    if AbilityTrigger_BS_ChannelEarth_IsChanneled(caster) then
        AbilityTrigger_BS_ChannelEarth_Evoke(caster, targetLoc)
    end
    
    if AbilityTrigger_BS_ChannelFire_IsChanneled(caster) then
        AbilityTrigger_BS_ChannelFire_Evoke(caster, targetLoc)
    end
end
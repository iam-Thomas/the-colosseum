AbilityTrigger_Miraju = nil

RegInit(function()
    AbilityTrigger_Miraju = AddAbilityCastTrigger(MirajuSID, AbilityTrigger_Miraju_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_Miraju, FourCC('O00I'))
end)

function AbilityTrigger_Miraju_Actions()

    LastRoninCast = GetSpellAbilityId()

    if not (LastMirajuCast == nil) then
        BlzStartUnitAbilityCooldown(GetTriggerUnit(), LastMirajuCast, 0.01)
    end

end

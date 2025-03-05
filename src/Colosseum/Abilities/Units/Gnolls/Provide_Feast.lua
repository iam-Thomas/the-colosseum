AbilityTrigger_Provide_Feast = nil

RegInit(function()
    AbilityTrigger_Provide_Feast = AddAbilityCastTrigger(ProvideFeastSID, AbilityTrigger_Provide_Feast_Actions)
end)

function AbilityTrigger_Provide_Feast_Actions()
    local target = GetSpellTargetUnit()

    if(UnitIsAGnoll(target)) then
        GnollFeast(target, 15, false)
    end

end

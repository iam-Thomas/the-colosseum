function GetPhaseCreepers()
    return {
        signatureUnitId = FourCC('n008'),
        groups = {
            commons = {
                { { count = 12, unitString = "creepm0" } },
                { { count = 2, unitString = "creepm1" }, { count = 4, unitString = "creepm0" } },
                { { count = 1, unitString = "creepr0" }, { count = 6, unitString = "creepm0" } },
                { { count = 2, unitString = "creepr1" }, { count = 4, unitString = "creepm0" } },
                { { count = 1, unitString = "creepc0" }, { count = 2, unitString = "creepm2" }, { count = 4, unitString = "creepm0" } },
            },
            rares = {

            },
            epics = {

            },
            legendaries = {

            },
        },
        bosses = {
            { { count = 1, unitString = "creepb0" } },
            { { count = 1, unitString = "creepb1" } },
            { { count = 1, unitString = "creepb2" } },
        },
        followUp = {
            FourCC('o009'), -- Horde, kodo
        },
        evaluateState = function(roundIndex, phaseRoundIndex)
            local isBossRound = phaseRoundIndex > 2
        
            return {
                IsTransitionFight = phaseRoundIndex > 5,
                IsBossFight = phaseRoundIndex > 2,
            }
        end
    }
end
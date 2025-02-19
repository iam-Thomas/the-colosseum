function GetPhaseMurlocs()
    return {
        signatureUnitId = FourCC('n00Q'),
        groups = {
            commons = {
                { { count = 6, unitString = "mrlm0" } },
                { { count = 4, unitString = "mrlm0" }, { count = 2, unitString = "mrlr0" } },
                { { count = 1, unitString = "mrlm1" }, { count = 4, unitString = "mrlm0" } },
            },
            rares = {
                { { count = 1, unitString = "mrlc0" }, { count = 4, unitString = "mrlm0" } },
                { { count = 1, unitString = "mrlc0" }, { count = 2, unitString = "mrlr0" }, { count = 2, unitString = "mrlm0" } },
            },
            epics = {
                { { count = 3, unitString = "mrlm1" } },
                { { count = 2, unitString = "mrlc0" }, { count = 3, unitString = "mrlm0" } },
            },
            legendaries = {
                
            },
        },
        bosses = {
            { { count = 1, unitString = "mrlb0" }, { count = 3, unitString = "mrlm0" } },
            { { count = 1, unitString = "mrlb1" } },
            { { count = 2, unitString = "mrlm1" }, { count = 3, unitString = "mrlc0" } },
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
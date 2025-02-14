function GetPhaseMurlocs()
    return {
        signatureUnitId = FourCC('n00Q'),
        groups = {
            commons = {
                { { count = 6, unitString = "mrlm0" } },
            },
            rares = {

            },
            epics = {

            },
            legendaries = {

            },
        },
        bosses = {
            { { count = 1, unitString = "mrlb0" } },
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
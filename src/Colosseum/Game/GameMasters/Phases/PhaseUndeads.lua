function GetPhaseUndeads()
    return {
        signatureUnitId = FourCC('u005'),
        groups = {
            commons = {
                { { count = 12, unitString = "udm0" } },
                { { count = 4, unitString = "udm0" }, { count = 1, unitString = "udc0" } },
                { { count = 6, unitString = "udm0" }, { count = 1, unitString = "udc1" } },
                { { count = 9, unitString = "udm0" }, { count = 1, unitString = "udr0" } },
            },
            rares = {
                { { count = 6, unitString = "udm0" }, { count = 2, unitString = "udr0" } },
                { { count = 6, unitString = "udm0" }, { count = 1, unitString = "udc1" } },
            },
            epics = {
                { { count = 3, unitString = "udm0" }, { count = 3, unitString = "udr0" } },
                { { count = 6, unitString = "udm0" }, { count = 2, unitString = "udc0" } },
                { { count = 2, unitString = "udc1" } },
            },
            legendaries = {
                { { count = 6, unitString = "udm0" }, { count = 4, unitString = "udr0" } },
            },
        },
        bosses = {
            { { count = 1, unitString = "udb0" } },
            { { count = 1, unitString = "udb1" } },
            { { count = 1, unitString = "udb2" }, { count = 2, unitString = "udc1" } },
        },
        followUp = {
            FourCC('h00E'), -- bandits
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
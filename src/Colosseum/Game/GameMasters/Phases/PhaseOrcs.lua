function GetPhaseHorde()
    return {
        signatureUnitId = FourCC('o009'),
        groups = {
            commons = {
                { { count = 3, unitString = "hordem0" } },
                { { count = 2, unitString = "hordem1" } },
                { { count = 1, unitString = "hordec0" }, { count = 2, unitString = "hordem0" } },
                { { count = 1, unitString = "hordec1" }, { count = 2, unitString = "hordem0" } },
            },
            rares = {

            },
            epics = {

            },
            legendaries = {

            },
        },
        bosses = {
            { { count = 1, unitString = "hordeb0" } },
            { { count = 1, unitString = "hordeb1" } },
            { { count = 1, unitString = "hordeb2" } },
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
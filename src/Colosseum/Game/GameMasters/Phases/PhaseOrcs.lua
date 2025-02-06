function GetPhaseHorde()
    return {
        groups = {
            { { 3, "hordem0" } },
            { { 2, "hordem1" } },
            { { 2, "hordec0" }, { 1, "hordem0" } },
            { { 1, "hordec1" }, { 2, "hordem0" } },
        },
        bosses = {
            { { 1, "hordeb0" } },
            { { 1, "hordeb1" } },
            { { 1, "hordeb2" } },
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
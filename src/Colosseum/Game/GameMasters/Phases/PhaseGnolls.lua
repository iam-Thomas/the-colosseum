function GetPhaseGnolls()
    return {
        signatureUnitId = FourCC('n013'),
        groups = {
            commons = {
                { { count = 3, unitString = "gnoll_gnasher" } },
                { { count = 2, unitString = "gnoll_brute" } },
                { { count = 1, unitString = "gnoll_poacher" }, { count = 2, unitString = "gnoll_gnasher" } },
                { { count = 1, unitString = "gnoll_spikey" }, { count = 2, unitString = "gnoll_gnasher" } },
            },
            rares = {

            },
            epics = {

            },
            legendaries = {

            },
        },
        bosses = {
            { { count = 1, unitString = "gnoll_hogger" } },
            { { count = 1, unitString = "gnoll_trapper" } },
            { { count = 1, unitString = "gnoll_brute" } },
        },
        defaultGroups = {
            { { count = 5, unitString = "gnoll_spikey" } },
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
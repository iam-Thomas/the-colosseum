function GetPhaseGnolls()
    return {
        signatureUnitId = FourCC('n013'),
        groups = {
            commons = {
                { { count = 6, unitString = "gnoll_gnasher" } },
                { { count = 1, unitString = "gnoll_brute" }, { count = 4, unitString = "gnoll_gnasher" } },
                { { count = 2, unitString = "gnoll_poacher" }, { count = 4, unitString = "gnoll_gnasher" } },
                { { count = 2, unitString = "gnoll_spikey" }, { count = 5, unitString = "gnoll_gnasher" } },
            },
            rares = {
                { { count = 2, unitString = "gnoll_brute" }, { count = 2, unitString = "gnoll_gnasher" } },
                { { count = 1, unitString = "gnoll_wagon" }, { count = 3, unitString = "gnoll_gnasher" } },
                { { count = 6, unitString = "gnoll_spikey" }, { count = 3, unitString = "gnoll_gnasher" } },
                { { count = 3, unitString = "gnoll_poacher" }, { count = 3, unitString = "gnoll_gnasher" } },
            },
            epics = {
                { { count = 3, unitString = "gnoll_brute" } },
                { { count = 1, unitString = "gnoll_brute" }, { count = 4, unitString = "gnoll_poacher" } },
                { { count = 1, unitString = "gnoll_brute" }, { count = 3, unitString = "gnoll_brute" } },
                { { count = 2, unitString = "gnoll_wagon" } },
                { { count = 6, unitString = "gnoll_poacher" } },
                { { count = 2, unitString = "gnoll_brute" }, { count = 6, unitString = "gnoll_spikey" } },
                { { count = 12, unitString = "gnoll_spikey" } },
                { { count = 6, unitString = "gnoll_spikey" }, { count = 1, unitString = "gnoll_wagon" } },
            },
            legendaries = {

            },
        },
        bosses = {
            { { count = 1, unitString = "gnoll_hogger" } },
            { { count = 1, unitString = "gnoll_trapper" } },
            { { count = 3, unitString = "gnoll_brute" }, { count = 12, unitString = "gnoll_spikey" } },
        },
        defaultGroups = {
            { { count = 5, unitString = "gnoll_spikey" }, { count = 1, unitString = "gnoll_fleshpile" } },
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
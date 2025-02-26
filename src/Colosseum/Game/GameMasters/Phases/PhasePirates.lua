function GetPhasePirates()
    return {
        signatureUnitId = FourCC('n00Y'),
        groups = {
            commons = {
                { { count = 4, unitString = "piratem0" } },
                { { count = 3, unitString = "piratem0" }, { count = 1, unitString = "piratec0" } },
                { { count = 2, unitString = "piratem0" }, { count = 1, unitString = "piratem1" } },
                { { count = 2, unitString = "piratem0" }, { count = 1, unitString = "pirater0" } },
            },
            rares = {
                { { count = 1, unitString = "pirater1" }, { count = 2, unitString = "piratem0" } },
                { { count = 2, unitString = "piratec0" }, { count = 1, unitString = "pirater0" } },
                { { count = 1, unitString = "piratem0" }, { count = 1, unitString = "piratem1" }, { count = 1, unitString = "pirater0" } },
                { { count = 2, unitString = "piratem0" }, { count = 1, unitString = "pirater1" } },
            },
            epics = {
                { { count = 3, unitString = "pirater0" } },
                { { count = 2, unitString = "pirater1" } },
                { { count = 2, unitString = "pirater0" }, { count = 3, unitString = "piratem0" } },
                { { count = 2, unitString = "piratem1" }, { count = 1, unitString = "piratec0" } },
                { { count = 1, unitString = "piratec0" }, { count = 4, unitString = "piratem0" } },
                { { count = 1, unitString = "piratem1" }, { count = 3, unitString = "piratec0" } },
            },
            legendaries = {
                { { count = 3, unitString = "piratem1" } },
                { { count = 1, unitString = "piratem1" }, { count = 2, unitString = "piratec0" }, { count = 2, unitString = "piratem0" } },
            },
        },
        bosses = {
            { { count = 1, unitString = "pirateb0" } },
            { { count = 1, unitString = "pirateb1" } },
            { { count = 1, unitString = "pirateb2" } },
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
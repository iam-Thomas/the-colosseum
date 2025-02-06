function GetPhaseBandits()
    return {
        groups = {
            { { 6, "bandtm0" } },
            { { 6, "bandtr0" } },
            { { 3, "bandtm0" }, { 3, "bandtr0" } },
            { { 2, "bandtm1" }, { 3, "bandtm0" } },
            { { 2, "bandtm1" }, { 3, "bandtr0" } },
            { { 3, "bandtm0" }, { 2, "bandtc0" } },
            { { 4, "bandtm1" } },
        },
        bosses = {
            { { 1, "bandtm2" } },
            { { 2, "bandtr2" } },
            { { 1, "bandtc2" } },
        },
        followUp = {
            FourCC('n008'), -- Creepers, broodmother
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
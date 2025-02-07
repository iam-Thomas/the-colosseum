function GetPhaseBandits()
    return {
        signatureUnitId = FourCC('h00E'),
        groups = {
            commons = {
                { { count = 6, unitString = "bandtm0" } },
                { { count = 6, unitString = "bandtr0" } },
                { { count = 3, unitString = "bandtm0" }, { count = 3, unitString = "bandtr0" } },
                { { count = 2, unitString = "bandtm1" }, { count = 3, unitString = "bandtm0" } },
                { { count = 2, unitString = "bandtm1" }, { count = 3, unitString = "bandtr0" } },
                { { count = 3, unitString = "bandtm0" }, { count = 2, unitString = "bandtc0" } },
                { { count = 4, unitString = "bandtm1" } },
            },
            rares = {

            },
            epics = {

            },
            legendaries = {

            },            
        },
        bosses = {
            { { count = 1, unitString = "bandtm2" } },
            { { count = 2, unitString = "bandtr2" } },
            { { count = 1, unitString = "bandtc2" } },
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
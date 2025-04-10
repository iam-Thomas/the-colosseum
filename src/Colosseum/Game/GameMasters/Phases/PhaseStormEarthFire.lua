function GetPhaseStormEarthFire()
    return {
        signatureUnitId = FourCC('n015'),
        groups = {
            commons = {
                { { count = 1, unitString = "sef0" } },
                { { count = 1, unitString = "sef1" } },
                { { count = 1, unitString = "sef2" } },
            },
            rares = {

            },
            epics = {

            },
            legendaries = {

            },            
        },
        bosses = {

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
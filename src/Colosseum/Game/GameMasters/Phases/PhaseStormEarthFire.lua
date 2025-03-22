function GetPhaseStormEarthFire()
    return {
        signatureUnitId = FourCC('n015'),
        groups = {
            commons = {

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
            FourCC('h00E'), -- bandits
        },
        evaluateState = function(roundIndex, phaseRoundIndex)
            return {
                IsTransitionFight = phaseRoundIndex > 1,
                IsBossFight = true,
            }
        end,
        draftIntercept = function(roundIndex, phaseRoundIndex)
            local selectorUnit = GameLoop_GetNextIndexedSelectorUnit()
            return true
        end
    }
end
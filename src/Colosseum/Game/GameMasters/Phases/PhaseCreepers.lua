function GetPhaseCreepers()
    return {
        groups = {
            { { 12, "creepm0" } },
            { { 2, "creepm1" }, { 4, "creepm0" } },
            { { 1, "creepr0" }, { 6, "creepm0" } },
            { { 2, "creepr1" }, { 4, "creepm0" } },
            { { 1, "creepc0" }, { 2, "creepm2" }, { 4, "creepm0" } },
        },
        bosses = {
            { { 1, "creepb0" } },
            { { 1, "creepb1" } },
            { { 1, "creepb2" } },
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
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
            --{}
        },
        followUp = {
            FourCC('h00E'), -- bandits
        },
        evaluateState = function(roundIndex, phaseRoundIndex)
            return {
                IsTransitionFight = phaseRoundIndex > 1,
                IsBossFight = true,
            }
        end
        -- draftIntercept = function(roundIndex, phaseRoundIndex)
        --     local bosses = { FourCC('n014'), FourCC('n015'), FourCC('n016') }
        --     local bossIndex = 1
        --     print("bosses: " .. #bosses)

        --     local nManaToGrant = CountPlayersInForceBJ(udg_GladiatorPlayers)
        --     print("nManaToGrant: " .. nManaToGrant)
        --     for i = 1, nManaToGrant do
        --         local selectorUnit = GameLoop_GetNextIndexedSelectorUnit()
        --         print("selectorUnit: " .. tostring(selectorUnit))

        --         local array = nil
        --         local owner = GetOwningPlayer(selectorUnit)
        --         for i = 1, #glPlayerSelections do
        --             if (owner == Player(i - 1)) then
        --                 array = glPlayerSelections[i]
        --                 print("array: " .. tostring(array))
        --             end
        --         end

        --         array[#array] = bosses[bossIndex]
        --         bossIndex = bossIndex + 1
        --         if (bossIndex > #bosses) then
        --             bossIndex = 1
        --         end
        --     end
        --     return true
        -- end
    }
end
CDUpgradesMaxLevel = 10

RegInit(function()
    DelayedCallback(2.06, function()
        ForForce(udg_GladiatorPlayers, function()
            local player = GetEnumPlayer()
            SetPlayerTechResearched(player, FourCC('R009'), CDUpgradesMaxLevel)
            SetPlayerTechResearched(player, FourCC('R008'), CDUpgradesMaxLevel)
        end)
    end)
end)

function ResolveRoundCooldown()
    ForGroup(udg_GladiatorHeroes, function()
        local unit = GetEnumUnit()
        local owner = GetOwningPlayer(unit)
        AddPlayerTechResearched(owner, FourCC('R009'), 1)
        AddPlayerTechResearched(owner, FourCC('R008'), 1)
    end)
end

function SetRoundCooldown_R(caster, rounds)
    local owner = GetOwningPlayer(caster)
    SetPlayerTechResearched(owner, FourCC('R009'), CDUpgradesMaxLevel - (rounds + 1))
end

function SetRoundCooldown_E(caster, rounds)
    local owner = GetOwningPlayer(caster)
    SetPlayerTechResearched(owner, FourCC('R008'), CDUpgradesMaxLevel - (rounds + 1))
end
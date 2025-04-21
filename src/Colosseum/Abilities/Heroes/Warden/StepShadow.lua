RegInit(function()
    local trigger = AddAbilityCastTrigger('A0AS', AbilityTrigger_Warden_StepShadow)
end)

function AbilityTrigger_Warden_StepShadow()
    local caster = GetSpellAbilityUnit()
    local summoner = Warden_GetAnimatedShadowSummoner(caster)

    local casterLoc = GetUnitLoc(caster)
    local summonerLoc = GetUnitLoc(summoner)

    local casterX = GetLocationX(casterLoc)
    local casterY = GetLocationY(casterLoc)
    local summonerX = GetLocationX(summonerLoc)
    local summonerY = GetLocationY(summonerLoc)
    
    SetUnitX(caster, summonerX)
    SetUnitY(caster, summonerY)
    SetUnitX(summoner, casterX)
    SetUnitY(summoner, casterY)

    RemoveLocation(casterLoc)
    RemoveLocation(summonerLoc)
end
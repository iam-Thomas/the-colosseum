AbilityTrigger_Cannonball_Barrage = nil

RegInit(function()
    AbilityTrigger_Cannonball_Barrage = AddAbilityCastTrigger('A08X', AbilityTrigger_Cannonball_Barrage_Actions)
end)

function AbilityTrigger_Cannonball_Barrage_Actions()
    local caster = GetSpellAbilityUnit()
    local targetPoint = GetSpellTargetLoc()
    local waves = 10
    local fireRate = 1.3

    local wavecount = 1
    
    CastDummyAbilityOnPoint(GetOwningPlayer(caster), targetPoint, FourCC('A08Y'), 1, "rainoffire", targetPoint, 15.0)

    local cannonTimer = CreateTimer()
    TimerStart(cannonTimer, fireRate, true, function()
        wavecount = wavecount + 1

        CastDummyAbilityOnPoint(GetOwningPlayer(caster), targetPoint, FourCC('A08Y'), 1, "rainoffire", targetPoint, 15.0)

        if wavecount == waves then
            DestroyTimer(cannonTimer)
        end
    end)

end

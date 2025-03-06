AbilityTrigger_Carrion_Feast = nil
AbilityTrigger_Great_Carrion_Feast = nil

RegInit(function()
    AbilityTrigger_Carrion_Feast = AddAbilityCastTrigger(CarrionFeastSID, AbilityTrigger_Carrion_Feast_Actions)
    AbilityTrigger_Great_Carrion_Feast = AddAbilityCastTrigger(GreatCarrionFeastSID, AbilityTrigger_Carrion_Feast_Actions)
end)

function AbilityTrigger_Carrion_Feast_Actions()
    local spellId = GetSpellAbilityId()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local timer = CreateTimer()
    TimerStart(timer, 4, false, function()
        if (GetUnitTypeId(target) == FourCC(CarrionFleshPileUID)) and (GetUnitCurrentOrder(caster) == String2OrderIdBJ("cripple")) then
            local isGreaterFeast = false
            if (spellId == FourC(GreatCarrionFeastSID)) then
                isGreaterFeast = true
            end

            GnollFeast(caster, 0, isGreaterFeast)
        end
        DestroyTimer(timer)

    end) 
end

function GnollFeast(unit, duration, isGreaterFeast)
    local level = 0

    if (duration == 0) then
        level = 10
    else
        level = math.floor( duration / 5 )
        level = math.min( level, 9 )
    end

    if (isGreaterFeast) then
        level = level + 10
    end

    CastDummyAbilityOnTarget(unit, unit, FourCC(GnollFeastDummySID), level, "bloodlust")
end

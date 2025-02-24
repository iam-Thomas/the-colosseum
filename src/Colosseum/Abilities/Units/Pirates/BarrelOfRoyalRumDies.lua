AbilityTrigger_Barrel_Of_Royal_Rum_Dies = nil

RegInit(function()
    AbilityTrigger_Barrel_Of_Royal_Rum_Dies = CreateTrigger();
    TriggerAddAction(AbilityTrigger_Barrel_Of_Royal_Rum_Dies, AbilityTrigger_Barrel_Of_Royal_Rum_Dies_Actions);
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_Barrel_Of_Royal_Rum_Dies, EVENT_PLAYER_UNIT_DEATH)
end)

function AbilityTrigger_Barrel_Of_Royal_Rum_Dies_Actions()
    local caster = GetDyingUnit()

    if (not (FourCC('o00H') == GetUnitTypeId(caster))) then
        return
    end

    local casterPoint = GetUnitLoc(caster)
    local specialeffect = CreateEffectAtPoint(casterPoint, "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl", 0.05)

    local units = GetUnitsInRange_Targetable(caster, casterPoint, 250)
    for i = 1, #units do
        if (GetUnitTypeId(units[i]) == FourCC('o00H')) then
            SetUnitState(units[i], UNIT_STATE_LIFE, 1)
        else 
            CauseMagicDamage_Fire(caster, units[i], 100)
            CauseStunMini(caster, units[i])
        end
    end
end
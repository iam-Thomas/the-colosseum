ItemTrigger_ForceStaff = nil

RegInit(function()
    ItemTrigger_ForceStaff = AddAbilityCastTrigger('A0A2', ItemTrigger_ForceStaff_Actions)
end)

function ItemTrigger_ForceStaff_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local distance = 600.00
    if IsUnitEnemy(target, GetOwningPlayer(caster)) then
        local casterLoc = GetUnitLoc(caster)
        local targetLoc = GetUnitLoc(target)
        local angle = AngleBetweenPoints(casterLoc, targetLoc)
        Knockback_Angled(target, angle, distance, nil)
    else
        local angle = GetUnitFacing(target)
        Knockback_AngledNoInterrupt(target, angle, distance, nil)
    end
end
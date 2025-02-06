ItemTrigger_Razorspine_Plating = nil
ItemTrigger_Razorspine_Plating_Damaged = nil

RegInit(function()
    ItemTrigger_Razorspine_Plating = AddItemTrigger_Activate(FourCC('I00C'), ItemTrigger_Razorspine_Plating_Actions)
    ItemTrigger_Razorspine_Plating_Damaged = AddDamagedEventTrigger_TargetHasBuff(FourCC('B00Y'), ItemTrigger_Razorspine_Plating_Damaged_Actions)
end)

function ItemTrigger_Razorspine_Plating_Actions()
    local caster = GetManipulatingUnit()
    --A05N
    --B00Y
    ApplyManagedBuff(caster, FourCC('A05N'), FourCC('B00Y'), 7.00, "overhead", "Abilities\\Spells\\Undead\\ThornyShield\\ThornyShieldTargetChestLeft.mdl")
end

function ItemTrigger_Razorspine_Plating_Damaged_Actions()
    if (BlzGetEventDamageType() == DAMAGE_TYPE_DEFENSIVE) then
        return
    end

    local caster = BlzGetEventDamageTarget()
    local target = GetEventDamageSource()
    local amount = GetEventDamage()

    local locA = GetUnitLoc(caster)
    local locB = GetUnitLoc(target)
    local dist = DistanceBetweenPoints(locA, locB)
    if dist > 400 then
        return
    end

    local returnDamage = amount * 1.00

    CauseDefensiveDamage(caster, target, returnDamage)
end
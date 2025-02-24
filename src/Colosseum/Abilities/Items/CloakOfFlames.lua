ItemTrigger_CloakOfFlames = nil

RegInit(function()
    ItemTrigger_CloakOfFlames = AddItemTrigger_Periodic(FourCC('I008'), 1.0, ItemTrigger_CloakOfFlames_Actions)
end)

function ItemTrigger_CloakOfFlames_Actions(hero)
    local loc = GetUnitLoc(hero)
    local units = GetUnitsInRange_EnemyTargetable(hero, loc, 210.0)

    local armor = BlzGetUnitArmor(hero)
    local damage = 5 + (armor * 0.4)

    for i = 1, #units do
        CauseMagicDamage_Fire(hero, units[i], damage)
    end
end

-- magic damage reduction trigger handled in Common.MagicDamageResist.lua
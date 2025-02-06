-- ItemTrigger_MageSpaulders = nil

-- RegInit(function()
--     ItemTrigger_MageSpaulders = AddItemTrigger_Periodic(FourCC('I005'), 5.0, ItemTrigger_MageSpaulders_Actions)
-- end)

-- function ItemTrigger_MageSpaulders_Actions(hero)
--     local int = GetHeroInt(hero, true)
--     local bonusArmor = math.ceil(int * 0.1)
--     GrantTempArmor(hero, bonusArmor, 5.0)
-- end

ItemTrigger_BattleMageArmor = nil

RegInit(function()
    ItemTrigger_BattleMageArmor = AddItemTrigger_Activate(FourCC('I005'), ItemTrigger_BattleMageArmor_Actions)
end)

function ItemTrigger_BattleMageArmor_Actions()
    local caster = GetManipulatingUnit()
    local int = GetHeroInt(caster, true)
    local armor = int * 0.2
    GrantTempArmor(caster, armor, 8.0)
end
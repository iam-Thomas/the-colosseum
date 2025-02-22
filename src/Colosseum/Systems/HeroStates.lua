RegInit(function()
    
end)

function GetHeroBonusDamageFromItems(hero)
    local result = 0

    for i = 1, 6 do
        local item = UnitItemInSlot(hero, i - 1)
        if item ~= nil then
            for j = 1, 4 do
                local ability = BlzGetItemAbilityByIndex(item, j - 1)
                local str = BlzGetAbilityStringField(ability, ABILITY_SF_NAME)
                local rss = string.find(str, "Damage")
                if rss ~= nil then
                    local bonusDamage = BlzGetAbilityIntegerLevelField(ability, ABILITY_ILF_MAX_MANA_GAINED, 0)
                    result = result + bonusDamage
                end
                
            end
        end        
    end

    return result
end
    
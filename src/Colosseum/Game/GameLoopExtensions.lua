function GameLoop_AddGoldToPlayer(player, amount)
    if (udg_IsDevelopment) then
        -- give the gold to player 1 red
        player = Player(0)
    end

    local gold = GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD)
    SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, gold + amount)
end
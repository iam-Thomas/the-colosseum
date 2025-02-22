function GameLoop_AddGoldToPlayer(player, amount)
    if (udg_IsDevelopment) then
        -- give the gold to player 1 red
        player = Player(0)
    end

    local gold = GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD)
    SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, gold + amount)
end

function GameLoop_BeginIntermissionTimer(message, time, cancelPredicate, callback)
    local timer = CreateTimer()
    local dialog = CreateTimerDialog(timer)

    local frequentTimer = CreateTimer()
    local elapsed = 0.00
    local duration = time

    TimerStart(timer, time, false, function()
        DestroyTimerDialog(dialog)
        DestroyTimer(timer)
        DestroyTimer(frequentTimer)
        callback()
    end)

    TimerDialogSetTitle(dialog, message)
    TimerDialogDisplay(dialog, true)

    TimerStart(frequentTimer, 0.20, true, function()
        if (cancelPredicate()) then
            DestroyTimerDialog(dialog)
            DestroyTimer(timer)
            DestroyTimer(frequentTimer)
            callback()
        end
    end)
end
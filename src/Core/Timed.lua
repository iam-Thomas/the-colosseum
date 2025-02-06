function DelayedCallback(delay, callback)
    local timer = CreateTimer()
    TimerStart(timer, delay, false, function()
        DestroyTimer(timer)
        callback()
    end)
end

function PeriodicCallback(interval, callback)
    local timer = CreateTimer()
    TimerStart(timer, interval, true, function()
        local cancel = callback()
        if cancel then
            DestroyTimer(timer)
        end
    end)
end
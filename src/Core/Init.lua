InitFunctions = {}

function InitLua()
    --SetMapFlag(MAP_LOCK_RESOURCE_TRADING, true)
    for _, func in ipairs(InitFunctions) do
        func()
    end
end

function RegInit(func)
    table.insert(InitFunctions, func)
end
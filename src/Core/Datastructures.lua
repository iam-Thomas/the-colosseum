function SelectRandomIndeces(max, n)
    local values = {}
    for i = 1, max do
        table.insert(values, i)
    end
    
    local result = {}
    for i = 1, n do
        if (#values < 1) then
            return result
        end

        local randomIndex = math.random(1, #values)
        local value = values[randomIndex]
        table.insert(result, value)
        table.remove(values, randomIndex)
    end

    return result
end
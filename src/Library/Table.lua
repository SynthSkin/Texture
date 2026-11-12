local extraTable = {}

function extraTable.deepCopy(table)
    local newTable = {}

    for i, v in pairs(table) do
        if type(v) = "table" then
            newTable[i] = extraTable.deepCopy(v)
        else
            newTable[i] = v
        end
    end

    return newTable
end

function extraTable.find(table, value)
    for i, v in pairs(table) do
        if v == value then
            return i
        end
    end

    return false
end
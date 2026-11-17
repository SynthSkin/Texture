local extraTable = {}

function extraTable.deepCopy<T>(tbl: T): T
    if type(tbl) ~= "table" then
        return tbl
    end

    local newTable = table.clone(tbl :: any)

    for i, v in newTable do
        if type(v) == "table" then
            newTable[i] = extraTable.deepCopy(v)
        end
    end

    return (newTable :: any) :: T
end

function extraTable.find(tbl: { [any]: any }, value: any): any
    local index = table.find(tbl, value)
    if index ~= nil then
        return index
    end

    for i, v in tbl do
        if v == value then
            return i
        end
    end

    return false
end

function extraTable.doContentsExistIn(tablea: { [any]: any }, tableb: { [any]: any }) --Returns true if all contents of table a are within table b
    for k, value in pairs(tablea) do
        if not extraTable.find(tableb, value) then
            return false
        end
    end
    return true
end

return extraTable

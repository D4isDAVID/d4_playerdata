Utils.kvp = {}

---@param prefix string
---@param func fun(key: string)
function Utils.searchKvp(prefix, func)
    local handle = StartFindKvp(prefix)

    if handle == -1 then
        return
    end

    local key
    repeat
        key = FindKvp(handle)

        if key ~= nil then
            func(key)
        end
    until key == nil

    EndFindKvp(handle)
end

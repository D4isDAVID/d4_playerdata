Utils.kvp = {}

---@param prefix string
---@param func fun(key: string): boolean?
function Utils.searchKvp(prefix, func)
    local handle = StartFindKvp(prefix)

    if handle == -1 then
        return
    end

    local key
    repeat
        key = FindKvp(handle)

        if key ~= nil and func(key) then
            break
        end
    until key == nil

    EndFindKvp(handle)
end

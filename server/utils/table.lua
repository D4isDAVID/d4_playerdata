---@generic T
---@param tble table<T, unknown>
---@return T keys
function Utils.keys(tble)
    local keys = {}

    for key in pairs(tble) do
        keys[#keys + 1] = key
    end

    return keys
end

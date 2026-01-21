Storage.persistId = {}

local key = 'persistId'

---@return integer persistId
function Storage.persistId.increment()
    local persistId = GetResourceKvpInt(key) + 1

    SetResourceKvpIntNoSync(key, persistId)

    return persistId
end

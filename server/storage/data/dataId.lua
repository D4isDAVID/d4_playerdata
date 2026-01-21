Storage.dataId = {}

local key = 'dataId'

---@return integer dataId
function Storage.dataId.increment()
    local dataId = GetResourceKvpInt(key) + 1

    SetResourceKvpIntNoSync(key, dataId)

    return dataId
end

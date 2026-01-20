Storage.dataToUser = {}

local rootKey = 'dataToUser:'

---@param dataId integer
---@return string key
local function key(dataId)
    return rootKey .. tostring(dataId)
end

---@param dataId integer
---@return integer? userId
function Storage.dataToUser.get(dataId)
    local userId = GetResourceKvpInt(key(dataId))

    if userId == 0 then
        return nil
    end

    return userId
end

---@param dataId integer
---@param userId integer
function Storage.dataToUser.set(dataId, userId)
    SetResourceKvpIntNoSync(key(dataId), userId)
end

---@param dataId integer
function Storage.dataToUser.delete(dataId)
    DeleteResourceKvpNoSync(key(dataId))
end

exports('getUserIdFromDataId', Storage.dataToUser.get)

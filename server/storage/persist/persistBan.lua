Storage.persistBan = {}

local rootKey = 'persistBan:'

---@param persistId integer
---@return string key
local function key(persistId)
    return rootKey .. tostring(persistId)
end

---@param persistId integer
---@return boolean exists
function Storage.persistBan.exists(persistId)
    return GetResourceKvpInt(key(persistId)) ~= 0
end

---@param persistId integer
function Storage.persistBan.set(persistId)
    SetResourceKvpIntNoSync(key(persistId), persistId)
end

---@param persistId integer
function Storage.persistBan.delete(persistId)
    DeleteResourceKvpNoSync(key(persistId))
end

exports('isPersistIdBanned', Storage.persistBan.exists)

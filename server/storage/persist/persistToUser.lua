Storage.persistToUser = {}

local rootKey = 'persistToUser:'

---@param persistId integer
---@param userId integer?
---@return string key
local function key(persistId, userId)
    return rootKey .. tostring(persistId) .. ':' .. tostring(userId or '')
end

---@param persistId integer
---@return integer[] userIds
function Storage.persistToUser.getAll(persistId)
    local userId = {}

    Utils.searchKvp(key(persistId), function(idKey)
        userId[#userId + 1] = GetResourceKvpInt(idKey)
    end)

    return userId
end

---@param persistId integer
---@param userId integer
function Storage.persistToUser.set(persistId, userId)
    SetResourceKvpIntNoSync(key(persistId, userId), userId)
end

---@param persistId integer
---@param userId integer
function Storage.persistToUser.delete(persistId, userId)
    DeleteResourceKvpNoSync(key(persistId, userId))
end

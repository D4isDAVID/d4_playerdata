Storage.userToPersist = {}

local rootKey = 'userToPersist:'

---@param userId integer
---@return string key
local function key(userId)
    return rootKey .. tostring(userId)
end

---@param userId integer
---@return integer? persistId
function Storage.userToPersist.get(userId)
    local persistId = GetResourceKvpInt(key(userId))

    if persistId == 0 then
        return nil
    end

    return persistId
end

---@param userId integer
---@param persistId integer
function Storage.userToPersist.set(userId, persistId)
    SetResourceKvpIntNoSync(key(userId), persistId)
end

---@param userId integer
function Storage.userToPersist.delete(userId)
    DeleteResourceKvpNoSync(key(userId))
end

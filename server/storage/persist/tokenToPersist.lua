Storage.tokenToPersist = {}

local rootKey = 'tokenToPersist:'

---@param token string
---@return string key
local function key(token)
    return rootKey .. token
end

---@param token string
---@return integer? persistId
function Storage.tokenToPersist.get(token)
    local persistId = GetResourceKvpInt(key(token))

    if persistId == 0 then
        return nil
    end

    return persistId
end

---@param token string
---@param persistId integer
function Storage.tokenToPersist.set(token, persistId)
    SetResourceKvpIntNoSync(key(token), persistId)
end

---@param token string
function Storage.tokenToPersist.delete(token)
    DeleteResourceKvpNoSync(key(token))
end

exports('getPersistIdFromToken', Storage.tokenToPersist.get)

Storage.identifierToPersist = {}

local rootKey = 'identifierToPersist:'

---@param identifier string
---@return string key
local function key(identifier)
    return rootKey .. identifier
end

---@param identifier string
---@return integer? persistId
function Storage.identifierToPersist.get(identifier)
    local persistId = GetResourceKvpInt(key(identifier))

    if persistId == 0 then
        return nil
    end

    return persistId
end

---@param identifier string
---@param persistId integer
function Storage.identifierToPersist.set(identifier, persistId)
    SetResourceKvpIntNoSync(key(identifier), persistId)
end

---@param identifier string
function Storage.identifierToPersist.delete(identifier)
    DeleteResourceKvpNoSync(key(identifier))
end

exports('getPersistIdFromIdentifier', Storage.identifierToPersist.get)

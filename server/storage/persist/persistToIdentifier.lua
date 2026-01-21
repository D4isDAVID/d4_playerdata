Storage.persistToIdentifier = {}

local rootKey = 'persistToIdentifier:'

---@param persistId integer
---@param identifier string?
---@return string key
local function key(persistId, identifier)
    return rootKey .. tostring(persistId) .. ':' .. (identifier or '')
end

---@param persistId integer
---@return boolean exists
function Storage.persistToIdentifier.hasAny(persistId)
    local exists = false

    Utils.searchKvp(key(persistId), function()
        exists = true
        return true
    end)

    return exists
end

---@param persistId integer
---@return string[] identifiers
function Storage.persistToIdentifier.getAll(persistId)
    local identifiers = {}

    Utils.searchKvp(key(persistId), function(idKey)
        identifiers[#identifiers + 1] = GetResourceKvpString(idKey)
    end)

    return identifiers
end

---@param persistId integer
---@param identifier string
function Storage.persistToIdentifier.set(persistId, identifier)
    SetResourceKvpNoSync(key(persistId, identifier), identifier)
end

---@param persistId integer
function Storage.persistToIdentifier.deleteAll(persistId)
    Utils.searchKvp(key(persistId), function(idKey)
        DeleteResourceKvpNoSync(idKey)
    end)
end

exports('getIdentifiersFromPersistId', Storage.persistToIdentifier.getAll)

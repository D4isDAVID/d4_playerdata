Storage.userToIdentifier = {}

local rootKey = 'userToIdentifier:'

---@param userId integer
---@param identifierType string?
---@return string key
local function key(userId, identifierType)
    return rootKey .. tostring(userId) .. ':' .. (identifierType or '')
end

---@param userId integer
---@param identifierType string
---@return string? identifier
function Storage.userToIdentifier.get(userId, identifierType)
    return GetResourceKvpString(key(userId, identifierType))
end

---@param userId integer
---@return string[] identifiers
function Storage.userToIdentifier.getAll(userId)
    local identifiers = {}

    Utils.searchKvp(key(userId), function(idKey)
        identifiers[#identifiers + 1] = GetResourceKvpString(idKey)
    end)

    return identifiers
end

---@param userId integer
---@param identifier string
function Storage.userToIdentifier.set(userId, identifier)
    local identifierType = Utils.getIdentifierType(identifier)
    SetResourceKvpNoSync(key(userId, identifierType), identifier)
end

---@param userId integer
---@param identifierType string
function Storage.userToIdentifier.delete(userId, identifierType)
    DeleteResourceKvpNoSync(key(userId, identifierType))
end

exports('getIdentifierFromUserId', Storage.userToIdentifier.get)
exports('getIdentifiersFromUserId', Storage.userToIdentifier.getAll)

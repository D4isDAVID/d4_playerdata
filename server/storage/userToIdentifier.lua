Storage.userToIdentifier = {}

local rootKey = 'userToIdentifier:'

---@param userId integer
---@param identifierType string?
---@return string key
local function key(userId, identifierType)
    return rootKey .. tostring(userId) .. ':' .. (identifierType or '')
end

---@param userId integer
---@return string[] identifiers
function Storage.userToIdentifier.getAll(userId)
    local identifiers = {}

    Utils.kvp.search(key(userId), function(idKey)
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

exports('getIdentifiersFromUserId', Storage.userToIdentifier.getAll)

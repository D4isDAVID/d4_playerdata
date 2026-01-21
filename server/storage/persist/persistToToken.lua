Storage.persistToToken = {}

local rootKey = 'persistToToken:'

---@param persistId integer
---@param token string?
---@return string key
local function key(persistId, token)
    return rootKey .. tostring(persistId) .. ':' .. (token or '')
end

---@param persistId integer
---@return string[] tokens
function Storage.persistToToken.getAll(persistId)
    local tokens = {}

    Utils.searchKvp(key(persistId), function(idKey)
        tokens[#tokens + 1] = GetResourceKvpString(idKey)
    end)

    return tokens
end

---@param persistId integer
---@param token string
function Storage.persistToToken.set(persistId, token)
    SetResourceKvpNoSync(key(persistId, token), token)
end

---@param persistId integer
function Storage.persistToToken.deleteAll(persistId)
    Utils.searchKvp(key(persistId), function(idKey)
        DeleteResourceKvpNoSync(idKey)
    end)
end

exports('getTokensFromPersistId', Storage.persistToToken.getAll)

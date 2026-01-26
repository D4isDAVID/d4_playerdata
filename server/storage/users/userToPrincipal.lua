Storage.userToPrincipal = {}

local rootKey = 'userToPrincipal:'

---@param userId integer
---@param principal string?
---@return string key
local function key(userId, principal)
    return rootKey .. tostring(userId) .. ':' .. (principal or '')
end

---@param userId integer
---@param principal string
---@return boolean exists
function Storage.userToPrincipal.exists(userId, principal)
    return GetResourceKvpString(key(userId, principal)) ~= nil
end

---@param userId integer
---@return string[] principals
function Storage.userToPrincipal.getAll(userId)
    local principals = {}

    Utils.searchKvp(key(userId), function(idKey)
        principals[#principals + 1] = GetResourceKvpString(idKey)
    end)

    return principals
end

---@param userId integer
---@param principal string
function Storage.userToPrincipal.set(userId, principal)
    SetResourceKvpNoSync(key(userId, principal), principal)
end

---@param userId integer
---@param principal string
function Storage.userToPrincipal.delete(userId, principal)
    DeleteResourceKvpNoSync(key(userId, principal))
end

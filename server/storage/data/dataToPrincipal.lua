Storage.dataToPrincipal = {}

local rootKey = 'dataToPrincipal:'

---@param dataId integer
---@param principal string?
---@return string key
local function key(dataId, principal)
    return rootKey .. tostring(dataId) .. ':' .. (principal or '')
end

---@param dataId integer
---@param principal string
---@return boolean exists
function Storage.dataToPrincipal.exists(dataId, principal)
    return GetResourceKvpString(key(dataId, principal)) ~= nil
end

---@param dataId integer
---@return string[] principals
function Storage.dataToPrincipal.getAll(dataId)
    local principals = {}

    Utils.searchKvp(key(dataId), function(idKey)
        principals[#principals + 1] = GetResourceKvpString(idKey)
    end)

    return principals
end

---@param dataId integer
---@param principal string
function Storage.dataToPrincipal.set(dataId, principal)
    SetResourceKvpNoSync(key(dataId, principal), principal)
end

---@param dataId integer
---@param principal string
function Storage.dataToPrincipal.delete(dataId, principal)
    DeleteResourceKvpNoSync(key(dataId, principal))
end

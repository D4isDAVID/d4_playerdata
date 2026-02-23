Storage.identifierToUser = {}

local rootKey = 'identifierToUser:'

---@param identifier string
---@return string key
local function key(identifier)
    return rootKey .. identifier
end

---@param identifier string
---@return integer? userId
function Storage.identifierToUser.get(identifier)
    local userId = GetResourceKvpInt(key(identifier))

    if userId == 0 then
        return nil
    end

    return userId
end

---@param identifier string
---@param userId integer
function Storage.identifierToUser.set(identifier, userId)
    SetResourceKvpIntNoSync(key(identifier), userId)
end

---@param identifier string
function Storage.identifierToUser.delete(identifier)
    DeleteResourceKvpNoSync(key(identifier))
end

Storage.userToData = {}

local rootKey = 'userToData:'

---@param userId integer
---@param dataId integer?
---@return string key
local function key(userId, dataId)
    return rootKey .. tostring(userId) .. ':' .. tostring(dataId or '')
end

---@param userId integer
---@param dataId integer
---@return boolean
function Storage.userToData.exists(userId, dataId)
    return GetResourceKvpInt(key(userId, dataId)) ~= 0
end

---@param userId integer
---@return integer[] dataIds
function Storage.userToData.getAll(userId)
    local dataIds = {}

    Utils.searchKvp(key(userId), function(idKey)
        dataIds[#dataIds + 1] = GetResourceKvpInt(idKey)
    end)

    return dataIds
end

---@param userId integer
---@param dataId integer
function Storage.userToData.set(userId, dataId)
    SetResourceKvpIntNoSync(key(userId, dataId), dataId)
end

exports('doesDataIdExistForUserId', Storage.userToData.exists)
exports('getDataIdsFromUserId', Storage.userToData.getAll)

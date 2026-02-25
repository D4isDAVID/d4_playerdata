API.data = {}

---@type table<string, integer>
local playerToDataId = {}
---@type table<integer, string>
local dataIdToPlayer = {}

local autoAssign = true

---@param player unknown
---@return integer? dataId
function API.data.get(player)
    player = tostring(player)

    return playerToDataId[player]
end

---@param dataId integer
---@return boolean exists
function API.data.exists(dataId)
    return Storage.dataToUser.get(dataId) ~= nil
end

---@param dataId integer
---@return string? player
function API.data.getPlayer(dataId)
    return dataIdToPlayer[dataId]
end

---@param player unknown
---@param dataId integer
---@return boolean success
function API.data.assign(player, dataId)
    player = tostring(player)
    local resource = GetInvokingResource()

    if playerToDataId[player] ~= nil or dataIdToPlayer[dataId] ~= nil then
        return false
    end

    local userId = API.users.get(player)
    if userId == nil or not Storage.userToData.exists(userId, dataId) then
        return false
    end

    playerToDataId[player] = dataId
    dataIdToPlayer[dataId] = player

    local principals = Storage.dataToPrincipal.getAll(dataId)
    for i = 1, #principals do
        Utils.addDataPrincipal(dataId, principals[i])
    end
    Utils.addPlayerPrincipal(player, Utils.getDataAceName(dataId))

    local name = GetPlayerName(player)
    if resource == nil then
        print(('%s (User ID %s) was auto-assigned Data ID %s')
            :format(name, userId, dataId))
    else
        print(('%s (User ID %s) was assigned Data ID %s by resource %s')
            :format(name, userId, dataId, resource))
    end

    TriggerEvent('d4_playerdata:dataAssigned', player, dataId)

    return true
end

---@param player unknown
---@return boolean success
function API.data.unassign(player)
    player = tostring(player)

    local dataId = playerToDataId[player]
    if dataId == nil then
        return false
    end

    playerToDataId[player] = nil
    dataIdToPlayer[dataId] = nil

    Utils.removePlayerPrincipal(player, Utils.getDataAceName(dataId))
    local principals = Storage.dataToPrincipal.getAll(dataId)
    for i = 1, #principals do
        Utils.removeDataPrincipal(dataId, principals[i])
    end

    local name = GetPlayerName(player)
    print(('%s (User ID %s) was unassigned Data ID %s')
        :format(name, API.users.get(player), dataId))
    TriggerEvent('d4_playerdata:dataUnassigned', player, dataId)

    return true
end

---@param userId integer
---@return integer? dataId
function API.data.create(userId)
    if not API.users.exists(userId) then
        return nil
    end

    local dataId = Storage.dataId.increment()

    Storage.dataToUser.set(dataId, userId)
    Storage.userToData.set(userId, dataId)

    FlushResourceKvp()
    TriggerEvent('d4_playerdata:dataCreated', dataId, userId)

    return dataId
end

---@param dataId integer
---@return boolean success
function API.data.delete(dataId)
    if API.data.getPlayer(dataId) ~= nil then
        return false
    end

    local userId = Storage.dataToUser.get(dataId)
    if userId == nil then
        return false
    end

    Storage.dataToUser.delete(dataId)
    Storage.userToData.delete(userId, dataId)

    FlushResourceKvp()
    TriggerEvent('d4_playerdata:dataDeleted', dataId, userId)

    return true
end

---@param dataId integer
---@param newUserId integer
---@return boolean success
function API.data.migrate(dataId, newUserId)
    if API.data.getPlayer(dataId) ~= nil then
        return false
    end

    local oldUserId = Storage.dataToUser.get(dataId)
    if oldUserId == nil or oldUserId == newUserId then
        return false
    end

    Storage.dataToUser.set(dataId, newUserId)
    Storage.userToData.set(newUserId, dataId)
    Storage.userToData.delete(oldUserId, dataId)

    FlushResourceKvp()
    TriggerEvent('d4_playerdata:dataMigrated', dataId, newUserId,
        oldUserId)

    return true
end

---@param dataId integer
---@param principal string
---@return boolean success
function API.data.addPrincipal(dataId, principal)
    if not API.data.exists(dataId)
    or Storage.dataToPrincipal.exists(dataId, principal) then
        return false
    end

    Storage.dataToPrincipal.set(dataId, principal)
    FlushResourceKvp()

    if API.data.getPlayer(dataId) ~= nil then
        Utils.addDataPrincipal(dataId, principal)
    end

    return true
end

---@param dataId integer
---@param principal string
---@return boolean success
function API.data.removePrincipal(dataId, principal)
    if not API.data.exists(dataId)
    or not Storage.dataToPrincipal.exists(dataId, principal) then
        return false
    end

    Storage.dataToPrincipal.delete(dataId, principal)
    FlushResourceKvp()

    if API.data.getPlayer(dataId) ~= nil then
        Utils.removeUserPrincipal(dataId, principal)
    end

    return true
end

---@param player unknown
---@return integer? dataId
function API.data.autoAssign(player)
    ---@type integer?
    if playerToDataId[player] ~= nil or not autoAssign then
        return nil
    end

    local userId = API.users.get(player)
    if userId == nil then
        return nil
    end

    local dataIds = Storage.userToData.getAll(userId)
    local dataId

    for i = 1, #dataIds do
        local id = dataIds[i]

        if dataIdToPlayer[id] == nil and (dataId == nil or id < dataId) then
            dataId = id
        end
    end

    if dataId == nil then
        dataId = API.data.create(userId)
    end

    return dataId
end

---@param enabled boolean
---@param resource string?
function API.data.toggleAutoAssign(enabled, resource)
    autoAssign = enabled

    if autoAssign then
        print(
            'Data ID auto assignment has been re-enabled as the resources disabling it have been stopped'
        )
    else
        print(('Data ID auto assignment has been disabled by resource %s')
            :format(resource))
    end
end

exports('getDataId', API.data.get)
exports('getDataIdsFromUserId', Storage.userToData.getAll)
exports('doesDataIdExist', API.data.exists)
exports('doesDataIdExistForUserId', Storage.userToData.exists)
exports('getPlayerFromDataId', API.data.getPlayer)
exports('getUserIdFromDataId', Storage.dataToUser.get)
exports('assignDataId', API.data.assign)
exports('unassignDataId', API.data.unassign)
exports('createDataId', API.data.create)
exports('deleteDataId', API.data.delete)
exports('migrateDataId', API.data.migrate)
exports('addDataIdPrincipal', API.data.addPrincipal)
exports('removeDataIdPrincipal', API.data.removePrincipal)

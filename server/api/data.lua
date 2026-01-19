API.data = {}

---@type table<unknown, integer>
local playerToDataId = {}
---@type table<integer, unknown>
local dataIdToPlayer = {}

local autoAssign = true

---@param player unknown
---@return integer? dataId
function API.data.get(player)
    player = tostring(player)

    return playerToDataId[player]
end

---@param dataId integer
---@return unknown? player
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

    Utils.addPlayerPrincipal(player, Utils.getDataAceName(dataId))
    if resource == nil then
        print(('Player %s (User ID %s) was auto-assigned Data ID %s')
            :format(player, userId, dataId))
    else
        print(('Player %s (User ID %s) was assigned Data ID %s by resource %s')
            :format(player, userId, dataId, resource))
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

    playerToDataId[source] = nil
    dataIdToPlayer[dataId] = nil
    Utils.removePlayerPrincipal(player, Utils.getDataAceName(dataId))
    print(('Player %s (User ID %s) was unassigned Data ID %s')
        :format(player, API.users.get(player), dataId))
    TriggerEvent('d4_playerdata:dataUnassigned', player, dataId)

    return true
end

---@param userId integer
---@return integer dataId
function API.data.create(userId)
    local dataId = Storage.dataId.increment()

    Storage.dataToUser.set(dataId, userId)
    Storage.userToData.set(userId, dataId)

    FlushResourceKvp()
    return dataId
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

exports('getDataId', API.data.get)
exports('getPlayerFromDataId', API.data.getPlayer)
exports('assignDataId', API.data.assign)
exports('unassignDataId', API.data.unassign)
exports('createDataId', API.data.create)
exports('disableDataAutoAssign', function()
    if not autoAssign then
        return
    end

    autoAssign = false
    print(('Data ID auto assignment has been disabled by resource %s')
        :format(GetInvokingResource()))
end)

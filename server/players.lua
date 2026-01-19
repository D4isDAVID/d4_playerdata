---@param player unknown
local function initPlayer(player)
    local userId = API.users.ensure(player)
    if not userId then
        print(('Player %s did not get a User ID'):format(player))
        DropPlayer(player, 'Failed to assign a User ID.')
        return
    end

    local dataId = API.data.autoAssign(player)
    if dataId and not API.data.assign(player, dataId) then
        print(('Player %s did not get Data ID %s'):format(player, dataId))
        DropPlayer(player, ('Failed to assign Data ID %s.'):format(dataId))
        return
    end
end

---@param player unknown
local function removePlayer(player)
    local dataId = API.data.get(player)
    if dataId then
        API.data.unassign(player)
    end

    local userId = API.users.get(player)
    if userId then
        API.users.remove(player)
    end
end

Utils.onResourceStop(function()
    for i = 0, GetNumPlayerIndices() - 1 do
        local player = GetPlayerFromIndex(i)
        removePlayer(player)
    end
end)

AddEventHandler('playerDropped', function()
    removePlayer(source)
end)
AddEventHandler('playerJoining', function()
    initPlayer(source)
end)

CreateThread(function()
    for i = 0, GetNumPlayerIndices() - 1 do
        local player = GetPlayerFromIndex(i)
        initPlayer(player)
    end
end)

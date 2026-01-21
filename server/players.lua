---@param player unknown
local function initPlayer(player)
    if Convars.usePersistIds() then
        local persistId = API.persist.ensure(player, true)
        if persistId == nil then
            print(('Player %s did not get a Persist ID'):format(player))
            DropPlayer(player, 'Failed to assign a Persist ID.')
            return
        end
    end

    local userId = API.users.ensure(player)
    if userId == nil then
        print(('Player %s did not get a User ID'):format(player))
        DropPlayer(player, 'Failed to assign a User ID.')
        return
    end

    local dataId = API.data.autoAssign(player)
    if dataId ~= nil and not API.data.assign(player, dataId) then
        print(('Player %s did not get Data ID %s'):format(player, dataId))
        DropPlayer(player, ('Failed to assign Data ID %s.'):format(dataId))
        return
    end
end

---@param player unknown
local function removePlayer(player)
    API.data.unassign(player)
    API.users.remove(player)
    API.persist.remove(player)
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

---@class Deferrals
---@field defer fun()
---@field update fun(message: string)
---@field done fun(failureReason?: string)

---@param name string
---@param setKickReason fun(reason: string)
---@param deferrals Deferrals
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local identifiers = Utils.getIdentifiers(source)

    if #identifiers == 0 then
        print(('Not letting %s in because they do not have any usable identifiers'):format(name))
        setKickReason('No identifiers available.')
    end

    deferrals.defer()
    local userId = API.users.get(source)

    if userId ~= nil and API.users.isConnected(userId) and not Convars.allowDuplicatePlayers() then
        print(('Not letting %s in because a player with their User ID is already connected'):format(name))
        deferrals.done('You are already in the server.')
    end

    deferrals.done()
end)

---@param player unknown
local function initPlayer(player)
    local userId = API.users.ensure(player)

    if not userId then
        print(('Player %s did not get a User ID'):format(player))
        DropPlayer(player, 'Failed to assign a User ID.')

        return
    end

    print(('Player %s was assigned User ID %s'):format(player, userId))
    TriggerEvent('d4_playerdata:playerJoined', player, userId)
end

AddEventHandler('playerJoining', function()
    initPlayer(source)
end)

CreateThread(function()
    for i = 0, GetNumPlayerIndices() - 1 do
        local player = GetPlayerFromIndex(i)
        initPlayer(player)
    end
end)

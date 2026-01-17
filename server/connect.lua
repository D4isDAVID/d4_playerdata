---@class Deferrals
---@field defer fun()
---@field update fun(message: string)
---@field done fun(failureReason?: string)

---@param name string
---@param deferrals Deferrals
AddEventHandler('playerConnecting', function(name, _, deferrals)
    local source = source

    deferrals.defer()
    Wait(0)

    local missingIdentifiers = Utils.getMissingIdentifiers(source)
    if #missingIdentifiers > 0 then
        local missingStr = table.concat(missingIdentifiers, ', ')
        print(('Dropping %s because of missing required identifiers: %s')
            :format(name, missingStr))
        deferrals.done(('You are missing required identifiers: %s')
            :format(missingStr))
        return
    end

    local identifiers = Utils.getIdentifiers(source)
    if #identifiers == 0 then
        print(('Dropping %s because there are no usable identifiers')
            :format(name))
        deferrals.done('No usable identifiers available.')
        return
    end

    local userId = API.users.get(source)

    if userId ~= nil and API.users.isConnected(userId) and not Convars.allowDuplicatePlayers() then
        print(('Dropping %s because their User ID is already connected')
            :format(name))
        deferrals.done('You are already in the server.')
        return
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

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

    if Convars.usePersistIds() then
        deferrals.update('Searching Persist ID...')
        local persistId = API.persist.ensure(source, true)
        if persistId ~= nil and Storage.persistBan.exists(persistId) then
            print(('Dropping %s (Persist ID %s) because they are banned')
                :format(name, persistId))
            deferrals.done('You are banned from this server.')
            return
        end
    end

    deferrals.update('Checking required identifiers...')

    local missingIdentifiers = Utils.getMissingIdentifiers(source)
    if #missingIdentifiers > 0 then
        local missingStr = table.concat(missingIdentifiers, ', ')
        print(('Dropping %s because of missing required identifiers: %s')
            :format(name, missingStr))
        deferrals.done(('You are missing required identifiers: %s')
            :format(missingStr))
        return
    end

    deferrals.update('Checking usable identifiers...')

    local identifiers = Utils.getIdentifiers(source)
    if #identifiers == 0 then
        print(('Dropping %s because there are no usable identifiers')
            :format(name))
        deferrals.done('No usable identifiers available.')
        return
    end

    if not Convars.allowDuplicateUsers() then
        deferrals.update('Searching User ID...')

        local userId = API.users.get(source)
        if userId ~= nil and API.users.isConnected(userId) then
            print(('Dropping %s because their User ID is already connected')
                :format(name))
            deferrals.done('You are already in the server.')
            return
        end
    end

    deferrals.done()
end)

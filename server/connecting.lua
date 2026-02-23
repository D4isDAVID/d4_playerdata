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

    deferrals.update('Checking required identifiers...')
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

    deferrals.update('Checking usable identifiers...')
    Wait(0)

    local identifiers = Utils.getIdentifiers(source)
    if #identifiers == 0 then
        print(('Dropping %s because there are no usable identifiers')
            :format(name))
        deferrals.done('No usable identifiers available.')
        return
    end

    if not Convars.allowDuplicateUsers() then
        deferrals.update('Searching User ID...')
        Wait(0)

        if not API.users.connect(source) then
            print(('Dropping %s because their User ID is already connected')
                :format(name))
            deferrals.done('You are already in the server.')
            return
        end
    end

    deferrals.done()
end)

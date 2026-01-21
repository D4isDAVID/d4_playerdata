API.persist = {}

---@type table<string, integer>
local playerToPersistId = {}
---@type table<integer, table<string, true>>
local persistIdToPlayers = {}

---@param player unknown
---@return integer? userId
function API.persist.get(player)
    player = tostring(player)

    return playerToPersistId[player]
end

---@param tokens string[]
---@param identifiers string[]
---@return integer[] persistIds
function API.persist.resolve(tokens, identifiers)
    local set = {}
    local persistIds = {}

    for i = 1, #tokens do
        local found = Storage.tokenToPersist.get(tokens[i])
        if found ~= nil and not set[found] then
            set[found] = true
            persistIds[#persistIds + 1] = found
        end
    end

    for i = 1, #identifiers do
        local found = Storage.identifierToPersist.get(identifiers[i])
        if found ~= nil and not set[found] then
            set[found] = true
            persistIds[#persistIds + 1] = found
        end
    end

    table.sort(persistIds)
    return persistIds
end

---@param persistId integer
---@param tokens string[]
local function linkTokens(persistId, tokens)
    for i = 1, #tokens do
        local token = tokens[i]
        Storage.tokenToPersist.set(token, persistId)
        Storage.persistToToken.set(persistId, token)
    end
end

---@param persistId integer
---@param identifiers string[]
local function linkIdentifiers(persistId, identifiers)
    for i = 1, #identifiers do
        local identifier = identifiers[i]
        Storage.identifierToPersist.set(identifier, persistId)
        Storage.persistToIdentifier.set(persistId, identifier)
    end
end

---@param persistId integer
---@param userId integer
function API.persist.linkUser(persistId, userId)
    local identifiers = Storage.userToIdentifier.getAll(userId)
    linkIdentifiers(persistId, identifiers)

    Storage.userToPersist.set(userId, persistId)
    Storage.persistToUser.set(persistId, userId)
end

---@param userId integer
function API.persist.unlinkUser(userId)
    local persistId = Storage.userToPersist.get(userId)
    if persistId ~= nil then
        Storage.userToPersist.delete(userId)
        Storage.persistToUser.delete(persistId, userId)
    end
end

---@param oldPersistId integer
---@param newPersistId integer
local function migrate(oldPersistId, newPersistId)
    local tokens = Storage.persistToToken.getAll(oldPersistId)
    local identifiers = Storage.persistToIdentifier.getAll(oldPersistId)
    local userIds = Storage.persistToUser.getAll(oldPersistId)

    linkTokens(newPersistId, tokens)
    Storage.persistToToken.deleteAll(oldPersistId)

    linkIdentifiers(newPersistId, identifiers)
    Storage.persistToIdentifier.deleteAll(oldPersistId)

    for i = 1, #userIds do
        local userId = userIds[i]
        API.persist.linkUser(newPersistId, userId)
        Storage.persistToUser.delete(oldPersistId, userId)
    end
end

---@param player unknown
---@return integer? persistId
function API.persist.ensure(player)
    player = tostring(player)

    local tokens = Utils.getTokens(player)
    local identifiers = GetPlayerIdentifiers(player)

    if #tokens == 0 and #identifiers == 0 then
        return nil
    end

    local persistIds = API.persist.resolve(tokens, identifiers)
    local userIds = API.users.resolve(identifiers)

    local persistId = persistIds[1]
    if persistId == nil then
        persistId = Storage.persistId.increment()
    end

    for i = 2, #persistIds do
        migrate(persistIds[i], persistId)
    end

    linkTokens(persistId, tokens)
    linkIdentifiers(persistId, identifiers)
    for i = 1, #userIds do
        API.persist.linkUser(persistId, userIds[i])
    end

    playerToPersistId[player] = persistId
    if persistIdToPlayers[persistId] == nil then
        persistIdToPlayers[persistId] = {}
    end
    persistIdToPlayers[persistId][player] = true

    print(('Player %s was assigned Persist ID %s'):format(player, persistId))
    FlushResourceKvp()

    return persistId
end

---@param player unknown
function API.persist.remove(player)
    player = tostring(player)

    local persistId = playerToPersistId[player]
    if persistId == nil then
        return
    end

    playerToPersistId[player] = nil
    persistIdToPlayers[persistId][player] = nil
    if next(persistIdToPlayers[persistId]) == nil then
        persistIdToPlayers[persistId] = nil
    end
end

exports('getPersistId', API.persist.get)
exports('resolvePersistIds', API.persist.resolve)

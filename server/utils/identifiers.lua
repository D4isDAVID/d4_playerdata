---@param identifier string
---@return string identifierType
function Utils.getIdentifierType(identifier)
    return identifier:match('([^:]+):')
end

---@param player unknown
---@return string[]
function Utils.getTokens(player)
    ---@type string[]
    local tokens = {}

    for i = 0, GetNumPlayerTokens(player) - 1 do
        tokens[#tokens + 1] = GetPlayerToken(player, i)
    end

    return tokens
end

---@param player unknown
---@return string[]
function Utils.getIdentifiers(player)
    local ignoredIdentifiers = Convars.ignoredIdentifiers()
    ---@type string[]
    local identifiers = {}

    for i = 0, GetNumPlayerIdentifiers(player) - 1 do
        local identifier = GetPlayerIdentifier(player, i)
        local idType = Utils.getIdentifierType(identifier)

        if not ignoredIdentifiers[idType] then
            identifiers[#identifiers + 1] = identifier
        end
    end

    return identifiers
end

---@param player unknown
---@return string[]
function Utils.getMissingIdentifiers(player)
    local requiredIdentifiers = Convars.requiredIdentifiers()
    ---@type string[]
    local missing = {}

    for i = 1, #requiredIdentifiers do
        local identifierType = requiredIdentifiers[i]
        local identifier = GetPlayerIdentifierByType(player, identifierType)

        if identifier == nil then
            missing[#missing + 1] = identifierType
        end
    end

    return missing
end

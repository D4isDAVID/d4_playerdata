local ignoredIdentifiers = {
    ip = true,
}

---@param identifier string
---@return string identifierType
function Utils.getIdentifierType(identifier)
    return identifier:match('([^:]+):')
end

---@param player unknown
---@return string[]
function Utils.getIdentifiers(player)
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

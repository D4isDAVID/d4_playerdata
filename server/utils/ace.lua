---@param player unknown
---@return string
function Utils.getPlayerAceName(player)
    return ('player.%s'):format(player)
end

---@param userId unknown
---@return string
function Utils.getUserAceName(userId)
    return ('user.%s'):format(userId)
end

---@param dataId unknown
---@return string
function Utils.getDataAceName(dataId)
    return ('data.%s'):format(dataId)
end

---@param child string
---@param parent string
function Utils.addPrincipal(child, parent)
    ExecuteCommand(('add_principal "%s" "%s"'):format(child, parent))
end

---@param child string
---@param parent string
function Utils.removePrincipal(child, parent)
    ExecuteCommand(('remove_principal "%s" "%s"'):format(child, parent))
end

---@param player unknown
---@param parent string
function Utils.addPlayerPrincipal(player, parent)
    Utils.addPrincipal(Utils.getPlayerAceName(player), parent)
end

---@param player unknown
---@param parent string
function Utils.removePlayerPrincipal(player, parent)
    Utils.removePrincipal(Utils.getPlayerAceName(player), parent)
end

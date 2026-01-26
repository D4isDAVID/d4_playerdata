---@param player unknown
---@return string
function Utils.getPlayerAceName(player)
    return ('player.%s'):format(player)
end

---@param userId integer
---@return string
function Utils.getUserAceName(userId)
    return ('user.%s'):format(userId)
end

---@param dataId integer
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

---@param userId integer
---@param parent string
function Utils.addUserPrincipal(userId, parent)
    Utils.addPrincipal(Utils.getUserAceName(userId), parent)
end

---@param userId unknown
---@param parent string
function Utils.removeUserPrincipal(userId, parent)
    Utils.removePrincipal(Utils.getUserAceName(userId), parent)
end

---@param dataId integer
---@param parent string
function Utils.addDataPrincipal(dataId, parent)
    Utils.addPrincipal(Utils.getDataAceName(dataId), parent)
end

---@param dataId unknown
---@param parent string
function Utils.removeDataPrincipal(dataId, parent)
    Utils.removePrincipal(Utils.getDataAceName(dataId), parent)
end

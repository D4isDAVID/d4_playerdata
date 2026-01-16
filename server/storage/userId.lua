Storage.userId = {}

local key = 'userId'

---@return integer userId
function Storage.userId.increment()
    local userId = GetResourceKvpInt(key) + 1

    SetResourceKvpIntNoSync(key, userId)

    return userId
end

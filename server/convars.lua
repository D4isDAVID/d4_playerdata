---@generic T : table
---@param name string
---@param default T
---@return T
local function getConvarTable(name, default)
    local raw = GetConvar(name, json.encode(default))
    local tbl = json.decode(raw)

    if type(tbl) ~= 'table' then
        return default
    end

    return tbl
end

---@generic T
---@param name string
---@param default T[]
---@return table<T, true>
local function getConvarSet(name, default)
    local tbl = getConvarTable(name, default)
    local set = {}

    for i = 1, #tbl do
        set[tbl[i]] = true
    end

    return set
end

---@generic T
---@param name string
---@param default T
---@param func fun(name: string, default: T): T
---@return T
local function createConvarHandler(name, default, func)
    local value = func(name, default)

    AddConvarChangeListener(name, function()
        value = func(name, default)
    end)

    return function()
        return value
    end
end

Convars = {
    ---@return boolean
    usePersistIds = createConvarHandler(
        'd4_playerdata_usePersistIds',
        true,
        GetConvarBool
    ),
    ---@return boolean
    allowDuplicateUsers = createConvarHandler(
        'd4_playerdata_allowDuplicateUsers',
        false,
        GetConvarBool
    ),
    ---@return boolean
    migrateMultipleUsers = createConvarHandler(
        'd4_playerdata_migrateMultipleUsers',
        false,
        GetConvarBool
    ),
    ---@return table<string, true>
    requiredIdentifiers = createConvarHandler(
        'd4_playerdata_requiredIdentifiers',
        {},
        getConvarTable
    ),
    ---@return table<string, true>
    ignoredIdentifiers = createConvarHandler(
        'd4_playerdata_ignoredIdentifiers',
        {},
        function(name, default)
            local value = getConvarSet(name, default)
            value['ip'] = true
            return value
        end
    ),
}

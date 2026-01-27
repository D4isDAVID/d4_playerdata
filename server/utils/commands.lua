---@class RegisterCommandParam
---@field name string
---@field help string?

---@class RegisterCommandOptions
---@field name string
---@field help string?
---@field params RegisterCommandParam[]?
---@field restricted boolean?

---@type RegisterCommandOptions[]
local commands = {}

---@param command RegisterCommandOptions
---@param handler fun(source: unknown, args: string[])
function Utils.registerCommand(command, handler)
    RegisterCommand(command.name, handler, command.restricted)

    command.name = '/' .. command.name
    commands[#commands + 1] = command

    TriggerClientEvent('chat:addSuggestion', -1, command)
end

AddEventHandler('playerJoining', function()
    TriggerClientEvent('chat:addSuggestions', source, commands)
end)

CreateThread(function()
    TriggerClientEvent('chat:addSuggestions', -1, commands)
end)

---@param name string
---@param param string
---@return string player
function Utils.parsePlayerParam(name, param)
    if param == nil or not DoesPlayerExist(param) then
        error(("Invalid player ID for parameter '%s'"):format(name))
    end

    return param
end

---@param name string
---@param param string
---@return number integer
function Utils.parseNumberParam(name, param)
    local parsed = tonumber(param)
    if parsed == nil then
        error(("Invalid number value for parameter '%s'"):format(name))
    end

    return parsed
end

---@param name string
---@param param string
---@return integer integer
function Utils.parseIntegerParam(name, param)
    return math.floor(Utils.parseNumberParam(name, param))
end

---@param name string
---@param param string
---@return integer userId
function Utils.parseUserIdParam(name, param)
    local userId = Utils.parseIntegerParam(name, param)
    if not API.users.exists(userId) then
        error(("Invalid User ID for parameter '%s'"):format(name))
    end

    return userId
end

---@param name string
---@param param string
---@return integer persistId
function Utils.parsePersistIdParam(name, param)
    local persistId = Utils.parseIntegerParam(name, param)
    if not API.persist.exists(persistId) then
        error(("Invalid Persist ID for parameter '%s'"):format(name))
    end

    return persistId
end

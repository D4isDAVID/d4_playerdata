---@class RegisterCommandParam<T>
---@field name string
---@field help string?
---@field parser? fun(name: string, value: string): T

---@class RegisterCommandOptions
---@field name string
---@field help string?
---@field params RegisterCommandParam[]?
---@field restricted boolean?

---@type RegisterCommandOptions[]
local commands = {}

---@param player unknown
---@param message string
local function sendCommandResult(player, message)
    exports.chat:addMessage(player, {
        args = { message },
    })
end

---@param command RegisterCommandOptions
---@param handler fun(source: unknown, args: unknown[]): unknown
function Utils.registerCommand(command, handler)
    ---@param source unknown
    ---@param rawArgs string[]
    ---@return unknown
    local wrapped = function(source, rawArgs)
        local params = command.params or {}
        local args = {}

        for i = 1, #rawArgs do
            local param = params[i] or {}
            local arg = rawArgs[i]

            if param.parser == nil then
                args[i] = arg
            else
                args[i] = param.parser(param.name, arg)
            end
        end

        for i = 1, #params do
            if args[i] == nil then
                error(('Parameter %s not provided'):format(params[i].name))
            end
        end

        return handler(source, args)
    end

    RegisterCommand(command.name, function(source, args)
        CreateThread(function()
            local success, result = pcall(wrapped, source, args)
            local message = tostring(result)

            if success then
                sendCommandResult(source, message)
            else
                sendCommandResult(source, '^1' .. message .. '^7')
            end
        end)
    end, command.restricted)

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
---@return integer dataId
function Utils.parseDataIdParam(name, param)
    local dataId = Utils.parseIntegerParam(name, param)
    if not API.data.exists(dataId) then
        error(("Invalid Data ID for parameter '%s'"):format(name))
    end

    return dataId
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

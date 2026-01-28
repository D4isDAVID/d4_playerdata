---@param resource string
---@param func fun()
---@return EventHandler
function Utils.onResourceStop(resource, func)
    ---@param stopped string
    return AddEventHandler('onResourceStop', function(stopped)
        if stopped == resource then
            func()
        end
    end)
end

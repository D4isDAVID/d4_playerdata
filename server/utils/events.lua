---@param func fun()
---@return EventHandler
function Utils.onResourceStop(func)
    return AddEventHandler('onResourceStop', function(resource)
        if resource == Utils.currentResource then
            func()
        end
    end)
end

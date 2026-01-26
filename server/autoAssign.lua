local METADATA = 'd4_playerdata_disableDataAutoAssign'

---@type table<string, true>
local resources = {}

---@param resource string
local function onResourceStart(resource)
    local metadataCount = GetNumResourceMetadata(resource, METADATA)
    if metadataCount == 0 or resources[resource] then return end

    resources[resource] = true
    API.data.toggleAutoAssign(false, resource)
end

---@param resource string
local function onResourceStop(resource)
    if not resources[resource] then return end

    resources[resource] = nil
    if next(resources) == nil then
        API.data.toggleAutoAssign(true)
    end
end

AddEventHandler('onResourceStart', onResourceStart)
AddEventHandler('onResourceStop', onResourceStop)

for i = 0, GetNumResources() - 1 do
    local resource = GetResourceByFindIndex(i)
    local state = GetResourceState(resource)

    if state == 'started' then
        onResourceStart(resource)
    end
end

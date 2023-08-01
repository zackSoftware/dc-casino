---@diagnostic disable: param-type-mismatch

local takenChair = {}
RegisterNetEvent('dc-casino:roulette:server:syncChairs', function(type, chairCoords)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))

    if type == 'enter' and #(playerCoords - chairCoords) >= 5 then return end

    if type == 'enter' then
        if takenChair[source] then
            TriggerClientEvent('dc-casino:roulette:client:syncChairs', -1, 'leave', takenChair[source])
            table.remove(takenChair, source)
        end
        takenChair[source] = chairCoords
    elseif type == 'leave' then
        table.remove(takenChair, source)
    end
    TriggerClientEvent('dc-casino:roulette:client:syncChairs', -1, type, chairCoords)
end)

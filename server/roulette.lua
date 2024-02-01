---@diagnostic disable: param-type-mismatch

local takenChair, activeTables = {}, {}

RegisterNetEvent('dc-casino:roulette:server:syncChairs', function(type, chairCoords)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))

    if type == 'enter' and #(playerCoords - chairCoords) >= 5 then return end

    if type == 'enter' then
        if takenChair[source] then
            TriggerClientEvent('dc-casino:roulette:client:syncChairs', -1, 'leave', takenChair[source])
        end
        takenChair[source] = chairCoords
    elseif type == 'leave' then
        takenChair[source] = nil
    end
    TriggerClientEvent('dc-casino:roulette:client:syncChairs', -1, type, chairCoords)
end)

local function checkActivePlayers(tableIndex)
    ::redo::
    for i = 1, #activeTables[tableIndex] do
        if not DoesPlayerExist(activeTables[tableIndex][i]) or not takenChair[activeTables[tableIndex][i]] then table.remove(activeTables[tableIndex], i) goto redo end
    end

    if #activeTables[tableIndex] == 0 then return false else return true end
end

local function startTableHandler(tableIndex)
    CreateThread(function()
        while #activeTables[tableIndex] > 0 do

            if not checkActivePlayers(tableIndex) then break end

            for i = 1, #activeTables[tableIndex] do
                TriggerClientEvent('dc-casino:roulette:client:startBetting', activeTables[tableIndex][i], tableIndex)
            end

            Wait(30000)

            if not checkActivePlayers(tableIndex) then break end

            local randomResult = math.random(1, 38)
            TriggerClientEvent('dc-casino:roulette:client:startRoulette', -1, randomResult, tableIndex)
            lib.callback.await('dc-casino:roulette:callback:checkObject', activeTables[tableIndex][1])

            local playerBets = {}

            for i = 1, #activeTables[tableIndex] do
                playerBets[#playerBets + 1] = {
                    source = activeTables[tableIndex][i],
                    chosen = lib.callback.await('dc-casino:roulette:callback:getClientInput', activeTables[tableIndex][i])
                }
            end

            for i = 1, #playerBets do
                local player = ESX.GetPlayerFromId(playerBets[i].source)
                local bettingAmount, potentialReward = 0, 0
                for j = 1, #playerBets[i].chosen do
                    bettingAmount = bettingAmount + playerBets[i].chosen[j].amount
                    for k = 1, #playerBets[i].chosen[j].bets do
                        if playerBets[i].chosen[j].bets[k] == randomResult then
                            potentialReward = potentialReward + (playerBets[i].chosen[j].amount * RouletteRewards[#playerBets[i].chosen[j].bets] + playerBets[i].chosen[j].amount)
                        end
                    end
                end
                if bettingAmount > 0 then
                    if UseCash and player.removeAccountMoney('cash', bettingAmount)
                    or UseBank and player.removeAccountMoney('bank', bettingAmount)
                    or UseItem and player.removeInventoryItem(ItemName, bettingAmount) then
                        if UseCash and player.addAccountMoney('cash', potentialReward, 'Casino Slot Spin')
                        or UseBank and player.addAccountMoney('bank', potentialReward, 'Casino Slot Spin')
                        or UseItem and player.addAccountMoney(ItemName, potentialReward) then  player.showNotification('You won back €'..potentialReward) end
                    else
                        player.showNotification('Nothing left to bet with')
                    end
                end
            end

            Wait(0)
        end
    end)
end

RegisterNetEvent('dc-casino:roulette:server:enterTable', function(rouletteIndex)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))

    if not takenChair[source] then return end
    if #(playerCoords - RouletteLocations[rouletteIndex].coords.xyz) >= 5 then return end

    if activeTables[rouletteIndex] and activeTables[rouletteIndex][1] then
        activeTables[rouletteIndex][#activeTables[rouletteIndex]+1] = source
    else
        activeTables[rouletteIndex] = { source }
        startTableHandler(rouletteIndex)
    end
end)

AddEventHandler('playerDropped', function()
    if takenChair[source] then
        TriggerClientEvent('dc-casino:roulette:client:syncChairs', -1, 'leave', takenChair[source])
        table.remove(takenChair, source)
    end
end)

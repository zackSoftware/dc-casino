local QBCore = exports['qb-core']:GetCoreObject()
local UsedSlots = {}
local Slots = {}

RegisterNetEvent('dc-casino:slots:server:enter', function(netID, ReelLocation1, ReelLocation2, ReelLocation3)
    local src = source
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local SlotEntity = NetworkGetEntityFromNetworkId(netID)
    local SlotModel = GetEntityModel(SlotEntity)
    local SlotCoords = GetEntityCoords(SlotEntity)

    if not SlotReferences[SlotModel] then return end
    if #(PlayerCoords - SlotCoords) > 4 then return end
    if #(SlotCoords - ReelLocation1) > 2 or #(SlotCoords - ReelLocation2) > 2 or #(SlotCoords - ReelLocation2) > 2 then return end
    if UsedSlots[netID] then return end

    UsedSlots[netID] = true
    TriggerClientEvent('dc-casino:slots:client:enter', src)
    SetTimeout(1000, function()
        local ReelEntity1 = CreateObject(SlotReferences[SlotModel].reela, ReelLocation1, true, false, false)
        local ReelEntity2 = CreateObject(SlotReferences[SlotModel].reela, ReelLocation2, true, false, false)
        local ReelEntity3 = CreateObject(SlotReferences[SlotModel].reela, ReelLocation3, true, false, false)
        while not DoesEntityExist(ReelEntity1) do Wait(0) end
        while not DoesEntityExist(ReelEntity2) do Wait(0) end
        while not DoesEntityExist(ReelEntity3) do Wait(0) end    
        Slots[src] = {
            Slot = NetworkGetEntityFromNetworkId(netID),
            SlotNetID = netID,
            Reference = SlotReferences[SlotModel],
            Reel1 = ReelEntity1,
            Reel2 = ReelEntity2,
            Reel3 = ReelEntity3,
            ReelLoc1 = ReelLocation1,
            ReelLoc2 = ReelLocation2,
            ReelLoc3 = ReelLocation3,
        }
        FreezeEntityPosition(Slots[src].Reel1, true)
        FreezeEntityPosition(Slots[src].Reel2, true)
        FreezeEntityPosition(Slots[src].Reel3, true)
        local SlotHeading = GetEntityHeading(SlotEntity)
        SetEntityRotation(Slots[src].Reel1, 0.0, 0.0, SlotHeading, 2, 1)
        SetEntityRotation(Slots[src].Reel2, 0.0, 0.0, SlotHeading, 2, 1)
        SetEntityRotation(Slots[src].Reel3, 0.0, 0.0, SlotHeading, 2, 1)
    end)
end)

RegisterNetEvent('dc-casino:slots:server:spin', function()
    local src = source
    local SpinTime = math.random(4000, 6000)
    local ReelRewards = {
        math.random(0, 15),
        math.random(0, 15),
        math.random(0, 15)
    }
    local SlotHeading = GetEntityHeading(Slots[src].Slot)

    if not Slots[src] then return end

    local BlurryReel1 = CreateObject(Slots[src].Reference.reelb, Slots[src].ReelLoc1, true, false, false)
    local BlurryReel2 = CreateObject(Slots[src].Reference.reelb, Slots[src].ReelLoc2, true, false, false)
    local BlurryReel3 = CreateObject(Slots[src].Reference.reelb, Slots[src].ReelLoc3, true, false, false)
    while not DoesEntityExist(BlurryReel1) do Wait(0) end
    while not DoesEntityExist(BlurryReel2) do Wait(0) end
    while not DoesEntityExist(BlurryReel3) do Wait(0) end
    FreezeEntityPosition(BlurryReel1, true)
    FreezeEntityPosition(BlurryReel2, true)
    FreezeEntityPosition(BlurryReel3, true)
    SetEntityRotation(BlurryReel1, 0.0, 0.0, SlotHeading, 2, 1)
    SetEntityRotation(BlurryReel2, 0.0, 0.0, SlotHeading, 2, 1)
    SetEntityRotation(BlurryReel3, 0.0, 0.0, SlotHeading, 2, 1)
    TriggerClientEvent('dc-casino:slots:client:spinreels', src, SpinTime, ReelRewards[1] * 22.5, ReelRewards[2] * 22.5, ReelRewards[3] * 22.5, NetworkGetNetworkIdFromEntity(BlurryReel1), NetworkGetNetworkIdFromEntity(BlurryReel2), NetworkGetNetworkIdFromEntity(BlurryReel3), NetworkGetNetworkIdFromEntity(Slots[src].Reel1), NetworkGetNetworkIdFromEntity(Slots[src].Reel2), NetworkGetNetworkIdFromEntity(Slots[src].Reel3))
    SetTimeout(SpinTime, function()
        
    end)
end)

RegisterNetEvent('dc-casino:slots:server:leave', function()
    local src = source
    if DoesEntityExist(Slots[src].Reel1) then DeleteEntity(Slots[src].Reel1) end
    if DoesEntityExist(Slots[src].Reel2) then DeleteEntity(Slots[src].Reel2) end
    if DoesEntityExist(Slots[src].Reel3) then DeleteEntity(Slots[src].Reel3) end
    UsedSlots[Slots[src].SlotNetID] = false
    Slots[src] = {}
end)

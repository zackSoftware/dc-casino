local rouletteEntities, roulettePeds, highlightEntities = {}, {}, {}
local pedComp = SetPedComponentVariation
local randomPedClothes = {
    function(ped) pedComp(ped, 0, 4, 0, 0) pedComp(ped, 1, 0, 0, 0) pedComp(ped, 2, 4, 0, 0) pedComp(ped, 3, 2, 1, 0) pedComp(ped, 4, 1, 0, 0) pedComp(ped, 6, 1, 0, 0) pedComp(ped, 7, 1, 0, 0) pedComp(ped, 8, 2, 0, 0) pedComp(ped, 10, 0, 0, 0) pedComp(ped, 11, 0, 0, 0) SetPedVoiceGroup(ped, `S_F_Y_Casino_01_LATINA_01`) end,
    function(ped) pedComp(ped, 0, 3, 0, 0) pedComp(ped, 1, 1, 0, 0) pedComp(ped, 2, 3, 0, 0) pedComp(ped, 3, 2, 1, 0) pedComp(ped, 4, 0, 0, 0) pedComp(ped, 6, 1, 0, 0) pedComp(ped, 7, 2, 0, 0) pedComp(ped, 8, 3, 0, 0) pedComp(ped, 10, 1, 0, 0) pedComp(ped, 11, 0, 0, 0) SetPedVoiceGroup(ped, `S_F_Y_Casino_01_ASIAN_01`) end,
    function(ped) pedComp(ped, 0, 2, 1, 0) pedComp(ped, 1, 1, 0, 0) pedComp(ped, 2, 2, 0, 0) pedComp(ped, 3, 0, 3, 0) pedComp(ped, 4, 0, 0, 0) pedComp(ped, 6, 1, 0, 0) pedComp(ped, 7, 2, 0, 0) pedComp(ped, 8, 1, 0, 0) pedComp(ped, 10, 1, 0, 0) pedComp(ped, 11, 0, 0, 0) SetPedVoiceGroup(ped, `S_F_Y_Casino_01_ASIAN_02`) end,
    function(ped) pedComp(ped, 0, 2, 0, 0) pedComp(ped, 1, 1, 0, 0) pedComp(ped, 2, 3, 0, 0) pedComp(ped, 3, 1, 3, 0) pedComp(ped, 4, 0, 0, 0) pedComp(ped, 6, 1, 0, 0) pedComp(ped, 7, 2, 0, 0) pedComp(ped, 8, 3, 0, 0) pedComp(ped, 10, 1, 0, 0) pedComp(ped, 11, 0, 0, 0) SetPedVoiceGroup(ped, `S_F_Y_Casino_01_LATINA_01`) end,
    function(ped) pedComp(ped, 0, 4, 0, 0) pedComp(ped, 1, 1, 0, 0) pedComp(ped, 2, 0, 0, 0) pedComp(ped, 3, 0, 0, 0) pedComp(ped, 4, 0, 0, 0) pedComp(ped, 6, 1, 0, 0) pedComp(ped, 7, 2, 0, 0) pedComp(ped, 8, 1, 0, 0) pedComp(ped, 10, 1, 0, 0) pedComp(ped, 11, 0, 0, 0) SetPedVoiceGroup(ped, `S_F_Y_Casino_01_LATINA_02`) end,
    function(ped) pedComp(ped, 0, 1, 1, 0) pedComp(ped, 1, 0, 0, 0) pedComp(ped, 2, 1, 0, 0) pedComp(ped, 3, 0, 3, 0) pedComp(ped, 4, 0, 0, 0) pedComp(ped, 6, 0, 0, 0) pedComp(ped, 7, 0, 0, 0) pedComp(ped, 8, 0, 0, 0) pedComp(ped, 10, 1, 0, 0) pedComp(ped, 11, 0, 0, 0) SetPedVoiceGroup(ped, `S_F_Y_Casino_01_ASIAN_01`) end,
    function(ped) pedComp(ped, 0, 1, 1, 0) pedComp(ped, 1, 0, 0, 0) pedComp(ped, 2, 1, 1, 0) pedComp(ped, 3, 1, 3, 0) pedComp(ped, 4, 0, 0, 0) pedComp(ped, 6, 0, 0, 0) pedComp(ped, 7, 2, 0, 0) pedComp(ped, 8, 1, 0, 0) pedComp(ped, 10, 1, 0, 0) pedComp(ped, 11, 0, 0, 0) SetPedVoiceGroup(ped, `S_F_Y_Casino_01_ASIAN_02`) end,
    function(ped) pedComp(ped, 0, 2, 1, 0) pedComp(ped, 1, 0, 0, 0) pedComp(ped, 2, 2, 1, 0) pedComp(ped, 3, 3, 3, 0) pedComp(ped, 4, 1, 0, 0) pedComp(ped, 6, 1, 0, 0) pedComp(ped, 7, 2, 0, 0) pedComp(ped, 8, 3, 0, 0) pedComp(ped, 10, 0, 0, 0) pedComp(ped, 11, 0, 0, 0) SetPedVoiceGroup(ped, `S_F_Y_Casino_01_LATINA_02`) end,
}

local function setupRoulette(index)
    rouletteEntities[index] = CreateObject(`vw_prop_casino_roulette_01b`, RouletteLocations[index].coords.x, RouletteLocations[index].coords.y, RouletteLocations[index].coords.z, false, true, false)
    SetEntityHeading(rouletteEntities[index], RouletteLocations[index].coords.w)
    local pedCoordsX = -0.1 * Cos(RouletteLocations[index].coords.w) - 0.6 * Sin(RouletteLocations[index].coords.w)
    local pedCoordsY = -0.1 * Sin(RouletteLocations[index].coords.w) + 0.6 * Cos(RouletteLocations[index].coords.w)
    local pedCoords = vector3(pedCoordsX, pedCoordsY, 0.0) + RouletteLocations[index].coords.xyz
    roulettePeds[index] = CreatePed(26, `s_f_y_casino_01`, pedCoords.x, pedCoords.y, pedCoords.z, RouletteLocations[index].coords.w - 180, false, true)
    SetEntityCanBeDamaged(roulettePeds[index], false)
    SetPedAsEnemy(roulettePeds[index], false)
    SetBlockingOfNonTemporaryEvents(roulettePeds[index], true)
    SetPedResetFlag(roulettePeds[index], 249, true)
    SetPedConfigFlag(roulettePeds[index], 185, true)
    SetPedConfigFlag(roulettePeds[index], 108, true)
    N_0x352e2b5cf420bf3b(roulettePeds[index], true)
    SetPedCanEvasiveDive(roulettePeds[index], false)
    N_0x2f3c3d9f50681de4(roulettePeds[index], true)
    SetPedCanRagdollFromPlayerImpact(roulettePeds[index], false)
    SetPedConfigFlag(roulettePeds[index], 208, true)
    SetPedDefaultComponentVariation(roulettePeds[index])
    randomPedClothes[math.random(1, #randomPedClothes)](roulettePeds[index])
end

local function deleteRouletteTable(index)
    if DoesEntityExist(rouletteEntities[index]) then DeleteObject(rouletteEntities[index]) end
    if DoesEntityExist(roulettePeds[index]) then DeleteEntity(roulettePeds[index]) end
end

CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(cache.ped)
        for i = 1, #RouletteLocations do
            if #(playerCoords - RouletteLocations[i].coords.xyz) <= 40 then
                if not RouletteLocations[i].spawned then
                    RouletteLocations[i].spawned = true
                    lib.requestModel(`vw_prop_casino_roulette_01b`)
                    lib.requestModel(`s_f_y_casino_01`)
                    setupRoulette(i)
                    SetModelAsNoLongerNeeded(`vw_prop_casino_roulette_01b`)
                    SetModelAsNoLongerNeeded(`s_f_y_casino_01`)
                end
            elseif #(playerCoords - RouletteLocations[i].coords.xyz) >= 100 then
                if RouletteLocations[i].spawned then
                    RouletteLocations[i].spawned = false
                    deleteRouletteTable(i)
                end
            end
        end
        Wait(1000)
    end
end)

local function deleteRouletteTables()
    for i = 1, #rouletteEntities do
        if DoesEntityExist(rouletteEntities[i]) then DeleteObject(rouletteEntities[i]) end
    end
    for i = 1, #roulettePeds do
        if DoesEntityExist(roulettePeds[i]) then DeleteEntity(roulettePeds[i]) end
    end
end

AddEventHandler('onResourceStop', deleteRouletteTables)

local sittingInAChair, chairInfo, rouletteInfo, chosenBets = false, {}, {}, {}
local randomExitScene = { 'sit_exit_left' }

local function leaveChair()
    sittingInAChair = false
    TriggerServerEvent('dc-casino:roulette:server:syncChairs', 'leave', chairInfo.coords)
end

local function checkChair()
    CreateThread(function()
        while sittingInAChair do
            local playerCoords = GetEntityCoords(cache.ped)
            if #(playerCoords - chairInfo.coords) >= 5 then
                leaveChair()
            end
            Wait(1000)
        end
    end)
end

local function checkCamera()
    CreateThread(function()
        local bettingCoordX, bettingCoordY = 0.4 * Cos(rouletteInfo.coords.w) - 0.0 * Sin(rouletteInfo.coords.w), 0.4 * Sin(rouletteInfo.coords.w) + 0.0 * Cos(rouletteInfo.coords.w)
        local bettingCamera = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', rouletteInfo.coords.x + bettingCoordX, rouletteInfo.coords.y + bettingCoordY, rouletteInfo.coords.z + 2.0, -90.0, 0.0, rouletteInfo.rotation.z, 70.0, false, 2)
        local rouletteCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', rouletteInfo.coords.x, rouletteInfo.coords.y, rouletteInfo.coords.z + 2.4, 0.0, 0.0, 0.0, 40.0, false, 2)
        local rouletteWheelCoords = GetEntityBonePosition_2(rouletteInfo.entity, GetEntityBoneIndexByName(rouletteInfo.entity, 'Roulette_Wheel'))
        PointCamAtCoord(rouletteCam, rouletteWheelCoords.x, rouletteWheelCoords.y, rouletteWheelCoords.z)
        local function turnOffCams() RenderScriptCams(false, false, 0, true, false) SetCamActive(bettingCamera, false) SetCamActive(rouletteCam, false) end
        while sittingInAChair do
            local cameraMode = GetFollowPedCamViewMode()
            if cameraMode == 0 then
                N_0x79c0e43eb9b944e2('CASINO_ROULETTE_CAMERA')
            elseif cameraMode == 1 then
                if not IsCamActive(bettingCamera) then
                    turnOffCams()
                    SetCamActive(bettingCamera, true)
                    RenderScriptCams(true, true, 2000, true, false)
                end
            elseif cameraMode == 2 then
                if not IsCamActive(rouletteCam) then
                    turnOffCams()
                    SetCamActive(rouletteCam, true)
                    RenderScriptCams(true, false, 0, true, false)
                end
            elseif cameraMode == 4 then
                if IsCamActive(rouletteCam) or IsCamActive(bettingCamera) then
                    turnOffCams()
                end
            end
            Wait(0)
        end
        turnOffCams()
    end)
end

local function getClosestBettingPoint(mouseX, mouseY)
    local closestOption = 1
    for i = 1, #BetPositions do
        if #(vec2(mouseX, mouseY) - vec2(BetPositions[i].coords.x, BetPositions[i].coords.y)) < #(vec2(mouseX, mouseY) - vec2(BetPositions[closestOption].coords.x, BetPositions[closestOption].coords.y)) then
            closestOption = i
        end
    end
    return BetPositions[closestOption].options
end

local function deleteHighlights()
    for i = 1, #highlightEntities do
        if DoesEntityExist(highlightEntities[i]) then DeleteEntity(highlightEntities[i]) end
    end
end

AddEventHandler('onResourceStop', deleteHighlights)

local function showHighlights(bettingOptions)
    deleteHighlights()
    lib.requestModel(`vw_prop_vw_marker_01a`)
    lib.requestModel(`vw_prop_vw_marker_02a`)
    for i = 1, #bettingOptions do
        local model = bettingOptions[i] == 37 and `vw_prop_vw_marker_01a` or bettingOptions[i] == 38 and `vw_prop_vw_marker_01a` or `vw_prop_vw_marker_02a`
        local offsetX = HighlightPositions[bettingOptions[i]].x * Cos(rouletteInfo.coords.w) - HighlightPositions[bettingOptions[i]].y * Sin(rouletteInfo.coords.w)
        local offsetY = HighlightPositions[bettingOptions[i]].x * Sin(rouletteInfo.coords.w) + HighlightPositions[bettingOptions[i]].y * Cos(rouletteInfo.coords.w)
        highlightEntities[i] = CreateObject(model, rouletteInfo.coords.x + offsetX, rouletteInfo.coords.y + offsetY, rouletteInfo.coords.z + HighlightPositions[i].z, false, true, false)
        SetEntityHeading(highlightEntities[i], rouletteInfo.coords.w)
        SetEntityDynamic(highlightEntities[i], false)
        SetEntityHasGravity(highlightEntities[i], false)
        SetEntityCompletelyDisableCollision(highlightEntities[i], false, false)
        SetEntityAlpha(highlightEntities[i], 200, true)
        SetObjectTextureVariation(highlightEntities[i], 1)
    end
end

local function highlightBets()
    CreateThread(function()
        local currentBets = {}
        while sittingInAChair do
            if GetFollowPedCamViewMode() == 1 then
                SetMouseCursorActiveThisFrame()
                local mouseX, mouseY = GetControlNormal(0, 239), GetControlNormal(0, 240)
                local getBets = getClosestBettingPoint(mouseX, mouseY)
                if getBets ~= currentBets then
                    currentBets = getBets
                    showHighlights(currentBets)
                end
                Wait(0)
            else
                Wait(500)
            end
        end
        deleteHighlights()
    end)
end

local function startRouletteHandler()
    checkChair()
    checkCamera()
    highlightBets()
    CreateThread(function()
        while sittingInAChair do
            if IsControlJustReleased(0, 202) then
                local exitScene = NetworkCreateSynchronisedScene(chairInfo.coords.x, chairInfo.coords.y, chairInfo.coords.z, chairInfo.rotation.x, chairInfo.rotation.y, chairInfo.rotation.z, 2, true, false, 1065353216, 13, 1.0)
                NetworkAddPedToSynchronisedScene(cache.ped, exitScene, 'anim_casino_b@amb@casino@games@shared@player@', randomExitScene[math.random(1, #randomExitScene)], 2.0, -2.0, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(exitScene)
                leaveChair()
                Wait(GetAnimDuration('anim_casino_b@amb@casino@games@shared@player@', 'sit_exit_left') * 600)
                NetworkStopSynchronisedScene(exitScene)
            end
            Wait(0)
        end
    end)
end

local takenChairs = {}
local randomEnterScene = { 'sit_enter_left', 'sit_enter_left_side', 'sit_enter_right_side', 'sit_enter_right' }

local function isChairTaken(chairCoords)
    local nearbyChair
    for i = 1, #takenChairs do
        if takenChairs[i] == chairCoords then
            nearbyChair = i
        end
    end
    return nearbyChair
end

local function enterClosestChair(rouletteIndex)
    local allRouletteChairs, rouletteChairsOrdered = {}, {}
    for i = 1, 4 do
        local boneIndex = GetEntityBoneIndexByName(rouletteEntities[i], string.format('Chair_Base_0%s', i))
        allRouletteChairs[i] = { coords = GetEntityBonePosition_2(rouletteEntities[rouletteIndex], boneIndex), rotation = GetEntityBoneRotation(rouletteEntities[rouletteIndex], boneIndex) }
    end
    local playerCoords = GetEntityCoords(cache.ped)
    repeat
        local closestChair = 1
        for i = 1, #allRouletteChairs do
            if #(playerCoords - allRouletteChairs[i].coords) < #(playerCoords - allRouletteChairs[closestChair].coords) then
                closestChair = i
            end
        end
        rouletteChairsOrdered[#rouletteChairsOrdered + 1] = { coords = allRouletteChairs[closestChair].coords, rotation = allRouletteChairs[closestChair].rotation }
        table.remove(allRouletteChairs, closestChair)
    until #allRouletteChairs == 0
    for i = 1, #rouletteChairsOrdered do
        if #(playerCoords - rouletteChairsOrdered[i].coords) <= 1.5 then
            if not isChairTaken(rouletteChairsOrdered[i].coords) and not sittingInAChair then
                sittingInAChair = true
                chairInfo = { coords = rouletteChairsOrdered[i].coords, rotation = rouletteChairsOrdered[i].rotation }
                rouletteInfo = { coords = RouletteLocations[rouletteIndex].coords, rotation = GetEntityRotation(rouletteEntities[rouletteIndex]), entity = rouletteEntities[rouletteIndex] }
                local enterScene = NetworkCreateSynchronisedScene(rouletteChairsOrdered[i].coords.x, rouletteChairsOrdered[i].coords.y, rouletteChairsOrdered[i].coords.z, rouletteChairsOrdered[i].rotation.x, rouletteChairsOrdered[i].rotation.y, rouletteChairsOrdered[i].rotation.z, 2, true, false, 1065353216, 13, 1.0)
                NetworkAddPedToSynchronisedScene(cache.ped, enterScene, 'anim_casino_b@amb@casino@games@shared@player@', randomEnterScene[math.random(1, #randomEnterScene)], 2.0, -2.0, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(enterScene)
                TriggerServerEvent('dc-casino:roulette:server:syncChairs', 'enter', rouletteChairsOrdered[i].coords)
                TriggerServerEvent('dc-casino:roulette:server:enterTable', rouletteIndex)
                startRouletteHandler()
            end
        end
    end
    if not sittingInAChair then lib.notify({ id = 'roulette_Chair', title = 'This seat isn\'t available', type = 'error' }) end
end

CreateThread(function()
    while true do
        local sleep = 600
        local playerCoords = GetEntityCoords(cache.ped)
        for i = 1, #RouletteLocations do
            if #(playerCoords - RouletteLocations[i].coords.xyz) < 2.4 and not sittingInAChair then
                sleep = 0
                DrawText3D(RouletteLocations[i].coords.xyz + vec3(0, 0, 1.2), "~o~E~w~ - Enter")
                if IsControlJustReleased(0, 38) then
                    enterClosestChair(i)
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('dc-casino:roulette:client:syncChairs', function(type, chairCoords)
    if type == 'enter' then
        takenChairs[#takenChairs + 1] = chairCoords
    elseif type == 'leave' then
        local chairIndex = isChairTaken(chairCoords)
        if chairIndex then table.remove(takenChairs, chairIndex) end
    end
end)

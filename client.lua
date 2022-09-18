local Slot
local SlotCoords
local ClosestSlot
local ClosestSlotCoord = vector3(0, 0, 0)
local NearbySlot
local EnteredSlot
local SlotObject1
local SlotObject2
local SlotObject3
local ReelLocation1
local ReelLocation2
local ReelLocation3
local ClosestSlotForwardX
local ClosestSlotForwardY
local ShouldDrawScaleForm = false
local Scaleform
local ClosestSlotModel
local AnimDict = 'anim_casino_a@amb@casino@games@slots@male'
local Slots = {
    2362925439,
    2775323096,
    3863977906,
    654385216,
    161343630,
    1096374064,
    207578973,
    3807744938
}
local RandomEnter = {
    'enter_left',
    'enter_right',
    'enter_left_short',
    'enter_right_short'
}
local RandomLeave = {
    'exit_left',
    'exit_right'
}
local RandomIdle = {
    'base_idle_a',
    'base_idle_b',
    'base_idle_c',
    'base_idle_d',
    'base_idle_e',
    'base_idle_f'
}
local RandomSpin = {
    'press_spin_a',
    'press_spin_b',
    'pull_spin_a',
    'pull_spin_b'
}
local Sounds = {
    function() PlaySoundFromCoord(-1, 'no_win', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'small_win', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'big_win', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'jackpot', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'place_bet', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'place_max_bet', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'spinning', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'start_spin', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'wheel_stop_clunk', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'wheel_stop_on_prize', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'welcome_stinger', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'spin_wheel', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'spin_wheel_win', ClosestSlotCoord, SlotReferences[ClosestSlotModel].sound, false, 20, false) end
}
local RandomEnterMessage = {
    'Daring today?',
    'You will lose money!',
    'You have coins?'
}
local ChosenBetAmount = 1
local BetAmounts = {
    50,
    100,
    150,
    250,
    500,
}

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end
	return handle
end

local function CallScaleformMethod(method, ...)
	local t
	local args = { ... }
	BeginScaleformMovieMethod(Scaleform, method)
	for k, v in ipairs(args) do
		t = type(v)
		if t == 'string' then
			PushScaleformMovieMethodParameterString(v)
		elseif t == 'number' then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == 'boolean' then
			PushScaleformMovieMethodParameterBool(v)
		end
	end
	EndScaleformMovieMethod()
end

local function SetupScaleform()
    CreateThread(function()
        Scaleform = RequestScaleformMovie('SLOT_MACHINE')
        while not HasScaleformMovieLoaded(Scaleform) do Wait(0) end
        if SlotReferences[ClosestSlotModel].theme then
            CallScaleformMethod('SET_THEME', SlotReferences[ClosestSlotModel].theme)
        else
            CallScaleformMethod('SET_THEME')
        end    
        local model = ClosestSlotModel
        local handle = CreateNamedRenderTargetForModel("machine_"..SlotReferences[ClosestSlotModel].scriptrt, model)
        while ShouldDrawScaleForm do
            N_0x32f34ff7f617643b(Scaleform, 1)
            SetTextRenderId(handle) -- Sets the render target to the handle we grab above
            SetScriptGfxDrawOrder(4)
            SetScriptGfxDrawBehindPausemenu(true)
            DrawScaleformMovie(Scaleform, 0.401, 0.09, 0.805, 0.195, 255, 255, 255, 255, 0)
            SetTextRenderId(GetDefaultScriptRendertargetRenderId()) -- Resets the render target
            Wait(0)
        end
    end)
end

local function SlotMachineHandler()
    local LeverScene = 0
    local IdleScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, ClosestSlotRotation, 2, 2, 0, 1.0, 0, 1.0)
    RequestAnimDict(AnimDict)
    while not HasAnimDictLoaded(AnimDict) do Wait(0) end
    local RandomAnimName = RandomIdle[math.random(1, #RandomIdle)]
    NetworkAddPedToSynchronisedScene(PlayerPedId(), IdleScene, AnimDict, RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
    NetworkStartSynchronisedScene(IdleScene)
    CreateThread(function()
        while true do
            if IsControlJustPressed(0, 202) then
                local LeaveScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, ClosestSlotRotation, 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict(AnimDict)
                while not HasAnimDictLoaded(AnimDict) do Wait(0) end
                RandomAnimName = RandomLeave[math.random(1, #RandomLeave)]
                NetworkAddPedToSynchronisedScene(PlayerPedId(), LeaveScene, AnimDict, RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(LeaveScene)
                Wait(GetAnimDuration(AnimDict, RandomAnimName) * 700)
                NetworkStopSynchronisedScene(LeaveScene)
                EnteredSlot = false
                ShouldDrawScaleForm = false
                TriggerServerEvent('dc-casino:slots:server:leave')
                break
            elseif IsControlJustPressed(0, 201) then
                local PullScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, ClosestSlotRotation, 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict(AnimDict)
                while not HasAnimDictLoaded(AnimDict) do Wait(0) end
                RandomAnimName = RandomSpin[math.random(1, #RandomSpin)]
                if RandomAnimName == 'pull_spin_a' then
                    LeverScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, ClosestSlotRotation, 2, 2, 0, 1.0, 0, 1.0)
                    N_0x45f35c0edc33b03b(LeverScene, GetEntityModel(ClosestSlot), ClosestSlotCoord, AnimDict, 'pull_spin_a_SLOTMACHINE', 2.0, -1.5, 13.0)
                    NetworkStartSynchronisedScene(LeverScene)
                elseif RandomAnimName == 'pull_spin_b' then
                    LeverScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, ClosestSlotRotation, 2, 2, 0, 1.0, 0, 1.0)
                    N_0x45f35c0edc33b03b(LeverScene, GetEntityModel(ClosestSlot), ClosestSlotCoord, AnimDict, 'pull_spin_b_SLOTMACHINE', 2.0, -1.5, 13.0)
                    NetworkStartSynchronisedScene(LeverScene)
                end
                NetworkAddPedToSynchronisedScene(PlayerPedId(), PullScene, AnimDict, RandomAnimName, 2.0, -1.5, 13, 16, 1000.0, 0)
                NetworkStartSynchronisedScene(PullScene)
                local AnimationDuration = GetAnimDuration(AnimDict, RandomAnimName) * 1000
                Wait(AnimationDuration / 2)
                TriggerServerEvent('dc-casino:slots:server:spin', AnimationDuration)
                Wait(AnimationDuration / 2)
                NetworkStopSynchronisedScene(LeverScene) --- Has to be stopped otherwise it will only work 50% of the time
            elseif IsControlJustPressed(0, 38) then
                if not BetAmounts[ChosenBetAmount + 1] then ChosenBetAmount = 1 else ChosenBetAmount = ChosenBetAmount + 1 end
                local BetOneScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, ClosestSlotRotation, 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict(AnimDict)
                while not HasAnimDictLoaded(AnimDict) do Wait(0) end
                NetworkAddPedToSynchronisedScene(PlayerPedId(), BetOneScene, AnimDict, 'press_betone_a', 2.0, -1.5, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(BetOneScene)
                Wait(GetAnimDuration(AnimDict, 'press_betone_a') * 200)
                CallScaleformMethod('SET_BET', BetAmounts[ChosenBetAmount])
            elseif IsControlJustPressed(0, 45) then
                ChosenBetAmount = #BetAmounts
                local BetMaxScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, ClosestSlotRotation, 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict(AnimDict)
                while not HasAnimDictLoaded(AnimDict) do Wait(0) end
                NetworkAddPedToSynchronisedScene(PlayerPedId(), BetMaxScene, AnimDict, 'press_betmax_a', 2.0, -1.5, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(BetMaxScene)
                Wait(GetAnimDuration(AnimDict, 'press_betmax_a') * 200)
                CallScaleformMethod('SET_BET', BetAmounts[ChosenBetAmount])
            end
            Wait(0)
        end
    end)
end

CreateThread(function()
    while not RequestScriptAudioBank("dlc_vinewood/casino_slot_machines_01", 0) do Wait(0) end
    while not RequestScriptAudioBank("dlc_vinewood/casino_slot_machines_02", 0) do Wait(0) end
    while not RequestScriptAudioBank("dlc_vinewood/casino_slot_machines_03", 0) do Wait(0) end
	while true do
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        for i = 1, #Slots do
            Slot = GetClosestObjectOfType(PlayerCoords, 1.2, Slots[i], true)
            if Slot ~= 0 then
                SlotCoords = GetEntityCoords(Slot)
                local CurrentDistance = #(PlayerCoords - SlotCoords)
                if CurrentDistance < 1.8 and CurrentDistance < #(PlayerCoords - ClosestSlotCoord) then
                    NearbySlot = true
                    ClosestSlot = Slot
                    ClosestSlotCoord = SlotCoords
                    ClosestSlotForwardX = GetEntityForwardX(ClosestSlot)
                    ClosestSlotForwardY = GetEntityForwardY(ClosestSlot)
                    ClosestSlotModel = GetEntityModel(ClosestSlot)
                    ClosestSlotRotation = GetEntityRotation(ClosestSlot)
                    ReelLocation1 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), -0.115, 0.047, 0.906)
                    ReelLocation2 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), 0.005, 0.047, 0.906)
                    ReelLocation3 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), 0.125, 0.047, 0.906)
                end
            elseif #(PlayerCoords - ClosestSlotCoord) > 1.8 then
                NearbySlot = false
            end
        end
        Wait(600)
	end
end)

CreateThread(function()
	while true do
        local WaitTime = 500
        if NearbySlot and not EnteredSlot then
            WaitTime = 0
            DrawText3D(ClosestSlotCoord.x - ClosestSlotForwardX, ClosestSlotCoord.y - ClosestSlotForwardY, ClosestSlotCoord.z + 1, "~o~E~w~ - Play "..SlotReferences[ClosestSlotModel].name)
            if IsControlJustReleased(0, 38) then
                local netID = NetworkGetEntityIsNetworked(ClosestSlot) and NetworkGetNetworkIdFromEntity(ClosestSlot)
                if not netID then
                    NetworkRegisterEntityAsNetworked(ClosestSlot)
                    netID = NetworkGetNetworkIdFromEntity(ClosestSlot)
                    NetworkUseHighPrecisionBlending(netID, false)
                    SetNetworkIdExistsOnAllMachines(netID, true)
                    SetNetworkIdCanMigrate(netID, true)
                end
                TriggerServerEvent('dc-casino:slots:server:enter', netID, ReelLocation1, ReelLocation2, ReelLocation3)
            end
        end
        Wait(WaitTime)
    end
end)

RegisterNetEvent('dc-casino:slots:client:enter', function()
    local Ped = PlayerPedId()
    if GetEntityModel(Ped) == `mp_f_freemode_01` then AnimDict = 'anim_casino_a@amb@casino@games@slots@female' end
    local EnterScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, ClosestSlotRotation, 2, 2, 0, 1.0, 0, 1.0)
    RequestAnimDict(AnimDict)
    while not HasAnimDictLoaded(AnimDict) do Wait(0) end
    local RandomAnimName = RandomEnter[math.random(1, #RandomEnter)]
    NetworkAddPedToSynchronisedScene(Ped, EnterScene, AnimDict, RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
    NetworkStartSynchronisedScene(EnterScene)
    EnteredSlot = true
    ShouldDrawScaleForm = true
    SetupScaleform()
    Wait(GetAnimDuration(AnimDict, RandomAnimName) * 1000)
    CallScaleformMethod('SET_MESSAGE', RandomEnterMessage[math.random(1, #RandomEnterMessage)])
    CallScaleformMethod('SET_BET', BetAmounts[ChosenBetAmount])
    SlotMachineHandler()
end)

RegisterNetEvent('dc-casino:slots:client:spinreels', function(ReelReward1, ReelReward2, ReelReward3, BlurryReelID1, BlurryReelID2, BlurryReelID3, ReelID1, ReelID2, ReelID3)
    local EndTime = GetGameTimer() + 4000
    local SlotHeading = GetEntityHeading(ClosestSlot)
    local BlurryReel1 = NetworkGetEntityFromNetworkId(BlurryReelID1)
    local BlurryReel2 = NetworkGetEntityFromNetworkId(BlurryReelID2)
    local BlurryReel3 = NetworkGetEntityFromNetworkId(BlurryReelID3)
    local Reel1 = NetworkGetEntityFromNetworkId(ReelID1)
    local Reel2 = NetworkGetEntityFromNetworkId(ReelID2)
    local Reel3 = NetworkGetEntityFromNetworkId(ReelID3)
    while not NetworkRequestControlOfEntity(BlurryReel1) do Wait(0) end
    while not NetworkRequestControlOfEntity(BlurryReel2) do Wait(0) end
    while not NetworkRequestControlOfEntity(BlurryReel3) do Wait(0) end
    while not NetworkRequestControlOfEntity(Reel1) do Wait(0) end
    while not NetworkRequestControlOfEntity(Reel2) do Wait(0) end
    while not NetworkRequestControlOfEntity(Reel3) do Wait(0) end

    SetEntityVisible(Reel1, false)
    SetEntityVisible(Reel2, false)
    SetEntityVisible(Reel3, false)
    while GetGameTimer() < EndTime do
        SetEntityRotation(BlurryReel1, math.random(0, 15) * 22.5 + math.random(1, 60), 0.0, SlotHeading, 2, true)
        if EndTime - GetGameTimer() > 1000 then
            SetEntityRotation(BlurryReel2, math.random(0, 15) * 22.5 + math.random(1, 60), 0.0, SlotHeading, 2, true)
            if EndTime - GetGameTimer() < 1050 then
                DeleteObject(BlurryReel2)
                SetEntityRotation(Reel2, ReelReward2, 0.0, SlotHeading, 2, true)
                SetEntityVisible(Reel2, true)
            end
            if EndTime - GetGameTimer() > 2000 then
                SetEntityRotation(BlurryReel3, math.random(0, 15) * 22.5 + math.random(1, 60), 0.0, SlotHeading, 2, true)
                if EndTime - GetGameTimer() < 2050 then
                    DeleteObject(BlurryReel3)
                    SetEntityRotation(Reel3, ReelReward3, 0.0, SlotHeading, 2, true)
                    SetEntityVisible(Reel3, true)
                end
            end
        end
        Wait(0)
    end
    DeleteObject(BlurryReel1)
    SetEntityRotation(Reel1, ReelReward1, 0.0, SlotHeading, 2, true)
    SetEntityVisible(Reel1, true)
end)

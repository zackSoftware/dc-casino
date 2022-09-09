local Slot
local SlotCoords
local ClosestSlot
local ClosestSlotCoord = vector3(0, 0, 0)
local NearbySlot
local EnteredSlot
local SlotObject1
local SlotObject2
local SlotObject3
local SlotLocation1
local SlotLocation2
local SlotLocation3
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
local SlotReferences = {
    ['vw_prop_casino_slot_01a'] = {
        sound = 'dlc_vw_casino_slot_machine_ak_npc_sounds',
        texture = 'CasinoUI_Slots_Angel'
    },
    ['vw_prop_casino_slot_02a'] = {
        sound = 'dlc_vw_casino_slot_machine_ir_npc_sounds',
        texture = 'CasinoUI_Slots_Impotent'
    },
    ['vw_prop_casino_slot_03a'] = {
        sound = 'dlc_vw_casino_slot_machine_rsr_npc_sounds',
        texture = 'CasinoUI_Slots_Ranger'
    },
    ['vw_prop_casino_slot_04a'] = {
        sound = 'dlc_vw_casino_slot_machine_fs_npc_sounds',
        texture = 'CasinoUI_Slots_Fame'
    },
    ['vw_prop_casino_slot_05a'] = {
        sound = 'dlc_vw_casino_slot_machine_ds_npc_sounds',
        texture = 'CasinoUI_Slots_Deity'
    },
    ['vw_prop_casino_slot_06a'] = {
        sound = 'dlc_vw_casino_slot_machine_kd_npc_sounds',
        texture = 'CasinoUI_Slots_Knife'
    },
    ['vw_prop_casino_slot_07a'] = {
        sound = 'dlc_vw_casino_slot_machine_td_npc_sounds',
        texture = 'CasinoUI_Slots_Diamond'
    },
    ['vw_prop_casino_slot_08a'] = {
        sound = 'dlc_vw_casino_slot_machine_hz_npc_sounds',
        texture = 'CasinoUI_Slots_Evacuator'
    },
}
local Sounds = {
    function() PlaySoundFromCoord(-1, 'no_win', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'small_win', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'big_win', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'jackpot', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'place_bet', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'place_max_bet', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'spinning', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'start_spin', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'wheel_stop_clunk', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'wheel_stop_on_prize', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'welcome_stinger', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'spin_wheel', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end,
    function() PlaySoundFromCoord(-1, 'spin_wheel_win', ClosestSlotCoord, SlotReferences[GetEntityArchetypeName(ClosestSlot)].sound, false, 20, false) end
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

local function SetupReels()
    RequestModel(3104582536)
    while not HasModelLoaded(3104582536) do Wait(0) end

    if DoesEntityExist(SlotObject1) then DeleteObject(SlotObject1) end
    if DoesEntityExist(SlotObject2) then DeleteObject(SlotObject2) end
    if DoesEntityExist(SlotObject3) then DeleteObject(SlotObject3) end

    SlotLocation1 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), -0.115, 0.047, 0.906)
    SlotLocation2 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), 0.005, 0.047, 0.906)
    SlotLocation3 = GetObjectOffsetFromCoords(ClosestSlotCoord, GetEntityHeading(ClosestSlot), 0.125, 0.047, 0.906)

    SlotObject1 = CreateObject(3104582536, SlotLocation1, false, false, true)
    SlotObject2 = CreateObject(3104582536, SlotLocation2, false, false, true)
    SlotObject3 = CreateObject(3104582536, SlotLocation3, false, false, true)

    FreezeEntityPosition(SlotObject1, true)
    FreezeEntityPosition(SlotObject2, true)
    FreezeEntityPosition(SlotObject3, true)

    SetEntityCollision(SlotObject1, false, false)
    SetEntityCollision(SlotObject2, false, false)
    SetEntityCollision(SlotObject3, false, false)

    SetEntityRotation(SlotObject1, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)
    SetEntityRotation(SlotObject2, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)
    SetEntityRotation(SlotObject3, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)

    SetModelAsNoLongerNeeded(3104582536)
end

local function SetupBlurReels()
    DeleteObject(SlotObject1)
    DeleteObject(SlotObject2)
    DeleteObject(SlotObject3)

    RequestModel(2703955257)
    while not HasModelLoaded(2703955257) do Wait(0) end

    SlotObject1 = CreateObject(2703955257, SlotLocation1, false, false, true)
    SlotObject2 = CreateObject(2703955257, SlotLocation2, false, false, true)
    SlotObject3 = CreateObject(2703955257, SlotLocation3, false, false, true)

    FreezeEntityPosition(SlotObject1, true)
    FreezeEntityPosition(SlotObject2, true)
    FreezeEntityPosition(SlotObject3, true)

    SetEntityCollision(SlotObject1, false, false)
    SetEntityCollision(SlotObject2, false, false)
    SetEntityCollision(SlotObject3, false, false)

    SetEntityRotation(SlotObject1, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)
    SetEntityRotation(SlotObject2, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)
    SetEntityRotation(SlotObject3, 0.0, 0.0, GetEntityHeading(ClosestSlot), 2, 1)

    SetModelAsNoLongerNeeded(2703955257)
end

local function SpinReels()
    local EndTime = GetGameTimer() + 4000
    local ReelReward1 = math.random(0, 16) * 22.5
    local ReelReward2 = math.random(0, 16) * 22.5
    local ReelReward3 = math.random(0, 16) * 22.5
    local CurrentHeading1 = GetEntityHeading(SlotObject1)
    local CurrentHeading2 = GetEntityHeading(SlotObject2)
    local CurrentHeading3 = GetEntityHeading(SlotObject3)
    local SlotHeading = GetEntityHeading(ClosestSlot)
    RequestModel(3104582536)
    while not HasModelLoaded(3104582536) do Wait(0) end
    while GetGameTimer() < EndTime do
        SetEntityRotation(SlotObject1, math.random(0, 16) * 22.5, 0.0, SlotHeading, 2, true)
        if EndTime - GetGameTimer() > 1000 then
            SetEntityRotation(SlotObject2, math.random(0, 16) * 22.5, 0.0, SlotHeading, 2, true)
            if EndTime - GetGameTimer() < 1050 then
                DeleteObject(SlotObject2)
                SlotObject2 = CreateObject(3104582536, SlotLocation2, false, false, true)
                FreezeEntityPosition(SlotObject2, true)
                SetEntityCollision(SlotObject2, false, false)
                SetEntityRotation(SlotObject2, ReelReward2, 0.0, SlotHeading, 2, true)
            end
            if EndTime - GetGameTimer() > 2000 then
                SetEntityRotation(SlotObject3, math.random(0, 16) * 22.5, 0.0, SlotHeading, 2, true)
                if EndTime - GetGameTimer() < 2050 then
                    DeleteObject(SlotObject3)
                    SlotObject3 = CreateObject(3104582536, SlotLocation3, false, false, true)
                    FreezeEntityPosition(SlotObject3, true)
                    SetEntityCollision(SlotObject3, false, false)
                    SetEntityRotation(SlotObject3, ReelReward3, 0.0, SlotHeading, 2, true)
                end
            end
        end
        Wait(0)
    end
    DeleteObject(SlotObject1)
    SlotObject1 = CreateObject(3104582536, SlotLocation1, false, false, true)
    FreezeEntityPosition(SlotObject1, true)
    SetEntityCollision(SlotObject1, false, false)
    SetEntityRotation(SlotObject1, ReelReward1, 0.0, SlotHeading, 2, true)
    SetModelAsNoLongerNeeded(3104582536)
end

local function SlotMachineHandler()
    EnteredSlot = true
    IdleScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
    RequestAnimDict('anim_casino_a@amb@casino@games@slots@male')
    while not HasAnimDictLoaded('anim_casino_a@amb@casino@games@slots@male') do Wait(0) end
    local RandomAnimName = RandomIdle[math.random(1, #RandomIdle)]
    NetworkAddPedToSynchronisedScene(PlayerPedId(), IdleScene, 'anim_casino_a@amb@casino@games@slots@male', RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
    NetworkStartSynchronisedScene(IdleScene)
    CreateThread(function()
        while true do
            if IsControlJustPressed(0, 202) then
                LeaveScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict('anim_casino_a@amb@casino@games@slots@male')
                while not HasAnimDictLoaded('anim_casino_a@amb@casino@games@slots@male') do Wait(0) end
                local RandomAnimName = RandomLeave[math.random(1, #RandomLeave)]
                NetworkAddPedToSynchronisedScene(PlayerPedId(), LeaveScene, 'anim_casino_a@amb@casino@games@slots@male', RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(LeaveScene)
                Wait(GetAnimDuration('anim_casino_a@amb@casino@games@slots@male', RandomAnimName) * 700)
                DeleteObject(SlotObject1)
                DeleteObject(SlotObject2)
                DeleteObject(SlotObject3)
                NetworkStopSynchronisedScene(LeaveScene)
                EnteredSlot = false
                break
            elseif IsControlJustPressed(0, 201) then
                PullScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict('anim_casino_a@amb@casino@games@slots@male')
                while not HasAnimDictLoaded('anim_casino_a@amb@casino@games@slots@male') do Wait(0) end
                local RandomAnimName = RandomSpin[math.random(1, #RandomSpin)]
                if RandomAnimName == 'pull_spin_a' then
                    LeverScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                    N_0x45f35c0edc33b03b(LeverScene, GetEntityModel(ClosestSlot), ClosestSlotCoord, 'anim_casino_a@amb@casino@games@slots@male', 'pull_spin_a_SLOTMACHINE', 2.0, -1.5, 13.0)
                    NetworkStartSynchronisedScene(LeverScene)
                elseif RandomAnimName == 'pull_spin_b' then
                    LeverScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                    N_0x45f35c0edc33b03b(LeverScene, GetEntityModel(ClosestSlot), ClosestSlotCoord, 'anim_casino_a@amb@casino@games@slots@male', 'pull_spin_b_SLOTMACHINE', 2.0, -1.5, 13.0)
                    NetworkStartSynchronisedScene(LeverScene)
                end
                NetworkAddPedToSynchronisedScene(PlayerPedId(), PullScene, 'anim_casino_a@amb@casino@games@slots@male', RandomAnimName, 2.0, -1.5, 13, 16, 1000.0, 0)
                NetworkStartSynchronisedScene(PullScene)
                Wait(GetAnimDuration('anim_casino_a@amb@casino@games@slots@male', RandomAnimName) * 1000 / 2)
                NetworkStopSynchronisedScene(LeverScene) --- Has to be stopped otherwise it will only work 50% of the time
                FreezeEntityPosition(ClosestSlot, true) --- N_0x45f35c0edc33b03b will prevent the machine being stuck to their position for some reason?
                SetupBlurReels()
                SpinReels()
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
            Slot = GetClosestObjectOfType(PlayerCoords, 0.9, Slots[i], true)
            if Slot ~= 0 then
                SlotCoords = GetEntityCoords(Slot)
                local CurrentDistance = #(PlayerCoords - SlotCoords)
                if CurrentDistance < 1.8 and CurrentDistance < #(PlayerCoords - ClosestSlotCoord) then
                    NearbySlot = true
                    ClosestSlot = Slot
                    ClosestSlotCoord = SlotCoords
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
            DrawText3D(ClosestSlotCoord.x, ClosestSlotCoord.y, ClosestSlotCoord.z + 1, "~o~E~w~ - Aight")
            if IsControlJustReleased(0, 38) then
                EnterScene = NetworkCreateSynchronisedScene(ClosestSlotCoord, GetEntityRotation(ClosestSlot), 2, 2, 0, 1.0, 0, 1.0)
                RequestAnimDict('anim_casino_a@amb@casino@games@slots@male')
                while not HasAnimDictLoaded('anim_casino_a@amb@casino@games@slots@male') do Wait(0) end
                local RandomAnimName = RandomEnter[math.random(1, #RandomEnter)]
                NetworkAddPedToSynchronisedScene(PlayerPedId(), EnterScene, 'anim_casino_a@amb@casino@games@slots@male', RandomAnimName, 2.0, -1.5, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(EnterScene)
                Wait(GetAnimDuration('anim_casino_a@amb@casino@games@slots@male', RandomAnimName) * 500)
                SetupReels()
                Wait(GetAnimDuration('anim_casino_a@amb@casino@games@slots@male', RandomAnimName) * 500)
                SlotMachineHandler()
            end
        end
        Wait(WaitTime)
    end
end)

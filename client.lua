------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------
-- SISTEMA DE ANIMACIONES PARA ANCESTRAL RP MADE BY eхтαѕy#0900 --
------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------


Citizen.CreateThread(function()
    local dict = "missminuteman_1ig_2"

	RequestAnimDict(dict)
	RequestAnimDict("random@arrests@busted")
	while not HasAnimDictLoaded(dict) and not HasAnimDictLoaded("random@arrests@busted") do
		Citizen.Wait(500)
	end
    local handshead = false
	local handshead2 = false
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 323) then --Start holding X
            if not handshead then
					TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 3.0, 1.0, -1, 50, 0, false, false, false)
					handshead = true
			elseif not handshead2 then
					TaskPlayAnim(PlayerPedId(), "random@arrests@busted", "idle_c", 3.0, 1.0, -1, 50, 0, false, false, false)
					handshead2 = true
			else
					ClearPedTasks(GetPlayerPed(-1))
					handshead = false
					handshead2 = false
            end
        end
    end
end)


Citizen.CreateThread(function()

	local isRagdolling = 0

 	while true do
 		Citizen.Wait(0)
 		if IsControlJustReleased(1, 82) then
 			isRagdolling = (isRagdolling + 1) % 2
		end
 		if isRagdolling == 1 then
			SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
 		end
 	end
 end)

 Citizen.CreateThread(function()
    while true do
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.1) 
    	Wait(0)
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.1) 
    	Wait(0)
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	   DisableControlAction(1, 140, true)
       	   DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustReleased(0, 20) then -- 20 is z
			Citizen.Wait(25)
			if not isRadarExtended then
				SetRadarBigmapEnabled(true, false)
				LastGameTimer = GetGameTimer()
				isRadarExtended = true
			elseif isRadarExtended then
				SetRadarBigmapEnabled(false, false)
				LastGameTimer = 0
				isRadarExtended = false
			end
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests@busted", "idle_c", 3) then
			DisableControlAction(0, 24, true) -- attack
			DisableControlAction(0, 25, true) -- aim
			DisableControlAction(0, 37, true) -- weapon wheel
			DisableControlAction(0, 44, true) -- cover
			DisableControlAction(0, 45, true) -- reload
			DisableControlAction(0, 140, true) -- light attack
			DisableControlAction(0, 141, true) -- heavy attack
			DisableControlAction(0, 142, true) -- alternative attack
			DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
		end
	end
end)

RegisterCommand("cross", function(source, args, raw)
    TriggerEvent("CrossHands")
end, false)

RegisterNetEvent("CrossHands")
AddEventHandler("CrossHands", function(inputText)
RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@base")
TaskPlayAnim(GetPlayerPed(-1),"amb@world_human_hang_out_street@female_arms_crossed@base", "base", 1.0,-1.0, 5000, 1, 1, true, true, true)
end)


-- cross arms

Citizen.CreateThread(function()
    local dict = "amb@world_human_hang_out_street@female_arms_crossed@base"

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(5)
	end
    local crossarms = false
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 47) then --Start holding g
            if not crossarms then
                TaskPlayAnim(GetPlayerPed(-1), dict, "base", 3.0, 1.0, -1, 50, 0, false, false, false)
                crossarms = true
            else
                crossarms = false
                ClearPedTasks(GetPlayerPed(-1))
            end
        end
    end
end)


local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)
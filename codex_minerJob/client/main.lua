ESX              = nil
local PlayerData = {}
local isMenuOn = false
 

local shopCostMenu = 0
local goldOresCount = 0
local pickaxeCounter = 0
local ironOresCount = 0
local impacts = 0

local event_destination = nil
local isMining = false
local newSpawnReady = true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)




local display = false




--very important cb 
RegisterNUICallback("exit", function(data)
   
	SetDisplay(false)
	Citizen.Wait(3000)
	isMenuOn = false
end)


function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
		status = bool,
		goldOres = goldOresCount,
		ironOres = ironOresCount,
    })
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		TriggerServerEvent("refreshItems:minerJob")
	end
end)

RegisterNetEvent("refreshGold:minerJob")
AddEventHandler("refreshGold:minerJob", function(goldCount)
	goldOresCount = goldCount
end)

RegisterNetEvent("refreshIron:minerJob")
AddEventHandler("refreshIron:minerJob", function(ironCount)
	ironOresCount = ironCount
end)

RegisterNetEvent("refreshPickaxe:minerJob")
AddEventHandler("refreshPickaxe:minerJob", function(pickaxeCount)
	pickaxeCounter = pickaxeCount
end)


Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)



-- local blips = {
-- 	{title="Mine", colour=0, id=527, x=-593.95855712891, y=2091.75390625, z=131.71856689453},
--   }

-- Citizen.CreateThread(function()

--     for _, info in pairs(blips) do
--       info.blip = AddBlipForCoord(info.x, info.y, info.z)
--       SetBlipSprite(info.blip, info.id)
--       SetBlipDisplay(info.blip, 4)
--       SetBlipScale(info.blip, 0.9)
--       SetBlipColour(info.blip, info.colour)
--       SetBlipAsShortRange(info.blip, true)
-- 	  BeginTextCommandSetBlipName("STRING")
--       AddTextComponentString(info.title)
--       EndTextCommandSetBlipName(info.blip)
--     end
-- end)


Citizen.CreateThread(function()

	RequestModel(Config.NPCHash)
	while not HasModelLoaded(Config.NPCHash) do
	Wait(1)

	end

	--PROVIDER
		meth_dealer_seller = CreatePed(1, Config.NPCHash, -601.15631103516,2092.1804199219,130.34860229492, 60, false, true)
		SetBlockingOfNonTemporaryEvents(meth_dealer_seller, true)
		SetPedDiesWhenInjured(meth_dealer_seller, false)
		SetPedCanPlayAmbientAnims(meth_dealer_seller, true)
		SetPedCanRagdollFromPlayerImpact(meth_dealer_seller, false)
		SetEntityInvincible(meth_dealer_seller, true)
		FreezeEntityPosition(meth_dealer_seller, true)
		TaskStartScenarioInPlace(meth_dealer_seller, "WORLD_HUMAN_SMOKING", 0, true);

end)




Citizen.CreateThread(function()
	while true do
		local coords = GetEntityCoords(PlayerPedId())

		Citizen.Wait(0)
		local distance2 = GetDistanceBetweenCoords(coords, -601.15631103516,2092.8804199219,131.34860229492, true)
		DrawMarker(2, -601.15631103516,2092.8804199219,131.34860229492, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 41, 197, 1, 110, 0, 1, 0, 1)
		


		if distance2 <= 1 then
			if(IsControlJustReleased(1, 38))then
				if isMenuOn == false then

					SetDisplay(not display)
					isMenuOn = true
				end
			end
		end
			
	
	end
end)



Citizen.CreateThread(function()
	spawnNewMarker1()

	while true do
		Citizen.Wait(4)
		while newSpawnReady do
			Citizen.Wait(4)

			spawnNewMarker1()
			newSpawnReady = false
			Citizen.Wait(Config.RefreshMarkerTimer)

			newSpawnReady = true

		end
	end

end)






RegisterNUICallback("buyPickAxe", function(data)
   
	shopCostMenu = 250
	TriggerServerEvent("buyPickAxe:minerJob", shopCostMenu)
	

end)


RegisterNUICallback("buyFood", function(data)
   
	shopCostMenu = 5
	TriggerServerEvent("buysandwich:minerJob", shopCostMenu)
	

end)

RegisterNUICallback("buyWater", function(data)
   
	shopCostMenu = 1
	TriggerServerEvent("buyWater:minerJob", shopCostMenu)
	

end)

RegisterNUICallback("sellResource", function()
	TriggerServerEvent("sellResource:minerJob")
end)




local marker1spawnt = false


RegisterNetEvent("showReward:minerJob")
AddEventHandler("showReward:minerJob", function(completReward)
	TriggerEvent('notifications', "#29c501", "CODEX", "Kazandığın Para: "..completReward.."$")
end)

 function spawnNewMarker1()
	marker1spawnt = false
	
	random_destination = math.random(1, #Config.MiningPoints)
	random_destination2 = math.random(1, #Config.MiningPoints2)
	random_destination3 = math.random(1, #Config.MiningPoints3)
	Citizen.Wait(1000)
	marker1spawnt = true
	
end


Citizen.CreateThread(function()
while true do
	Citizen.Wait(4)
	while marker1spawnt do
		Citizen.Wait(4)

	
		event_destination = Config.MiningPoints[random_destination]
		event_destination2 = Config.MiningPoints2[random_destination2]
		event_destination3 = Config.MiningPoints3[random_destination3]

		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		local dpos = event_destination	
		local dpos2 = event_destination2	
		local dpos3 = event_destination3	
		local delivery_point_distance = Vdist(dpos.x, dpos.y, dpos.z, pos.x, pos.y, pos.z)
		local delivery_point_distance2 = Vdist(dpos2.x, dpos2.y, dpos2.z, pos.x, pos.y, pos.z)
		local delivery_point_distance3 = Vdist(dpos3.x, dpos3.y, dpos3.z, pos.x, pos.y, pos.z)
			
		if delivery_point_distance < 500.0 then
			DrawMarker(3, dpos.x, dpos.y, dpos.z+1,0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 255, 255, 255, 155, 0, 0, 2, 0, 0, 0, 0)
			DrawMarker(3, dpos2.x, dpos2.y, dpos2.z+1,0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 255, 255, 255, 155, 0, 0, 2, 0, 0, 0, 0)
			DrawMarker(3, dpos3.x, dpos3.y, dpos3.z+1,0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 255, 255, 255, 155, 0, 0, 2, 0, 0, 0, 0)
			if delivery_point_distance < 1.5 then
				if isMining == false then
					DisplayHelpText("Kazmak için ~INPUT_CONTEXT~ ~r~tuşuna bas")
				

					if(IsControlJustReleased(1, 38))then
						if pickaxeCounter > 0 then
							local result = exports["skillbar"]:threeSkillbar()
							if result then
								mining()
								TriggerServerEvent("removePickaxe:minerJob")
							else
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Kazamadın !"})
							end
						else
							TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Kazman yok !"})
						end
						
					end
				

				end
			elseif delivery_point_distance2 < 1.5 then

				if isMining == false then
					DisplayHelpText("Kazmak için ~INPUT_CONTEXT~ ~r~tuşuna bas")
				

					if(IsControlJustReleased(1, 38))then
						
						if pickaxeCounter > 0 then
							local result = exports["skillbar"]:threeSkillbar()
							if result then
								mining()
								TriggerServerEvent("removePickaxe:minerJob")
							else
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Kazamadın !"})
							end
						else
							TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Kazman yok !"})
						end
						
					end
				

				end

			elseif delivery_point_distance3 < 1.5 then

				if isMining == false then
					DisplayHelpText("Kazmak için ~INPUT_CONTEXT~ ~r~tuşuna bas")
				

					if(IsControlJustReleased(1, 38))then
						
						if pickaxeCounter > 0 then
							local result = exports["skillbar"]:threeSkillbar()
							if result then
								mining()
								TriggerServerEvent("removePickaxe:minerJob")
							else
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Kazamadın !"})
							end
						else
							TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Kazman yok !"})
						end
						
					end
				

				end
			end
		end

	end
end

	

end)





function mining()
	isMining = true
    Citizen.CreateThread(function()
        while impacts < 3 do
            Citizen.Wait(1)
				local ped = PlayerPedId()	
                RequestAnimDict("amb@world_human_hammering@male@base")
                Citizen.Wait(100)
                TaskPlayAnim((ped), 'amb@world_human_hammering@male@base', 'base', 12.0, 12.0, -1, 80, 0, 0, 0, 0)
                SetEntityHeading(ped, 270.0)
                if impacts == 0 then
                    pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
                    AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
                end  
                Citizen.Wait(2500)
                impacts = impacts+1
                if impacts == 3 then
                    DetachEntity(pickaxe, 1, true)
                    DeleteEntity(pickaxe)
                    DeleteObject(pickaxe)
                    impacts = 0
					Citizen.Wait(1000)

					TriggerServerEvent("addItems:minerJob")
					isMining = false
					
                    break
                end        
        end
    end)
end



RegisterNetEvent("pickaxeBroken:minerJob")
AddEventHandler("pickaxeBroken:minerJob", function()
	TriggerEvent('notifications', "#29c501", "CODEX", "Kazman Kırıldı.")
end)






function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

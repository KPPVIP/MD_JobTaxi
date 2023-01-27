
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)



local service = false
print ("^5Crée par : Mathéo#2802") 
print ("^3Discord  : https://discord.gg/KdGpw48kES") 
print ("^3Info     : Partager le 20/04/2022")

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------- MENU GARAGE ----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
   while true do
	  Wait(0)
		for k,v in pairs(Config.prendreservice) do
		local coords = GetEntityCoords(PlayerPedId())
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then 
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
				DrawMarker(21, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0.0, 255.0, 0.0, 170, 0, 1, 2, 0, nil, nil, 0)
					if service == false then
						ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour prendre votre service en tant de taxi.")
						if IsControlJustPressed(0,51) then
							service = true
						end 
					else
						ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour mettre fin a votre service en tant de taxi.")
						if IsControlJustPressed(0,51) then
							service = false
						end 
					end
				end
			end
			
		end
	end
end) 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------- MENU GARAGE ----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
   while true do
	  Wait(0)
		for k,v in pairs(Config.garage) do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(PlayerPedId())
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
				if service == true then			
					if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 15.0) then
					DrawMarker(36, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0.0, 255.0, 0.0, 170, 0, 1, 2, 0, nil, nil, 0)
						if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3.0) then
							ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au garage.")
							if IsControlJustPressed(0,51) then
								RageUI.CloseAll()
								RageUI.Visible(RMenu:Get('garage', 'main'), not RageUI.Visible(RMenu:Get('garage', 'main')))
							end 
						end
					end
				end
			end
			
		end
	end
end) 

RMenu.Add('garage', 'main', RageUI.CreateMenu("Garage", "Garage"))
Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('garage', 'main'), true, true, true, function() 
		

            RageUI.Button("Ranger la voiture", "Pour ranger une voiture.", {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if (Selected) then  
					if not IsPedInAnyVehicle(PlayerPedId(), false) then				
					local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
					if dist4 < 4 then
						DeleteEntity(veh)
						RageUI.CloseAll()
					end 
					end
				end
            end)

            RageUI.Button("Taxi", "Pour sortir un taxi.", {RightLabel =">"},true, function(Hovered, Active, Selected)
				if (Selected) then   
					Citizen.Wait(1)  
					RageUI.CloseAll()
					spawnCar("taxi")
				end
            end)
		
            
        end, function()
        end)
        Citizen.Wait(0)
    end
end)

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(500)
    end
	for k,v in pairs(Config.carspawn) do
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
		local vehicle = CreateVehicle(car, v.Pos.x, v.Pos.y, v.Pos.z, 59.5, true, false)
		SetEntityAsMissionEntity(vehicle, true, true)
		local plaque = "Taxi"..math.random(1,100)
		SetVehicleNumberPlateText(vehicle, plaque) 
		SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
		Citizen.Wait(1000)
	end	
end

-------------------------------- BLIPS
local blips = 0
Citizen.CreateThread(function()
	while true do
	Wait(0)
		if blips == 0 then
			for k,v in pairs(Config.garage) do
				Taxi = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
				SetBlipSprite(Taxi ,  198)
				SetBlipScale(Taxi , 1.0)
				SetBlipAsShortRange(Taxi, true)
				SetBlipColour(Taxi, 5)
				PulseBlip(Taxi)
				BeginTextCommandSetBlipName("Taxi")
				AddTextEntry("Taxi", "Taxi")
				EndTextCommandSetBlipName(Taxi)
				blips = 1
			end
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------- MENU PATRON ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
   while true do
	  Wait(0)
		for k,v in pairs(Config.boss) do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(PlayerPedId())
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' and ESX.PlayerData.job.grade_name == 'boss' then  
				if service == true then
					if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
					DrawMarker(21, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0.0, 255.0, 0.0, 170, 0, 1, 2, 0, nil, nil, 0)
					ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au menu patron.")
						if IsControlJustPressed(0,51) then
							RageUI.CloseAll()
							RageUI.Visible(RMenu:Get('boss', 'main'), not RageUI.Visible(RMenu:Get('boss', 'main')))
							RefreshMoney()
							
						end 
					end
				end
			end
		end
	end
end) 

RMenu.Add('boss', 'main', RageUI.CreateMenu("Menu patron", "Menu patron"))
Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('boss', 'main'), true, true, true, function() 
		RefreshMoney()
		if societymoney ~= nil then
					RageUI.Button("			 ~p~~s~Coffre Entreprise : ".. societymoney.."~p~ $", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then

						end
					end)
				end
            RageUI.Button("Retirer argent de la société", nil, {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if Selected then
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. 'taxi',
                    {
                        title = ('Montant')
                    }, function(data, menu)
                    local amount = tonumber(data.value)

                if amount == nil then
                    ESX.ShowNotification('Montant invalide')
                else
                    menu.close()
                    TriggerServerEvent('esx_society:withdrawMoney', 'taxi', amount)
                        end
                    end)
                end
            end)
			
            RageUI.Button("Déposer argent de la société", nil, {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if Selected then
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. 'taxi',
                    {
                        title = ('Montant')
                    }, function(data, menu)
                        local amount = tonumber(data.value)
                        if amount == nil then
                            ESX.ShowNotification('Montant invalide')
                        else
                            menu.close()
                            TriggerServerEvent('esx_society:depositMoney', 'taxi', amount)
                        end
                    end)
                end
            end)

            RageUI.Button("Accéder aux actions de Patron", nil, {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if Selected then
                    aboss()
                    RageUI.CloseAll()
                end
            end)
        end, function()
        end)
        Citizen.Wait(0)
    end
end)

-------------------------------- FONCTION BOSS
function aboss()
    TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
        menu.close()
    end, {wash = false})
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)


function Updatessocietymoney(money)
    societymoney = ESX.Math.GroupDigits(money)
    
end
function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('mechanic:getSocietyMoney', function(money)
            societymoney = money
        end, "society_"..ESX.PlayerData.job.name)
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------ MENU F6 ------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------- TOUCHE MENU F6
Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
			local playerPed = PlayerPedId()
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then 
				if IsControlJustReleased(0 ,167) then
					if service == true then
						RageUI.CloseAll()
						RageUI.Visible(RMenu:Get('taxi', 'main'), not RageUI.Visible(RMenu:Get('taxi', 'main')))
					else
						ESX.ShowNotification("Vous devez prendre votre service a l\'entreprise ! ", "error", 1000)
					end
				end	
			end
        end
    end)
	
-------------------------------- MENU F6
RMenu.Add('taxi', 'main', RageUI.CreateMenu("Taxi", "Intéraction"))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('taxi', 'main'), true, true, true, function() 

            RageUI.Button("Annonces", "Faire un annonces ", {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if (Selected) then   
					RageUI.Visible(RMenu:Get('taxi', 'Annonces'), not RageUI.Visible(RMenu:Get('taxi', 'Annonces')))
				end
            end)

            RageUI.Button("Faire une facture", "Faire une facture a un client.", {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if (Selected) then   
					RageUI.CloseAll()        
					OpenBillingMenu() 
				end
            end)

            RageUI.Button("Start/Stop missions taxi", "commancer votre tourner", {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if Selected then
                if OnJob then
                    StopTaxiJob()
                else
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'taxi' then
                        local playerPed = PlayerPedId()
                        local vehicle   = GetVehiclePedIsIn(playerPed, false)
    
                        if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                            if tonumber(ESX.PlayerData.job.grade) >= 3 then
                                StartTaxiJob()
                            else
                                if IsInAuthorizedVehicle() then
                                    StartTaxiJob()
                                else
                                    RageUI.Popup({
                                        message = "Tu dois être dans un taxi !"})
                                end
                            end
                        else
                            if tonumber(ESX.PlayerData.job.grade) >= 3 then
                                ESX.ShowNotification('vous devez être dans un véhicule pour commencer la mission')
                            else
                                RageUI.Popup({
                                    message = "Tu dois être dans un taxi !"})
                            end
                        end
                    end
                end
			end
            end)
        end, function()
        end)
        Citizen.Wait(0)
    end
end)

-------------------------------- MENU ANNONCES
RMenu.Add('taxi', 'Annonces', RageUI.CreateMenu("Taxi", "Faire un annonces"))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('taxi', 'Annonces'), true, true, true, function() 
		
			RageUI.Button("				~p~↓ ~s~Annonces(s) ~p~↓", nil, {RightLabel = nil},true, function(Hovered, Active, Selected)
				if (Selected) then  	
					
				end
            end)
			
            RageUI.Button("Ouvert", "Faire une annonces", {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if (Selected) then  	
					TriggerServerEvent('Ouvre:annonce')	
				end
            end)

			RageUI.Button("Fermer", "Faire une annonces", {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if (Selected) then   
					TriggerServerEvent('Ferme:annonce')
				end
            end)
			
			RageUI.Button("prise de service", "Faire une annonces pour votre prise de service", {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if (Selected) then   
					TriggerServerEvent('prise de service:annonce')
				end
            end)
        end, function()
        end)
        Citizen.Wait(0)
    end
end)

-------------------------------- FONCTION FACTURE --------------------------------

function OpenBillingMenu()
	ESX.UI.Menu.Open(
	  'dialog', GetCurrentResourceName(), 'billing',
	  {
		title = "Facture"
	  },
	  function(data, menu)
	  
		local amount = tonumber(data.value)
		local player, distance = ESX.Game.GetClosestPlayer()
  
		if player ~= -1 and distance <= 3.0 then
  
		  menu.close()
		  if amount == nil then
			  ESX.ShowNotification("~r~Problèmes~s~: Montant invalide")
		  else
			local playerPed        = GetPlayerPed(-1)
			
			TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
			Citizen.Wait(5000)
			  TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_taxi', ('taxi'), amount)
			  Citizen.Wait(100)
			  ESX.ShowNotification("~r~Vous avez bien envoyer la facture")
		  end
		else
		  ESX.ShowNotification("~r~Problèmes~s~: Aucun joueur à proximitée")
		end
	  end,
	  function(data, menu)
		  menu.close()
	  end
	)
  end
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------- SYSTEME DE PNJ ----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if OnJob then
			if CurrentCustomer == nil then
				DrawSub('conduisez à la recherche de ~y~passagers', 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					local waitUntil = GetGameTimer() + GetRandomIntInRange(15000, 20000)

					while OnJob and waitUntil > GetGameTimer() do
						Citizen.Wait(0)
					end

					if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then
							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(1, 1)
							TaskStandStill(CurrentCustomer, standTime)

							ESX.ShowNotification('vous avez ~g~trouvé~s~ un client, conduisez jusqu\'à ce dernier')
						end
					end
				end
			else
				if IsPedFatallyInjured(CurrentCustomer) then
					ESX.ShowNotification('votre client est ~r~inconscient~s~. Cherchez-en un autre.')

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
				end

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = #(playerCoords - customerCoords)

					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
						if CustomerEnteredVehicle then
							local targetDistance = #(playerCoords - targetCoords)

							if targetDistance <= 10.0 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								ESX.ShowNotification('vous êtes ~g~arrivé~s~ à destination')

								TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)
								TriggerServerEvent('MD_JobTaxi:success')
								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									ESX.SetTimeout(60000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
							end

							if targetCoords then
								DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
							end
						else
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil
							targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
							local distance = #(playerCoords - targetCoords)
							while distance < Config.MinimumDistance do
								Citizen.Wait(5)

								targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
								distance = #(playerCoords - targetCoords)
							end

							local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
							local msg    = nil

							if street[2] ~= 0 and street[2] ~= nil then
								msg = string.format('~s~Emmenez-moi à~y~ %s~s~, près de~y~ %s', GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2]))
							else
								msg = string.format('~s~Emmenez-moi à~y~ %s', GetStreetNameFromHashKey(street[1]))
							end

							ESX.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName('Destination')
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else
						DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then

								if not IsNearCustomer then
									ESX.ShowNotification('vous êtes à proximité du client, approchez-vous de lui')
									IsNearCustomer = true
								end

							end

							if customerDistance <= 20.0 then
								if not CustomerIsEnteringVehicle then
									ClearPedTasksImmediately(CurrentCustomer)

									local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(vehicle, i) then
											freeSeat = i
											break
										end
									end

									if freeSeat then
										TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
										CustomerIsEnteringVehicle = true
									end
								end
							end
						end
					end
				else
					DrawSub('veuillez remonter dans votre véhicule pour continuer la mission', 5000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))
	
	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	return false
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end
	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end
	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	targetCoords              = nil
end


function StartTaxiJob()
	ShowLoadingPromt('Prise de service', 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

function GetRandomWalkingNPC()
	local search = {}
	local peds   = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)
		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	OnJob = false
	DrawSub('Mission terminée', 5000)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyspinnerOn(type)
		Citizen.Wait(time)

		BusyspinnerOff()
	end)
end

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------- MENU VESTAIRE ----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RMenu.Add('Vestaire', 'taxi', RageUI.CreateMenu("Vestaire", "Menu Vestaire"))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('Vestaire', 'taxi'), true, true, true, function()

            RageUI.Button("S'équiper de sa tenue : ~b~Civile",nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    vcivil()
                end
            end)

            RageUI.Button("S'équiper de la tenue : ~g~taxi",nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    tenuetaxi()
                end
            end)

			end, function()
        end, 1)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local playerPed = PlayerPedId()
        for k,v in pairs(Config.vestaire) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then 
			local coords = GetEntityCoords(PlayerPedId())
				if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
				if service == true then	
					DrawMarker(21, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0.0, 255.0, 0.0, 170, 0, 1, 2, 0, nil, nil, 0)
					ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour accéder au vestiaire")
						if IsControlJustPressed(0,51) then
							RageUI.CloseAll()
							RageUI.Visible(RMenu:Get('Vestaire', 'taxi'), not RageUI.Visible(RMenu:Get('Vestaire', 'taxi')))
						end 
					end
				end
           end
        
		end
    end
end)

			
function tenuetaxi()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
		if model == GetHashKey("mp_m_freemode_01") then
			clothesSkin = {
				['tshirt_1'] = 21,  ['tshirt_2'] = 0,
				['torso_1'] = 4,   ['torso_2'] = 0,
				['arms'] = 4,      ['helmet_1'] = -1,
				['pants_1'] = 28,   ['pants_2'] = 0,
				['shoes_1'] = 10,   ['shoes_2'] = 0,
				['chain_1'] = 13,   ['shoes_2'] = 0,
			}
		else
			clothesSkin = {
				['tshirt_1'] = 36,  ['tshirt_2'] = 0,
				['torso_1'] = 141,   ['torso_2'] = 0,
				['arms'] = 72,
				['pants_1'] = 35,   ['pants_2'] = 0,
				['shoes_1'] = 52,   ['shoes_2'] = 0,
			}
		end
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end

function vcivil()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------- MENU COFFRE -----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RMenu.Add('taxi', 'coffre', RageUI.CreateMenu("Taxi", "Intéraction"))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('taxi', 'coffre'), true, true, true, function() 
		
			RageUI.Button("Prendre Objet(s)", nil, {RightLabel = "<"},true, function(Hovered, Active, Selected)
				if (Selected) then  
					OpenGetStocksTaxiMenu()
					RageUI.CloseAll()
				end
            end)
			
            RageUI.Button("Déposer Objet(s)", nil, {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if (Selected) then  	
					OpenPutStocksTaxiMenu()
					RageUI.CloseAll()
				end
            end)

			RageUI.Button("Prendre Arme(s)", nil, {RightLabel = "<"},true, function(Hovered, Active, Selected)
				if (Selected) then   
					OpenGetWeaponMenu()
					RageUI.CloseAll()
				end
            end)
			
			RageUI.Button("Déposer Arme(s)", nil, {RightLabel = ">"},true, function(Hovered, Active, Selected)
				if (Selected) then   
					OpenPutWeaponMenu()
					RageUI.CloseAll()
				end
            end)

        end, function()
        end)

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(Config.coffre) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then 
			local coords = GetEntityCoords(PlayerPedId())
				if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
				DrawMarker(21, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0.0, 255.0, 0.0, 170, 0, 1, 2, 0, nil, nil, 0)
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour accéder au coffre")
					if IsControlJustPressed(0,51) then
						RageUI.Visible(RMenu:Get('taxi', 'coffre'), not RageUI.Visible(RMenu:Get('taxi', 'coffre')))
					end 
				end
           end
        
		end
    end
end)

function OpenGetStocksTaxiMenu()
	ESX.TriggerServerCallback('taxi:prendreitem', function(items)
		local elements = {}

		for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'Taxi',
			title    = 'Taxi stockage',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                css      = 'Taxi',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('taxi:prendreitems', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksLSPDMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksTaxiMenu()
	ESX.TriggerServerCallback('taxi:inventairejoueur', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'Taxi',
			title    = 'inventaire',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                css      = 'Taxi',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					
					if itemName == "crystal" then
					
					else
						TriggerServerEvent('taxi:stockitem', itemName, count)
					end

					Citizen.Wait(300)
					OpenPutStocksLSPDMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end


function OpenGetWeaponMenu()

	ESX.TriggerServerCallback('taxi:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
		{
			title    = 'Coffre-Armurerie',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('taxi:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
	{
		title    = 'Coffre-Armurerie',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('taxi:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------ FIN ----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
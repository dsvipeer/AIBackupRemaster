--******************************************************   * All bugs were fixed + added new backup
--*                                                    *   * Credits: https://github.com/Mooreiche/AIBackup
--*   AIBACKUP REMASTERED by MajorFivePD (dsvipeer)   *    * https://github.com/dsvipeer
--*                                                    *   * https://forum.cfx.re/u/MajorFivePD/summary
--******************************************************

-- variables --
police        = GetHashKey('police3')      -- You can add any vehicle here, replace or addon.
policeman     = GetHashKey("s_m_y_cop_01") -- You can add any ped here.
companyName   = "Dispatch"                 -- DO NOT TOUCH
companyIcon   = "CHAR_CALL911"             -- DO NOT TOUCH
drivingStyle  = 537133628                  -- https://www.vespura.com/fivem/drivingstyle/
playerSpawned = false
active        = false
arrived       = false
vehicle       = nil
driver_ped    = nil
vehBlip       = nil


-- spawning events --

RegisterNetEvent('POL:Spawn')


playerSpawned = true



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerSpawned then
            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'police') then
                if IsUsingKeyboard() and IsControlJustPressed(1, 314) then
                    TriggerEvent('POL:Spawn')
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerSpawned then
            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'police') then
                if IsUsingKeyboard() and IsControlJustPressed(1, 315) then
                    LeaveScene()
                end
            end
        end
    end
end)


AddEventHandler('POL:Spawn', function(player)
    if not active then
        if player == nil then
            player = PlayerPedId()
        end

        Citizen.CreateThread(function()
            active = true
            local pc = GetEntityCoords(player)

            RequestModel(policeman)
            while not HasModelLoaded(policeman) do
                RequestModel(policeman)
                Citizen.Wait(1)
            end

            RequestModel(police)
            while not HasModelLoaded(police) do
                RequestModel(police)
                Citizen.Wait(1)
            end

            local offset = GetOffsetFromEntityInWorldCoords(player, 50, 50, 0)
            local heading, spawn = GetNthClosestVehicleNodeFavourDirection(offset.x, offset.y, offset.z, pc.x, pc.y, pc
                .z, 20, 1, 0x40400000, 0)

            vehicle = CreateVehicle(police, spawn.x, spawn.y, spawn.z, heading, true, true)
            driver_ped = CreatePedInsideVehicle(vehicle, 6, policeman, -1, true, true)

            SetEntityAsMissionEntity(vehicle)
            SetEntityAsMissionEntity(driver_ped)

            SetModelAsNoLongerNeeded(police)
            SetModelAsNoLongerNeeded(policeman)

            GiveWeaponToPed(driver_ped, GetHashKey("WEAPON_COMBATPISTOL"), math.random(20, 100), false, true)

            LoadAllPathNodes(true)
            while not AreAllNavmeshRegionsLoaded() do
                Wait(1)
            end

            local playerGroupId = GetPedGroupIndex(player)
            SetPedAsGroupMember(driver_ped, playerGroupId)

            NetworkRequestControlOfEntity(driver_ped)
            ClearPedTasksImmediately(driver_ped)

            local _, relHash = AddRelationshipGroup("POL8")
            SetPedRelationshipGroupHash(driver_ped, relHash)
            SetRelationshipBetweenGroups(0, relHash, GetHashKey("PLAYER"))
            SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), relHash)

            vehBlip = AddBlipForEntity(vehicle)
            SetBlipSprite(vehBlip, 3)

            SetVehicleSiren(vehicle, true)

            local vehicleToFollow = GetVehiclePedIsIn(player, false)
            local mode = -1             -- 0 for ahead, -1 = behind , 1 = left, 2 = right, 3 = back left, 4 = back right
            local speed = 50.0          -- Modify the backup maximum speed when following you.
            local minDistance = 4.0     -- Default safe distance set by me, you can change it here.
            local p7 = 0                -- Do not touch here
            local noRoadsDistance = 0.0 -- Do not touch here

            TaskVehicleEscort(driver_ped, vehicle, vehicleToFollow, mode, speed, 537657916, minDistance, p7,
                noRoadsDistance)

            ShowAdvancedNotification(companyIcon, companyName, "DISPATCH", "A Patrol Unit is heading to your location.")

            arrived = false
            while not arrived do
                Citizen.Wait(0)
                local coords = GetEntityCoords(vehicle)
                local distance = #(coords - pc)
                if distance < 25.0 then
                    arrived = true
                end
            end
            while GetEntitySpeed(vehicle) > 0 do
                Wait(1)
            end
        end)
    end
end)



-- command --
RegisterCommand("aib", function()
    local player = PlayerPedId()
    if player ~= nil then
        if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'police') then
            TriggerEvent('POL:Spawn', player)
        else
            ShowAdvancedNotification(companyIcon, companyName, "DISPATCH", "You aren't a police officer.")
            return
        end
    end
end, false)

-- functions --
function EnterVehicle()
    if vehicle ~= nil then
        TaskEnterVehicle(driver_ped, vehicle, 2000, -1, 20, 1, 0)
        while GetIsTaskActive(driver_ped, 160) do
            Wait(1)
        end
        TaskEnterVehicle(passenger_ped, vehicle, 2000, 0, 20, 1, 0)
        while GetIsTaskActive(passenger_ped, 160) do
            Wait(1)
        end
    end
end

function LeaveVehicle()
    if vehicle ~= nil then
        ClearPedTasks(driver_ped)
        TaskLeaveVehicle(driver_ped, vehicle, 0)
        while IsPedInAnyVehicle(driver_ped, false) do
            Wait(1)
        end
        ClearPedTasks(passenger_ped)
        TaskLeaveVehicle(passenger_ped, vehicle, 0)
        while IsPedInAnyVehicle(passenger_ped, false) do
            Wait(1)
        end
    end
end

function LeaveScene()
    if active then
        ShowAdvancedNotification(companyIcon, companyName, "DISPATCH", "Backup Dispatch has been cancelled.")


        ClearPedTasksImmediately(driver_ped)
        ClearPedTasksImmediately(passenger_ped)


        TaskWarpPedIntoVehicle(driver_ped, vehicle, -1)
        TaskWarpPedIntoVehicle(passenger_ped, vehicle, -2)


        SetRelationshipBetweenGroups(0, GetPedRelationshipGroupHash(driver_ped), GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(0, GetPedRelationshipGroupHash(passenger_ped), GetHashKey("PLAYER"))


        if DoesBlipExist(vehBlip) then
            RemoveBlip(vehBlip)
        end
        if DoesEntityExist(vehicle) then
            SetEntityAsNoLongerNeeded(vehicle)
        end
        if DoesEntityExist(driver_ped) then
            SetEntityAsNoLongerNeeded(driver_ped)
        end
        if DoesEntityExist(passenger_ped) then
            SetEntityAsNoLongerNeeded(passenger_ped)
        end


        active = false
        arrived = false
    end
end

-- command --
RegisterCommand("aib2", function()
    local player = PlayerId()
    if player ~= nil then
        if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'police') then
            TriggerEvent('POLMav:Spawn', player)
        else
            ShowAdvancedNotification(companyIcon, companyName, "DISPATCH", "You aren't a police officer.")
            return
        end
    end
end, false)


RegisterNetEvent('POLMav:Spawn')
AddEventHandler('POLMav:Spawn', function(player)
    if not active then
        if player == nil then
            player = PlayerId()
        end

        Citizen.CreateThread(function()
            active = true
            local pc = GetEntityCoords(GetPlayerPed(player))
            local offset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(player), 0, 0, 100)
            local heading, spawnPos = GetNthClosestVehicleNodeFavourDirection(offset.x, offset.y, offset.z, pc.x, pc.y,
                pc.z, 1, 1, 3.0, 0x40400000, 0)


            local distanceToPlayer = #(spawnPos - pc)
            if distanceToPlayer < 50 then
                spawnPos = pc + vector3(0, 0, 50)
            end

            RequestModel("polmav")
            while not HasModelLoaded("polmav") do
                RequestModel("polmav")
                Citizen.Wait(1)
            end

            RequestModel("s_m_m_pilot_02")
            while not HasModelLoaded("s_m_m_pilot_02") do
                RequestModel("s_m_m_pilot_02")
                Citizen.Wait(1)
            end

            vehicle = CreateVehicle(GetHashKey("polmav"), spawnPos.x, spawnPos.y, spawnPos.z, heading, true, true)
            driver_ped = CreatePedInsideVehicle(vehicle, 4, GetHashKey("s_m_m_pilot_02"), -1, true, true)

            SetEntityAsMissionEntity(vehicle)
            SetEntityAsMissionEntity(driver_ped)

            SetModelAsNoLongerNeeded("polmav")
            SetModelAsNoLongerNeeded("s_m_m_pilot_02")

            SetVehicleEngineOn(vehicle, true, true, true)
            ShowAdvancedNotification(companyIcon, companyName, "DISPATCH", "A Heli Unit is heading to your location.")
            local blip = AddBlipForEntity(vehicle)
            SetBlipSprite(blip, 422)
            SetBlipColour(blip, 38)
            SetBlipFlashes(blip, true)
            SetBlipFlashTimer(blip, 500)

            TaskVehicleFollow(driver_ped, vehicle, GetPlayerPed(player), 50.0, 2500, 33.0, 5)

            while active do
                Citizen.Wait(0)
            end

            RemoveBlip(blip)
        end)
    end
end)


function ShowAdvancedNotification(icon, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, 4, sender, title, text)
    DrawNotification(false, true)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

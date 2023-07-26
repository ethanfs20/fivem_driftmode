local driftModeEnabled = false
local defaultHandling = {}

RegisterNetEvent('driftmode:initClient')
AddEventHandler('driftmode:initClient', function()
    if Config.vehicleWhitelist then
        local ped = PlayerPedId()
        local pedVehicle = GetVehiclePedIsIn(ped)
        local vehicleModel = GetEntityModel(pedVehicle)
        local isWhitelisted = false

        for _, model in ipairs(Config.models) do
            if vehicleModel == GetHashKey(model) then
                isWhitelisted = true
                break
            end
        end

        if not isWhitelisted then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "Drift Mode",
                    "This vehicle is not whitelisted for drift mode."
                }
            })
            return
        end
    end

    if Config.vehicleClassWhitelist then
        local ped = PlayerPedId()
        local pedVehicle = GetVehiclePedIsIn(ped)
        local vehicleClass = GetVehicleClass(pedVehicle)
        local isWhitelisted = false

        for _, class in ipairs(Config.classes) do
            if vehicleClass == class then
                isWhitelisted = true
                break
            end
        end

        if not isWhitelisted then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "Drift Mode",
                    "This vehicle class is not whitelisted for drift mode."
                }
            })
            return
        end
    end

    driftModeEnabled = not driftModeEnabled

    -- send chat message to notify disable or enable
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {
            "Drift Mode",
            "Drift Mode is now " ..
                (driftModeEnabled and "enabled" or "disabled")
        }
    })

    modifyHandling()
end)

function modifyHandling()
    local ped = PlayerPedId()
    local pedVehicle = GetVehiclePedIsIn(ped)

    if driftModeEnabled then
        -- Store current handling values as default for the vehicle
        SetDriftTyresEnabled(pedVehicle, 1)
        SetReduceDriftVehicleSuspension(pedVehicle, 1)
        if Config.twostep then
            Citizen.CreateThread(function()
                local all_part = {} -- Move the all_part table here to handle drift smoke particles separately
                while driftModeEnabled do
                    Citizen.Wait(0)
                    if IsPedInAnyVehicle(ped) then
                        local RPM = GetVehicleCurrentRpm(pedVehicle)

                        if GetPedInVehicleSeat(pedVehicle, -1) == ped and RPM >
                            0.9 then
                            AddExplosion(GetEntityCoords(pedVehicle), 61, 0.0,
                                         true, true, 0.0, true)
                            Citizen.Wait(math.random(100, 400))
                        end
                    end
                end
            end)
        end
        Citizen.CreateThread(function()
            local all_part = {} -- Move the all_part table here to handle drift smoke particles separately
            while driftModeEnabled do
                Citizen.Wait(0)
                local speed = GetEntitySpeed(pedVehicle) * 3.6 -- Convert speed to km/h

                if IsPedInAnyVehicle(ped) then
                    local RPM = GetVehicleCurrentRpm(pedVehicle)

                    if GetPedInVehicleSeat(pedVehicle, -1) == ped and speed > 5 then
                        for i = 0, 20 do -- Increased density to 20
                            UseParticleFxAssetNextCall("core")
                            local W1 = StartParticleFxLoopedOnEntityBone(
                                           "exp_grd_bzgas_smoke", pedVehicle,
                                           0.2, 0, 0, 0, 0, 0,
                                           GetEntityBoneIndexByName(pedVehicle,
                                                                    "wheel_lr"),
                                           1.0, 0, 0, 0) -- Increased size to 1.0
                            UseParticleFxAssetNextCall("core")
                            local W2 = StartParticleFxLoopedOnEntityBone(
                                           "exp_grd_bzgas_smoke", pedVehicle,
                                           0.2, 0, 0, 0, 0, 0,
                                           GetEntityBoneIndexByName(pedVehicle,
                                                                    "wheel_rr"),
                                           1.0, 0, 0, 0) -- Increased size to 1.0
                            table.insert(all_part, W1)
                            table.insert(all_part, W2)
                        end

                        Citizen.Wait(1000)
                        for _, W in ipairs(all_part) do
                            StopParticleFxLooped(W, true)
                        end
                    end
                end
            end
        end)
    else
        -- Reset handling properties to default
        SetDriftTyresEnabled(pedVehicle, 0)
        SetReduceDriftVehicleSuspension(pedVehicle, 0)
    end
end

Citizen.CreateThread(function()
    if Config.keybind then
        while true do
            Citizen.Wait(0)
            -- Check if the key is pressed
            if IsControlJustPressed(0, Config.startKey) then
                -- Perform the action you want when the key is pressed
                TriggerServerEvent('driftmode:initServer')
            end
        end
    else
        return
    end
end)

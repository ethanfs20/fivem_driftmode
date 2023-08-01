local driftModeEnabled = false
local currentVeh = nil
local all_part = {}
local QBCore = nil
if Config.qbcore then QBCore = exports['qb-core']:GetCoreObject() end

local function IsVehicleWhitelisted(pedVehicle)
    local vehicleModel = GetEntityModel(pedVehicle)
    for _, model in ipairs(Config.models) do
        if vehicleModel == GetHashKey(model) then return true end
    end
    return false
end

local function IsVehicleClassWhitelisted(pedVehicle)
    local vehicleClass = GetVehicleClass(pedVehicle)
    for _, class in ipairs(Config.classes) do
        if vehicleClass == class then return true end
    end
    return false
end

local function disableDrift(pedVehicle)
    SetDriftTyresEnabled(pedVehicle, 0)
    SetReduceDriftVehicleSuspension(pedVehicle, 0)
    driftModeEnabled = not driftModeEnabled
end

local function notify(message)
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"Drift Mode", message}
    })
end

function QBCore.Functions.HasItem(item)
    local p = promise.new()
    QBCore.Functions.TriggerCallback('QBCore:HasItem',
                                     function(result) p:resolve(result) end,
                                     item)
    return Citizen.Await(p)
end

function ToggleDriftMode()
    local ped = PlayerPedId()
    local pedVehicle = GetVehiclePedIsIn(ped)
    if Config.qbcore then
        print(Config.item)
        if not QBCore.Functions.HasItem(Config.item) then
            notify("You need the required item to use Drift Mode.")
            return
        end
    end
    currentVeh = pedVehicle

    if not IsPedInAnyVehicle(ped) then
        notify('You must be in a vehicle to use this command.')
        return
    end

    if Config.vehicleWhitelist and not IsVehicleWhitelisted(pedVehicle) then
        notify('This vehicle is not whitelisted for drift mode.')
        return
    end

    if Config.vehicleClassWhitelist and
        not IsVehicleClassWhitelisted(pedVehicle) then
        notify('This vehicle class is not whitelisted for drift mode.')
        return
    end

    if driftModeEnabled then
        disableDrift(pedVehicle)
        notify('Drift mode is now ' ..
                   (driftModeEnabled and "enabled" or "disabled") .. '.')
        return
    else
        driftModeEnabled = not driftModeEnabled
        notify('Drift mode is now ' ..
                   (driftModeEnabled and "enabled" or "disabled") .. '.')
    end

    SetDriftTyresEnabled(pedVehicle, 1)
    SetReduceDriftVehicleSuspension(pedVehicle, 1)

    Citizen.CreateThread(function()
        while driftModeEnabled do
            Citizen.Wait(0)
            if driftModeEnabled == false then break end
            local speed = GetEntitySpeed(pedVehicle) * 3.6 -- Convert speed to km/h
            if IsPedInAnyVehicle(ped) then
                if pedVehicle ~= currentVeh then
                    currentVeh = pedVehicle
                    disableDrift(pedVehicle)
                    break
                end
                local RPM = GetVehicleCurrentRpm(pedVehicle)
                if GetPedInVehicleSeat(pedVehicle, -1) == ped and speed > 5 then
                    for i = 0, 20 do -- Increased density to 20
                        UseParticleFxAssetNextCall("core")
                        local W1 = StartParticleFxLoopedOnEntityBone(
                                       "exp_grd_bzgas_smoke", pedVehicle, 0.2,
                                       0, 0, 0, 0, 0, GetEntityBoneIndexByName(
                                           pedVehicle, "wheel_lr"), 1.0, 0, 0, 0) -- Increased size to 1.0
                        UseParticleFxAssetNextCall("core")
                        local W2 = StartParticleFxLoopedOnEntityBone(
                                       "exp_grd_bzgas_smoke", pedVehicle, 0.2,
                                       0, 0, 0, 0, 0, GetEntityBoneIndexByName(
                                           pedVehicle, "wheel_rr"), 1.0, 0, 0, 0) -- Increased size to 1.0
                        table.insert(all_part, W1)
                        table.insert(all_part, W2)
                    end

                    Citizen.Wait(500)
                    for _, W in ipairs(all_part) do
                        StopParticleFxLooped(W, true)
                    end
                end
            else
                disableDrift(pedVehicle)
                print('broke')
                break
            end
        end
    end)

    if Config.twostep then
        Citizen.CreateThread(function()
            while driftModeEnabled do
                Citizen.Wait(0)
                if driftModeEnabled == false then break end
                if IsPedInAnyVehicle(ped) then
                    local RPM = GetVehicleCurrentRpm(pedVehicle)
                    if GetPedInVehicleSeat(pedVehicle, -1) == ped and RPM > 0.9 then
                        AddExplosion(GetEntityCoords(pedVehicle), 61, 0.0, true,
                                     true, 0.0, true)
                        Citizen.Wait(math.random(100, 400))
                    end
                end
            end
        end)
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

RegisterNetEvent('driftmode:initClient')
AddEventHandler('driftmode:initClient', function() ToggleDriftMode() end)

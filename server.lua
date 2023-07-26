RegisterCommand("driftmode", function(source, args, rawCommand)
    local source = source
    if source ~= nil then
        checkPermission(source)
    else
        print("Someone or something tried to run cmd: driftmode")
    end
end)

RegisterServerEvent('driftmode:initServer')
AddEventHandler('driftmode:initServer', function()
    local source = source
    if source ~= nil then
        checkPermission(source)
    else
        print("Someone or something tried to init driftmode:initServer")
    end
end)

function checkPermission(source)
    if Config.permissionsBased then
        if IsPlayerAceAllowed(source, Config.permissionName) then
            TriggerClientEvent('driftmode:initClient', source)
        else
            -- Send chat message to notify player that they don't have permission
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "Drift Mode",
                    "You do not have permission to use this command."
                }
            })
        end
    else
        TriggerClientEvent('driftmode:initClient', source)
    end
end

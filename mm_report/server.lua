ESX = exports['es_extended']:getSharedObject()

local send = 0
RegisterNetEvent("mmreport:send")
AddEventHandler("mmreport:send", function(msg)
    local id = source
    local name = GetPlayerName(source)
    
    send = send + 1
    
    TriggerClientEvent("mmreport:add", -1, id, name, msg, send)
    TriggerEvent("mmreport:CreatedNotify")
end)

RegisterNetEvent("mmreport:checkServer")
AddEventHandler("mmreport:checkServer", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    
    for i=1, #Config.AllowedGroups do
        if group == Config.AllowedGroups[i] then
            TriggerClientEvent("mmreport:tab", source)
            break
        end
    end
end)

RegisterNetEvent("mmreport:teleport")
AddEventHandler("mmreport:teleport", function(globalId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(globalId)
    local targetPed = GetPlayerPed(globalId)
    local coords = GetEntityCoords(targetPed)
    TriggerClientEvent("mmreport:TeleportAdmin", source, coords)
end)

RegisterNetEvent("mmreport:vybavene")
AddEventHandler("mmreport:vybavene", function(globalSend)
    TriggerClientEvent("mmreport:delete", -1, globalSend)
end)

RegisterNetEvent("mmreport:CreatedNotify")
AddEventHandler("mmreport:CreatedNotify", function()
    TriggerClientEvent("mmreport:SendNotify", -1)
end)

RegisterServerEvent("mmreport:DatabazaVybavene")
AddEventHandler("mmreport:DatabazaVybavene", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    exports.oxmysql:execute('SELECT resolved_reports FROM mm_reports WHERE identifier = ?', {identifier}, function(result)
        if result and #result > 0 then
            exports.oxmysql:execute('UPDATE mm_reports SET resolved_reports = resolved_reports + 1 WHERE identifier = ?', {identifier})
        else
            exports.oxmysql:execute('INSERT INTO mm_reports (identifier, resolved_reports) VALUES (?, ?)', {identifier, 1})
        end
    end)
end)
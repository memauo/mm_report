local options = {}
local options_dva = {}
local globalId = nil
local globalName = nil
local globalMsg = nil
local GlobalSend = nil
local duty = Config.Duty
local ESX = exports['es_extended']:getSharedObject()
local playerGroup = nil
local created = 0


function _U(str)
    return Locales[Config.Locale][str] or str
end



RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    playerGroup = xPlayer.group
end)


CreateThread(function()
    if Config.Duty == 1 then
        duty = 1
        TriggerEvent("mmreport:DutyCheck")
    end
    if not playerGroup then
        playerGroup = ESX.GetPlayerData().group
    end
end)

RegisterCommand(Config.PlayerCommand, function(source, args, rawCommand)
    local msg = table.concat(args, " ")
    if created==0 then
        TriggerServerEvent("mmreport:send", msg)
        lib.notify({
            title = 'MM_REPORT',
            description = _U('report_created'),
            type = 'inform'
        })
        created = 1
        SetTimeout(Config.CreationTimeout, function()
            created = 0
        end)
    end
end)

RegisterNetEvent("mmreport:add")
AddEventHandler("mmreport:add", function(id, name, msg, send)
    globalId = id
    globalName = name
    globalMsg = msg
    globalSend = send
    table.insert(options, {
        title = '['..send..']-('..id..')'..' '..name,
        description = msg,
        icon = 'fa-solid fa-ticket',
        sendId = send,
        onSelect = function()
            TriggerEvent("mmreport:menu", send, id)
        end
    })
end)




RegisterCommand(Config.DutyCommand, function()
    if duty ~= 2 then
        duty = 1 - duty
        TriggerEvent("mmreport:DutyCheck")
    else
       lib.notify({
           title = 'MM_REPORT',
           description = _U('duty_disabled'),
           type = 'inform'
       }) 
    end
end)

RegisterNetEvent("mmreport:DutyCheck") 
AddEventHandler("mmreport:DutyCheck", function()
    if duty==1 then
        lib.notify({
            title = 'MM_REPORT',
            description = _U('on_duty'),
            type = 'success'
        })
    end
    if duty==0 then
        lib.notify({
            title = 'MM_REPORT',
            description = _U('off_duty'),
            type = 'error'
        })
    end
end)


RegisterCommand(Config.AdminCommand, function(source, args, rawCommand)
   TriggerServerEvent("mmreport:checkServer")
end)
RegisterKeyMapping(Config.AdminCommand, "Open menu", "keyboard", Config.AdminBind)

RegisterNetEvent("mmreport:tab")
AddEventHandler("mmreport:tab", function()
    lib.registerContext({
        id = 'report_menu',
        title = _U('player_reports'),
        options = options
    })
    lib.showContext('report_menu')
end)

RegisterNetEvent("mmreport:menu")
AddEventHandler("mmreport:menu", function(send, id)
    globalSend = send
    globalId = id
    options_dva = {
        {
            title = _U('teleport'),
            description = '',
            icon = 'fa-solid fa-location-dot',
            onSelect = function()
                TriggerServerEvent("mmreport:teleport", globalId)
            end
        },
        {
            title = _U('mark_done'),
            description = '',
            icon = 'fa-solid fa-check',
            onSelect = function()
                TriggerServerEvent('mmreport:vybavene', globalSend)
                TriggerServerEvent('mmreport:DatabazaVybavene')
            end
        },
        {
            title = _U('done'),
            description = '',
            icon = 'fa-solid fa-house',
            onSelect = function()
                lib.showContext('report_menu')
            end
        }
    }
    lib.registerContext({
        id = 'report_mini_menu',
        title = 'Report',
        options = options_dva
    })
    lib.showContext('report_mini_menu')
end)

RegisterNetEvent("mmreport:TeleportAdmin")
AddEventHandler("mmreport:TeleportAdmin", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
end)

RegisterNetEvent("mmreport:delete")
AddEventHandler("mmreport:delete", function(globalSend)
    for i = #options, 1, -1 do
        if options[i].sendId == globalSend then
            table.remove(options, i)
            break
        end
    end
end)
RegisterNetEvent("mmreport:SendNotify")
AddEventHandler("mmreport:SendNotify", function()
    if duty == 1 then
        for i = 1, #Config.AllowedGroups do
            if playerGroup == Config.AllowedGroups[i] then
                lib.notify({
                    title = 'MM_REPORT',
                    description = _U('new_report_created'),
                    type = 'inform'
                })
                break
            end
        end
    end
end)
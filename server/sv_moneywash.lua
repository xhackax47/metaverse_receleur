local QBCore = exports['qb-core']:GetCoreObject()


function PercentageCut(percent, value)
    if tonumber(percent) and tonumber(value) then
        return (value * percent) / 100
    end
    return false
end

RegisterNetEvent("metaverse_receleur:server:checkforitems")
AddEventHandler("metaverse_receleur:server:checkforitems", function()
    local ServerDataWorth = 0
    local montantGold = 0
    local montantDiam = 0
    local montantTotal = 0
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for slot, data in pairs(Player.PlayerData.items) do
        if data ~= nil then
            if data.name == 'goldbar' then
                ServerDataWorthG = ServerDataWorth + (1000 * data.amount)
                montantGold = montantGold + data.amount
                Player.Functions.RemoveItem('goldbar', data.amount, slot)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], "remove", montantGold)
                TriggerClientEvent('QBCore:Notify', src, 'Attends. je reprends tes ' .. montantGold .. ' lingots.')
            elseif data.name == 'diamond' then
                ServerDataWorthD = ServerDataWorth + (1000 * data.amount)
                montantDiam = montantDiam + data.amount
                Player.Functions.RemoveItem('diamond', data.amount, slot)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['diamond'], "remove", montantDiam)
                TriggerClientEvent('QBCore:Notify', src, 'Attends. je reprends tes ' .. montantDiam .. ' diamants.')
            end
        end
    end

    if ServerDataWorthG > 0 and montantGold > 0 or ServerDataWorthD > 0 and montantDiam > 0 then
        montantTotal = montantGold + montantDiam
        ServerDataWorthT = 1000 * montantTotal
        TriggerClientEvent('metaverse_receleur:client:exchangeitems', src, ServerDataWorthT)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Tu n\'as rien d\'intéressant.')
    end

end)


RegisterNetEvent("metaverse_receleur:server:returncleancash")
AddEventHandler("metaverse_receleur:server:returncleancash", function(ServerDataWorth)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local finalworth = ServerDataWorth
    local fee = PercentageCut(Config.Percentage, finalworth)
    local floored = math.floor(finalworth - fee)

    if Config.UseFee then
        Player.Functions.AddMoney('cash', floored)
        TriggerClientEvent('QBCore:Notify', src,
            'Tiens voila ' ..
            floored .. '$ après mes ' .. Config.Percentage .. '% de commission, t\'as cru je travaillais gratos?',
            'success')
    else
        Player.Functions.AddMoney('cash', finalworth)
        TriggerClientEvent('QBCore:Notify', src, 'Tiens voila '..finalworth..'$.', 'success')
    end
end)

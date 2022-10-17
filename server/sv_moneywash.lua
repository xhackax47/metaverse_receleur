local QBCore = exports['qb-core']:GetCoreObject()


function PercentageCut(percent, value)
    if tonumber(percent) and tonumber(value) then
        return (value*percent)/100
    end
    return false
end


RegisterNetEvent("metaverse_receleur:server:checkforbills")
AddEventHandler("metaverse_receleur:server:checkforbills", function()
    local ServerDataWorth = 0
    local amount = 0
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for slot, data in pairs(Player.PlayerData.items) do
        if data ~= nil then
            if data.name == 'goldbar' then
                ServerDataWorth = ServerDataWorth + (1000 * data.amount)
                amount = amount + data.amount
                Player.Functions.RemoveItem('goldbar', data.amount, slot)
            elseif data.name == 'diamond' then
                ServerDataWorth = ServerDataWorth + (1000 * data.amount)
                amount = amount + data.amount
                Player.Functions.RemoveItem('diamond', data.amount, slot)
            end
        end
    end
    
        if ServerDataWorth > 0 and amount > 0 then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], "remove", amount)
            TriggerClientEvent('metaverse_receleur:client:exchangebills', src, ServerDataWorth)
            TriggerClientEvent('QBCore:Notify', src, 'Attends. je reprends tes '..amount..' lingots.')
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
        TriggerClientEvent('QBCore:Notify', src, 'Tiens voila '..floored..'$ après mes '..Config.Percentage..'% de commission, t\'as cru je travaillais gratos?', 'success')
--    else
--        Player.Functions.AddMoney('cash', finalworth)
--        TriggerClientEvent('QBCore:Notify', src, 'Tiens voila '..finalworth..'$.', 'success')
    end
end)

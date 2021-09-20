ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("buyPickAxe:minerJob")
AddEventHandler("buyPickAxe:minerJob", function(shopCostMenu)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getMoney() >= 250 then
        xPlayer.removeMoney(shopCostMenu)
        xPlayer.addInventoryItem("pickaxe", 1)
    end
end)


RegisterNetEvent("buysandwich:minerJob")
AddEventHandler("buysandwich:minerJob", function(shopCostMenu)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(shopCostMenu)
    xPlayer.addInventoryItem("sandwich", 1)
end)


RegisterNetEvent("buyWater:minerJob")
AddEventHandler("buyWater:minerJob", function(shopCostMenu)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(shopCostMenu)
    xPlayer.addInventoryItem("water", 1)
end)


RegisterServerEvent("refreshItems:minerJob") 
AddEventHandler("refreshItems:minerJob", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		
	local goldCount = xPlayer.getInventoryItem('gold').count
	local ironCount = xPlayer.getInventoryItem('iron').count
	local pickaxeCount = xPlayer.getInventoryItem('pickaxe').count
    

    TriggerClientEvent("refreshGold:minerJob", source, goldCount)
    TriggerClientEvent("refreshIron:minerJob", source, ironCount)
    TriggerClientEvent("refreshPickaxe:minerJob", source, pickaxeCount)
end)


RegisterNetEvent("sellResource:minerJob")
AddEventHandler("sellResource:minerJob", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    local goldCount = xPlayer.getInventoryItem('gold').count
    local ironCount = xPlayer.getInventoryItem('iron').count

    local randomGoldCash = math.random(1000, 1200)
    local randomIronCash = math.random(50, 80)


    local goldReward = goldCount * randomGoldCash
    local ironReward = ironCount * randomIronCash
    local completReward = goldReward + ironReward

    if goldCount > 0 then
        xPlayer.removeInventoryItem("gold", goldCount)
        xPlayer.addMoney(goldReward)

    end
    if ironCount > 0 then
        xPlayer.removeInventoryItem("iron", ironCount)
        xPlayer.addMoney(ironReward)
    end

    if completReward == 0 then

    else
        TriggerClientEvent("showReward:minerJob", source, completReward)
    end
    

end)


RegisterNetEvent("addItems:minerJob")
AddEventHandler("addItems:minerJob", function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local randomItem = math.random(1,100)

    local randomeIronCounter = math.random(1,3)

    if randomItem < 97 then
        if xPlayer.canCarryItem('iron', 1) then
            xPlayer.addInventoryItem("iron", randomeIronCounter)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Üzerine daha fazla demir alamazsın."})
        end
    else
        if xPlayer.canCarryItem('gold', 1) then
            xPlayer.addInventoryItem("gold", 1)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Üzerine daha fazla altın alamazsın."})
        end
    end

end)


RegisterNetEvent("removePickaxe:minerJob")
AddEventHandler("removePickaxe:minerJob", function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local randomDestroy = math.random(1,100)
   
    print(randomDestroy)
    if randomDestroy < 90 then
        
    else
        TriggerClientEvent("pickaxeBroken:minerJob", source)
        xPlayer.removeInventoryItem("pickaxe", 1)
    end

end)
RegisterCommand("announce", function(source, args)
    local argString = table.concat(args, " ")
    if argString ~= nil then
        TriggerClientEvent('notifications', -1, "#1dbe0f", "ANKÜNDIGUNG", argString)
    end
end, true)

RegisterCommand("id", function(source, args)
    TriggerClientEvent('notifications', source, "#1dbe0f", "ANKÜNDIGUNG", "Deine ID ist: " .. source)
end, false)

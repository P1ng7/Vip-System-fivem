local config = lib.require('config')


RegisterCommand(config.buy_command, function(src, args)
    local input = lib.inputDialog(string.upper(config.buy_command), {
        { type = "input", label = "Code", password = true, icon = "lock", required = true },
    })  
    if input then 
        local code = input[1]
        if code then 
            print('debug 1')
            local response = lib.callback.await('p_vips-system:reclaimCode', false, input[1])
        end
    end
end)

RegisterCommand(config.generate_code_command, function(src, args)
    local isAdmin = lib.callback.await('p_vips-system:isPlayerAuth', false)
    if isAdmin then 
        local options = {}
        for k,v in pairs(config.Vips) do 
            options[#options + 1] = {
                value = k,
                label = v.prefix
            }
        end 
        local input = lib.inputDialog('GENERATE CODE', {
            {type = 'select', label = 'Vip', description = 'VIPs to generate', options = options, required = true},
        })
        if input[1] then 
            local code = lib.callback.await('p_vips-system:saveCode', false, tonumber(input[1]))
            lib.setClipboard(code)
        end
    end
end)



RegisterNetEvent('p_vips-system:reclaimPurcharse')
AddEventHandler('p_vips-system:reclaimPurcharse', function(code, level)
    local alert = lib.alertDialog({
		header = "The code is valid !",
		content = "Are you sure you want to claim this code? \n\n It contains a: VIP " .. config.Vips[level].prefix,
		centered = true,
		cancel = true,
	})
    if alert ~= 'confirm' then 
        return
    end

    local success = lib.callback.await('p_vips-system:giveVip', false, code)


end)
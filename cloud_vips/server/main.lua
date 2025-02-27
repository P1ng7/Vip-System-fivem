local player = lib.require('server/player')
local config = lib.require('config')
local vips = lib.require('server/vips')
local discord = lib.require('server/discord')

AddEventHandler("playerJoining", function(playerId)
    if player.isPlayerVip(playerId) then 
        local identifier = GetPlayerIdentifierByType(playerId, 'license')
        local response = MySQL.query.await('SELECT `expires` FROM `p_vips` WHERE `identifier` = ?', {
            identifier
        })
        if response then 
            if response[1] then 
                for k,v in pairs(response) do 
                    local fecha = v.expires

                    
                    local year, month, day, hour, min, sec = fecha:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")

                    
                    local timestamp = os.time({
                        year = tonumber(year),
                        month = tonumber(month),
                        day = tonumber(day),
                        hour = tonumber(hour),
                        min = tonumber(min),
                        sec = tonumber(sec)
                    })

                    
                    if (timestamp - os.time()) <= 0 then 
                        MySQL.update('DELETE FROM p_vips WHERE identifier = ?', {
                            identifier
                        }, function(affectedRows)
                           
                        end)
                    end

                end
            end
        end

    end
end)



lib.callback.register('p_vips-system:isPlayerAuth', function(source)
    return player.isPlayerAuth(source)
end)

lib.callback.register('p_vips-system:saveCode', function(source, level)
    if player.isPlayerAuth(source) then 
        local code = vips.generateCode()
        if code then 
            discord.sendWebHook(
                config.discord_webhook_on_gen_code,
                "CODE CREATED",
                "The player: **#"..source.." "..GetPlayerName(source).."** \n I create the VIP: **"..config.Vips[level].prefix.."** \n Code: **||"..code.."||**",
                16776960,
                os.date("%Y-%m-%d %H:%M:%S", os.time())
            )
            vips.saveCode(code, level)
            return code
        else
            return nil
        end
    end
end)


lib.callback.register('p_vips-system:reclaimCode', function(source, code)
    local compare_success, code, level = vips.checkCode(code)
    if compare_success then 
        TriggerClientEvent('p_vips-system:reclaimPurcharse',source, code, level)
        return true
    end
    return false
end)


lib.callback.register('p_vips-system:giveVip', function(source, code, level)
    local compare_success, valid_code, vip_level = vips.checkCode(code)
    if not compare_success or not valid_code or not vip_level then
        print("^1[ERROR] Código VIP inválido o no encontrado.^0")
        return false
    end
   
    local future_time = os.time() + (config.vips_days_remaining * 86400)
    local expiration_date = os.date("%Y-%m-%d %H:%M:%S", future_time)

    vips.setUsedCode(valid_code)
    player.giveVip(source, vip_level, expiration_date)
    SetTimeout(3500, function()
            discord.sendWebHook(
                config.discord_webhook_on_claim_code,
                "CODE RECLAIM",
                "The player: **#"..source.." "..GetPlayerName(source).."** \n I redeem the VIP: **"..config.Vips[vip_level].prefix.."** \n Code: **||"..code.."||**",
                16776960,
                os.date("%Y-%m-%d %H:%M:%S", os.time())
            )
    end)
    

    return true
end)



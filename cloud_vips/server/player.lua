local self = {}
local config = lib.require('config')
local discord = lib.require('server/discord')


function self.isPlayerAuth(src)
    local identifier = GetPlayerIdentifierByType(src, "license")
    for k,v in pairs(config.authLicenses) do 
        if v == identifier then 
            return true
        end
    end
    return false
end


function self.isPlayerVip(src)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    if identifier then 
        local response = MySQL.query.await('SELECT `level` FROM `p_vips` WHERE `identifier` = ?', {
            identifier
        })  
        if response[1] then
            for k,v in pairs(response) do 
                if v.level >= 1 then 
                    return true
                end 
            end
        end
        return false
    end

end
exports('isPlayerVip', self.isPlayerVip)



function self.giveVip(src, level, time)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    if identifier then 
        MySQL.insert('INSERT INTO `p_vips` (identifier, level, expires) VALUES (?, ?, ?)', {
            identifier, level, time
        }, function(id)
            
        end)
    end
end





return self
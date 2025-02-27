local config = lib.require('config')
local self = {}




function self.generateCode()
    local caracteres
    local longitud = config.code_lenght
    local codigo = ""
    if config.alpha_numeric then 
        caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        for i = 1, longitud do
            local indice = math.random(1, #caracteres)
            codigo = codigo .. string.sub(caracteres, indice, indice)
        end
    else
        caracteres = "0123456789"
        for i = 1, longitud do
            local indice = math.random(1, #caracteres)
            codigo = codigo .. string.sub(caracteres, indice, indice)
        end
    end

    return codigo
end

function self.saveCode(code, level)
    MySQL.insert('INSERT INTO `p_codes` (code, level, used) VALUES (?, ?, ?)', {
        code, level, false
    }, function(id)
        
    end)
end

function self.checkCode(code)
    local response = MySQL.query.await('SELECT * FROM `p_codes` WHERE `code` = ?', {
        code
    })
    if response[1] then 
        for k,v in pairs(response) do 
            if v.used == false then 
                return true, v.code, v.level
            end
        end
    end

    return false
     
end

function self.setUsedCode(code)
    MySQL.update('UPDATE p_codes SET used = ? WHERE code = ?', {
        true, code
    }, function(affectedRows)
    end)

end


return self
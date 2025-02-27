local self = {}

function self.sendWebHook(webhook, name, message, color, footer)
    if not webhook or webhook == "" then
        print("^1[ERROR] Webhook URL no especificada.^0")
        return
    end

    local embed = {
        {
            ["color"] = color or 16711680, 
            ["title"] = "**".. (name or "Sin título") .."**",
            ["description"] = message or "Sin contenido",
            ["footer"] = {
                ["text"] = footer or "Sistema",
            },
        }
    }

    local payload = {
        embeds = embed
    }

    PerformHttpRequest(webhook, function(err, text, headers)
        if err ~= 200 then
            print(("^1[ERROR] Fallo al enviar webhook: %s | Código: %s^0"):format(text, err))
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end



return self
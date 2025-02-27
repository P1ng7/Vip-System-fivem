local self = {}



self.buy_command = 'buy'
self.generate_code_command = 'generate_code'
self.discord_webhook_on_gen_code = "https://discord.com/api/webhooks/1343329844334956564/X-KLmoo567HoZR3hSkGW4aQ5IJA3R66ES3Z8ZjolR-FMroj7h7XYPC15FMBMW8E7gd5w"
self.discord_webhook_on_claim_code = "https://discord.com/api/webhooks/1343329844334956564/X-KLmoo567HoZR3hSkGW4aQ5IJA3R66ES3Z8ZjolR-FMroj7h7XYPC15FMBMW8E7gd5w"
self.code_lenght = 11 
self.alpha_numeric = true -- 123456789ABC..
self.vips_days_remaining = 30 -- 1 Month

self.authLicenses = {
    "license:87f085bd47405092bdfa9af07204dd9fb3c595c1"
}


self.Vips = {
    [1] = {
        prefix = "Bronze",
    },
    [2] = {
        prefix = "Silver"
    },
    [3] = {
        prefix = "Gold"
    },
    [4] = {
        prefix = "Ruby"
    },
    [5] = {
        prefix = "Platinum" 
    },
    [6] = {
        prefix = "Diamond"
    }
}


return self
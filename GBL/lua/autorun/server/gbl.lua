print("loading GBL...")

-- script based on https://github.com/cresterienvogel/Skids/blob/master/skids.lua --
-- Global Ban List by Vladhog Development --
-- Special thanks for Erik Maksimets --


local list = {}

function update()
	http.Fetch("http://vladhog.ru/GlobalBanListAPI/api/get_list",
		function(content)
			list = util.JSONToTable(content)
		end
	)
end

concommand.Add("gbl_update", function(ply)
	update()
	PrintMessage(HUD_PRINTTALK, "Global Ban List was updated!")
end)

timer.Simple(0, function()
	print("Global Ban List by Vladhog Development")
	print("Special thanks for Erik Maksimets")
	update()
end)

hook.Add("CheckPassword", "Global Ban List", function(steamid)
	if table.HasValue(list, util.SteamIDFrom64(steamid)) then
		return false, "\
				You are banned \
				\
				This server using Global Ban List by Vladhog Development\
				vladhog.development@gmail.com"
	end
end)
	
print("loaded!")

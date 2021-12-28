print("loading GBL...")

-- script based on https://github.com/cresterienvogel/Skids/blob/master/skids.lua --
-- Global Ban List by Vladhog Development --
-- Special thanks for Erik Maksimets --


local list = {}
local api_key = "insert your api key here"

function update()
	http.Fetch("http://vladhogstudio.ddns.net/GlobalBanListAPI/api/get_list",
		function(content)
			list = util.JSONToTable(content)
		end
	)
end

concommand.Add("gbl_update", function(ply)
	if IsValid(ply) then
		if (ply:IsSuperAdmin() or ply:IsListenServerHost()) then
			update()
			ply:PrintMessage(HUD_PRINTTALK, "Global Ban List was updated!")
		else
			ply:PrintMessage(HUD_PRINTTALK, "You can't use this command!")
		end
	else
		update()
		print("Global Ban List was updated!")
	end
end)

concommand.Add("gbl_ban", function(ply, cmd, arg)
	if IsValid(ply) then
		if (ply:IsSuperAdmin() or ply:IsListenServerHost()) then
			if api_key == ("insert your api key here" or nil) then
				ply:PrintMessage(HUD_PRINTTALK, "Error: invalid api key")
				return
			end
			if arg[1] == nil then return end
			if arg[6] == nil then return end
			game.KickID(arg[1], atg[2])
			http.Fetch("http://vladhogstudio.ddns.net/GlobalBanListAPI/api/add;steamid=" .. arg[1] .. ";apikey=" .. api_key .. ";reason=" .. arg[2],
				function(content)
					ply:PrintMessage(HUD_PRINTTALK, content)
					update()
				end
			)
		else
			ply:PrintMessage(HUD_PRINTTALK, "You can't use this command!")
		end
	else 
		if api_key == ("insert your api key here" or nil) then
			print("Error: invalid api key")
			return
		end
		if arg[1] == nil then return end
		if arg[6] == nil then return end
		game.KickID(arg[1] .. ":" .. arg[3] .. ":" .. arg[5], arg[6])
		http.Fetch("http://vladhogstudio.ddns.net/GlobalBanListAPI/api/add;steamid=" .. arg[1] .. ":" .. arg[3] .. ":" .. arg[5] .. ";apikey=" .. api_key .. ";reason=" .. arg[6],
			function(content)
				print(content)
				update()
			end
		)
	end
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
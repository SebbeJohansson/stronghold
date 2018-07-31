GM.Adverts = {}

local PATH_HudAdverts = "gamemodes/stronghold/hud_adverts.txt"

local PATH_ChatAdverts = "gamemodes/stronghold/chat_adverts.txt"

GM.Adverts.KeyReplacements = {}
GM.Adverts.KeyReplacements["{HOSTNAME}"] = function() return GetHostName() end
GM.Adverts.KeyReplacements["{TIMELIMIT}"] = function() local t = (GetConVarNumber( "mp_timelimit" )*60) return Format("%01d:%02d",math.floor(t/60),math.floor(t%60)) end
GM.Adverts.KeyReplacements["{TIMELEFT}"] = function() local t = (GetConVarNumber( "mp_timelimit" )*60) - (CurTime()-(GAMEMODE.LastGameReset or 0)) return Format("%01d:%02d",math.floor(t/60),math.floor(t%60)) end
GM.Adverts.KeyReplacements["{FRAGLIMIT}"] = function() return GetConVarNumber( "mp_fraglimit" ) end
GM.Adverts.KeyReplacements["{SERVERTIME}"] = function() return os.date("%H:%M:%S %z") end
GM.Adverts.KeyReplacements["{CURRENTMAP}"] = function() return game.GetMap() end
GM.Adverts.KeyReplacements["{NEXTMAP}"] = function() return game.GetMapNext() end

GM.Adverts.HudAdverts = {}
GM.Adverts.HudAdvertsTime = 30
GM.Adverts.CurrentHudAdvert = 1
GM.Adverts.LastSentHudAdvert = { color=1, text="" }

GM.Adverts.ChatAdverts = {}
GM.Adverts.ChatAdvertsTime = 30
GM.Adverts.CurrentChatAdvert = 1
GM.Adverts.LastSentChatAdvert = { color=1, text="" }

local function AddAdvertsFromJSON(json, adverts)
    local tbl = util.JSONToTable(json)['adverts']
    for k, v in pairs(tbl) do
        local array = {}
        for key, value in pairs(v) do
            array[key] = value
        end
        table.insert(adverts, array)
    end
end

function GM:LoadAdverts( ply )
	if IsValid( ply ) and !ply:IsAdmin() then return end
	
	GAMEMODE.Adverts.HudAdverts = {}
	GAMEMODE.Adverts.ChatAdverts = {}

	-- Load file if it exists otherwise create it
	if file.Exists( PATH_HudAdverts, "GAME" ) then
		local data = file.Read( PATH_HudAdverts, "GAME" )
        AddAdvertsFromJSON(data, GAMEMODE.Adverts.HudAdverts)
	else
        Msg("No ",PATH_HudAdverts, " file exists. Using HudAdvertsFileDefault from sv_adverts.lua.\n")
        AddAdvertsFromJSON(GAMEMODE.Adverts.HudAdvertsFileDefault, GAMEMODE.Adverts.HudAdverts)
	end

	-- Load ChatAdverts file
	if file.Exists( PATH_ChatAdverts, "GAME" ) then
		local data = file.Read( PATH_ChatAdverts, "GAME" )
        AddAdvertsFromJSON(data, GAMEMODE.Adverts.ChatAdverts)
	else
        Msg("No ",PATH_ChatAdverts, " file exists. Using HudAdvertsFileDefault from sv_adverts.lua.\n")
        AddAdvertsFromJSON(GAMEMODE.Adverts.ChatAdvertsFileDefault, GAMEMODE.Adverts.ChatAdverts)
	end
end
concommand.Add( "sh_reloadadverts", function() GAMEMODE:LoadAdverts() end )

local function HudAdvertsTimer()
	local GAMEMODE = GAMEMODE or GM

	if #GAMEMODE.Adverts.HudAdverts == 0 then return end

	if GAMEMODE.Adverts.CurrentHudAdvert > #GAMEMODE.Adverts.HudAdverts then GAMEMODE.Adverts.CurrentHudAdvert = 1 end
	
	local type = "hint"
	local list = GAMEMODE.Adverts.HudAdverts
	local current = GAMEMODE.Adverts.CurrentHudAdvert
	GAMEMODE.Adverts.CurrentHudAdvert = GAMEMODE.Adverts.CurrentHudAdvert + 1
	
	-- CODE BELOW THIS POINT IN THIS FUNCTION IS PLUG-AND-PLAY WITH OTHER TIMER (It uses the locals above)
	
	-- Get advert color and string
	local col = list[current] and list[current].color or 1
	local str = list[current] and list[current].text or ""
	
	-- Replace keys in string
	for k, v in pairs(GAMEMODE.Adverts.KeyReplacements) do
		str = string.gsub( str, k, tostring(v()) )
	end
	
	-- Replace convars
	str = string.gsub( str, "{(.+)}", GetConVarString )
	
	-- Send it to everyone
	for _, ply in ipairs(player.GetHumans()) do
		if IsValid( ply ) then
			GAMEMODE.Net:SendAdvert( ply, type, col, str )
		end
	end
	
	GAMEMODE.Adverts.LastSentHint = { color=col, text=str }
end HudAdvertsTimer()
timer.Create( "SH_Hud_Adverts", GM.Adverts.HudAdvertsTime, 0, HudAdvertsTimer )

local function ChatAdvertsTimer()
	if #GAMEMODE.Adverts.ChatAdverts == 0 then return end

	if GAMEMODE.Adverts.CurrentChatAdvert > #GAMEMODE.Adverts.HudAdverts then GAMEMODE.Adverts.CurrentChatAdvert = 1 end
	
	local type = "chatvert"
	local list = GAMEMODE.Adverts.ChatAdverts
	local current = GAMEMODE.Adverts.CurrentChatAdvert
	GAMEMODE.Adverts.CurrentChatAdvert = GAMEMODE.Adverts.CurrentChatAdvert + 1
	
	-- CODE BELOW THIS POINT IN THIS FUNCTION IS PLUG-AND-PLAY WITH OTHER TIMER (It uses the locals above)
	
	-- Get advert color and string
	local col = list[current] and list[current].color or 1
	local str = list[current] and list[current].text or ""
	
	-- Replace keys in string
	for k, v in pairs(GAMEMODE.Adverts.KeyReplacements) do
		str = string.gsub( str, k, tostring(v()) )
	end
	
	-- Replace convars
	str = string.gsub( str, "{(.+)}", GetConVarString )
	
	-- Send it to everyone
	for _, ply in ipairs(player.GetHumans()) do
		if IsValid( ply ) then
			GAMEMODE.Net:SendAdvert( ply, type, col, str )
		end
	end
	
	GAMEMODE.Adverts.LastSentHudAdvert = { color=col, text=str }
end
timer.Create( "SH_Adverts_Chatvert", GM.Adverts.ChatAdvertsTime, 0, ChatAdvertsTimer )

// Use command sh_reloadadverts to reload adverts.
GM.Adverts.HudAdvertsFileDefault = [[{
  "keys":[
    "{HOSTNAME}",
    "{TIMELIMIT}",
    "{TIMELEFT}",
    "{FRAGLIMIT}",
    "{SERVERTIME}",
    "{CURRENTMAP}",
    "{NEXTMAP}"
  ],
  "colors":{
    "1" : "White"  ,
    "2" : "Grey"   ,
    "3" : "Red"    ,
    "4" : "Green"  ,
    "5" : "Blue"   ,
    "6" : "Yellow" ,
    "7" : "Orange" ,
    "8" : "Teal"   ,
    "9" : "Aqua"   ,
    "10" : "Violet"
  },
  "adverts": [
    {
      "color": 1,
      "text": "If you experience performance issues, try turning off effects in the options menu."
    },
    {
       "color": 4,
       "text": "Hold right click with the toolgun and move your mouse to switch tool modes."
    },
    {
       "color": 7,
       "text": "It's a good idea to create more than one spawnpoint."
    },
    {
       "color": 9,
       "text": "Spawn protection will protect you for {sh_immunetime} seconds."
    },
    {
       "color": 3,
       "text": "Money farming is considered cheating."
    }
  ]
}]]

GM.Adverts.ChatAdvertsFileDefault = [[{
  "keys":[
    "{HOSTNAME}",
    "{TIMELIMIT}",
    "{TIMELEFT}",
    "{FRAGLIMIT}",
    "{SERVERTIME}",
    "{CURRENTMAP}",
    "{NEXTMAP}"
  ],
  "colors":{
    "1" : "White"  ,
    "2" : "Grey"   ,
    "3" : "Red"    ,
    "4" : "Green"  ,
    "5" : "Blue"   ,
    "6" : "Yellow" ,
    "7" : "Orange" ,
    "8" : "Teal"   ,
    "9" : "Aqua"   ,
    "10" : "Violet"
  },
  "adverts": [
    {
      "color": 4,
      "text": "If you have suggestions to improve gameplay or need to report a bug, visit forums.roaringcow.com"
    },
    {
       "color": 4,
       "text": "{HOSTNAME} suggestions {TIMELIMIT} gameplay {FRAGLIMIT} to {SERVERTIME} bug, {CURRENTMAP}ums.roa{NEXTMAP}m."
    }
  ]
}]]

--[[
	GM13 Changes
	
	Added:
	Removed:
	Updated:
		net code
	Changed:
		cleaned code
]]--

team.SetUp( 50, "Hermits (No Team)", Color(226,226,226,255) )

GM.Team = {}
GM.Teams = {}
GM.Teams[50] = { Leader=nil, Name="Hermits (No Team)", Color=Color(226,226,226,255) }

function GM.Team:TeamCreated( intIndex, pLeader, strName, colColor )
	GAMEMODE.Teams[intIndex] = { Leader=pLeader, Name=strName, Color=colColor }
	team.SetUp( intIndex, strName, colColor )
end

function GM.Team:TeamDisbanded( intIndex )
	if GAMEMODE.GameOver then return end -- Keep teams at the end for spectate info
	GAMEMODE.Teams[intIndex] 		= nil
	team.GetAllTeams()[intIndex] 	= nil
end

function GM.Team:TeamLeaderChange( intIndex, pLeader )
	if GAMEMODE.Teams[intIndex] then
		GAMEMODE.Teams[intIndex].Leader = pLeader
	end
end

//Config
//Thanks to Lt.Smith.. who kinda stole this code off me in the first place.. and then modified it a little.. but it's all okay, because now I stole it back and used it for what I needed =)

local enablenames = true
local enabletitles = true
local textalign = 1
// Distance multiplier. The higher this number, the further away you'll see names and titles.
local distancemulti = 2

////////////////////////////////////////////////////////////////////
// Don't edit below this point unless you know what you're doing. //
////////////////////////////////////////////////////////////////////

function DrawNameTitle()

	local vStart = LocalPlayer():GetPos()
	local vEnd
	local ply = LocalPlayer()

	for k, v in pairs(player.GetAll()) do
		if (ply:Team() == v:Team()) and ply:Team() != 50 then
			local vStart = LocalPlayer():EyePos()
			local vEnd = v:EyePos()
			local trace = {}
			
			trace.start = vStart
			trace.endpos = vEnd
			local trace = util.TraceLine( trace )
			
			if trace.HitWorld then
				--Do nothing!
			else
				local mepos = LocalPlayer():GetPos()
				local tpos = v:GetPos()
				local tdist = mepos:Distance(tpos)
				
				if tdist <= 3000 then
					local zadj = 0.03334 * tdist
					local pos = v:GetPos() + Vector(0,0,v:OBBMaxs().z + 5 + zadj)
					pos = pos:ToScreen()
					
					local alphavalue = (200 * distancemulti) - (tdist/1.5)
					alphavalue = math.Clamp(alphavalue, 0, 255)
					
					local outlinealpha = (150 * distancemulti) - (tdist/2)
					outlinealpha = math.Clamp(outlinealpha, 0, 255)
					
					local playercolour = team.GetColor(v:Team())
					local playertitle = string.Left( team.GetName(v:Team()), 16 )
					
					if ( (v != LocalPlayer()) and (v:GetNWBool("exclusivestatus") == false) ) then
						if (enablenames == true) then
							draw.SimpleTextOutlined(v:Name(), "TargetID", pos.x, pos.y - 10, Color(playercolour.r, playercolour.g, playercolour.b, alphavalue),textalign,1,2,Color(0,0,0,outlinealpha))
						end
						if (not (playertitle == "")) and (enabletitles == true) then
							draw.SimpleTextOutlined(playertitle, "Trebuchet18", pos.x, pos.y + 6, Color(255,255,255,alphavalue),textalign,1,1,Color(0,0,0,outlinealpha))
						end
					end
				end
			end
		end
	end
end
hook.Add("HUDPaint", "DrawNameTitle", DrawNameTitle)

function TeamMateHUDPaint()
    if GetConVar("sh_teamdot"):GetInt() == 1 then
        local teamindex = LocalPlayer():Team()
        local players = player.GetAll()
        local teammates = team.GetPlayers(teamindex)
        local teamcolor = team.GetColor(teamindex)

        for k, v in ipairs(teammates) do
            if not IsValid(v) then continue end
            if v == LocalPlayer() then continue end
            if not v:Alive() then continue end
            if teamindex == 50 then continue end
			
            local pos = v:LocalToWorld( v:OBBCenter() )
            local sPos = pos:ToScreen()
            local pDist = (LocalPlayer():GetPos()-sPos[k]):Length()
            local fade = math.Clamp( pDist-500, 0, 210 )
            
            local vStart = LocalPlayer():EyePos()
            local vEnd = v:EyePos()
            local trace = {}
            trace.start = vStart
            trace.endpos = vEnd
            local trace = util.TraceLine( trace )
        
            if trace.HitWorld then
                draw.RoundedBox( 4, sPos.x-4, sPos.y-4, 8, 8, Color(20,20,20,210) )
                draw.RoundedBox( 2, sPos.x-2, sPos.y-2, 4, 4, Color(teamcolor.r,teamcolor.g,teamcolor.b,210) )
            elseif pDist > 1000 then
                draw.RoundedBox( 4, sPos.x-4, sPos.y-4, 8, 8, Color(20,20,20,fade) )
                draw.RoundedBox( 2, sPos.x-2, sPos.y-2, 4, 4, Color(teamcolor.r,teamcolor.g,teamcolor.b,math.Clamp(fade-30,0,210 )) )
            end
        end
    end
    
end
hook.Add( "HUDPaint", "TeamMateHUDPaint", TeamMateHUDPaint )

local function HaloGraphs()
    if GetConVar("sh_teamoutline"):GetInt() == 1 then
        local teamindex = LocalPlayer():Team()
        local teammates = team.GetPlayers(teamindex)
        local teamcolor = team.GetColor(teamindex)

        for k,v in pairs(teammates) do
            if not IsValid(v) then continue end
            if v == LocalPlayer() then continue end
            if not v:Alive() then continue end
            if teamindex == 50 then continue end
            halo.Add(teammates, Color(teamcolor.r,teamcolor.g,teamcolor.b, 255), 3, 3, 1, 1, GetConVar("sh_teamoutline_esp"):GetBool())
        end
    end
end
hook.Add("PreDrawHalos", "TeamHalo", HaloGraphs)
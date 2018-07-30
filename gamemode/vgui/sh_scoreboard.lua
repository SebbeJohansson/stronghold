surface.CreateFont("ScoreboardHeader", {size=64,font="BebasNeue"})

surface.CreateFont("ScoreboardColumnRow", {size=24,font="BebasNeue"})
surface.CreateFont("ScoreboardGangRow", {size=25,font="BebasNeue"})
surface.CreateFont("ScoreboardRow", {size=20,font="BebasNeue"})

CreateConVar("gog_sbcur",1,FCVAR_ARCHIVE,"Enables/Disables the cursor in the scoreboard.")

function GM:CreateScoreboard()
	local xsize = ScrW()*0.85
	local ysize = ScrH()*0.8
	
	local plylist = vgui.Create("DPanelList")
	plylist:SetSize(xsize,ysize)
	plylist:Center()
	plylist:SetSpacing(5)
	plylist:EnableVerticalScrollbar(true)
	plylist.TeamPanels = {}
	plylist.Columns = {
		Name = 0.008,
		Rank = 0.3,
		Kills = 0.8,
		Deaths = 0.85,
		Ping = 0.95
	}
	
	function plylist:Paint(w,h)
		self:SizeToContents()
		self:SetSize(xsize,math.min(self:GetTall(),ysize))
		self:Center()
		draw.RoundedBox(4,0,0,w,h,Color(0,0,0,153))
	end

	function plylist:Update()
		local items = table.Copy(self.Items)
		table.sort(items,function(a,b)
				return (a.inforow == false and false or (a.inforow and !(b.inforow == false)))
		end)
		self:Clear()
		for k,v in pairs(items) do
			self:AddItem(v)
		end
	end
	
	GAMEMODE.Scoreboard = plylist

	local header = vgui.Create("DLabel",plylist)
	header:SetText("")
    header:SetSize(0,44)
	header.inforow = false

    function header:Paint(w,h)
        local text = GAMEMODE:GetGameDescription()

        surface.SetFont("ScoreboardHeader")

        local tw = surface.GetTextSize(text)

        surface.SetTextColor(color_white)
        surface.SetTextPos((w/2)-(tw/2),-6)
        surface.DrawText(text)
    end
    
    plylist:AddItem(header)
    
    local inforow = vgui.Create("DLabel",plylist)
    inforow:SetText("")
    inforow:SetSize(0,22)
    inforow.inforow = true
	
	function inforow:Paint(w,h)
		for k,v in pairs(plylist.Columns) do
			surface.SetFont("ScoreboardColumnRow")
			surface.SetTextPos(w*v,h-22)
			surface.SetTextColor(Color(255,255,255,255))
			surface.DrawText(k)
		end
		draw.RoundedBox(4,0,0,w,self:GetTall(),Color(89, 154, 207,153))
	end
	
	plylist:AddItem(inforow)
	
	for k,v in pairs(player.GetAll()) do
		GAMEMODE:ScoreboardPlayerRow(v)
	end
	
	if timer.Exists("ScoreboardUpdate") then
		timer.Start("ScoreboardUpdate")
	else
		timer.Create("ScoreboardUpdate",1,0,function()
			GAMEMODE:ScoreboardUpdate()
		end)
	end
	
	GAMEMODE:ScoreboardUpdate()
end

function GM:ScoreboardUpdate()
	GAMEMODE.Scoreboard:Update()
	for k,v in pairs(GAMEMODE.Scoreboard.TeamPanels) do
		v:Update()
	end
end

function GM:ScoreboardPlayerRow(ply)
	if not (GAMEMODE.Scoreboard.TeamPanels[ply:Team()] and GAMEMODE.Scoreboard.TeamPanels[ply:Team()]:IsValid()) then
		local teampanel = vgui.Create("DPanelList",GAMEMODE.Scoreboard)
		teampanel:SetSpacing(1)
		teampanel.Team = ply:Team()
		teampanel.Name = team.GetName(ply:Team())
		
		local label = vgui.Create("DLabel",GAMEMODE.Scoreboard)
		label:SetFont("ScoreboardGangRow")
		label:SetText("   "..team.GetName(ply:Team()) )
		function label:PaintOver()
			if IsValid(ply) then
				label:SetText("   "..team.GetName(ply:Team()) )
			end
		end
		label.Team = ply:Team()
		label:SetSize(0,32)
		
		function label:Paint(w,h)
			draw.RoundedBox( 4, 0, 0, w, h, SetColorAlpha(team.GetColor(self.Team),75) )
		end
		
		teampanel:AddItem(label)
		
		function teampanel:PaintOver()
			self:SizeToContents()
		end
		
		function teampanel:Update()
			local items = table.Copy(self.Items)
			table.sort(items,function(a,b)
				if IsValid(a.ply) and IsValid(b.ply) then
					return (a.ply:Frags() == b.ply:Frags() and a.ply:Name() > b.ply:Name() or a.ply:Frags() > b.ply:Frags() )
				else
					return (a.Team != nil)
				end
			end)
			self:Clear()
			for k,v in pairs(items) do
				self:AddItem(v)
			end
		end
		
		GAMEMODE.Scoreboard:AddItem(teampanel)
		
		GAMEMODE.Scoreboard.TeamPanels[ply:Team()] = teampanel
	end
	
	local label = vgui.Create("DLabel",GAMEMODE.Scoreboard)
	label:SetText("")
	label.ply = ply
	
	function label:Paint(w,h)
		if not IsValid(self.ply) then
			self:Remove()
			GAMEMODE:ScoreboardUpdate()
			return
		end
		draw.RoundedBox( 4, 0, 0, w, h, Color(54, 89, 117,75) )

		local values = {
			Name = self.ply:Name(),
			Rank = self.ply:GetGroupName(),
			Kills = self.ply:Frags(),
			Deaths = self.ply:Deaths(),
			Ping = self.ply:Ping()
		}
		for k,v in pairs(values) do
			local pos = GAMEMODE.Scoreboard.Columns[k]
			
			surface.SetFont("ScoreboardRow")
			surface.SetTextPos(w*pos,0)
			surface.SetTextColor(Color(255,255,255,255))
			surface.DrawText(v)
		end
	end
	
	GAMEMODE.Scoreboard.TeamPanels[ply:Team()]:AddItem(label)
	GAMEMODE.Scoreboard.TeamPanels[ply:Team()]:SizeToContentsY()
end

function GM:ScoreboardShow()
	local sbcur = math.floor(cvars.Number("gog_sbcur"))
	if sbcur == 0 then
		gui.EnableScreenClicker(false)
	else
		gui.EnableScreenClicker(true)
	end
	GAMEMODE.CreateScoreboard()
end

function GM:ScoreboardHide()
	if (IsValid(GAMEMODE.Scoreboard)) then
		gui.EnableScreenClicker(false)
		GAMEMODE.Scoreboard:Remove()
		if timer.Exists("ScoreboardUpdate") then
			timer.Stop("ScoreboardUpdate")
		end
	end
end

function GM:HUDDrawScoreBoard()
	-- bye bye old scoreboard ;)
end
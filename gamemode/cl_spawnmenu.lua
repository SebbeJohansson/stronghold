function GM:InitSpawnMenu()
	if ValidPanel( g_SpawnMenu ) then g_SpawnMenu:Remove() end
	g_SpawnMenu = vgui.Create( "sh_spawnmenu" )
	g_SpawnMenu:SetVisible( false )
	g_SpawnMenu:SetSkin( "stronghold" )
end
hook.Add( "OnGamemodeLoaded", "CreateSpawnMenu", function() GAMEMODE:InitSpawnMenu() end )

function GM:OnSpawnMenuOpen()
	if g_SpawnMenu then g_SpawnMenu:Open() end
end

function GM:OnSpawnMenuClose()
	if g_SpawnMenu then g_SpawnMenu:Close() end 
end

function ModelSearch( SearchString, iLimit )
	local ret = {}

	for k, v in pairs(GAMEMODE.SpawnLists["All"]) do
		if string.find( string.lower(v), string.lower(SearchString) ) then
			table.insert( ret, v )
		end
	end

	table.sort( ret )
	return ret
end

function GM:DoModelSearch( str )
	local ret = {}
	if str:len() < 3 then
		table.insert( ret, "Enter at least 3 characters" )
	else
		str = str:lower()
		for k, v in pairs( self.SpawnLists["All"] ) do
			if v:find( str ) then
				table.insert( ret, v )
			end
		end
	end
	return ret
end
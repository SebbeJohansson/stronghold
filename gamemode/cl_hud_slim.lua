--[[-------------------------------------------------------

Fight to Survive: Stronghold by RoaringCow, TehBigA is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.

This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/ or send a letter to Creative Commons, 
444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

---------------------------------------------------------]]

--[[ Locals ]]--

local TEX_GRADIENT_TOP 			= surface.GetTextureID( "vgui/gradient-u" )
local TEX_GRADIENT_BOTTOM 		= surface.GetTextureID( "vgui/gradient-d" )
local TEX_GRADIENT_RIGHT 		= surface.GetTextureID( "vgui/gradient-r" )
local TEX_GRADIENT_LEFT 		= surface.GetTextureID( "vgui/gradient-l" )
local TEX_GRADIENT_BOTTOMLEFT 	= surface.GetTextureID( "vgui/gradient-bl" )
local TEX_GRADIENT_BOTTOMRIGHT 	= surface.GetTextureID( "vgui/gradient-br" )

local TEX_HUDICONS 					= {}
TEX_HUDICONS["health2"] 			= surface.GetTextureID( "hudicons/health2" )
TEX_HUDICONS["shield"] 				= surface.GetTextureID( "hudicons/shield" )
TEX_HUDICONS["weapon_sh_drone"] 	= surface.GetTextureID( "hudicons/shield" )
TEX_HUDICONS["weapon_sh_c4"] 		= surface.GetTextureID( "hudicons/c4" )
TEX_HUDICONS["weapon_sh_flash"] 	= surface.GetTextureID( "hudicons/fnade" )
TEX_HUDICONS["weapon_sh_grenade"] 	= surface.GetTextureID( "hudicons/henade" )
TEX_HUDICONS["weapon_sh_smoke"] 	= surface.GetTextureID( "hudicons/snade" )

local TEX_STANCE_AIMING 			= surface.GetTextureID( "stance/aiming" )
local TEX_STANCE_AIMING_CROUCHED 	= surface.GetTextureID( "stance/aiming_crouched" )
local TEX_STANCE_RELAXED 			= surface.GetTextureID( "stance/relaxed" )
local TEX_STANCE_RELAXED_CROUCHED 	= surface.GetTextureID( "stance/relaxed_crouched" )

local TEX_FIREMODE_AUTO 			= surface.GetTextureID( "firemode/automatic" )
local TEX_FIREMODE_SEMIAUTO 		= surface.GetTextureID( "firemode/semiautomatic" )

-- --------------------------------------------------------------------------------------------------------------
--[[ Helper Functions ]]--

local function ColorBlend( scale, c1, c2 )
	scale = math.Clamp( scale, 0, 1 )
	local scale2 = -(scale-1)
	
	return Color( 
		math.Clamp( math.floor(c1.r*scale2+c2.r*scale), 0, 255 ),
		math.Clamp( math.floor(c1.g*scale2+c2.g*scale), 0, 255 ),
		math.Clamp( math.floor(c1.b*scale2+c2.b*scale), 0, 255 ),
		math.Clamp( math.floor(c1.a*scale2+c2.a*scale), 0, 255 )
	)
end

local function DrawBar( x, y, w, h, scale, right, color, col_scale )
	local bx, by 	= x+1, y+1
	local bh, bw 	= h-2, math.Round( (w-2) * scale )
	local bw_extra 	= math.Round( (w-2) - bw )

	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( x, y, w, h )
	
	surface.SetDrawColor( color.r*col_scale, color.g*col_scale, color.b*col_scale, 120 )
	surface.DrawRect( (right and bx+bw_extra or bx), by, bw, bh )
	
	--surface.SetDrawColor( 0, 0, 0, 150 )
	--surface.SetTexture( TEX_GRADIENT_BOTTOM )
	--surface.DrawTexturedRect( (right and bx+bw_extra or bx), by+bh*0.35, bw, bh*0.65 )
	
	--surface.SetDrawColor( 255, 255, 255, 2 )
	--surface.SetTexture( TEX_GRADIENT_TOP )
	--surface.DrawTexturedRect( (right and bx+bw_extra or bx), by, bw, bh*0.65 )
end

-- --------------------------------------------------------------------------------------------------------------
--[[ Normal HUD ]]--

GM.Huds = GM.Huds or {}
GM.Huds.Slim = {
	LastMoney = nil,
	LastMoney_Time = 0,
	LastVoiceChannel = nil,
	LastVoiceChannel_Time = 0
}

function GM.Huds.Slim:Paint( GAMEMODE )
	self:DrawGBux( GAMEMODE )
	self:DrawHealthAmmo( GAMEMODE )
	self:DrawHintBar(GAMEMODE)
end

function GM.Huds.Slim:DrawHintBar( GAMEMODE )
	local w, h 			= ScrW(), 20
	local scale 		= math.Clamp( (CurTime() - GAMEMODE.HintBar.LastChange) / GAMEMODE.HintBar.FadeTime, 0, 1 )
	local scale_flash 	= math.Clamp( (CurTime() - GAMEMODE.HintBar.LastChange) / 0.80, 0, 1 )
	local scale_flash_r = (-scale_flash+1)
	local lscale 		= -scale+1

	local c = GAMEMODE.CachedColors[GAMEMODE.HintBar.CurColor or 1] or GAMEMODE.CachedColors[1]
	local tw, _ = surface.GetTextSize( GAMEMODE.HintBar.CurMsg )
	if not tw then return end --!!!!!!

	local c = GAMEMODE.CachedColors[GAMEMODE.HintBar.LastColor or 1] or GAMEMODE.CachedColors[1]
	local tw, _ = surface.GetTextSize( GAMEMODE.HintBar.LastMsg )

	
	-- Timer
	if GAMEMODE.CountDownEnd != -1 and GAMEMODE.CountDownTitle != "" and GAMEMODE.CountDownEnd-CurTime() <= 600 then
		local timeleft = math.max( 0, GAMEMODE.CountDownEnd-CurTime() )
		local countdown = Format( "%02d.%02d", math.floor(timeleft/60), math.floor(timeleft%60) )
		
		surface.SetTextColor( 255, 255, 255, 220 )

		surface.SetFont( "gbux_default" )
		local tw, _ = surface.GetTextSize( countdown )
		if not tw then return end --!!!!!!

		surface.SetTextPos( w-tw-2, 0 )
		surface.DrawText( countdown )
		
		surface.SetFont( "gbux_default" )
		local tw2, _ = surface.GetTextSize( GAMEMODE.CountDownTitle.." - " )
		if not tw then return end --!!!!!!

		surface.SetTextPos( w-tw-tw2-2, 0 )
		surface.DrawText( GAMEMODE.CountDownTitle.." - " )
	end
end
local difference = 0
function GM.Huds.Slim:DrawGBux()
	local w, h	= 120, 30
	local ply 	= LocalPlayer()
	
	local money = ply:GetMoney()
	if money ~= self.LastMoney  then 
		if self.LastMoney then difference = money - self.LastMoney end
		self.LastMoney_Time = RealTime() 
	end
	if RealTime() - self.LastMoney_Time > 5 then return end

	self.LastMoney = money
	local alpha = 1 - (RealTime() - self.LastMoney_Time) / 5
	local quickfade = 1 - (RealTime() - self.LastMoney_Time) /0.5
	
	-- Draw background
	surface.SetTexture( TEX_GRADIENT_LEFT )
	surface.SetDrawColor( 20, 20, 20, 200*alpha )
	--surface.DrawTexturedRect( 0, 0, w, h )
	surface.SetDrawColor( 200, 200, 200, 200*alpha )
	--surface.DrawTexturedRect( 0, h-2, w, 1 )
	
	surface.SetTextColor( 255, 255, 255, 220*alpha )
	
	-- Labels
	surface.SetFont( "gbux_defaultbold" )
	
	surface.SetTextPos( 4, 2 )
	surface.DrawText( "Money:" )
	
	surface.SetTextPos( 4, 14 )
	surface.DrawText( "Multiplier:" )
	
	-- Amounts
	surface.SetFont( "gbux_default" )
	
	local money = UTIL_PRound( money, 2 )
	surface.SetTextPos( 70, 2 )
	surface.DrawText( UTIL_FormatMoney(money) )
	
	surface.SetTextPos( 75, 14 )
	surface.DrawText( ply:GetMultiplier() )
	
	local red, green, add = difference < 0 and 255 or 0, difference > 0 and 255 or 0, difference < 0 and -1 or 1
	
	local xoffset, yoffset = surface.GetTextSize(UTIL_FormatMoney(money))
	surface.SetTextColor( red, green, 0, 200*quickfade )
	surface.SetTextPos( 80+xoffset+(quickfade*10*add), 2 )
	surface.DrawText( UTIL_FormatMoney(difference) )
end

function GM.Huds.Slim:DrawHealthAmmo()
	local ply 		= LocalPlayer()
	
	local wep 		= ply:GetActiveWeapon()
	local doammo 	= (IsValid( wep ) and wep:Clip1() != -1 and wep.Primary.ClipSize != -1)

	local nadeclass = ply:GetLoadoutExplosive()
	local donade	= false

	for _, v in ipairs( ply:GetWeapons() ) do
		if v:GetClass() == nadeclass then
			donade = true
			break
		end
	end
	
	local sw, sh 	= ScrW(), ScrH()
	local w, h 		= 256, 30
	local h_actual 	= h*2
	local color 	= team.GetColor( ply:Team() )
	
	-- Left background
	surface.SetTexture( TEX_GRADIENT_LEFT )
	
	surface.SetDrawColor( 0, 0, 0, 100 )
	--surface.DrawTexturedRect( 0, sh-h, w, h )
	
	surface.SetDrawColor( color.r*0.50, color.g*0.50, color.b*0.50, 100 )
	--surface.DrawTexturedRect( 0, sh-h+1, w, h_actual )
	
	surface.SetDrawColor( 200, 200, 200, 200 )
	--surface.DrawTexturedRect( 0, sh-h+1, w, 1 )
	
	-- Left info
	if !ply.LastHurt or !ply.LastHeal then ply.LastHurt = 0 ply.LastHeal = 0 end
	local hp, ar, armax = math.max(ply:Health(),0), ply:GetCount( "props" ), GetConVarNumber("sbox_maxprops")
	local lasthurt 		= math.Clamp( (CurTime()-ply.LastHurt) / 0.60, 0, 1 )
	local lastheal 		= math.Clamp( (CurTime()-ply.LastHeal) / 0.30, 0, 1 )
	local hpcolor 		= (lasthurt < 1 and ColorBlend( lasthurt, Color(255,0,0,255), color )) or (lastheal < 1 and ColorBlend( lastheal, Color(0,255,0,255), color )) or color

	local x, y = 0, sh-h
	local bar = 3
	DrawBar( x+5, y+7, w-12, bar, (hp/100), false, hpcolor, 1 )
	DrawBar( x+5, y+bar+12, w-12, bar, -(ar/armax)+1, false, Color(255,255,255,255), 1 )
	
	surface.SetTexture( TEX_GRADIENT_BOTTOM )
	for i = 1, armax do
		surface.SetDrawColor( 0, 0, 0, 120*(-i/armax+1) )
		--surface.DrawTexturedRect( x+5+((w-12)/armax)*i, y+38, 1, bar )
		--surface.DrawTexturedRect( x+5+((w-12)/armax)*i, y+bar+12, 1, bar )
	end
	
	-- Voice Channel
	local voicechannel = GAMEMODE.ConVars.VoiceChannel:GetInt()
	if voicechannel ~= self.LastVoiceChannel then self.LastVoiceChannel_Time = RealTime() end
	if RealTime() - self.LastVoiceChannel_Time <= 3 then
		self.LastVoiceChannel = voicechannel
		local alpha = 1 - math.max( 0, (RealTime() - (self.LastVoiceChannel_Time+2)) / 1 )
		
		surface.SetFont( "DermaDefaultBold" )
		surface.SetTextColor( 255, 255, 255, 255*alpha )
		
		surface.SetTexture( TEX_GRADIENT_LEFT )
		surface.SetDrawColor( 0, 0, 0, 100*alpha )
		--surface.DrawTexturedRect( 0, sh-h-15, 150, 15 )
		surface.SetDrawColor( 200, 200, 200, 200*alpha )
		--surface.DrawTexturedRect( 0, sh-h-14, 150, 1 )
		
		local tw, th = surface.GetTextSize( "Voice Channel: " )
		surface.SetTextPos( 2, sh-h-6-th*0.50 )
		surface.DrawText( "Voice Channel: " )
		
		surface.SetTextColor( voicechannel == 1 and Color(color.r,color.g,color.b,color.a*alpha) or Color(250,250,0,255*alpha) )
		surface.DrawText( voicechannel == 0 and "Public" or "Team" )
	end
	
	surface.SetTextColor( 255, 255, 255, 255 )
	
	-- Right side
	if doammo or donade then
		-- Background
	
		local firemode_extend = 0
		if doammo and IsValid( wep ) and wep.FireSelect == 1 then firemode_extend = 37 end
		
		local h = math.max( (doammo and 25 or 0) + (donade and 24 or 0) + 1, 25 )
		
		surface.SetTexture( TEX_GRADIENT_RIGHT )
		
		surface.SetDrawColor( 0, 0, 0, 200 )
		--surface.DrawTexturedRect( sw-w, sh-h, w, h )
		
		surface.SetDrawColor( color.r*0.50, color.g*0.50, color.b*0.50, 100 )
		--surface.DrawTexturedRect( sw-w, sh-h+1, w, h_actual )
		
		surface.SetDrawColor( 200, 200, 200, 200 )
		--surface.DrawTexturedRect( sw-w, sh-h+1, w, 1 )
	end
	
	local x, y = sw-w, sh-h-5
	local bar = 3
	
	-- Nade info
	if donade and TEX_HUDICONS[nadeclass] then
		surface.SetTexture( TEX_HUDICONS[nadeclass] )
		surface.SetDrawColor( 255, 255, 255, 255 )
		for i = 1, (nadeclass == "weapon_sh_c4" and 1 or ply:GetAmmoCount( "grenade" )) do
			surface.DrawTexturedRect( sw-10*i-10, sh-15-(doammo and 20 or 0), 16, 16 )
		end
	end
	
	-- Ammo info
	if doammo then
		local ammoflash = math.sin( RealTime() * 10 )
		local ammo 		= (wep:Clip1()/wep.Primary.ClipSize)
		local ammodelta = (w-12) / wep.Primary.ClipSize
		local ammocolor = (ammo < 0.25 and ColorBlend( ammoflash, Color(255,0,0,255), Color(150,150,150,200) )) or Color(150,150,150,200)
		DrawBar( x+7, y+24, w-12, bar, ammo, true, ammocolor, 1 )
		
		if ammodelta > 2 then
			surface.SetTexture( TEX_GRADIENT_BOTTOM )
			for i = 1, wep.Primary.ClipSize do
				surface.SetDrawColor( 0, 0, 0, 200*(-i/wep.Primary.ClipSize+1) )
				surface.DrawTexturedRect( x+w-6-ammodelta*i, y+24, 1, bar )
			end
		end
		
		if ammo == 0 then
			surface.SetDrawColor( 255, 50, 50, 255*((ammoflash+1)*0.50) )
			surface.DrawLine( x+7, y+24, x+w-5, y+24 )
			surface.DrawLine( x+w-5, y+24, x+w-5, y+bar+24 )
			surface.DrawLine( x+7, y+bar+24, x+w-5, y+bar+24 )
			surface.DrawLine( x+7, y+24, x+7, y+bar+24 )
		end
		
		surface.SetFont( "gbux_default" )
		
		local str 			= "x"..math.ceil( ply:GetAmmoCount(wep:GetPrimaryAmmoType()) / wep.Primary.ClipSize )
		local tw, th 		= surface.GetTextSize( str )
		local mag_x, mag_y 	= sw-7-tw, y+18+bar*0.50-th*0.50

		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( mag_x, mag_y )
		surface.DrawText( str )
		
		if IsValid( wep ) and wep.FireSelect == 1 then
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( x+7, y+20, 12, 3 )
			
			surface.SetDrawColor( 255, 255, 255, 200 )
			if wep.Primary.Automatic then
				surface.DrawRect( x+8, y+21, 2, 1 )
				surface.DrawRect( x+12, y+21, 2, 1 )
				surface.DrawRect( x+16, y+21, 2, 1 )
			else
				surface.SetDrawColor( 255, 255, 255, 200 )
				surface.DrawRect( x+8, y+21, 10, 1 )
			end
		end
	end
end
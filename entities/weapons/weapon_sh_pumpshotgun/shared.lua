if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "ar2"
elseif (CLIENT) then
	SWEP.PrintName 		= "M3 SUPER 90"
	SWEP.IconLetter 	= "k"
	killicon.AddFont("weapon_sh_pumpshotgun", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end
SWEP.MuzzleAttachment		= "1" 
SWEP.Base 					= "sh_base"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel 			= "models/weapons/w_shot_m3super90.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 6
SWEP.Primary.NumShots 		= 9
SWEP.Primary.Cone 			= 0.15
SWEP.Primary.ClipSize 		= 8
SWEP.Primary.Delay 			= 0.75
SWEP.Primary.DefaultClip 	= 8
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "buckshot"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.RMod					= 0
SWEP.Zoom					= 0
SWEP.FireSelect				= 0
SWEP.IronCycleSpeed			= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.ADSPos 				= Vector (5.7431, -3, 3.3682)
SWEP.ADSAngle				= Angle (0.0634, -0.0235, 0)
SWEP.DistantSound			= "shotty.mp3"
SWEP.ShootAnim				= 2
SWEP.DeployAnim				= 6
SWEP.ReloadAnim				= 5
SWEP.ShellReloadAnim		= 3
SWEP.FinishReloadAnim		= 4
SWEP.Origin					= Vector(-2,2.5,-3)
SWEP.Pump					= true
SWEP.AlwaysAnim				= true
SWEP.EjectPos				= Vector(5,-3.5,10)
SWEP.EjectDir				= Vector(1,0,0)
SWEP.EjectDelay				= 0.7

SWEP.VElements = {
	["suppressor"] = { 
		type = "Model", 
		model = "models/weapons/suppressor.mdl",  
		bone = "v_weapon.M3_PARENT", 
		pos = Vector(0, 3.45, 16), 
		angle = Angle(-90, 0, -270), 
		size = 1, 
		color = Color(255, 255, 255, 255),
		surpresslightning = false,  
		skin = 0, 
		bodygroup = {} 
		},
	["m145"] = { 
		type = "Model", 
		model = "models/weapons/m145.mdl", 
		bone = "v_weapon.M3_PARENT", 
		pos = Vector(0.03, 4.85, 3), 
		angle = Angle(0, 0, 0), 
		size = 0.45, 
		color = Color(255, 255, 255, 255), 
		surpresslightning = false, 
		--material = "models/props_combine/metal_combinebridge001", 
		AuxIronSightsPos = Vector (5.7431, -3, 2.6),
		AuxIronSightsAng = Vector (0.0634, -0.0235, -1.93),
		RRise = -0.01,
		RSlide = 0.0045,
		skin = 0, 
		bodygroup = {} 
		},
	["rds"] = { 
		type = "Model", 
		model = "models/weapons/rds.mdl", 
		bone = "v_weapon.M3_PARENT", 
		pos = Vector(0.03, 3.4, 3), 
		angle = Angle(-90, 0, 90), 
		size = 0.52, 
		color = Color(255, 255, 255, 255), 
		surpresslightning = false, 
		--material = "models/props_combine/metal_combinebridge001",
		AuxIronSightsPos = Vector (5.7431, -3, 2.7),
		AuxIronSightsAng = Vector (0.0634, -0.0235, -2),
		skin = 0, 
		bodygroup = {} 
		},
	["slugs"] = { 
		type = "Model", 
		model = "models/weapons/rds.mdl", 
		bone = "v_weapon.M3_PARENT", 
		pos = Vector(0.03, 3.4, 3), 
		angle = Angle(-90, 0, 90), 
		size = 0.1, 
		color = Color(255, 255, 255, 0), 
		surpresslightning = false, 
		--material = "models/props_combine/metal_combinebridge001",
		AuxIronSightsPos = Vector (5.7431, -3, 2.7),
		AuxIronSightsAng = Vector (0.0634, -0.0235, -2),
		skin = 0, 
		bodygroup = {} 
		},
	["scope"] = { 
		type = "Model", 
		model = "models/weapons/scope.mdl",  
		bone = "v_weapon.M3_PARENT", 
		pos = Vector(0, 4.9, 14),
		angle = Angle(90, 0, 90), 
		size = 0.14--[[Vector(0.123, 0.123, 0.123)]], 
		color = Color(255, 255, 255, 255),
		surpresslightning = false, 
		AuxIronSightsPos = Vector (5.7431, -3, 3),
		AuxIronSightsAng = Vector (0.0634, -0.0235, -2),
		RRise = 0.003,
		RSlide = 0.0004,
		skin = 0, 
		bodygroup = {} 
	}
}

SWEP.Rails = {	
	["rail"] = { 
		type = "Model", 
		model = "models/weapons/rail.mdl", 
		bone = "v_weapon.M3_PARENT", 
		pos = Vector(0.02,3.9,3), 
		angle = Angle(-90, 0, 90), 
		size = 0.55--[[Vector(0.123, 0.123, 0.123)]],  
		color = Color(255, 255, 255, 255), 
		surpresslightning = false, 
		--material = "models/props_combine/metal_combinebridge001", 
		skin = 0, 
		bodygroup = {} 
		},
	["rail2"] = { 
		type = "Model", 
		model = "models/weapons/rail.mdl", 
		bone = "v_weapon.M3_PARENT", 
		pos = Vector(0.02,3.9,5.3), 
		angle = Angle(-90, 0, 90), 
		size = 0.55--[[Vector(0.123, 0.123, 0.123)]],  
		color = Color(255, 255, 255, 255), 
		surpresslightning = false, 
		--material = "models/props_combine/metal_combinebridge001", 
		skin = 0, 
		bodygroup = {} 
		}
	}
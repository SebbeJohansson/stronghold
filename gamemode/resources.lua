
Msg("Loading workshop items: \n")
local WorkshopItems = {
    1090312212
}
for k, v in pairs( WorkshopItems ) do
    Msg("Adding: "..v.."("..k..")\n")
    resource.AddWorkshop(v)
end


resource.AddFile( "sound/advert.wav" )
resource.AddFile( "sound/doormod_disrupted.wav" )
resource.AddFile( "sound/doormod_loop.wav" )
resource.AddFile( "sound/weldspark.wav" )

resource.AddFile( "materials/vgui/gradient-bl.vmt" )
resource.AddFile( "materials/vgui/gradient-bl.vtf" )
resource.AddFile( "materials/vgui/gradient-br.vmt" )
resource.AddFile( "materials/vgui/gradient-br.vtf" )
resource.AddFile( "materials/vgui/gradient-l.vmt" )

resource.AddFile( "materials/hudicons/c4.vmt" )
resource.AddFile( "materials/hudicons/c4.vtf" )
resource.AddFile( "materials/hudicons/fnade.vmt" )
resource.AddFile( "materials/hudicons/fnade.vtf" )
resource.AddFile( "materials/hudicons/health.vmt" )
resource.AddFile( "materials/hudicons/health.vtf" )
resource.AddFile( "materials/hudicons/health2.vmt" )
resource.AddFile( "materials/hudicons/health2.vtf" )
resource.AddFile( "materials/hudicons/henade.vmt" )
resource.AddFile( "materials/hudicons/henade.vtf" )
resource.AddFile( "materials/hudicons/shield.vmt" )
resource.AddFile( "materials/hudicons/shield.vtf" )
resource.AddFile( "materials/hudicons/snade.vmt" )
resource.AddFile( "materials/hudicons/snade.vtf" )

--ToolGun
resource.AddFile( "materials/tool/propspawn.vmt" )
resource.AddFile( "materials/tool/propspawn.vtf" )
resource.AddFile( "materials/tool/remover.vmt" )
resource.AddFile( "materials/tool/remover.vtf" )
resource.AddFile( "materials/tool/repair.vmt" )
resource.AddFile( "materials/tool/repair.vtf" )
resource.AddFile( "materials/tool/spawnpoint.vmt" )
resource.AddFile( "materials/tool/spawnpoint.vtf" )
resource.AddFile( "materials/tool/ammocrate_open.vmt" )
resource.AddFile( "materials/tool/ammocrate_open.vtf" )
resource.AddFile( "materials/tool/tool_radialbg.vmt" )
resource.AddFile( "materials/tool/tool_radialbg.vtf" )
resource.AddFile( "materials/tool/tool_radialselect.vmt" )
resource.AddFile( "materials/tool/tool_radialselect.vtf" )
resource.AddFile( "materials/tool/spawnpoint.vmt" )
resource.AddFile( "materials/tool/spawnpoint.vtf" )
resource.AddFile( "materials/tool/BG.vtf")
resource.AddFile( "materials/tool/BG.vmt")

--ToolGunScreen
resource.AddFile( "materials/tool/screen/weaponcrate.vtf")
resource.AddFile( "materials/tool/screen/weaponcrate.vmt")
resource.AddFile( "materials/tool/screen/propspawn.vtf")
resource.AddFile( "materials/tool/screen/propspawn.vmt")
resource.AddFile( "materials/tool/screen/repair.vtf")
resource.AddFile( "materials/tool/screen/repair.vmt")
resource.AddFile( "materials/tool/screen/remover.vtf")
resource.AddFile( "materials/tool/screen/remover.vmt")
resource.AddFile( "materials/tool/screen/mobilesp.vtf")
resource.AddFile( "materials/tool/screen/mobilesp.vmt")

resource.AddFile( "materials/blood/blood_spray.vmt" )
resource.AddFile( "materials/blood/blood_spray.vtf" )
resource.AddFile( "materials/blood/dying.vmt" )
resource.AddFile( "materials/blood/dying.vtf" )
resource.AddFile( "materials/blood/bsplatv1.vmt" )
resource.AddFile( "materials/blood/bsplatv1.vtf" )

resource.AddFile( "materials/scope/scope_normal.vmt" )
resource.AddFile( "materials/scope/scope_normal.vtf" )

resource.AddFile( "materials/scope/acog_reticle.vtf" )
resource.AddFile( "materials/scope/acog_reticle.vmt" )

resource.AddFile( "materials/scope/augret.vtf" )
resource.AddFile( "materials/scope/augret.vmt" )

resource.AddFile( "materials/doormod_blocked.vmt" )
resource.AddFile( "materials/doormod_unblocked.vmt" )

resource.AddFile( "materials/vignette.vmt" )
resource.AddFile( "materials/vignette.vtf" )

-- Explosion / Hit effects
resource.AddFile( "materials/refract_ring.vmt" )
resource.AddFile( "materials/refract_ring.vtf" )

resource.AddFile( "materials/effects/dust.vmt" )
resource.AddFile( "materials/effects/dust2.vmt" )
resource.AddFile( "materials/effects/dust.vtf" )
resource.AddFile( "materials/effects/dust2.vtf" )

-- Ammo Crate
resource.AddFile( "models/items/ammocrate_smg2.mdl" )
resource.AddFile( "materials/models/items/ammocrate_smg1.vmt" )
resource.AddFile( "materials/models/items/ammocrate_smg1.vtf" )
resource.AddFile( "materials/models/items/ammocrate_smg2.vmt" )
resource.AddFile( "materials/models/items/ammocrate_smg2.vtf" )

resource.AddFile( "models/weapons/v_slam.mdl" )
resource.AddFile( "models/weapons/w_slam.mdl" )

resource.AddFile( "sound/hit1.wav")
resource.AddFile( "sound/hit2.wav")
resource.AddFile( "sound/hit3.wav")

resource.AddFile( "sound/weapons/suppressed_pistol.wav")
resource.AddFile( "sound/weapons/suppressed_ar.wav")
resource.AddFile( "sound/weapons/suppressed_m4.wav")
resource.AddFile( "sound/weapons/suppressed_ak.wav")
resource.AddFile( "sound/weapons/suppressed_p90.wav")
resource.AddFile( "sound/weapons/suppressed_ump.wav")
resource.AddFile( "sound/weapons/suppressed_552.wav")
resource.AddFile( "sound/weapons/suppressed_usp.wav")

resource.AddFile( "sound/distantsound/ak.mp3")
resource.AddFile( "sound/distantsound/aug.mp3")
resource.AddFile( "sound/distantsound/awp.mp3")
resource.AddFile( "sound/distantsound/deagle.mp3")
resource.AddFile( "sound/distantsound/famas.mp3")
resource.AddFile( "sound/distantsound/fiveseven.mp3")
resource.AddFile( "sound/distantsound/g3sg1.mp3")
resource.AddFile( "sound/distantsound/galil.mp3")
resource.AddFile( "sound/distantsound/glock.mp3")
resource.AddFile( "sound/distantsound/m4.mp3")
resource.AddFile( "sound/distantsound/mac.mp3")
resource.AddFile( "sound/distantsound/mp5.mp3")
resource.AddFile( "sound/distantsound/p90.mp3")
resource.AddFile( "sound/distantsound/p228.mp3")
resource.AddFile( "sound/distantsound/scout.mp3")
resource.AddFile( "sound/distantsound/sg550.mp3")
resource.AddFile( "sound/distantsound/sg552.mp3")
resource.AddFile( "sound/distantsound/shotty.mp3")
resource.AddFile( "sound/distantsound/ump.mp3")
resource.AddFile( "sound/distantsound/pumpshot.mp3")
resource.AddFile( "materials/hitdetection2.vmt")
resource.AddFile( "materials/hitdetection2.vtf")
resource.AddFile( "resource/fonts/cs1.ttf" ) 

resource.AddFile( "materials/maps/noicon.vmt" )

resource.AddFile( "models/weapons/v_rc_m4a1.mdl" )
resource.AddFile( "models/weapons/v_rc_p90.mdl" )
resource.AddFile( "models/weapons/v_rc_g3sg1.mdl" )
resource.AddFile( "models/weapons/v_rc_galil.mdl" )
resource.AddFile( "models/weapons/v_rc_sg552.mdl" )
resource.AddFile( "models/weapons/v_rc_m249para.mdl" )
resource.AddFile( "models/weapons/v_rc_awp.mdl" )
resource.AddFile( "models/weapons/v_rc_scout.mdl" )
resource.AddFile( "models/weapons/v_rc_aug.mdl" )

resource.AddFile( "models/weapons/rail.mdl")
resource.AddFile( "models/weapons/rds.mdl")
resource.AddFile( "models/weapons/m145.mdl")
resource.AddFile( "models/weapons/akmount.mdl")
resource.AddFile( "models/weapons/suppressor.mdl")
resource.AddFile( "models/weapons/scope.mdl")
resource.AddFile( "models/weapons/mrds.mdl")
resource.AddFile( "models/weapons/augrail.mdl")
resource.AddFile( "models/weapons/irons.mdl")
resource.AddFile( "models/weapons/irons_f.mdl")

resource.AddFile( "materials/models/uplink/uplink.vmt" )
resource.AddFile( "materials/models/uplink/uplink.vtf" )
resource.AddFile( "materials/models/rail/rail.vmt" )
resource.AddFile( "materials/models/rail/rail.vtf" )
resource.AddFile( "materials/models/rds/rds.vmt" )
resource.AddFile( "materials/models/rds/rds.vtf" )
resource.AddFile( "materials/models/rds/rds_bmp.vtf" )
resource.AddFile( "materials/models/m145/m145.vmt" )
resource.AddFile( "materials/models/m145/m145.vtf" )
resource.AddFile( "materials/models/m145/m145_bmp.vtf" )
resource.AddFile( "materials/models/suppressor/suppressor.vmt" )
resource.AddFile( "materials/models/suppressor/suppressor.vtf" )
resource.AddFile( "materials/models/suppressor/suppressor_bmp.vtf" )
resource.AddFile( "materials/models/scope/scope.vtf" )
resource.AddFile( "materials/models/scope/scope.vmt" )
resource.AddFile( "materials/models/scope/scope_bmp.vtf" )
resource.AddFile( "materials/scope/m145_reticle.vtf" )
resource.AddFile( "materials/scope/m145_reticle.vmt" )
resource.AddFile( "materials/models/mrds/mrds.vtf" )
resource.AddFile( "materials/models/mrds/mrds_bmp.vtf" )
resource.AddFile( "materials/models/mrds/mrds.vmt" )
resource.AddFile( "materials/models/mrds/augrail.vtf" )
resource.AddFile( "materials/models/mrds/augrail_bmp.vtf" )
resource.AddFile( "materials/models/mrds/augrail.vmt" )
resource.AddFile( "materials/models/akmount/akmount.vtf" )
resource.AddFile( "materials/models/akmount/akmount_bmp.vtf" )
resource.AddFile( "materials/models/akmount/akmount.vmt" )

resource.AddFile( "materials/models/augrail/augrail.vmt" )
resource.AddFile( "materials/models/augrail/augrail.vtf" )
resource.AddFile( "materials/models/augrail/augrail_bmp.vtf" )
resource.AddFile( "materials/models/irons/irons.vtf" )
resource.AddFile( "materials/models/irons/irons_bmp.vtf" )
resource.AddFile( "materials/models/irons/irons.vmt" )

resource.AddFile( "materials/models/stronghold/dronebmp.vtf" )
resource.AddFile( "materials/models/stronghold/dronemat.vtf" )
resource.AddFile( "materials/models/stronghold/dronemat.vmt" )
resource.AddFile( "models/stronghold/drone.mdl" )

resource.AddFile( "sound/stronghold/uav/uav_AB.wav" )
resource.AddFile( "sound/stronghold/snap.mp3" )
resource.AddFile( "sound/stronghold/whiz.mp3" )
resource.AddFile( "resource/fonts/KazmannSans.ttf" )

resource.AddFile( "particles/muzzle.pcf" )

resource.AddFile( "materials/stronghold/cowbody.vtf" )
resource.AddFile( "materials/stronghold/cowbody.vmt" )
resource.AddFile( "materials/stronghold/cowhead.vtf" )
resource.AddFile( "materials/stronghold/cowhead.vmt" )
resource.AddFile( "materials/stronghold/cowblink.vtf" )
resource.AddFile( "materials/stronghold/cowblink.vmt" )




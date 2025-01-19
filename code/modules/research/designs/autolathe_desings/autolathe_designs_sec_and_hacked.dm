///////////////////////////////////
//////////Autolathe Designs ///////
///////////////////////////////////
/////////////
////Secgear//
/////////////

/datum/design/beanbag_slug
	name = "Beanbag Slug"
	id = "beanbag_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 250)
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/ammo_casing/shotgun/beanbag
	category = list("initial", "Security")

/datum/design/rubbershot
	name = "Rubber Shot"
	id = "rubber_shot"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/rubbershot
	category = list("initial", "Security")

/datum/design/c38
	name = "Speed Loader (.38 rubber)"
	id = "c38"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 20000)
	build_path = /obj/item/ammo_box/c38
	category = list("initial", "Security")

/////////////////
///Hacked Gear //
/////////////////

/datum/design/large_welding_tool
	name = "Industrial Welding Tool"
	id = "large_welding_tool"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 70, /datum/material/glass = 60)
	build_path = /obj/item/weldingtool/largetank
	category = list("hacked", "Tools")

/datum/design/flamethrower
	name = "Flamethrower"
	id = "flamethrower"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/flamethrower/full
	category = list("hacked", "Security")

/datum/design/rcd
	name = "Rapid Construction Device (RCD)"
	id = "rcd"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/construction/rcd
	category = list("hacked", "Construction")

/datum/design/rpd_autolathe
	name = "Rapid Pipe Dispenser (RPD)"
	id = "rpd_autolathe"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 75000, /datum/material/glass = 37500)
	build_path = /obj/item/pipe_dispenser
	category = list("hacked", "Construction")

/datum/design/handcuffs
	name = "Handcuffs"
	id = "handcuffs"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/restraints/handcuffs
	category = list("hacked", "Security")

/datum/design/reciever
	name = "Modular Receiver"
	id = "modular_receiver"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 24000)
	build_path = /obj/item/weaponcrafting/receiver
	category = list("hacked", "Security")

/datum/design/shotgun_slug
	name = "Shotgun Slug"
	id = "shotgun_slug"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun
	category = list("hacked", "Security")

/datum/design/buckshot_shell
	name = "Buckshot Shell"
	id = "buckshot_shell"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/buckshot
	category = list("hacked", "Security")

/datum/design/shotgun_dart
	name = "Shotgun Dart"
	id = "shotgun_dart"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/dart
	category = list("hacked", "Security")

/datum/design/incendiary_slug
	name = "Incendiary Slug"
	id = "incendiary_slug"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/incendiary
	category = list("hacked", "Security")

/////////////////
//   Bullets   //
/////////////////

/datum/design/riot_dart
	name = "Foam Riot Dart"
	id = "riot_dart"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 1125) //Discount for making individually - no box = less metal!
	build_path = /obj/item/ammo_casing/caseless/foam_dart/riot
	category = list("hacked", "Security")

/datum/design/riot_darts
	name = "Foam Riot Dart Box"
	id = "riot_darts"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 50000) //Comes with 40 darts
	build_path = /obj/item/ammo_box/foambox/riot
	category = list("hacked", "Security")

/datum/design/a357
	name = "Revolver Bullet (.357)"
	id = "a357"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/a357
	category = list("hacked", "Security")

/datum/design/a762
	name = "Rifle Bullet (7.62mm)"
	id = "a762"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 5000) //need seclathe for clips
	build_path = /obj/item/ammo_casing/a762
	category = list("hacked", "Security")

/datum/design/c10mm
	name = "Ammo Box (10mm)"
	id = "c10mm"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/ammo_box/c10mm
	category = list("hacked", "Security")

/datum/design/c45
	name = "Ammo Box (.45)"
	id = "c45"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/ammo_box/c45
	category = list("hacked", "Security")

/datum/design/c9mm
	name = "Ammo Box (9mm)"
	id = "c9mm"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/ammo_box/c9mm
	category = list("hacked", "Security")

/datum/design/electropack
	name = "Electropack"
	id = "electropack"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 2500)
	build_path = /obj/item/electropack
	category = list("hacked", "Security")

/datum/design/cleaver
	name = "Butcher's Cleaver"
	id = "cleaver"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 18000)
	build_path = /obj/item/kitchen/knife/butcher
	category = list("hacked", "Dinnerware")

/datum/design/foilhat
	name = "Tinfoil Hat"
	id = "tinfoil_hat"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 5500)
	build_path = /obj/item/clothing/head/foilhat
	category = list("hacked", "Misc")


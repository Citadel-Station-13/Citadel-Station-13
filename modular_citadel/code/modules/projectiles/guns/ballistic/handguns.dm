
///foam stealth pistol///

/obj/item/gun/ballistic/automatic/toy/pistol/stealth
	name = "foam force stealth pistol"
	desc = "A small, easily concealable toy bullpup handgun. Ages 8 and up."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "foamsp"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	can_suppress = FALSE
	fire_sound = 'sound/weapons/gunshot_silenced.ogg'
	suppressed = TRUE
	burst_size = 1
	fire_delay = 0
	spread = 20
	actions_types = list()

/obj/item/gun/ballistic/automatic/toy/pistol/stealth/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("foamsp-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/////////RAYGUN MEMES/////////

/obj/item/projectile/beam/lasertag/ray		//the projectile, compatible with regular laser tag armor
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "ray"
	name = "ray bolt"
	eyeblur = 0

/obj/item/ammo_casing/energy/laser/raytag
	projectile_type = /obj/item/projectile/beam/lasertag/ray
	select_name = "raytag"
	fire_sound = 'sound/weapons/raygun.ogg'

/obj/item/gun/energy/laser/practice/raygun
	name = "toy ray gun"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "raygun"
	desc = "A toy laser with a classic, retro feel and look. Compatible with existing laser tag systems."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/raytag)
	selfcharge = EGUN_SELFCHARGE

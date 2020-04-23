/obj/item/ammo_casing/caseless/magspear
	name = "magnetic spear"
	desc = "A reusable spear that is typically loaded into kinetic spearguns."
	projectile_type = /obj/item/projectile/bullet/reusable/magspear
	caliber = "speargun"
	icon_state = "magspear"
	throwforce = 15 //still deadly when thrown
	throw_speed = 3

/obj/item/ammo_casing/caseless/laser
	name = "laser casing"
	desc = "You shouldn't be seeing this."
	caliber = "laser"
	icon_state = "s-casing-live"
	projectile_type = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/laser.ogg'
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/energy

/obj/item/ammo_casing/caseless/laser/gatling
	projectile_type = /obj/item/projectile/beam/weak/penetrator
	variance = 0.8
	click_cooldown_override = 1

//flechettes


/obj/item/ammo_casing/caseless/flechetteap
	name = "flechette (armor piercing)"
	desc = "A flechette made with a tungsten alloy."
	projectile_type = /obj/item/projectile/bullet/cflechetteap
	caliber = "flechette"
	throwforce = 1
	throw_speed = 3

/obj/item/ammo_casing/caseless/flechettes
	name = "flechette (serrated)"
	desc = "A serrated flechette made of a special alloy intended to deform drastically upon penetration of human flesh."
	projectile_type = /obj/item/projectile/bullet/cflechettes
	caliber = "flechette"
	throwforce = 2
	throw_speed = 3
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 40, "embedded_fall_chance" = 10)

/obj/item/ammo_casing/caseless/flechetteshredder
	name = "flechette (shredder)"
	desc = "A serrated flechette made of a special alloy that forms a monofilament edge."
	projectile_type = /obj/item/projectile/bullet/cflechettes

//spinfusor

/obj/item/ammo_casing/caseless/spinfusor
	name = "spinfusor disk"
	desc = "A magnetic disk designed specifically for the Stormhammer magnetic cannon. Packs a punch."
	projectile_type = /obj/item/projectile/bullet/spinfusor
	caliber = "spinfusor"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "disk"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 15 //still deadly when thrown
	force = 5
	throw_speed = 3
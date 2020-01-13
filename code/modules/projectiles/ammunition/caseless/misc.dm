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

/obj/item/ammo_casing/caseless/laser/heavy
	name = "heavy laser casing"
	projectile_type = /obj/item/projectile/beam/laser/heavylaser

/obj/item/ammo_casing/caseless/laser/weak
	name = "weak laser casing"
	projectile_type = /obj/item/projectile/beam/weak

/obj/item/ammo_casing/caseless/laser/weak/ap
	name = "weak penetrator laser casing"
	projectile_type = /obj/item/projectile/beam/weak/penetrator

/obj/item/ammo_casing/caseless/laser/disabler
	name = "disabler laser casing"
	projectile_type = /obj/item/projectile/beam/disabler

/obj/item/ammo_casing/caseless/laser/disabler/weak
	name = "weak disabler laser casing"
	projectile_type = /obj/item/projectile/beam/disabler/weak

/obj/item/ammo_casing/caseless/laser/pulse
	name = "pulse laser casing"
	projectile_type = /obj/item/projectile/beam/pulse

/obj/item/ammo_casing/caseless/laser/xray
	name = "xray laser casing"
	projectile_type = /obj/item/projectile/beam/xray

/obj/item/ammo_casing/caseless/laser/gatling
	projectile_type = /obj/item/projectile/beam/weak/penetrator
	variance = 0.8
	click_cooldown_override = 1

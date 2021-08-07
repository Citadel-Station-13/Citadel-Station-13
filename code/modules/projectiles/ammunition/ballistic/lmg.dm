// 1.95x129mm (SAW)

/obj/item/ammo_casing/mm195x129
	name = "1.95x129mm bullet casing"
	desc = "A 1.95x129mm bullet casing."
	icon_state = "762-casing"
	caliber = "mm195129"
	projectile_type = /obj/item/projectile/bullet/mm195x129

/obj/item/ammo_casing/mm195x129/ap
	name = "1.95x129mm armor-piercing bullet casing"
	desc = "A 1.95x129mm bullet casing designed with a hardened-tipped core to help penetrate armored targets."
	projectile_type = /obj/item/projectile/bullet/mm195x129_ap

/obj/item/ammo_casing/mm195x129/hollow
	name = "1.95x129mm hollow-point bullet casing"
	desc = "A 1.95x129mm bullet casing designed to cause more damage to unarmored targets."
	projectile_type = /obj/item/projectile/bullet/mm195x129_hp

/obj/item/ammo_casing/mm195x129/incen
	name = "1.95x129mm incendiary bullet casing"
	desc = "A 1.95x129mm bullet casing designed with a chemical-filled capsule on the tip that when bursted, reacts with the atmosphere to produce a fireball, engulfing the target in flames."
	projectile_type = /obj/item/projectile/bullet/incendiary/mm195x129

/obj/item/ammo_casing/mm712x82/match
	name = "7.12x82mm match bullet casing"
	desc = "A 7.12x82mm bullet casing manufactured to unfailingly high standards, you could pull off some cool trickshots with this."
	projectile_type = /obj/item/projectile/bullet/mm712x82_match

/obj/item/projectile/bullet/mm712x82_match
	name = "7.12x82mm match bullet"
	damage = 40
	ricochets_max = 2
	ricochet_chance = 60
	ricochet_auto_aim_range = 4
	ricochet_incidence_leeway = 35

// C3D (Borgs)

/obj/item/projectile/bullet/c3d
	damage = 20

// Mech LMG

/obj/item/projectile/bullet/lmg
	damage = 20

// Mech FNX-99

/obj/item/projectile/bullet/incendiary/fnx99
	damage = 20

// Turrets

/obj/item/projectile/bullet/manned_turret
	damage = 20

/obj/item/projectile/bullet/syndicate_turret
	damage = 20

// 1.95x129mm (SAW)

/obj/item/projectile/bullet/mm195x129
	name = "1.95x129mm bullet"
	damage = 40
	armour_penetration = 5
	wound_bonus = -50
	wound_falloff_tile = 0

/obj/item/projectile/bullet/mm195x129_ap
	name = "1.95x129mm armor-piercing bullet"
	damage = 40
	armour_penetration = 75

/obj/item/projectile/bullet/mm195x129_hp
	name = "1.95x129mm hollow-point bullet"
	damage = 50
	armour_penetration = -60
	sharpness = SHARP_EDGED
	wound_bonus = -40
	bare_wound_bonus = 30
	wound_falloff_tile = -8

/obj/item/projectile/bullet/incendiary/mm195x129
	name = "1.95x129mm incendiary bullet"
	damage = 20
	fire_stacks = 3

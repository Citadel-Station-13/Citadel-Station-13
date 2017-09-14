obj/item/projectile/energy/plasmabolt
	icon = 'icons/obj/VGProjectile.dmi'
	name = "plasma bolt"
	icon_state = "plasma"
	knockdown = 0
	flag = "energy"
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	light_range = 3
	light_color = LIGHT_COLOR_GREEN

/obj/item/projectile/energy/plasmabolt/light
	damage = 35
	icon_state = "plasma2"
	irradiate = 20
	stamina = 60

/obj/item/projectile/energy/plasmabolt/rifle
	damage = 50
	icon_state = "plasma3"
	irradiate = 35
	stamina = 120

/obj/item/projectile/energy/plasmabolt/MP40k
	damage = 35
	eyeblur = 4
	irradiate = 25
	stamina = 100
	icon_state = "plasma3"
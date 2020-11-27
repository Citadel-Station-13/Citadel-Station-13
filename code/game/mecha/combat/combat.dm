/obj/mecha/combat
	force = 30
	internal_damage_threshold = 50
	armor = list("melee" = 30, "bullet" = 30, "laser" = 15, "energy" = 20, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	mouse_pointer = 'icons/mecha/mecha_mouse.dmi'

/obj/mecha/combat/proc/max_ammo() //Max the ammo stored for Nuke Ops mechs, or anyone else that calls this
	for(var/obj/item/I in equipment)
		if(istype(I, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/))
			var/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gun = I
			gun.projectiles_cache = gun.projectiles_cache_max

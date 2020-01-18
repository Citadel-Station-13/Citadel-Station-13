/obj/mecha/combat
	force = 30
	internal_damage_threshold = 50
	armor = list("melee" = 30, "bullet" = 30, "laser" = 15, "energy" = 20, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	mouse_pointer = 'icons/mecha/mecha_mouse.dmi'
	var/spawn_tracked = TRUE

/obj/mecha/combat/Initialize()
	. = ..()
	if(spawn_tracked)
		trackers += new /obj/item/mecha_parts/mecha_tracking(src)
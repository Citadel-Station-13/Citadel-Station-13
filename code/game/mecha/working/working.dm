<<<<<<< HEAD
/obj/mecha/working
	internal_damage_threshold = 60

/obj/mecha/working/New()
	..()
	trackers += new /obj/item/mecha_parts/mecha_tracking(src)
=======
/obj/mecha/working
	internal_damage_threshold = 60

/obj/mecha/working/Initialize()
	. = ..()
	trackers += new /obj/item/mecha_parts/mecha_tracking(src)
>>>>>>> abf3f76... Converts /mecha + extras to Initialize (#34985)

/obj/item/deathbox
	name = "crush box"
	desc = "A box that crushes anything put in it when activated."
	var/cooldown = 0
	var/toggled = TRUE

/obj/item/deathbox/attack_self(mob/user)
	..()
	for (var/i in contents)
		qdel(i)
	qdel(src)

/obj/item/deathbox/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
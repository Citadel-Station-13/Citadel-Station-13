/obj/item/deathbox
	name = "crush box"
	desc = "A box that crushes anything put in it when activated."
	icon = 'icons/obj/device.dmi'
	icon_state = "deathbox"
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	var/cooldown = 0
	var/toggled = TRUE
	var/currentweight = 0

/obj/item/deathbox/attack_self(mob/user)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if (toggled)
		if (cooldown > world.time)
			to_chat(user,"<span class='warning'>The box cannot be reformed yet!</span>")
			return
		for (var/obj/item/i in contents)
			if (LAZYLEN(i.contents))
				to_chat(user,"<span class='warning'>You cannot crush something with something inside it!</span>")
				return
			var/obj/o = new /obj/effect/decal/cleanable/shreds(get_turf(src))
			o.desc = "The shredded remains of [i]."
			qdel(i)
		STR.max_items = 0
		icon_state = "[initial(icon_state)]sheet"
		name = "[initial(name)] sheet"
		desc = "A sheet that can be formed into a crush box."
		cooldown = world.time + 2 MINUTES
		w_class = WEIGHT_CLASS_TINY
	else
		icon_state = initial(icon_state)
		name = initial(name)
		desc = initial(desc)
		STR.max_items = 1
		w_class = WEIGHT_CLASS_NORMAL
	toggled = !toggled
	. = ..()

/obj/item/deathbox/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
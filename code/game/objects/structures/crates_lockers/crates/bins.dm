/obj/structure/closet/crate/bin
	desc = "A trash bin, place your trash here for the janitor to collect."
	name = "trash bin"
	icon_state = "largebins"
	open_sound = 'sound/effects/bin_open.ogg'
	close_sound = 'sound/effects/bin_close.ogg'
	material_drop = /obj/item/stack/sheet/metal
	material_drop_amount = 10
	anchored = TRUE
	horizontal = FALSE
	delivery_icon = null

/obj/structure/closet/crate/bin/New()
	..()
	update_icon()

/obj/structure/closet/crate/bin/closet_update_overlays(list/new_overlays)
	. = new_overlays
	cut_overlays()
	if(contents.len == 0)
		. += "largebing"
	else if(contents.len >= storage_capacity)
		. += "largebinr"
	else
		. += "largebino"

/obj/structure/closet/crate/bin/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/storage/bag/trash))
		var/obj/item/storage/bag/trash/T = W
		to_chat(user, "<span class='notice'>You fill the bag.</span>")
		for(var/obj/item/O in src)
			SEND_SIGNAL(T, COMSIG_TRY_STORAGE_INSERT, O, user, TRUE)
		T.update_icon()
		do_animate()
		return TRUE
	else
		return ..()

/obj/structure/closet/crate/bin/proc/do_animate()
	playsound(loc, open_sound, 15, 1, -3)
	flick("animate_largebins", src)
	spawn(13)
		playsound(loc, close_sound, 15, 1, -3)
		update_icon()

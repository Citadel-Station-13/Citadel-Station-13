//Bob underwear system. Epic.
/obj/item/clothing/underwear
	name = "Underwear"
	desc = "If you're reading this, something went wrong."
	icon = 'icons/mob/clothing/underwear.dmi' //if someone is willing to make proper inventory sprites that'd be very cash money
	mob_overlay_icon = 'icons/mob/clothing/underwear.dmi'
	anthro_mob_worn_overlay = 'icons/mob/clothing/underwear_digi.dmi'
	body_parts_covered = GROIN
	permeability_coefficient = 0.9
	block_priority = BLOCK_PRIORITY_UNDERWEAR
	slot_flags = ITEM_SLOT_UNDERWEAR
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	mutantrace_variation = STYLE_NO_ANTHRO_ICON
	var/list/appended = list()
	var/max_append = 3 //Maximum possible amount of appended underwear
	var/mutable_appearance/attached_overlay //overlay we display instead of the icon.
	//the reason we do this dumb, egregious stuff is for colors to show up proper, without affecting appended clothing.
	var/overlay_color = "#FFFFFF"
	var/under_type = /obj/item/clothing/underwear
	var/fitted = NO_FEMALE_UNIFORM
	var/dummy_thick = FALSE
	var/has_colors = TRUE
	var/list/pos_genders = list(MALE, FEMALE)

/obj/item/clothing/underwear/Initialize()
	. = ..()
	icon = null //this is awful
	update_icon()

/obj/item/clothing/underwear/update_icon()
	. = ..()
	update_overlays()

/obj/item/clothing/underwear/update_overlays()
	. = ..()
	cut_overlays()
	attached_overlay = mutable_appearance(initial(icon), icon_state, FLOAT_LAYER, FLOAT_PLANE, overlay_color)
	add_overlay(attached_overlay)
	for(var/obj/item/clothing/underwear/U in appended)
		add_overlay(U.attached_overlay)

/obj/item/clothing/underwear/examine(mob/user)
	. = ..()
	if(appended.len)
		for(var/obj/item/clothing/underwear/und in appended)
			. += "<span class='notice'>It has \the <b>[und]</b> appended.</span>"
	else
		. += "<span class='notice'>It has no other underwear appended.</span>"

/obj/item/clothing/underwear/attackby(obj/item/I, mob/user, params)
	if(!attach_underwear(I, user))
		return ..()

/obj/item/clothing/underwear/AltClick(mob/user)
	. = ..()
	if(appended.len)
		var/list/options = list()
		for(var/obj/item/clothing/underwear/U in appended)
			options[U.name] = U
		var/choose = input(user, "What underwear do you want to remove?", "Remove underwear", null) as anything in options
		if(choose)
			unattach_underwear(options[choose], user)

/obj/item/clothing/underwear/proc/attach_underwear(var/obj/item/clothing/underwear/U, var/mob/user)
	. = FALSE
	if(U && istype(U) && !istype(U, under_type) && (appended.len < max_append))
		if(U.appended.len)
			for(var/obj/item/clothing/underwear/und in U.appended)
				U.unattach_underwear(und)
				if(!attach_underwear(und))
					if(user)
						to_chat(user, "<span class='warning'>\The [und] can't be appended to \the [src].")
					und.forceMove(get_turf(src))
		appended += U
		add_overlay(U.attached_overlay)
		U.forceMove(src)
		body_parts_covered = initial(body_parts_covered)
		for(var/obj/item/clothing/underwear/W in appended)
			body_parts_covered |= initial(W.body_parts_covered)
		U.on_attached(src, user)
		if(user)
			to_chat(user, "<span class='notice'>You append \the [U] to \the [src].")
		U.update_icon()
		update_icon()
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_w_underwear()
		return TRUE
	else
		if(user)
			to_chat(user, "<span class='warning'>\The [U] can't be appended to \the [src].")

/obj/item/clothing/underwear/proc/on_attached(var/obj/item/clothing/underwear/U, var/mob/user) //special stuff to do on being attached to other underwear. does nothing by default.
	return

/obj/item/clothing/underwear/proc/unattach_underwear(var/obj/item/clothing/underwear/U, var/mob/user)
	. = FALSE
	if(U && istype(U))
		cut_overlay(U.attached_overlay)
		appended -= U
		U.on_unattached(src, user)
		body_parts_covered = initial(body_parts_covered)
		for(var/obj/item/clothing/underwear/W in appended)
			body_parts_covered |= initial(W.body_parts_covered)
		var/mob/living/carbon/C = user
		if(C && istype(C))
			if(!C.put_in_active_hand(U))
				U.forceMove(get_turf(src))
		else
			U.forceMove(get_turf(src))
		if(user)
			to_chat(user, "<span class='notice'>You take \the [U] off from \the [src].")
		U.update_icon()
		update_icon()
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_w_underwear()
		return TRUE

/obj/item/clothing/underwear/proc/on_unattached(var/obj/item/clothing/underwear/U, var/mob/user) //special stuff to do on being unattached from other underwear. does nothing by default.
	return

/obj/item/clothing/underwear/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(isinhands)
		return
	. += mutable_appearance(icon_file, icon_state, FLOAT_LAYER, FLOAT_PLANE, overlay_color)
	if(appended.len)
		for(var/obj/item/clothing/underwear/append in appended)
			if((icon_file == anthro_mob_worn_overlay) && (append.mutantrace_variation & (STYLE_DIGITIGRADE || STYLE_MUZZLE)))
				. += mutable_appearance(append.anthro_mob_worn_overlay, append.icon_state, FLOAT_LAYER, FLOAT_PLANE, append.overlay_color)
			else
				. += mutable_appearance(append.mob_overlay_icon, append.icon_state, FLOAT_LAYER, FLOAT_PLANE, append.overlay_color)
	if(damaged_clothes) //someone will make damaged underwear sprites... eventually... right?
		. += mutable_appearance('icons/effects/item_damage.dmi', "damageduniform")
	if(blood_DNA) //same thing here maybe
		. += mutable_appearance('icons/effects/blood.dmi', "uniformblood", color = blood_DNA_to_color())

/obj/item/clothing/underwear/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_w_underwear()

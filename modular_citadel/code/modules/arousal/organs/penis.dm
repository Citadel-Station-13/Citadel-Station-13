/obj/item/organ/genital/penis
	name 					= "penis"
	desc 					= "A male reproductive organ."
	icon_state 				= "penis"
	icon 					= 'modular_citadel/icons/obj/genitals/penis.dmi'
	zone 					= "groin"
	slot 					= "penis"
	w_class 				= 3
	can_masturbate_with 	= TRUE
	masturbation_verb 		= "stroke"
	can_climax 				= TRUE
	fluid_transfer_factor = 0.5
	size 					= 2 //arbitrary value derived from length and girth for sprites.
	var/length 				= 6	//inches
	var/cached_length //used to detect a change in length
	var/girth  				= 0
	var/girth_ratio 		= COCK_GIRTH_RATIO_DEF //0.73; check citadel_defines.dm
	var/knot_girth_ratio 	= KNOT_GIRTH_RATIO_DEF
	var/list/dickflags 		= list()
	var/list/knotted_types 	= list("knotted", "barbed, knotted")
	var/statuscheck			= FALSE
	var/prev_size			= 6


/obj/item/organ/genital/penis/update_size()
	var/mob/living/carbon/human/o = owner
	if(cached_length < 0)//I don't actually know what round() does to negative numbers, so to be safe!!
		var/obj/item/organ/genital/penis/P = o.getorganslot("penis")
		to_chat(o, "<span class='warning'>You feel your tallywacker shrinking away from your body as your groin flattens out!</b></span>")
		P.Remove(o)
	switch(round(cached_length))
		if(0 to 4) //If modest size
			length = cached_length
			size = 1
			if(statuscheck == TRUE)
				message_admins("Attempting to remove.")
				o.remove_status_effect(/datum/status_effect/chem/PElarger)
				statuscheck = FALSE
		if(5 to 8) //If modest size
			length = cached_length
			size = 2
			if(statuscheck == TRUE)
				message_admins("Attempting to remove.")
				o.remove_status_effect(/datum/status_effect/chem/PElarger)
				statuscheck = FALSE
		if(9 to INFINITY) //If massive
			length = cached_length
			size = 3 //no new sprites for anything larger yet
			if(statuscheck == FALSE)
				message_admins("Attempting to apply.")
				o.apply_status_effect(/datum/status_effect/chem/PElarger)
				statuscheck = TRUE
	message_admins("Pinas size: [size], [cached_length], [o]")
	message_admins("2. size vs prev_size")
	if (round(length) > round(prev_size))
		to_chat(o, "<span class='warning'>Your [pick("phallus", "willy", "dick", "prick", "member", "tool", "gentleman's organ", "cock", "wang", "knob", "dong", "joystick", "pecker", "johnson", "weenie", "tadger", "schlong", "thirsty ferret", "baloney pony", "schlanger")] [pick("swells up to", "flourishes into", "expands into", "bursts forth into", "grows eagerly into", "amplifys into")] a [uppertext(size)] inch penis.</b></span>")
	else if (round(length) < round(prev_size))
		to_chat(o, "<span class='warning'>Your [pick("phallus", "willy", "dick", "prick", "member", "tool", "gentleman's organ", "cock", "wang", "knob", "dong", "joystick", "pecker", "johnson", "weenie", "tadger", "schlong", "thirsty ferret", "baloney pony", "schlanger")] [pick("shrinks down to", "decreases into", "diminishes into", "deflates into", "shrivels regretfully into", "contracts into")] a [uppertext(size)] inch penis.</b></span>")
	prev_size = length
	icon_state = sanitize_text("penis_[shape]_[size]")
	//update_body()
	//P.update_icon()  //Either of these don't work, why???
	girth = (length * girth_ratio)

/obj/item/organ/genital/penis/update_appearance()
	//var/mob/living/carbon/o = owner
	var/string = "penis_[GLOB.cock_shapes_icons[shape]]_[size]"
	icon_state = sanitize_text(string)
	var/lowershape = lowertext(shape)
	desc = "You see a [lowershape] penis. You estimate it's about [round(length, 0.25)] inch[length > 1 ? "es" : ""] long."
	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
		else
			color = "#[owner.dna.features["cock_color"]]"
	owner.update_body()

/obj/item/organ/genital/penis/update_link()
	if(owner)
		linked_organ = (owner.getorganslot("testicles"))
		if(linked_organ)
			linked_organ.linked_organ = src
	else
		if(linked_organ)
			linked_organ.linked_organ = null
		linked_organ = null

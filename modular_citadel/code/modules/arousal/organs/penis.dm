/obj/item/organ/genital/penis
	name 					= "penis"
	desc 					= "A male reproductive organ."
	icon_state 				= "penis"
	icon 					= 'modular_citadel/icons/obj/genitals/penis.dmi'
	zone 					= "groin"
	slot 					= ORGAN_SLOT_PENIS
	can_masturbate_with 	= TRUE
	masturbation_verb 		= "stroke"
	can_climax 				= TRUE
	fluid_transfer_factor	= 0.5
	size 					= 2 //arbitrary value derived from length and girth for sprites.
	var/length 				= 6	//inches
	var/cached_length			//used to detect a change in length
	var/girth  				= 4.38
	var/girth_ratio 		= COCK_GIRTH_RATIO_DEF //0.73; check citadel_defines.dm
	var/knot_girth_ratio 	= KNOT_GIRTH_RATIO_DEF
	var/list/dickflags 		= list()
	var/list/knotted_types 	= list("knotted", "barbed, knotted")
	var/prev_length			= 6 //really should be renamed to prev_length

/obj/item/organ/genital/penis/Initialize()
	. = ..()
	/* I hate genitals.*/

/obj/item/organ/genital/penis/update_size()
	var/mob/living/carbon/human/o = owner
	if(!ishuman(o) || !o)
		return
	if(cached_length < 0)//I don't actually know what round() does to negative numbers, so to be safe!!
		var/obj/item/organ/genital/penis/P = o.getorganslot("penis")
		to_chat(o, "<span class='warning'>You feel your tallywacker shrinking away from your body as your groin flattens out!</b></span>")
		P.Remove(o)
	switch(round(cached_length))
		if(0 to 4) //If modest size
			length = cached_length
			size = 1
			if(owner.has_status_effect(/datum/status_effect/chem/penis_enlarger))
				o.remove_status_effect(/datum/status_effect/chem/penis_enlarger)
		if(5 to 10) //If modest size
			length = cached_length
			size = 2
			if(owner.has_status_effect(/datum/status_effect/chem/penis_enlarger))
				o.remove_status_effect(/datum/status_effect/chem/penis_enlarger)
		if(11 to 20) //If massive
			length = cached_length
			size = 3
			if(owner.has_status_effect(/datum/status_effect/chem/penis_enlarger))
				o.remove_status_effect(/datum/status_effect/chem/penis_enlarger)
		if(21 to 35) //If massive and due for large effects
			length = cached_length
			size = 3
			if(!owner.has_status_effect(/datum/status_effect/chem/penis_enlarger))
				o.apply_status_effect(/datum/status_effect/chem/penis_enlarger)
		if(36 to INFINITY) //If comical
			length = cached_length
			size = 4 //no new sprites for anything larger yet
			if(!owner.has_status_effect(/datum/status_effect/chem/penis_enlarger))
				o.apply_status_effect(/datum/status_effect/chem/penis_enlarger)

	if (round(length) > round(prev_length))
		to_chat(o, "<span class='warning'>Your [pick(GLOB.gentlemans_organ_names)] [pick("swells up to", "flourishes into", "expands into", "bursts forth into", "grows eagerly into", "amplifys into")] a [uppertext(round(length))] inch penis.</b></span>")
	else if ((round(length) < round(prev_length)) && (length > 0.5))
		to_chat(o, "<span class='warning'>Your [pick(GLOB.gentlemans_organ_names)] [pick("shrinks down to", "decreases into", "diminishes into", "deflates into", "shrivels regretfully into", "contracts into")] a [uppertext(round(length))] inch penis.</b></span>")
	prev_length = length
	icon_state = sanitize_text("penis_[shape]_[size]")
	girth = (length * girth_ratio)//Is it just me or is this ludicous, why not make it exponentially decay?

	//I have no idea on how to update sprites and I hate it

/obj/item/organ/genital/penis/update_appearance()
	var/string
	var/lowershape = lowertext(shape)
	desc = "You see [aroused_state ? "an erect" : "a flaccid"] [lowershape] penis. You estimate it's about [round(length, 0.25)] inch[round(length, 0.25) != 1 ? "es" : ""] long and [round(girth, 0.25)] inch[round(girth, 0.25) != 1 ? "es" : ""] in girth."

	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
				string = "penis_[GLOB.cock_shapes_icons[shape]]_[size]-s"
		else
			color = "#[owner.dna.features["cock_color"]]"
			string = "penis_[GLOB.cock_shapes_icons[shape]]_[size]"
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			icon_state = sanitize_text(string)
			H.update_genitals()

/obj/item/organ/genital/penis/update_link()
	if(owner)
		linked_organ = (owner.getorganslot("testicles"))
		if(linked_organ)
			linked_organ.linked_organ = src
			linked_organ.size = size
	else
		if(linked_organ)
			linked_organ.linked_organ = null
		linked_organ = null

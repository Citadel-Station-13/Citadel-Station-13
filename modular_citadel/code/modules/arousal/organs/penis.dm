/obj/item/organ/genital/penis
	name = "penis"
	desc = "A male reproductive organ."
	icon_state = "penis"
	icon = 'modular_citadel/icons/obj/genitals/penis.dmi'
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS
	masturbation_verb = "stroke"
	genital_flags = CAN_MASTURBATE_WITH|CAN_CLIMAX_WITH
	fluid_transfer_factor = 0.5
	size = 2 //arbitrary value derived from length and girth for sprites.
	layer_index = PENIS_LAYER_INDEX
	var/length = 6 //inches
	var/prev_length = 6 //really should be renamed to prev_length
	var/cached_length //used to detect a change in length
	var/girth = 4.38
	var/girth_ratio = COCK_GIRTH_RATIO_DEF //0.73; check citadel_defines.dm
	var/knot_girth_ratio = KNOT_GIRTH_RATIO_DEF
	var/list/knotted_types = list("knotted", "barbed, knotted")

/obj/item/organ/genital/penis/update_size()
	if(cached_length == length)
		return
	if(cached_length < 0)//I don't actually know what round() does to negative numbers, so to be safe!!
		if(owner)
			to_chat(owner, "<span class='warning'>You feel your tallywacker shrinking away from your body as your groin flattens out!</b></span>")
		QDEL_IN(src, 1)
		if(linked_organ)
			QDEL_IN(linked_organ, 1)
		return
	var/new_size
	var/enlargement = FALSE
	switch(round(cached_length))
		if(0 to 6.99) //If modest size
			new_size = 1
		if(7 to 10.99) //If large
			size = 2
		if(11 to 19.99) //If massive
			size = 3
		if(20 to 34.99) //If massive and due for large effects
			size = 3
			enlargement = TRUE
		if(35 to INFINITY) //If comical
			size = 4 //no new sprites for anything larger yet
			enlargement = TRUE
	length = cached_length
	if(owner)
		var/status_effect = owner.has_status_effect(/datum/status_effect/chem/penis_enlarger)
		if(enlargement && !status_effect)
			owner.apply_status_effect(/datum/status_effect/chem/penis_enlarger)
		else if(status_effect)
			owner.remove_status_effect(/datum/status_effect/chem/penis_enlarger)
	if(linked_organ)
		linked_organ.update_size(new_size - size)
	size = new_size

	if(owner)
		if (round(length) > round(prev_length))
			to_chat(owner, "<span class='warning'>Your [pick(GLOB.gentlemans_organ_names)] [pick("swells up to", "flourishes into", "expands into", "bursts forth into", "grows eagerly into", "amplifys into")] a [uppertext(round(length))] inch penis.</b></span>")
		else if ((round(length) < round(prev_length)) && (length > 0.5))
			to_chat(owner, "<span class='warning'>Your [pick(GLOB.gentlemans_organ_names)] [pick("shrinks down to", "decreases into", "diminishes into", "deflates into", "shrivels regretfully into", "contracts into")] a [uppertext(round(length))] inch penis.</b></span>")
	prev_length = length
	icon_state = sanitize_text("penis_[shape]_[size]")
	girth = (length * girth_ratio)//Is it just me or is this ludicous, why not make it exponentially decay?


/obj/item/organ/genital/penis/update_appearance()
	. = ..()
	var/string
	var/lowershape = lowertext(shape)
	desc = "You see [aroused_state ? "an erect" : "a flaccid"] [lowershape] [name]. You estimate it's about [round(length, 0.25)] inch[round(length, 0.25) != 1 ? "es" : ""] long and [round(girth, 0.25)] inch[round(girth, 0.25) != 1 ? "es" : ""] in girth."

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

/obj/item/organ/genital/penis/get_features(mob/living/carbon/human/H)
	var/datum/dna/D = H.dna
	if(D.species.use_skintones && D.features["genitals_use_skintone"])
		color = "#[skintone2hex(H.skin_tone)]"
	else
		color = "#[D.features["cock_color"]]"
	length = D.features["cock_length"]
	girth_ratio = D.features["cock_girth_ratio"]
	shape = D.features["cock_shape"]
	prev_length = length
	cached_length = length

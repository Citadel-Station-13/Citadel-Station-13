/obj/item/organ/genital/vagina
	name 					= "vagina"
	desc 					= "A female reproductive organ."
	icon					= 'code/citadel/icons/vagina.dmi'
	icon_state 				= "vagina"
	zone 					= "groin"
	slot 					= "vagina"
	size					= 1 //There is only 1 size right now
	can_masturbate_with		= TRUE
	masturbation_verb 	= "finger"
	can_climax 				= TRUE
	fluid_transfer_factor = 0.1 //Yes, some amount is exposed to you, go get your AIDS
	w_class 				= 3
	var/cap_length		= 8//D   E   P   T   H (cap = capacity)
	var/cap_girth		= 12
	var/cap_girth_ratio = 1.5
	var/clits				= 1
	var/clit_diam 			= 0.25
	var/clit_len			= 0.25
	var/list/vag_types = list("tentacle", "dentata", "hairy")


/obj/item/organ/genital/vagina/update_appearance()
	var/string = "vagina" //Keeping this code here, so making multiple sprites for the different kinds is easier.
	icon_state = sanitize_text(string)
	var/lowershape = lowertext(shape)
	var/details

	switch(lowershape)
		if("tentacle")
			details = "\nIts opening is lined with several tentacles and "
		if("dentata")
			details = "\nThere's teeth inside it and it is "
		if("hairy")
			details = "\nIt has quite a bit of hair growing on it and is "
		if("human")
			details = "\nIt is taut with smooth skin, though without much hair and "
		if("gaping")
			details = "\nIt is gaping slightly open, though without much hair and "
		else
			details = "\nIt has an exotic shape and is "
	if(aroused_state)
		details += "slick with female arousal."
	else
		details += "not very wet."

	desc = "That's a [lowershape] vagina. You estimate it to be around [round(cap_length, 0.5)] inch[cap_length > 1 ? "es" : ""] deep and could stretch around something [round(cap_girth, 0.5)] inch[cap_girth > 1 ? "es" : ""] in girth. \
	It has [clits > 1 ? "[clits] clits" : "a clit"] about [round(clit_len,0.25)] inch[clit_len > 1 ? "es" : ""] long and [round(clit_diam, 0.25)] inch[clit_diam > 1 ? "es" : ""] in diameter.[details]"

	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
		else
			color = "#[owner.dna.features["vag_color"]]"


/obj/item/organ/genital/vagina/update_link()
	if(owner)
		linked_organ = (owner.getorganslot("womb"))
		if(linked_organ)
			linked_organ.linked_organ = src
	else
		if(linked_organ)
			linked_organ.linked_organ = null
		linked_organ = null

/obj/item/organ/genital/vagina/is_exposed()
	. = ..()
	if(.)
		return TRUE
	return owner.is_groin_exposed()
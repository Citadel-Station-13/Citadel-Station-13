/obj/item/organ/genital/vagina
	name 					= "vagina"
	desc 					= "A female reproductive organ."
	icon					= 'code/citadel/icons/vagina.dmi'
	icon_state 				= "vagina"
	zone 					= "groin"
	slot 					= "vagina"
	size					= 1 //There is only 1 size right now
	can_masturbate_with		= 1
	w_class 				= 3
	var/wetness				= FALSE
	var/cap_length		= 8//D   E   P   T   H (cap = capacity)
	var/cap_girth		= 12
	var/cap_girth_ratio = 1.5
	var/clits				= 1
	var/clit_diam 			= 0.25
	var/clit_len			= 0.25
	var/list/vag_types = list("tentacle", "dentata", "hairy")
	var/obj/item/organ/genital/womb/linked_womb


/obj/item/organ/genital/vagina/update_appearance()
	var/string = "vagina" //Keeping this code here, so making multiple sprites for the different kinds is easier.
	icon_state = sanitize_text(string)
	var/lowershape = lowertext(shape)

	desc = "That's a [lowershape] vagina. You estimate it could stretch about [round(cap_length, 0.25)] inch[cap_length > 1 ? "es" : ""] deep, around something [round(cap_girth, 0.25)] inch[cap_girth > 1 ? "es" : ""] thick \
	and it has [clits > 1 ? "[clits] clits" : "a clit"], about [round(clit_len,0.25)] inch[clit_len > 1 ? "es" : ""] long and [round(clit_diam, 0.25)] inch[clit_diam > 1 ? "es" : ""] in diameter."
	switch(lowershape)
		if("tentacle")
			desc += "\nIts opening is lined with several tentacles and "
		if("dentata")
			desc += "\nThere's teeth inside it and it is "
		if("hairy")
			desc += "\nIt has quite a bit of hair growing on it and is "
		if("human")
			desc += "\nIt is taut with smooth skin, though without much hair and "
		if("gaping")
			desc += "\nIt is gaping slightly open, though without much hair and "
		if("dripping")
			desc += "\nIt is gaping slightly, inflamed and "
		else
			desc += "\nIt has an exotic shape and is "
	if(wetness)
		desc += "slick with female arousal."
	else
		desc += "not very wet."
	if(owner)
		color = "#[owner.dna.features["vag_color"]]"

/obj/item/organ/genital/vagina/update_link()
	if(owner)
		linked_womb = (owner.getorganslot("womb"))
		if(linked_womb)
			linked_womb.linked_vag = src
	else
		if(linked_womb)
			linked_womb.linked_vag = null
		linked_womb = null

/obj/item/organ/genital/vagina/remove_ref()
	if(linked_womb)
		linked_womb.linked_vag = null
		linked_womb = null

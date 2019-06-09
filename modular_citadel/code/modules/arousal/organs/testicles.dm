/obj/item/organ/genital/testicles
	name 					= "testicles"
	desc 					= "A male reproductive organ."
	icon_state 				= "testicles"
	icon 					= 'modular_citadel/icons/obj/genitals/testicles.dmi'
	zone 					= "groin"
	slot 					= "testicles"
	size 					= BALLS_SIZE_MIN
	var/size_name			= "average"
	shape					= "single"
	var/sack_size			= BALLS_SACK_SIZE_DEF
	fluid_id 				= "semen"
	producing				= TRUE
	can_masturbate_with		= TRUE
	masturbation_verb 		= "massage"
	can_climax				= TRUE
	var/sent_full_message	= TRUE //defaults to 1 since they're full to start

/obj/item/organ/genital/testicles/Initialize()
	. = ..()
	reagents.add_reagent(fluid_id, fluid_max_volume)

/obj/item/organ/genital/testicles/on_life()
	if(QDELETED(src))
		return
	if(reagents && producing)
		generate_cum()

/obj/item/organ/genital/testicles/proc/generate_cum()
	reagents.maximum_volume = fluid_max_volume
	if(reagents.total_volume >= reagents.maximum_volume)
		if(!sent_full_message)
			send_full_message()
			sent_full_message = TRUE
		return FALSE
	sent_full_message = FALSE
	update_link()
	if(!linked_organ)
		return FALSE
	reagents.isolate_reagent(fluid_id)//remove old reagents if it changed and just clean up generally
	reagents.add_reagent(fluid_id, (fluid_mult * fluid_rate))//generate the cum

/obj/item/organ/genital/testicles/update_link()
	if(owner && !QDELETED(src))
		linked_organ = (owner.getorganslot("penis"))
		if(linked_organ)
			linked_organ.linked_organ = src

	else
		if(linked_organ)
			linked_organ.linked_organ = null
		linked_organ = null

/obj/item/organ/genital/testicles/proc/send_full_message(msg = "Your balls finally feel full, again.")
	if(owner && istext(msg))
		to_chat(owner, msg)
		return TRUE

/obj/item/organ/genital/testicles/update_appearance()
	if(owner)
		if(size == 0)
			size_name = "nonexistant"
		if(size == 1)
			size_name = "average"
		if(size == 2)
			size_name = "enlarged"
		if(size >= 3)
			size_name = "engorged"

		if(!internal)
			desc = "You see an [size_name] pair of testicles dangling."
		else
			desc = "They don't have any testicles you can see."
		var/string
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
				string = "testicles_[GLOB.balls_shapes_icons[shape]]_[size]-s"
		else
			color = "#[owner.dna.features["balls_color"]]"
			string = "testicles_[GLOB.balls_shapes_icons[shape]]_[size]"
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			icon_state = sanitize_text(string)
			H.update_genitals()

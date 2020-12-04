/datum/species/angel
	name = "Angel"
	id = SPECIES_ANGEL
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,HAS_FLESH,HAS_BONE)
	mutant_bodyparts = list("tail_human" = "None", "ears" = "None", "wings" = "Angel")
	use_skintones = USE_SKINTONES_GRAYSCALE_CUSTOM
	no_equip = list(SLOT_BACK)
	blacklisted = 1
	limbs_id = SPECIES_HUMAN
	skinned_type = /obj/item/stack/sheet/animalhide/human
	species_category = SPECIES_CATEGORY_BASIC //they're a kind of human

	var/datum/action/innate/flight/fly

/datum/species/angel/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	..()
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "Angel"))
		if(!H.dna.species.mutant_bodyparts["wings"])
			H.dna.species.mutant_bodyparts["wings"] = "Angel"
		H.dna.features["wings"] = "Angel"
		H.update_body()
	if(ishuman(H) && !fly)
		fly = new
		fly.Grant(H)
	ADD_TRAIT(H, TRAIT_HOLY, SPECIES_TRAIT)

/datum/species/angel/on_species_loss(mob/living/carbon/human/H)
	if(fly)
		fly.Remove(H)
	if(H.movement_type & FLYING)
		H.setMovetype(H.movement_type & ~FLYING)
	ToggleFlight(H,0)
	if(H.dna && H.dna.species && (H.dna.features["wings"] == "Angel"))
		if(H.dna.species.mutant_bodyparts["wings"])
			H.dna.species.mutant_bodyparts -= "wings"
		H.dna.features["wings"] = "None"
		H.update_body()
	REMOVE_TRAIT(H, TRAIT_HOLY, SPECIES_TRAIT)
	..()

/datum/species/angel/spec_life(mob/living/carbon/human/H)
	HandleFlight(H)

/datum/species/angel/proc/HandleFlight(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		if(!CanFly(H))
			ToggleFlight(H,0)
			return 0
		return 1
	else
		return 0

/datum/species/angel/proc/CanFly(mob/living/carbon/human/H)
	if(!CHECK_MOBILITY(H, MOBILITY_MOVE))
		return FALSE
	if(H.wear_suit && ((H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))	//Jumpsuits have tail holes, so it makes sense they have wing holes too
		to_chat(H, "Your suit blocks your wings from extending!")
		return FALSE
	var/turf/T = get_turf(H)
	if(!T)
		return FALSE

	var/datum/gas_mixture/environment = T.return_air()
	if(environment && !(environment.return_pressure() > 30))
		to_chat(H, "<span class='warning'>The atmosphere is too thin for you to fly!</span>")
		return FALSE
	return TRUE

/datum/action/innate/flight
	name = "Toggle Flight"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUN
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"

/datum/action/innate/flight/Activate()
	var/mob/living/carbon/human/H = owner
	var/datum/species/angel/A = H.dna.species
	if(A.CanFly(H))
		if(H.movement_type & FLYING)
			to_chat(H, "<span class='notice'>You settle gently back onto the ground...</span>")
			A.ToggleFlight(H,0)
			H.update_mobility()
		else
			to_chat(H, "<span class='notice'>You beat your wings and begin to hover gently above the ground...</span>")
			H.set_resting(FALSE, TRUE)
			A.ToggleFlight(H,1)
			H.update_mobility()

/datum/species/angel/proc/flyslip(mob/living/carbon/human/H)
	var/obj/buckled_obj
	if(H.buckled)
		buckled_obj = H.buckled

	to_chat(H, "<span class='notice'>Your wings spazz out and launch you!</span>")

	playsound(H.loc, 'sound/misc/slip.ogg', 50, 1, -3)

	for(var/obj/item/I in H.held_items)
		H.accident(I)

	var/olddir = H.dir

	H.stop_pulling()
	if(buckled_obj)
		buckled_obj.unbuckle_mob(H)
		step(buckled_obj, olddir)
	else
		for(var/i=1, i<5, i++)
			spawn (i)
				step(H, olddir)
				H.spin(1,1)
	return 1


/datum/species/angel/spec_stun(mob/living/carbon/human/H,amount)
	if(H.movement_type & FLYING)
		ToggleFlight(H,0)
		flyslip(H)
	. = ..()

/datum/species/angel/negates_gravity(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return 1

/datum/species/angel/space_move(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return 1

/datum/species/angel/proc/ToggleFlight(mob/living/carbon/human/H,flight)
	if(flight && CanFly(H))
		stunmod = 2
		speedmod = -0.1
		H.setMovetype(H.movement_type | FLYING)
		override_float = TRUE
		H.pass_flags |= PASSTABLE
		H.OpenWings()
	else
		stunmod = 1
		speedmod = 0
		H.setMovetype(H.movement_type & ~FLYING)
		override_float = FALSE
		H.pass_flags &= ~PASSTABLE
		H.CloseWings()
	update_species_slowdown(H)

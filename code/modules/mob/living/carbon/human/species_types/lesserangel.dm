    
/datum/species/langel
	name = "Lesser Angel"
	id = "langel"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	mutant_bodyparts = list("wings")
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "Angel")
	use_skintones = 1
	no_equip = list(SLOT_BACK)
	blacklisted = 1
	limbs_id = "human"
	skinned_type = /obj/item/stack/sheet/animalhide/human

	var/datum/action/innate/flight/fly

/datum/species/langel/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	..()
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "Angel"))
		if(!("wings" in H.dna.species.mutant_bodyparts))
			H.dna.species.mutant_bodyparts |= "wings"
		H.dna.features["wings"] = "Angel"
		H.update_body()
	if(ishuman(H) && !fly)
		fly = new
		fly.Grant(H)
	ADD_TRAIT(H, SPECIES_TRAIT)

/datum/species/langel/handle_fire(mob/living/carbon/human/H, no_protection = FALSE)
	..()
	if(H.dna.features["wings"] != "Burnt Off" && H.bodytemperature >= 800 && H.fire_stacks > 0) //do not go into the extremely hot light. you will not survive
		to_chat(H, "<span class='danger'>Your precious wings burn to a crisp!</span>")
		H.dna.features["wings"] = "Burnt Off"
		handle_mutant_bodyparts(H)

/datum/species/langel/space_move(mob/living/carbon/human/H)
	. = ..()
	if(H.loc && !isspaceturf(H.loc) && H.dna.features["wings"] != "Burnt Off")
		var/datum/gas_mixture/current = H.loc.return_air()
		if(current && (current.return_pressure() >= ONE_ATMOSPHERE*0.85)) //as long as there's reasonable pressure and no gravity, flight is possible
			return TRUE

/datum/species/langel/on_species_loss(mob/living/carbon/human/H)
	if(fly)
		fly.Remove(H)
	if(H.movement_type & FLYING)
		H.movement_type &= ~FLYING
	ToggleFlight(H,0)
	if(H.dna && H.dna.species && (H.dna.features["wings"] == "Angel"))
		if("wings" in H.dna.species.mutant_bodyparts)
			H.dna.species.mutant_bodyparts -= "wings"
		H.dna.features["wings"] = "None"
		H.update_body()
	REMOVE_TRAIT(H, SPECIES_TRAIT)
	..()

/datum/species/langel/spec_life(mob/living/carbon/human/H)
	HandleFlight(H)

/datum/species/langel/proc/HandleFlight(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		if(!CanFly(H))
			ToggleFlight(H,0)
			return 0
		return 1
	else
		return 0

/datum/species/langel/proc/CanFly(mob/living/carbon/human/H)
	if(H.stat || H.IsStun() || H.IsKnockdown())
		return 0
	if(H.wear_suit && ((H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))	//Jumpsuits have tail holes, so it makes sense they have wing holes too
		to_chat(H, "Your suit blocks your wings from extending!")
		return 0
	var/turf/T = get_turf(H)
	if(!T)
		return 0

	var/datum/gas_mixture/environment = T.return_air()
	if(environment && !(environment.return_pressure() > 30))
		to_chat(H, "<span class='warning'>The atmosphere is too thin for you to fly!</span>")
		return 0
	else
		return 1

/datum/action/innate/flight
	name = "Toggle Flight"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUN
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"

/datum/action/innate/flight/Activate()
	var/mob/living/carbon/human/H = owner
	var/datum/species/langel/A = H.dna.species
	if(A.CanFly(H))
		if(H.movement_type & FLYING)
			to_chat(H, "<span class='notice'>You settle gently back onto the ground...</span>")
			A.ToggleFlight(H,0)
			H.update_canmove()
		else
			to_chat(H, "<span class='notice'>You beat your wings and begin to hover gently above the ground...</span>")
			H.resting = 0
			A.ToggleFlight(H,1)
			H.update_canmove()

/datum/species/langel/proc/flyslip(mob/living/carbon/human/H)
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


/datum/species/langel/spec_stun(mob/living/carbon/human/H,amount)
	if(H.movement_type & FLYING)
		ToggleFlight(H,0)
		flyslip(H)
	. = ..()

/datum/species/langel/negates_gravity(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return 1

/datum/species/langel/space_move(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return 1

/datum/species/langel/proc/ToggleFlight(mob/living/carbon/human/H,flight)
	if(flight && CanFly(H))
		stunmod = 2
		speedmod = -0.35
		H.movement_type |= FLYING
		override_float = TRUE
		H.pass_flags |= PASSTABLE
		H.OpenWings()
	else
		stunmod = 1
		speedmod = 0
		H.movement_type &= ~FLYING
		override_float = FALSE
		H.pass_flags &= ~PASSTABLE
		H.CloseWings()

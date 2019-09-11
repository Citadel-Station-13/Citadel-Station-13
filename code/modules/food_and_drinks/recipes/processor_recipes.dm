/datum/food_processor_process
	var/input
	var/blacklisted_inputs
	var/output
	var/time = 40
	var/output_multiplier = 1
	var/min_amount_rating = 1
	var/required_machine = /obj/machinery/processor
	var/req_emagged = FALSE

/datum/food_processor_process/New()
	if(input)
		input = typecacheof(input)
	if(blacklisted_inputs)
		blacklisted_inputs = typecacheof(blacklisted_inputs)

//This proc is called in two occasions: when trying to insert something in the food processor and when it's effectively processing food.
//the user arg is only set on the first case, thus you'll have to check it before running related statements.
/datum/food_processor_process/proc/check_requirements(obj/machinery/processor/P, atom/movable/X, mob/user)
	if(!istype(P, required_machine))
		return FALSE
	if(req_emagged && !CHECK_BITFIELD(P.obj_flags, EMAGGED))
		return FALSE
	if(P.rating_amount < min_amount_rating)
		if(user)
			to_chat(user, "<span class='warning'>\The [P] lacks the more advanced stock parts required to process \the [X].</span>")
		return FALSE
	return TRUE

/datum/food_processor_process/proc/make_results(obj/machinery/processor/P, atom/movable/X)
	if(!output || (X in P))
		return
	for(var/i in 1 to FLOOR(P.rating_amount * output_multiplier, 1))
		new output(P.drop_location())

/datum/food_processor_process/meat
	input = /obj/item/reagent_containers/food/snacks/meat/slab
	output = /obj/item/reagent_containers/food/snacks/faggot

/datum/food_processor_process/bacon
	input = /obj/item/reagent_containers/food/snacks/meat/rawcutlet
	output = /obj/item/reagent_containers/food/snacks/meat/rawbacon

/datum/food_processor_process/potatowedges
	input = /obj/item/reagent_containers/food/snacks/grown/potato/wedges
	output = /obj/item/reagent_containers/food/snacks/fries

/datum/food_processor_process/sweetpotato
	input = /obj/item/reagent_containers/food/snacks/grown/potato/sweet
	output = /obj/item/reagent_containers/food/snacks/yakiimo

/datum/food_processor_process/potato
	input = /obj/item/reagent_containers/food/snacks/grown/potato
	output = /obj/item/reagent_containers/food/snacks/tatortot

/datum/food_processor_process/carrot
	input = /obj/item/reagent_containers/food/snacks/grown/carrot
	output = /obj/item/reagent_containers/food/snacks/carrotfries

/datum/food_processor_process/soybeans
	input = /obj/item/reagent_containers/food/snacks/grown/soybeans
	output = /obj/item/reagent_containers/food/snacks/soydope

/datum/food_processor_process/spaghetti
	input = /obj/item/reagent_containers/food/snacks/doughslice
	output = /obj/item/reagent_containers/food/snacks/spaghetti

/datum/food_processor_process/corn
	input = /obj/item/reagent_containers/food/snacks/grown/corn
	output = /obj/item/reagent_containers/food/snacks/tortilla

/datum/food_processor_process/parsnip
	input = /obj/item/reagent_containers/food/snacks/grown/parsnip
	output = /obj/item/reagent_containers/food/snacks/roastparsnip

/datum/food_processor_process/mob
	var/kick_n_scream = TRUE
	var/instinct_verb = "cries at the coderbus"
	var/blind_istinct_noise = "animal"
	var/stuffin_time = 40
	var/check_items = TRUE

/datum/food_processor_process/mob/check_requirements(obj/machinery/processor/P, mob/living/L, mob/user)
	. = ..()
	if(!. || !user)
		return
	if(user.grab_state < GRAB_AGGRESSIVE)
		to_chat(user, "<span class='warning'>You need a better grip to do that!</span>")
		return FALSE
	if(L.buckled ||L.has_buckled_mobs())
		to_chat(user, "<span class='warning'>[L] is attached to something!</span>")
		return FALSE
	if(kick_n_scream && !L.mind && !L.incapacitated())
		user.visible_message("<span class='warning'>[L] [instinct_verb] and trashes around as [user] futilely attempts to stuff them into [P].</span>", "<span class='warning'>[L] [instinct_verb] and trashes around against your futile attempts at stuffing them into [P].</span>", "<span class='italics'>You hear angry [blind_istinct_noise] noises...</span>")
		return FALSE
	if(check_items)
		for(var/A in L.held_items + L.get_equipped_items())
			if(!A)
				continue
			var/obj/item/I = A
			if(!HAS_TRAIT(I, TRAIT_NODROP))
				to_chat(user, "<span class='danger'>Subject may not have abiotic items on.</span>")
				return FALSE
	if(stuffin_time)
		user.visible_message("<span class='warning'>[user] starts stuffing [L] into [P].</span>", "<span class='notice'>You start stuffing [L] into [P]...</span>")
		if(!do_mob(user, L, stuffin_time))
			return FALSE
	user.visible_message("<span class='warning'>[user] stuffs [L] into [P].</span>", "<span class='notice'>You stuff [L] into [P].</span>")

/datum/food_processor_process/mob/make_results(obj/machinery/processor/P, atom/movable/X)
	var/mob/living/L = X
	if(!output || !(L in P))
		return
	for(var/i in 1 to FLOOR(P.rating_amount * output_multiplier * max(0.25, L.mob_size * 0.5), 1))
		new output(P.drop_location())

/datum/food_processor_process/mob/slime
	input = /mob/living/simple_animal/slime
	required_machine = /obj/machinery/processor/slime
	instinct_verb = "blorbes"
	blind_istinct_noise = "slime"
	stuffin_time = 0

/datum/food_processor_process/mob/slime/make_results(obj/machinery/processor/P, mob/living/simple_animal/slime/S)
	if(!(S in P))
		return
	for(var/i in 1 to (S.cores + P.rating_amount - 1))
		var/atom/movable/item = new S.coretype(P.drop_location())
		P.adjust_item_drop_location(item)
		SSblackbox.record_feedback("tally", "slime_core_harvested", 1, S.colour)

/datum/food_processor_process/mob/sausage
	output = /obj/item/reagent_containers/food/snacks/sausage
	min_amount_rating = 3
	time = 80

/datum/food_processor_process/mob/sausage/poultry
	input = /mob/living/simple_animal/chicken
	instinct_verb = "clucks"

/datum/food_processor_process/mob/sausage/cow
	input = /mob/living/simple_animal/cow
	instinct_verb = "moos hauntingly"

/datum/food_processor_process/mob/sausage/goat
	input = /mob/living/simple_animal/hostile/retaliate/goat
	instinct_verb = "brays"

/datum/food_processor_process/mob/sausage/monky
	input = /mob/living/carbon/monkey
	kick_n_scream = FALSE

/datum/food_processor_process/mob/carp_tuna
	input = /mob/living/simple_animal/hostile/carp
	blacklisted_inputs = /mob/living/simple_animal/hostile/carp/eyeball //this shouldn't be a subtype of carp to start with.
	output = /obj/item/reagent_containers/food/snacks/tuna
	min_amount_rating = 3
	output_multiplier = 0.5
	instinct_verb = "gnashes"
	time = 80

/datum/food_processor_process/mob/killer_soup
	input = /mob/living/simple_animal/hostile/killertomato
	output = /obj/item/reagent_containers/food/snacks/soup/tomato
	min_amount_rating = 3
	output_multiplier = 0.5
	instinct_verb = "gnashes"
	blind_istinct_noise = "plant"
	time = 80

/datum/food_processor_process/mob/soylent_green
	req_emagged = TRUE
	kick_n_scream = FALSE
	input = /mob/living/carbon/human
	output = /obj/item/reagent_containers/food/snacks/soylentgreen
	output_multiplier = 0.5
	time = 80
/datum/food_processor_process
	var/input
	var/blacklisted_inputs
	var/output
	var/time = 40
	var/output_multiplier = 1
	var/min_amount_rating = 1
	var/required_machine = /obj/machinery/processor

/datum/food_processor_process/New()
	if(input)
		input = typecacheof(input)
	if(blacklisted_inputs)
		blacklisted_inputs = typecacheof(blacklisted_inputs)

/datum/food_processor_process/proc/check_requirements(obj/machinery/processor/P, atom/movable/X, mob/user)
	if(!istype(P, required_machine))
		return FALSE
	if(P.rating_amount >= min_amount_rating)
		if(user)
			to_chat(user, "<span class='warning'>\The [src] lacks the more advanced stock parts required to process \the [X].</span>")
		return FALSE

/datum/food_processor_process/proc/make_results(obj/machinery/processor/P, atom/movable/X)
	if(output)
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
	var/instinct_verb = "cries at the coderbus"
	var/blind_istinct_noise = "animal"

/datum/food_processor_process/mob/check_requirements(obj/machinery/processor/P, mob/living/L, mob/user)
	. = ..()
	if(. && user && L.stat != DEAD) //colloquially said, no user around equals to grinding time, so no moral check will cause issues there.
		user.visible_message("<span class='warning'>\The [L] [instinct_verb] and trashes around as [user] futilely attempts to stuff them into \the [src].</span>", "<span class='warning'>\The [L] [instinct_verb] and trashes around against your futile attempts at stuffing them into \the [src].</span>", "<span class='italics'>You hear angry [blind_istinct_noise] noises...</span>")
		return FALSE

/datum/food_processor_process/mob/slime
	input = /mob/living/simple_animal/slime
	output = null
	required_machine = /obj/machinery/processor/slime
	instinct_verb = "blorbes"
	blind_istinct_noise = "slime"

/datum/food_processor_process/mob/poultry_sausage
	input = /mob/living/simple_animal/chicken
	output = /obj/item/reagent_containers/food/snacks/sausage
	min_amount_rating = 3
	output_multiplier = 0.5
	instinct_verb = "clucks"

/datum/food_processor_process/mob/carp_tuna
	input = /mob/living/simple_animal/hostile/carp
	blacklisted_inputs = /mob/living/simple_animal/hostile/carp/eyeball //this shouldn't be a subtype of carp to start with.
	output = /obj/item/reagent_containers/food/snacks/tuna
	min_amount_rating = 3
	output_multiplier = 0.5
	instinct_verb = "gnashes"

/datum/food_processor_process/mob/killer_soup
	input = /mob/living/simple_animal/hostile/killertomato
	output = /obj/item/reagent_containers/food/snacks/soup/tomato
	min_amount_rating = 3
	output_multiplier = 0.5
	instinct_verb = "gnashes"
	blind_istinct_noise = "plant"
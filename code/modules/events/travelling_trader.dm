/datum/round_event_control/travelling_trader
	name = "Travelling Trader"
	typepath = /datum/round_event/travelling_trader
	weight = 10
	max_occurrences = 3
	earliest_start = 0 MINUTES

/datum/round_event/travelling_trader
	startWhen = 0
	endWhen = 900 //you effectively have 15 minutes to complete the traders request, before they disappear
	var/mob/living/carbon/human/dummy/travelling_trader/trader
	var/atom/spawn_location //where the trader appears

/datum/round_event/travelling_trader/setup()
	spawn_location = pick(GLOB.generic_event_spawns)

/datum/round_event/travelling_trader/start()
	//spawn a type of trader
	var/trader_type = pick(subtypesof(/mob/living/carbon/human/dummy/travelling_trader))
	message_admins("we picked trader [trader_type] at location [spawn_location]")
	trader = new trader_type(get_turf(spawn_location))
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(1, spawn_location)
	smoke.start()
	trader.visible_message("<b>[src]</b> suddenly appears in a puff of smoke!")

/datum/round_event/travelling_trader/announce(fake)
	priority_announce("A mysterious figure has been detected on sensors at [get_area(spawn_location)]", "Mysterious Figure")

/datum/round_event/travelling_trader/end()
	if(trader)
		trader.visible_message("The <b>[src]</b> has given up on waiting!")
		qdel(trader)

//the actual trader mob
/mob/living/carbon/human/dummy/travelling_trader //similar to a dummy because we want to be resource-efficient
	real_name = "Debug Travelling Trader"
	status_flags = GODMODE //avoid scenarios of people trying to kill the trader
	move_resist = MOVE_FORCE_VERY_STRONG //you can't bluespace bodybag them!
	var/datum/outfit/trader_outfit
	var/list/possible_wanted_items //weighted list of possible things to request
	var/list/possible_rewards //weighted list of possible things to give in return for the requested item
	var/atom/requested_item //the thing they chose from possible_wanted_items
	var/last_speech //last time someone tried interacting with them using their hand
	var/last_refusal //last time they vocally refused an item given to them
	var/initial_speech = "It looks like the coders did a mishap!" //first thing they say when interacted with, like a description
	var/speech_verb = "says"
	var/request_speech = "Please bring me a requested_item you shall be greatly rewarded!" //second thing they say when interacted with
	var/acceptance_speech = "This is exactly what I wanted! I shall be on my way now, thank you.!"
	var/refusal_speech = "A given_item? I wanted a requested_item!" //what they say when refusing an item
	var/active = TRUE

/mob/living/carbon/human/dummy/travelling_trader/proc/setup_speech(var/input_speech, var/obj/item/given_item)
	if(requested_item)
		var/atom/temp_requested = new requested_item
		input_speech = replacetext(input_speech, "requested_item", temp_requested.name)
		qdel(temp_requested)
	if(given_item)
		input_speech = replacetext(input_speech, "given_item", given_item.name)
	return input_speech

/mob/living/carbon/human/dummy/travelling_trader/attack_hand(mob/living/carbon/human/H)
	if(active && last_speech + 3 < world.realtime) //can only talk once per 3 seconds, to avoid spam
		last_speech = world.realtime
		if(initial_speech)
			visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(initial_speech)]\"")
			sleep(15)
		if(active && request_speech) //they might not be active anymore because of the prior sleep!
			visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(request_speech)]\"")

/mob/living/carbon/human/dummy/travelling_trader/attackby(obj/item/I, mob/user)
	if(active)
		if(check_item(I))
			active = FALSE
			visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(acceptance_speech, I)]\"")
			qdel(I)
			sleep(15)
			give_reward()
			qdel(src)
		else
			if(last_refusal + 3 < world.realtime)
				last_refusal = world.realtime
				visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(refusal_speech, I)]\"")

/mob/living/carbon/human/dummy/travelling_trader/proc/check_item(var/obj/item/supplied_item) //sometimes we might want to care about the properties of the item, etc
	return istype(supplied_item, requested_item)

/mob/living/carbon/human/dummy/travelling_trader/proc/give_reward()
	var/reward = pickweight(possible_rewards)
	new reward(get_turf(src))

/mob/living/carbon/human/dummy/travelling_trader/Initialize()
	..()
	ADD_TRAIT(src,TRAIT_PIERCEIMMUNE, "trader_pierce_immune") //don't let people take their blood
	equipOutfit(trader_outfit, TRUE)
	for(var/obj/item/item in src.get_equipped_items())
		ADD_TRAIT(item, TRAIT_NODROP, "trader_no_drop") //don't let people steal the travellers clothes!
		item.resistance_flags |= INDESTRUCTIBLE //don't let people burn their clothes off, either.
	if(!requested_item) //sometimes we already picked one
		requested_item = pickweight(possible_wanted_items)

/mob/living/carbon/human/dummy/travelling_trader/Destroy()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(1, loc)
	smoke.start()
	visible_message("<b>[src]</b> disappears in a puff of smoke, leaving something on the ground!")
	..()

//travelling trader subtypes (the types that can actually spawn)
//so far there's: cook / botanist / animal hunter

//cook
/mob/living/carbon/human/dummy/travelling_trader/cook
	name = "Otherworldly Chef"
	trader_outfit = /datum/outfit/job/cook
	initial_speech = "Mama-mia! I have came to this plane of existence, searching the greatest of foods!"
	request_speech = "Can you fetch me the delicacy known as requested_item? I would pay you for your service!"
	acceptance_speech = "Grazie! You have done me a service, my friend."
	refusal_speech = "A given_item? Surely you must be joking!"
	possible_rewards = list()


/mob/living/carbon/human/dummy/travelling_trader/cook/Initialize()
	//pick a random crafted food item as the requested item
	var/category = pick(list(/obj/item/reagent_containers/food/snacks/burger,/obj/item/reagent_containers/food/snacks/pie,/obj/item/reagent_containers/food/snacks/pizza,/obj/item/reagent_containers/food/snacks/soup,/obj/item/reagent_containers/food/snacks/store/bread))
	requested_item = pick(subtypesof(category))
	..()

//botanist
/mob/living/carbon/human/dummy/travelling_trader/gardener
	name = "Otherworldly Gardener"
	trader_outfit = /datum/outfit/job/botanist
	initial_speech = "I have come across this realm in search of rare plants and believe this station may be able to help me.."
	request_speech = "Are you able to bring me a requested_item? I could see that you get some reward for this task."
	acceptance_speech = "Amazing! Ill finally be able to make that salad. Goodbye for now!"
	refusal_speech = "A given_item? Did nobody ever teach you the basics of gardening?"
	possible_rewards = list()


/mob/living/carbon/human/dummy/travelling_trader/gardener/Initialize()
	requested_item = pick(subtypesof(/obj/item/reagent_containers/food/snacks/grown))
	..()

//animal hunter
/mob/living/carbon/human/dummy/travelling_trader/animal_hunter
	name = "Otherworldly Animal Specialist"
	trader_outfit = /datum/outfit/synthetic
	initial_speech = "Greetings, lifeform. I am here to locate a special creature aboard your station."
	request_speech = "Find me the creature known as  'requested_item' and you shall be rewarded for your efforts."
	refusal_speech = "Do you think me to be a fool, lifeform? I know a requested_item when I see one."
	possible_wanted_items = list(/mob/living/simple_animal/pet/dog/corgi/Ian = 1, /mob/living/simple_animal/sloth/paperwork = 1, /mob/living/carbon/monkey/punpun = 1, /mob/living/simple_animal/pet/fox/Renault = 1, /mob/living/simple_animal/hostile/carp/cayenne = 1)

mob/living/carbon/human/dummy/travelling_trader/animal_hunter/Initialize()
	acceptance_speech = pick(list("This lifeform shall make for a great stew, thank you.", "This lifeform shall be of a true use to our cause, thank you.", "The lifeform is adequate. Goodbye.", "This lifeform shall make a great addition to my collection."))
	..()

/mob/living/carbon/human/dummy/travelling_trader/animal_hunter/check_item(var/obj/item/supplied_item) //item is likely to be in contents of whats supplied
	if(requested_item in supplied_item.contents)
		//delete the contents, item given is correct, but we don't want the contents to spill out when the parent is deleted
		for(var/atom/thing in supplied_item.contents)
			qdel(thing)
		return TRUE
	return FALSE

//bartender
/mob/living/carbon/human/dummy/travelling_trader/bartender
	name = "Otherworldly Bartender"
	trader_outfit = /datum/outfit/job/bartender
	initial_speech = "Greetings, station inhabitor. I came to this dimension in the pursuit of a particular drink."
	request_speech = "Bring me thirty units of the beverage known as 'requested_item'."
	acceptance_speech = "This is truly the drink I have been seeking. Thank you."
	refusal_speech = "Do not mess with me, simpleton, I do not wish for that which you are trying to give me."

/mob/living/carbon/human/dummy/travelling_trader/bartender/Initialize() //pick a subtype of ethanol that isn't found in the default set of the booze dispensers reagents
	requested_item = pick(subtypesof(/datum/reagent/consumable/ethanol) - list(/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/consumable/ethanol/kahlua,
		/datum/reagent/consumable/ethanol/whiskey,
		/datum/reagent/consumable/ethanol/wine,
		/datum/reagent/consumable/ethanol/vodka,
		/datum/reagent/consumable/ethanol/gin,
		/datum/reagent/consumable/ethanol/rum,
		/datum/reagent/consumable/ethanol/tequila,
		/datum/reagent/consumable/ethanol/vermouth,
		/datum/reagent/consumable/ethanol/cognac,
		/datum/reagent/consumable/ethanol/ale,
		/datum/reagent/consumable/ethanol/absinthe,
		/datum/reagent/consumable/ethanol/hcider,
		/datum/reagent/consumable/ethanol/creme_de_menthe,
		/datum/reagent/consumable/ethanol/creme_de_cacao,
		/datum/reagent/consumable/ethanol/creme_de_coconut,
		/datum/reagent/consumable/ethanol/triple_sec,
		/datum/reagent/consumable/ethanol/sake,
		/datum/reagent/consumable/ethanol/applejack))
	..()

/mob/living/carbon/human/dummy/travelling_trader/bartender/check_item(var/obj/item/supplied_item) //you need to check its reagents
	if(istype(supplied_item, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/supplied_container = supplied_item
		if(supplied_container.reagents.has_reagent(requested_item, 30))
			return TRUE
	return FALSE

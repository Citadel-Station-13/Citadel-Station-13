/datum/round_event_control/travelling_trader
	name = "Travelling Trader"
	typepath = /datum/round_event/travelling_trader
	weight = 10
	max_occurrences = 3
	earliest_start = 0 MINUTES

/datum/round_event/travelling_trader
	startWhen = 0
	endWhen = 600 //you effectively have 10 minutes to complete the traders request, before they disappear
	var/mob/living/carbon/human/dummy/travelling_trader/trader
	var/atom/spawn_location //where the trader appears

/datum/round_event/travelling_trader/setup()
	//find position to place trader at, same as how jacq works for poofing
	var/list/targets = list()
	for(var/H in GLOB.network_holopads)
		var/area/A = get_area(H)
		if(!A || findtextEx(A.name, "AI") || !is_station_level(H))
			continue
		targets += H

	if(!targets)
		targets = GLOB.generic_event_spawns

	spawn_location = pick(targets)

/datum/round_event/travelling_trader/start()
	//spawn a type of trader
	trader = pick(subtypesof(/mob/living/carbon/human/dummy/travelling_trader))
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
/mob/living/carbon/human/dummy/travelling_trader //subtype of dummy because we want to be resource-efficient
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
		input_speech = replacetext(input_speech, "requested_item", requested_item.name)
	if(given_item)
		input_speech = replacetext(input_speech, "given_item", given_item.name)
	return input_speech

/mob/living/carbon/human/dummy/travelling_trader/attack_hand(mob/living/carbon/human/H)
	if(active && last_speech + 3 SECONDS < world.realtime) //can only talk once per 3 seconds, to avoid spam
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
			sleep(20)
			give_reward()
			qdel(src)
		else
			if(last_refusal + 3 SECONDS < world.realtime)
				last_refusal = world.realtime
				visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(refusal_speech, I)]\"")

/mob/living/carbon/human/dummy/travelling_trader/proc/check_item(var/obj/item/supplied_item) //sometimes we might want to care about the properties of the item, etc
	return istype(supplied_item, requested_item)

/mob/living/carbon/human/dummy/travelling_trader/proc/give_reward()
	var/reward = pickweight(possible_rewards)
	new reward(get_turf(src))

/mob/living/carbon/human/dummy/travelling_trader/Initialize()
	ADD_TRAIT(src,TRAIT_PIERCEIMMUNE, "trader_pierce_immune") //don't let people take their blood
	trader_outfit.equip(src, TRUE)
	for(var/obj/item/item in src.get_equipped_items())
		ADD_TRAIT(item, TRAIT_NODROP, "trader_no_drop") //don't let people steal the travellers clothes!
		item.resistance_flags |= INDESTRUCTIBLE //don't let people burn their clothes off, either.
	requested_item = pickweight(possible_wanted_items)
	..()

/mob/living/carbon/human/dummy/travelling_trader/Destroy()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(1, loc)
	smoke.start()
	visible_message("<b>[src]</b> disappears in a puff of smoke, leaving something on the ground!")
	..()

//travelling trader subtypes (the types that can actually spawn)
/datum/station_trait/bananium_shipment
	name = "Bananium Shipment"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	report_message = "Rumors has it that the clown planet has been sending support packages to clowns in this system"
	trait_to_give = STATION_TRAIT_BANANIUM_SHIPMENTS

/datum/station_trait/unnatural_atmosphere
	name = "Unnatural atmospherical properties"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	show_in_report = TRUE
	report_message = "System's local planet has irregular atmospherical properties"
	trait_to_give = STATION_TRAIT_UNNATURAL_ATMOSPHERE

	// This station trait modifies the atmosphere, which is too far past the time admins are able to revert it
	can_revert = FALSE

/datum/station_trait/unique_ai
	name = "Unique AI"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	show_in_report = TRUE
	report_message = "For experimental purposes, this station AI might show divergence from default lawset. Do not meddle with this experiment."
	trait_to_give = STATION_TRAIT_UNIQUE_AI

/datum/station_trait/ian_adventure
	name = "Ian's Adventure"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	show_in_report = FALSE
	report_message = "Ian has gone exploring somewhere in the station."

/datum/station_trait/ian_adventure/on_round_start()
	for(var/mob/living/simple_animal/pet/dog/corgi/dog in GLOB.mob_list)
		if(!(istype(dog, /mob/living/simple_animal/pet/dog/corgi/Ian) || istype(dog, /mob/living/simple_animal/pet/dog/corgi/puppy)))
			continue

		// Makes this station trait more interesting. Ian probably won't go anywhere without a little external help.
		// Also gives him a couple extra lives to survive eventual tiders.
		dog.AddComponent(/datum/component/twitch_plays/simple_movement/auto, 3 SECONDS)
		dog.AddComponent(/datum/component/multiple_lives, 2)
		RegisterSignal(dog, COMSIG_ON_MULTIPLE_LIVES_RESPAWN, .proc/do_corgi_respawn)

		// The extended safety checks at time of writing are about chasms and lava
		// if there are any chasms and lava on stations in the future, woah
		var/turf/current_turf = get_turf(dog)
		var/turf/adventure_turf = find_safe_turf(extended_safety_checks = TRUE, dense_atoms = FALSE)

		// Poof!
		do_smoke(location=current_turf)
		dog.forceMove(adventure_turf)
		do_smoke(location=adventure_turf)

/// Moves the new dog somewhere safe, equips it with the old one's inventory and makes it deadchat_playable.
/datum/station_trait/ian_adventure/proc/do_corgi_respawn(mob/living/simple_animal/pet/dog/corgi/old_dog, mob/living/simple_animal/pet/dog/corgi/new_dog, gibbed, lives_left)
	SIGNAL_HANDLER

	var/turf/current_turf = get_turf(new_dog)
	var/turf/adventure_turf = find_safe_turf(extended_safety_checks = TRUE, dense_atoms = FALSE)

	do_smoke(location=current_turf)
	new_dog.forceMove(adventure_turf)
	do_smoke(location=adventure_turf)

	if(old_dog.inventory_back)
		var/obj/item/old_dog_back = old_dog.inventory_back
		old_dog.inventory_back = null
		old_dog_back.forceMove(new_dog)
		new_dog.inventory_back = old_dog_back

	if(old_dog.inventory_head)
		var/obj/item/old_dog_hat = old_dog.inventory_head
		old_dog.inventory_head = null
		new_dog.place_on_head(old_dog_hat)

	new_dog.update_corgi_fluff()
	new_dog.regenerate_icons()
	new_dog.AddComponent(/datum/component/twitch_plays/simple_movement/auto, 3 SECONDS)
	if(lives_left)
		RegisterSignal(new_dog, COMSIG_ON_MULTIPLE_LIVES_RESPAWN, .proc/do_corgi_respawn)

	if(!gibbed) //The old dog will now disappear so we won't have more than one Ian at a time.
		qdel(old_dog)

/datum/station_trait/glitched_pdas
	name = "PDA glitch"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 15
	show_in_report = TRUE
	report_message = "Something seems to be wrong with the PDAs issued to you all this shift. Nothing too bad though."
	trait_to_give = STATION_TRAIT_PDA_GLITCHED

/datum/station_trait/announcement_intern
	name = "Announcement Intern"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 1
	show_in_report = TRUE
	report_message = "Please be nice to him."
	blacklist = list(/datum/station_trait/announcement_medbot)

/datum/station_trait/announcement_intern/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/intern

/datum/station_trait/announcement_medbot
	name = "Announcement \"System\""
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 1
	show_in_report = TRUE
	report_message = "Our announcement system is under scheduled maintanance at the moment. Thankfully, we have a backup."
	blacklist = list(/datum/station_trait/announcement_intern)

/datum/station_trait/announcement_medbot/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/medbot

GLOBAL_LIST_INIT(randomizing_station_name_messages, world.file2list("strings/randomizing_station_name_messages.txt"))

/datum/station_trait/randomizing_station_name
	name = "Randomizing station name"
	show_in_report = TRUE
	report_message = "Due to legal reasons or other, we might not be able to settle on a station name."
	trait_processes = TRUE
	COOLDOWN_DECLARE(randomizing_cooldown)
	var/trigger_every = 5 MINUTES
	blacklist = list(/datum/station_trait/randomizing_station_name/fast, /datum/station_trait/randomizing_station_name/slow)

/datum/station_trait/randomizing_station_name/on_round_start()
	. = ..()
	COOLDOWN_START(src, randomizing_cooldown, trigger_every)

/datum/station_trait/randomizing_station_name/process(delta_time)
	if(!COOLDOWN_FINISHED(src, randomizing_cooldown))
		return

	COOLDOWN_START(src, randomizing_cooldown, trigger_every)

	var/new_name = new_station_name()

	var/centcom_announcement = pick(GLOB.randomizing_station_name_messages)

	// Replace with CURRENT station name
	centcom_announcement = replacetext(centcom_announcement, "%CURRENT_STATION_NAME%", station_name())

	// Replace with NEW station name
	centcom_announcement = replacetext(centcom_announcement, "%NEW_STATION_NAME%", new_name)

	// Take a CREWMEMBER's name for the goofs
	if(findtext(centcom_announcement, "%RANDOM_CREWMEMBER%"))
		var/crewmember = locate(/mob/living/carbon/human) in GLOB.alive_mob_list
		if(!crewmember)
			crewmember = random_unique_name()
		centcom_announcement = replacetext(centcom_announcement, "%RANDOM_CREWMEMBER%", crewmember)

	// Replace with a completely RANDOM name
	if(findtext(centcom_announcement, "%RANDOM_NAME%"))
		var/name = random_unique_name()
		centcom_announcement = replacetext(centcom_announcement, "%RANDOM_NAME%", name)

	set_station_name(new_name)

	priority_announce(centcom_announcement)

/datum/station_trait/randomizing_station_name/fast
	name = "Randomizing station name - Fast"
	trigger_every = 3 MINUTES
	blacklist = list(/datum/station_trait/randomizing_station_name, /datum/station_trait/randomizing_station_name/slow)

/datum/station_trait/randomizing_station_name/slow
	name = "Randomizing station name - Slow"
	trigger_every = 10 MINUTES
	blacklist = list(/datum/station_trait/randomizing_station_name/fast, /datum/station_trait/randomizing_station_name)

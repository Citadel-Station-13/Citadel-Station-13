/datum/round_event_control/graffiti_artist
	name = "Create Graffiti Artist"
	typepath = /datum/round_event/ghost_role/graffiti_artist
	weight = 8 // same as pirates
	max_occurrences = 1

/datum/round_event/ghost_role/graffiti_artist
	var/success_spawn = 0
	role_name = "graffiti artist"
	fakeable = FALSE

/datum/round_event/ghost_role/graffiti_artist/kill()
	if(!success_spawn && control)
		control.occurrences--
	return ..()

/datum/round_event/ghost_role/graffiti_artist/spawn_role()
	//selecting a spawn_loc
	if(!SSjob.latejoin_trackers.len)
		return MAP_ERROR

	//selecting a candidate player
	var/list/candidates = get_candidates(ROLE_GRAFFITI_ARTIST, null, ROLE_GRAFFITI_ARTIST)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected_candidate = pick_n_take(candidates)
	var/key = selected_candidate.key

	var/datum/mind/Mind = new /datum/mind(key)
	Mind.assigned_role = ROLE_GRAFFITI_ARTIST
	Mind.special_role = ROLE_GRAFFITI_ARTIST
	Mind.active = 1

	var/mob/living/carbon/human/artist = new
	SSjob.SendToLateJoin(artist)
	var/datum/preferences/A = new() //Randomize appearance for the graffiti artist.
	A.copy_to(artist)
	artist.dna.update_dna_identity()
	Mind.transfer_to(artist)
	Mind.add_antag_datum(/datum/antagonist/graffiti_artist)

	// give them their outfit
	var/datum/outfit/graffiti_artist/artist_outfit = new
	artist.equipOutfit(artist_outfit)

	spawned_mobs += artist
	message_admins("[ADMIN_LOOKUPFLW(artist)] has been made into a graffiti artist by an event.")
	log_game("[key_name(artist)] was spawned as a graffiti artist by an event.")

	success_spawn = TRUE
	return SUCCESSFUL_SPAWN

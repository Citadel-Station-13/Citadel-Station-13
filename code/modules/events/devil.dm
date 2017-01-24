/datum/round_event_control/devil
	name = "Create Devil"
	typepath = /datum/round_event/ghost_role/devil
	max_occurrences = 0

/datum/round_event/ghost_role/devil
	var/success_spawn = 0
	role_name = "devil"

/datum/round_event/ghost_role/devil/kill()
	if(!success_spawn && control)
		control.occurrences--
	return ..()

/datum/round_event/ghost_role/devil/spawn_role()
	//selecting a spawn_loc
	var/list/spawn_locs = latejoin
	var/spawn_loc = pick(spawn_locs)
	if(!spawn_loc)
		return MAP_ERROR

	//selecting a candidate player
	var/list/candidates = get_candidates("devil", null, ROLE_DEVIL)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected_candidate = pick_n_take(candidates)
	var/key = selected_candidate.key

	var/datum/mind/Mind = create_devil_mind(key)
	Mind.active = 1

	var/mob/living/carbon/human/devil = create_event_devil(spawn_loc)
	Mind.transfer_to(devil)
	ticker.mode.finalize_devil(Mind)
	ticker.mode.add_devil_objectives(src, 2)
	Mind.announceDevilLaws()
	Mind.announce_objectives()


	spawned_mobs += devil
	message_admins("[key_name_admin(devil)] has been made into a devil by an event.")
	log_game("[key_name(devil)] was spawned as a devil by an event.")
	var/datum/job/jobdatum = SSjob.GetJob("Assistant")
	devil.job = jobdatum.title
	jobdatum.equip(devil)
	return SUCCESSFUL_SPAWN


/proc/create_event_devil(spawn_loc)
	var/mob/living/carbon/human/new_devil = new(spawn_loc)
	var/datum/preferences/A = new() //Randomize appearance for the devil.
	A.copy_to(new_devil)
	new_devil.dna.update_dna_identity()
	return new_devil

/proc/create_devil_mind(key)
	var/datum/mind/Mind = new /datum/mind(key)
	Mind.assigned_role = "devil"
	Mind.special_role = "devil"
	ticker.mode.devils |= Mind
	return Mind

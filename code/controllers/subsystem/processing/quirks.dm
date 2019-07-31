//Used to process and handle roundstart quirks
// - Quirk strings are used for faster checking in code
// - Quirk datums are stored and hold different effects, as well as being a vector for applying trait string
PROCESSING_SUBSYSTEM_DEF(quirks)
	name = "Quirks"
	init_order = INIT_ORDER_QUIRKS
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME

	var/list/quirks = list()		//Assoc. list of all roundstart quirk datum types; "name" = /path/
	var/list/quirk_names_by_path = list()
	var/list/quirk_points = list()	//Assoc. list of quirk names and their "point cost"; positive numbers are good traits, and negative ones are bad
	var/list/quirk_objects = list()	//A list of all quirk objects in the game, since some may process

/datum/controller/subsystem/processing/quirks/Initialize(timeofday)
	if(!quirks.len)
		SetupQuirks()
	return ..()

/datum/controller/subsystem/processing/quirks/proc/SetupQuirks()
	for(var/V in subtypesof(/datum/quirk))
		var/datum/quirk/T = V
		quirks[initial(T.name)] = T
		quirk_points[initial(T.name)] = initial(T.value)
		quirk_names_by_path[T] = initial(T.name)

/datum/controller/subsystem/processing/quirks/proc/AssignQuirks(mob/living/user, client/cli, spawn_effects, roundstart = FALSE, datum/job/job, silent = FALSE, mob/to_chat_target)
	GenerateQuirks(cli)
	var/list/quirks = cli.prefs.character_quirks.Copy()
	var/list/cut
	if(job && job.blacklisted_quirks)
		cut = filter_quirks(quirks, job)
	for(var/V in quirks)
		user.add_quirk(V, spawn_effects)
	if(!silent && LAZYLEN(cut))
		to_chat(to_chat_target || user, "<span class='boldwarning'>All of your non-neutral character quirks have been cut due to these quirks conflicting with your job assignment: [english_list(cut)].</span>")

/datum/controller/subsystem/processing/quirks/proc/quirk_path_by_name(name)
	return quirks[name]

/datum/controller/subsystem/processing/quirks/proc/quirk_points_by_name(name)
	return quirk_points[name]

/datum/controller/subsystem/processing/quirks/proc/quirk_name_by_path(path)
	return quirk_names_by_path[path]

/datum/controller/subsystem/processing/quirks/proc/total_points(list/quirk_names)
	. = 0
	for(var/i in quirk_names)
		. += quirk_points_by_name(i)

/datum/controller/subsystem/processing/quirks/proc/filter_quirks(list/quirks, datum/job/job)
	var/list/cut = list()
	var/list/banned_names = list()
	for(var/i in job.blacklisted_quirks)
		var/name = quirk_name_by_path(i)
		if(name)
			banned_names += name
	var/list/blacklisted = quirks & banned_names
	if(length(blacklisted))
		for(var/i in blacklisted)
			quirks -= i
			cut += i

	/*	//Code to automatically reduce positive quirks until balance is even.
	var/points_used = total_points(quirks)
	if(points_used > 0)
		//they owe us points, let's collect.
		for(var/i in quirks)
			var/points = quirk_points_by_name(i)
			if(points > 0)
				cut += i
				quirks -= i
				points_used -= points
			if(points_used <= 0)
				break
	*/

	//Nah, let's null all non-neutrals out.
	if(cut.len)
		for(var/i in quirks)
			if(quirk_points_by_name(i) != 0)
				//cut += i		-- Commented out: Only show the ones that triggered the quirk purge.
				quirks -= i

	return cut

/datum/controller/subsystem/processing/quirks/proc/GenerateQuirks(client/user)
	if(user.prefs.character_quirks.len)
		return
	user.prefs.character_quirks = user.prefs.all_quirks

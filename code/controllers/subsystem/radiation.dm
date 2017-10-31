PROCESSING_SUBSYSTEM_DEF(radiation)
	name = "Radiation"
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = 25

	var/list/warned_atoms = list()

/datum/controller/subsystem/processing/radiation/proc/warn(datum/component/radioactive/contamination)
	if(!contamination || QDELETED(contamination))
		return
<<<<<<< HEAD
	if(warned_atoms["\ref[radioactive.parent]"])
=======
	var/ref = REF(contamination.parent)
	if(warned_atoms[ref])
>>>>>>> b78e060... Merge pull request #32247 from ninjanomnom/minor-rad-fixes
		return
	warned_atoms[ref] = TRUE
	var/atom/master = contamination.parent
	SSblackbox.add_details("contaminated", "[master.type]")
<<<<<<< HEAD
	next_warn["\ref[master]"] = "\ref[radioactive]"
	var/wait_time = max(0, 500-(world.time-last_warn))+20 // wait at least 20 ticks, longer if we just messaged
	addtimer(CALLBACK(src, .proc/send_warn), wait_time, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/controller/subsystem/processing/radiation/proc/send_warn()
	var/msg = "Atom(s) have become contaminated by radiation and are strong enough they could pass it on:"
	var/still_alive = FALSE
	var/list/next_warn = src.next_warn // It's free performance!
	for(var/i in next_warn)
		var/atom/parent = locate(i)
		var/datum/component/radioactive/radioactive = locate(next_warn[i])
		if(!parent || !istype(parent) || !radioactive || !istype(radioactive))
			continue
		if(!still_alive)
			msg += "\n"
			still_alive = TRUE
		else
			msg += ", "
		msg += "[parent][ADMIN_VV(parent)]source:[radioactive.source]"
	if(!still_alive)
		return
	warned_atoms += next_warn
	src.next_warn = list()
	last_warn = world.time
	message_admins(msg)
=======
	var/msg = "has become contamintaed with enough radiation to contaminate other objects. || Source: [contamination.source] || Strength: [contamination.strength]"
	master.investigate_log(msg, INVESTIGATE_RADIATION)
>>>>>>> b78e060... Merge pull request #32247 from ninjanomnom/minor-rad-fixes

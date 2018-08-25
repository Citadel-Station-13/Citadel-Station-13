//until a unified one is done, here it is:
GLOBAL_VAR(last_poll_tally)

/proc/basic_IRV_poll_tally(pollid, list/force_elims)
	var/datum/IRV_poll_tally/tally = new(pollid)
	tally.force_eliminations = force_elims.Copy()
	GLOB.last_poll_tally = tally
	if(tally.Execute() != TRUE)
		return "ERROR"
	var/list/L = list()
	L += "Poll results, ID [pollid]:"
	if(force_elims)
		var/list/elims = list()
		for(var/i in force_elims)
			if(!tally.initial_options["[i]"])
				continue
			elims += "ID [i] - [tally.initial_options[i]]"
		L += "\<FORCEFULLY ELIMINATED\>: [elims.Join(", ")]."
	for(var/round_iteration in 1 to tally.rounds.len)
		var/datum/IRV_poll_tally_round/round = tally.rounds[round_iteration]
		L += "ROUND [round_iteration]------------------------------------------------------"
		var/list/options = list()
		for(var/id in round.options)
			if(!options.len)
				options[id] = round.options[id]
				continue
			var/resolved = FALSE
			for(var/i in 1 to options.len)
				if(round.first_vote_value[id] > round.first_vote_value[options[i]])
					options.Insert(i, id)
					options[id] = round.options[id]
					resolved = TRUE
					break
			if(!resolved)
				options[id] = round.options[id]
		for(var/i in options)
			L += "Choice ID [i] - [round.options[i]] - First pick votes [round.first_vote_value[i]] - Total vote value [round.total_vote_value[i]]"
		if(round.eliminated_id)
			L += "ELIMINATED: Choice ID [round.eliminated_id] - [round.options[round.eliminated_id]]"
	L += "WINNER:"
	var/datum/IRV_poll_tally_round/last_round = tally.rounds[tally.rounds.len]
	if(last_round && last_round.options.len == 1)
		L += "[last_round.options[last_round.options[1]]]"
	else
		L += "ERROR: WINNER COULD NOT BE AUTOMATICALLY SHOWN. INSPECT GLOB.LAST_POLL_TALLY!"
	return L.Join("<br>")

/client/proc/irv_poll_tally()
	set name = "Poll Tally - IRV"
	set category = "Server"
	var/pollid = input(mob, "Enter poll ID.", "Poll ID") as num|null
	if(!isnum(pollid))
		return
	var/list/force_elim
	if(alert(mob, "Would you like to forcefully eliminate options by ID? This is usually used to get runner-ups.", "Force eliminate?", "No", "Yes") == "Yes")
		force_elim = list()
		var/id
		do
			id = input(mob, "Enter ID of entry to eliminate, or cancel when finished.") as num|null
			if(id)
				force_elim += "[id]"
		while(id)
		if(!force_elim.len)
			force_elim = null
	var/datum/browser/popup = new(mob, "polltally", "polltally", 900, 600)
	popup.set_content(basic_IRV_poll_tally(pollid, force_elim))
	popup.open()

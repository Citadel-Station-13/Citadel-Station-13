//until a unified one is done, here it is:
GLOBAL_VAR(last_poll_tally)

/proc/basic_IRV_poll_tally(pollid)
	var/datum/IRV_poll_tally/tally = new(pollid)
	GLOB.last_poll_tally = tally
	if(tally.Execute() != TRUE)
		return "ERROR"
	. = list()
	. += "Poll results, ID [pollid]:"
	for(var/round_iteration in 1 to tally.rounds.len)
		var/datum/IRV_poll_tally_round/round = tally.rounds[round_iteration]
		. += "ROUND [round_iteration]------------------------------------------------------"
		var/list/options = list()
		for(var/id in round.options)
			if(!options.len)
				options[id] = round.options[id]
				continue
			for(var/i in 1 to options.len)
				if(round.first_vote_value[id] > round.first_vote_value[options[i]])
					options.Insert(i, id)
					options[id] = round.options[id]
					continue
				options[id] = round.options[id]
		for(var/i in options)
			. += "Choice ID [i] - [round.options[i]] - First pick votes [round.first_vote_value[i]] - Total vote value [round.total_vote_value[i]]"
		. += "ELIMINATED: Choice ID [round.eliminated_id] - [round.options[round.eliminated_id]]"
	var/list/L = .
	L.Join("<br>")

/client/proc/irv_poll_tally()
	set name = "Poll Tally - IRV"
	set category = "Server"
	var/id = input("Enter poll ID.", "Poll ID") as num|null
	if(!isnum(id))
		return
	var/datum/browser/popup = new(mob, "polltally", "polltally", 900, 600)
	popup.set_content(basic_IRV_poll_tally(id))
	popup.open()

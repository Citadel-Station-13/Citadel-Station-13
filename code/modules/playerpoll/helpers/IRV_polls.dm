//All poll/option ids in this file will be as text unless otherwise specified, for list operations!
//All vote values will be understandably as numbers unless otherwise specified, for math operations!
/proc/DB_IRV_poll_options_by_id(pollid)
	. = "ERROR"
	pollid = text2num(pollid)		//prevent injection
	if(!isnum(pollid))
		return
	var/datum/DBQuery/query_irv_options = SSdbcore.NewQuery("SELECT id, text FROM [format_table_name("poll_option")] WHERE pollid = [pollid]")
	if(!query_irv_options.warn_execute())
		qdel(query_irv_options)
		return
	. = list()
	while(query_irv_options.NextRow())
		var/id = text2num(query_irv_options.item[1])
		var/text = query_irv_options.item[2]
		.["[id]"] = text

#define ELIMINATION_ERROR "ELIMINATION_ERROR"
#define ELIMINATION_COMPLETE "ELIMINATION_COMPLETE"
#define ELIMINATION_CONTINUE "ELIMINATION_CONTINUE"
#define RETURN_ERROR return "ERROR IN [__FILE__] [__LINE__]"
#define RETURN_SUCCESS return TRUE

//Note: We will not add helpers to get individual ckey votes due to confidentiality, so the tally will have to be a large proc to do it all in one.
/datum/IRV_poll_tally_round
	var/list/options = list()		//option id = text
	var/total_vote_value = list()	//option id = val
	var/first_vote_value = list()	//option id = val
	var/eliminated_id				//option id

/datum/IRV_poll_tally_round/proc/check()
	for(var/i in options)
		if(!isnum(total_vote_value[i]) || !isnum(first_vote_value[i]))
			return FALSE
		if(total_vote_value[i] <= 0 || first_vote_value[i] <= 0)
			return FALSE
	return TRUE

/datum/IRV_poll_tally_round/proc/elimination()
	if(options.len == 0 || !check())
		return ELIMINATION_ERROR
	if(options.len == 1)
		return ELIMINATION_COMPLETE
	var/loser = first_vote_value[1]
	for(var/i in first_vote_value)
		if(first_vote_value[loser] > first_vote_value[i])
			loser = i
	return loser

/datum/IRV_poll_tally
	var/id
	var/list/IRV_poll_round/rounds = list()			//simple list of rounds ordered by elimination
	var/list/initial_options = list()				//see above
	var/list/initial_total_vote_value = list()
	var/list/initial_first_vote_value = list()

/datum/IRV_poll_tally/proc/setID(id)
	id = "[id]"					//make sure it's numerical

/datum/IRV_poll_tally/proc/check()
	for(var/i in initial_options)
		if(!isnum(initial_total_vote_value[i]) || !isnum(initial_first_vote_value.Find[i]))
			return FALSE
		if(initial_total_vote_value[i] <= 0 || initial_first_vote_value[i] <= 0)
			return FALSE
	return TRUE

/datum/IRV_poll_tally/proc/Execute()
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	initial_options.Cut()
	QDEL_LIST(rounds)
	initial_total_vote_value.Cut()
	initial_first_vote_value.Cut()
	var/pollid = num2text(id)			//prevent injection
	if(!isnum(pollid))
		usr = oldusr
		RETURN_ERROR
	var/list/options = DB_IRV_poll_options_by_id(pollid)
	var/list/options_left = options.Copy()
	initial_options = options.Copy()
	for(var/i in initial_options)
		initial_total_vote_value[i] = 0
		initial_first_vote_value[i] = 0
	//Unfortunately the way we store IRV votes is ordering the vote ids in the DB so we have to process one ckey at a time.
	var/list/ckeys = list()			//internally fetch and store the ckeys
	var/datum/DBQuery/query_irv_get_ckeys = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("poll_vote")] WHERE pollid = [pollid]")
	if(!query_irv_get_ckeys.warn_execute())
		qdel(query_irv_get_ckeys)
		usr = oldusr
		RETURN_ERROR
	while(query_irv_get_ckeys.NextRow())
		ckeys.Add(query_irv_get_ckeys.item[1])
	//Now individually grab votes for each ckey and orderize them.
	var/list/results_by_ckey = list()			//ckey = list(first pick, second pick, third pick, ...)
	for(var/ckey in ckeys)
		var/datum/DBQuery/query_irv_get_votes = SSdbcore.NewQuery("SELECT optionid FROM [format_table_name("poll_vote")] WHERE pollid = [id] AND ckey = '[ckey]'")
		if(!query_irv_get_votes.warn_execute())
			qdel(query_irv_get_votes)
			usr = oldusr
			RETURN_ERROR
		var/list/votedfor = list()
		while(query_irv_get_votes.NextRow())
			votedfor.Add(text2num(query_irv_get_votes.item[1]))
		if(votedfor.len <= 0)
			continue
		qdel(query_irv_get_votes)
		var/firstpick = votedfor[1]
		if(initial_first_vote_value.Find("[firstpick]"))
			initial_first_vote_value["[firstpick]"]++
		for(var/i in 1 to votedfor.len)
			var/option = votedfor[i]
			var/value = initial_options.len - i + 1
			initial_total_vote_value["[option]"] += value
		for(var/i in 1 to votedfor.len)						//textify things
			votedfor[i] = "[i]"
		results_by_ckey[ckey] = votedfor
	//Elimination rounds
	if(!check())
		usr = oldusr
		RETURN_ERROR
	var/retval = ELIMINATION_ERROR
	//First round
	var/datum/IRV_poll_tally_round/firstround = new
	firstround.options = initial_options.Copy()
	firstround.total_vote_value = initial_total_vote_value.Copy()
	firstround.first_vote_value = initial_first_vote_value.Copy()
	retval = firstround.elimination()
	if(retval == ELIMINATION_ERROR)
		usr = oldusr
		RETURN_ERROR
	if(retval == ELIMINATION_COMPLETE)
		usr = oldusr
		RETURN_SUCCESS
	//Continuous rounds
	do
		var/datum/IRV_poll_tally_round/lastround = rounds[rounds.len]
		var/loser_id = lastround.eliminated_id
		for(var/ckey in results_by_ckey)		//remove the loser
			var/list/L = results_by_ckey[ckey]
			L -= loser_id
		options_left -= L
		var/list/current_total_vote_value = list()		//get the current values
		var/list/current_first_vote_value = list()
		for(var/id in options_left)
			current_total_vote_value[id] = 0
			current_first_vote_value[id] = 0
		for(var/ckey in results_by_ckey)
			var/list/results = results_by_ckey[ckey]
			if(results.len <= 0)
				continue
			current_first_vote_value[results[1]]++
			for(var/i in 1 to L.len)
				current_total_vote_value[L[i]] += (initial_options.len - i + 1)
		var/datum/IRV_poll_tally_round/currentround = new
		currentround.options = options_left.Copy()
		currentround.total_vote_value = current_total_vote_value.Copy()
		currentround.first_vote_value = current_first_vote_value.Copy()
		retval = currentround.elimination()
	while(ratval == ELIMINATION_CONTINUE)
	if(!check())
		usr = oldusr
		RETURN_ERROR
	if(retval != ELIMINATION_COMPLETE)
		usr = oldusr
		RETURN_ERROR
	usr = oldusr
	RETURN_SUCCESS

#undef ELIMINATION_ERROR
#undef ELIMINATION_COMPLETE
#undef ELIMINATION_CONTINUE
#undef RETURN_ERROR
#undef RETURN_SUCCESS

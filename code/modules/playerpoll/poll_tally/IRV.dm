//All poll/option ids in this file will be as text unless otherwise specified, for list operations!
//All vote values will be understandably as numbers unless otherwise specified, for math operations!

//This entire system needs to be refactored to /datum/poll_tally later to support universal filtering

#define ELIMINATION_ERROR "ELIMINATION_ERROR"
#define ELIMINATION_COMPLETE "ELIMINATION_COMPLETE"
#define ELIMINATION_CONTINUE "ELIMINATION_CONTINUE"
#define RETURN_SUCCESS return TRUE

//Note: We will not add helpers to get individual ckey votes due to confidentiality, so the tally will have to be a large proc to do it all in one.
/datum/IRV_poll_tally_round
	var/list/options = list()		//option id = text
	var/total_vote_value = list()	//option id = val
	var/first_vote_value = list()	//option id = val
	var/eliminated_id				//option id

/datum/IRV_poll_tally_round/proc/elimination()
	if(options.len == 0)
		return ELIMINATION_ERROR
	if(options.len == 1)
		return ELIMINATION_COMPLETE
	var/loser = first_vote_value[1]
	for(var/i in first_vote_value)
		if(first_vote_value[loser] > first_vote_value[i])
			loser = i
		else if(first_vote_value[loser] == first_vote_value[i])
			if(total_vote_value[loser] > total_vote_value[i])		//i don't know how this'd work but uhhh
				loser = i
	eliminated_id = loser
	return ELIMINATION_CONTINUE

/datum/IRV_poll_tally
	var/id
	var/list/datum/IRV_poll_tally_round/rounds = list()			//simple list of rounds ordered by elimination
	var/list/initial_options = list()				//see above
	var/list/force_eliminations			//forcefully eliminate these first.
	var/list/initial_total_vote_value = list()
	var/list/initial_first_vote_value = list()

/datum/IRV_poll_tally/New(id)
	if(!isnull(id))
		setID(id)

/datum/IRV_poll_tally/proc/setID(id)
	if(!isnum(id))
		id = text2num(id)					//make sure it's numerical
		if(!isnum(id))
			return
	src.id = id

/datum/IRV_poll_tally/proc/Execute()
	var/list/force_eliminations = islist(src.force_eliminations)? src.force_eliminations.Copy() : list()
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	initial_options.Cut()
	QDEL_LIST(rounds)
	initial_total_vote_value.Cut()
	initial_first_vote_value.Cut()
	var/pollid = id			//prevent injection
	if(!isnum(pollid))
		pollid = text2num(pollid)
		if(!isnum(pollid))
			usr = oldusr
			RETURN_ERROR
	initial_options = DB_IRV_poll_options_by_id(pollid)
	var/list/options_left = initial_options.Copy()
	for(var/i in initial_options)
		initial_total_vote_value[i] = 0
		initial_first_vote_value[i] = 0
	if(force_eliminations)
		for(var/i in force_eliminations)
			if(!initial_options[i])
				force_eliminations -= i
				src.force_eliminations -= i
	//Unfortunately the way we store IRV votes is ordering the vote ids in the DB so we have to process one ckey at a time.
	var/list/ckeys = list()			//internally fetch and store the ckeys
	var/datum/DBQuery/query_irv_get_ckeys = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("poll_vote")] WHERE pollid = [pollid]")
	if(!query_irv_get_ckeys.warn_execute())
		qdel(query_irv_get_ckeys)
		usr = oldusr
		RETURN_ERROR
	while(query_irv_get_ckeys.NextRow())
		ckeys |= query_irv_get_ckeys.item[1]
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
			votedfor.Add(query_irv_get_votes.item[1])
		if(votedfor.len <= 0)
			continue
		qdel(query_irv_get_votes)
		var/firstpick = votedfor[1]
		if(initial_first_vote_value.Find(firstpick))
			initial_first_vote_value[firstpick]++
		for(var/i in 1 to votedfor.len)
			var/option = votedfor[i]
			var/value = initial_options.len - i + 1
			initial_total_vote_value[option] += value
		results_by_ckey[ckey] = votedfor
	//Elimination rounds
	var/retval = ELIMINATION_CONTINUE
	var/safety = 254
	var/list/current_first_vote_value = initial_first_vote_value.Copy()
	while((safety-- >= 1))
		var/datum/IRV_poll_tally_round/cround = new
		rounds += cround
		cround.total_vote_value = initial_total_vote_value.Copy()
		cround.first_vote_value = current_first_vote_value.Copy()
		cround.options = options_left.Copy()
		var/loser
		if(force_eliminations && force_eliminations.len)
			retval = ELIMINATION_CONTINUE
			loser = force_eliminations[force_eliminations.len]
			cround.eliminated_id = loser
			force_eliminations.len--
		else
			retval = cround.elimination()
			loser = cround.eliminated_id
		if(retval == ELIMINATION_ERROR)
			usr = oldusr
			RETURN_ERROR
		else if(retval == ELIMINATION_COMPLETE)
			usr = oldusr
			RETURN_SUCCESS
		else if(retval != ELIMINATION_CONTINUE)
			usr = oldusr
			RETURN_ERROR
		if(!loser)
			usr = oldusr
			RETURN_ERROR
		options_left -= loser
		current_first_vote_value.Cut()
		for(var/id in options_left)
			current_first_vote_value[id] = 0
		for(var/ckey in results_by_ckey)
			var/list/results = results_by_ckey[ckey]
			var/pos = results.Find(loser)
			if(pos)
				results.Cut(pos, pos + 1)
			current_first_vote_value[results[1]]++
	usr = oldusr
	RETURN_ERROR

#undef ELIMINATION_ERROR
#undef ELIMINATION_COMPLETE
#undef ELIMINATION_CONTINUE
#undef RETURN_SUCCESS

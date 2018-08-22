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
		.["id"] = text

#define ELIMINATION_ERROR "ELIMINATION_ERROR"
#define ELIMINATION_COMPLETE "ELIMINATION_COMPLETE"

//Note: We will not add helpers to get individual ckey votes due to confidentiality, so the tally will have to be a large proc to do it all in one.
/datum/IRV_poll_round
	var/options = list()			//option id = text
	var/total_vote_value = list()	//option id = val
	var/first_vote_value = list()	//option id = val
	var/eliminated_id				//option id

/datum/IRV_poll_round/proc/check()
	for(var/i in options)
		if(!isnum(total_vote_value[i]) || !isnum(first_vote_value[i]))
			return FALSE
		if(total_vote_value[i] <= 0 || first_vote_value[i] <= 0)
			return FALSE
	return TRUE

/datum/IRV_poll_round/proc/elimination()
	if(options.len == 0 || !check())
		return ELIMINATION_ERROR
	if(options.len == 1)
		return ELIMINATION_COMPLETE
	var/loser = first_vote_value[1]
	for(var/i in first_vote_value)
		if(first_vote_value[loser] > first_vote_value[i])
			loser = i
	return loser

/datum/IRV_poll
	var/id
	var/list/IRV_poll_round/rounds = list()
	var/list/initial_options = list()				//see above
	var/list/initial_total_vote_value = list()
	var/list/initial_first_vote_value = list()

/datum/IRV_poll/proc/setID(id)
	id = "[id]"					//make sure it's numerical

/datum/IRV_poll/proc/check()
	for(var/i in initial_options)
		if(!isnum(initial_total_vote_value[i]) || !isnum(initial_first_vote_value.Find[i]))
			return FALSE
		if(initial_total_vote_value[i] <= 0 || initial_first_vote_value[i] <= 0)
			return FALSE
	return TRUE

/datum/IRV_poll/proc/Initialize()		//grab the initial stuff from DB
	var/pollid = num2text(id)			//prevent injection
	if(!isnum(pollid))
		return
	var/list/options = DB_IRV_poll_options_by_id(pollid)

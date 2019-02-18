GENERAL_PROTECT_DATUM(/datum/playerpoll)

/datum/player_poll
	var/id				//SQL PollID primary key
	var/name			//name/title
	var/polltype
	var/list/datum/poll_option/options
	var/starttime
	var/endtime
	var/adminonly


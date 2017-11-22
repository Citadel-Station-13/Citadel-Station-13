SUBSYSTEM_DEF(blackbox)
	name = "Blackbox"
	wait = 6000
	flags = SS_NO_TICK_CHECK
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = INIT_ORDER_BLACKBOX

	var/list/msg_common = list()
	var/list/msg_science = list()
	var/list/msg_command = list()
	var/list/msg_medical = list()
	var/list/msg_engineering = list()
	var/list/msg_security = list()
	var/list/msg_deathsquad = list()
	var/list/msg_syndicate = list()
	var/list/msg_service = list()
	var/list/msg_cargo = list()
	var/list/msg_other = list()

	var/list/feedback = list()	//list of datum/feedback_variable
	var/triggertime = 0
	var/sealed = FALSE	//time to stop tracking stats?


/datum/controller/subsystem/blackbox/Initialize()
	triggertime = world.time
	. = ..()

//poll population
/datum/controller/subsystem/blackbox/fire()
	if(!SSdbcore.Connect())
		return
	var/playercount = 0
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			playercount += 1
	var/admincount = GLOB.admins.len
	var/datum/DBQuery/query_record_playercount = SSdbcore.NewQuery("INSERT INTO [format_table_name("legacy_population")] (playercount, admincount, time, server_ip, server_port, round_id) VALUES ([playercount], [admincount], '[SQLtime()]', INET_ATON(IF('[world.internet_address]' LIKE '', '0', '[world.internet_address]')), '[world.port]', '[GLOB.round_id]')")
	query_record_playercount.Execute()

	if(CONFIG_GET(flag/use_exp_tracking))
		if((triggertime < 0) || (world.time > (triggertime +3000)))	//subsystem fires once at roundstart then once every 10 minutes. a 5 min check skips the first fire. The <0 is midnight rollover check
			update_exp(10,FALSE)


/datum/controller/subsystem/blackbox/Recover()
	msg_common = SSblackbox.msg_common
	msg_science = SSblackbox.msg_science
	msg_command = SSblackbox.msg_command
	msg_medical = SSblackbox.msg_medical
	msg_engineering = SSblackbox.msg_engineering
	msg_security = SSblackbox.msg_security
	msg_deathsquad = SSblackbox.msg_deathsquad
	msg_syndicate = SSblackbox.msg_syndicate
	msg_service = SSblackbox.msg_service
	msg_cargo = SSblackbox.msg_cargo
	msg_other = SSblackbox.msg_other

	feedback = SSblackbox.feedback

	sealed = SSblackbox.sealed

//no touchie
/datum/controller/subsystem/blackbox/can_vv_get(var_name)
	if(var_name == "feedback")
		return FALSE
	return ..()

/datum/controller/subsystem/blackbox/vv_edit_var(var_name, var_value)
	return FALSE

/datum/controller/subsystem/blackbox/Shutdown()
	sealed = FALSE
	set_val("ahelp_unresolved", GLOB.ahelp_tickets.active_tickets.len)

	var/pda_msg_amt = 0
	var/rc_msg_amt = 0

	for (var/obj/machinery/message_server/MS in GLOB.message_servers)
		if (MS.pda_msgs.len > pda_msg_amt)
			pda_msg_amt = MS.pda_msgs.len
		if (MS.rc_msgs.len > rc_msg_amt)
			rc_msg_amt = MS.rc_msgs.len

	set_details("radio_usage","")

	add_details("radio_usage","COM-[msg_common.len]")
	add_details("radio_usage","SCI-[msg_science.len]")
	add_details("radio_usage","HEA-[msg_command.len]")
	add_details("radio_usage","MED-[msg_medical.len]")
	add_details("radio_usage","ENG-[msg_engineering.len]")
	add_details("radio_usage","SEC-[msg_security.len]")
	add_details("radio_usage","DTH-[msg_deathsquad.len]")
	add_details("radio_usage","SYN-[msg_syndicate.len]")
	add_details("radio_usage","SRV-[msg_service.len]")
	add_details("radio_usage","CAR-[msg_cargo.len]")
	add_details("radio_usage","OTH-[msg_other.len]")
	add_details("radio_usage","PDA-[pda_msg_amt]")
	add_details("radio_usage","RC-[rc_msg_amt]")

	if (!SSdbcore.Connect())
		return

	var/list/sqlrowlist = list()

	for (var/datum/feedback_variable/FV in feedback)
		sqlrowlist += list(list("time" = "Now()", "round_id" = GLOB.round_id, "var_name" =  "'[sanitizeSQL(FV.get_variable())]'", "var_value" = FV.get_value(), "details" = "'[sanitizeSQL(FV.get_details())]'"))

	if (!length(sqlrowlist))
		return

	SSdbcore.MassInsert(format_table_name("feedback"), sqlrowlist, ignore_errors = TRUE, delayed = TRUE)


/datum/controller/subsystem/blackbox/proc/LogBroadcast(blackbox_msg, freq)
	if(sealed)
		return
	switch(freq)
		if(1459)
			msg_common += blackbox_msg
		if(1351)
			msg_science += blackbox_msg
		if(1353)
			msg_command += blackbox_msg
		if(1355)
			msg_medical += blackbox_msg
		if(1357)
			msg_engineering += blackbox_msg
		if(1359)
			msg_security += blackbox_msg
		if(1441)
			msg_deathsquad += blackbox_msg
		if(1213)
			msg_syndicate += blackbox_msg
		if(1349)
			msg_service += blackbox_msg
		if(1347)
			msg_cargo += blackbox_msg
		else
			msg_other += blackbox_msg

/datum/controller/subsystem/blackbox/proc/find_feedback_datum(variable)
	for(var/datum/feedback_variable/FV in feedback)
		if(FV.get_variable() == variable)
			return FV

	var/datum/feedback_variable/FV = new(variable)
	feedback += FV
	return FV
<<<<<<< HEAD

/datum/controller/subsystem/blackbox/proc/set_val(variable, value)
	if(sealed)
=======
/*
feedback data can be recorded in 5 formats:
"text"
	used for simple single-string records i.e. the current map
	further calls to the same key will append saved data unless the overwrite argument is true or it already exists
	when encoded calls made with overwrite will lack square brackets
	calls: 	SSblackbox.record_feedback("text", "example", 1, "sample text")
			SSblackbox.record_feedback("text", "example", 1, "other text")
	json: {"data":["sample text","other text"]}
"amount"
	used to record simple counts of data i.e. the number of ahelps recieved
	further calls to the same key will add or subtract (if increment argument is a negative) from the saved amount
	calls:	SSblackbox.record_feedback("amount", "example", 8)
			SSblackbox.record_feedback("amount", "example", 2)
	json: {"data":10}
"tally"
	used to track the number of occurances of multiple related values i.e. how many times each type of gun is fired
	further calls to the same key will:
	 	add or subtract from the saved value of the data key if it already exists
		append the key and it's value if it doesn't exist
	calls:	SSblackbox.record_feedback("tally", "example", 1, "sample data")
			SSblackbox.record_feedback("tally", "example", 4, "sample data")
			SSblackbox.record_feedback("tally", "example", 2, "other data")
	json: {"data":{"sample data":5,"other data":2}}
"nested tally"
	used to track the number of occurances of structured semi-relational values i.e. the results of arcade machines
	similar to running total, but related values are nested in a multi-dimensional array built
	the final element in the data list is used as the tracking key, all prior elements are used for nesting
	all data list elements must be strings
	further calls to the same key will:
	 	add or subtract from the saved value of the data key if it already exists in the same multi-dimensional position
		append the key and it's value if it doesn't exist
	calls: 	SSblackbox.record_feedback("nested tally", "example", 1, list("fruit", "orange", "apricot"))
			SSblackbox.record_feedback("nested tally", "example", 2, list("fruit", "orange", "orange"))
			SSblackbox.record_feedback("nested tally", "example", 3, list("fruit", "orange", "apricot"))
			SSblackbox.record_feedback("nested tally", "example", 10, list("fruit", "red", "apple"))
			SSblackbox.record_feedback("nested tally", "example", 1, list("vegetable", "orange", "carrot"))
	json: {"data":{"fruit":{"orange":{"apricot":4,"orange":2},"red":{"apple":10}},"vegetable":{"orange":{"carrot":1}}}}
	tracking values associated with a number can't merge with a nesting value, trying to do so will append the list
	call:	SSblackbox.record_feedback("nested tally", "example", 3, list("fruit", "orange"))
	json: {"data":{"fruit":{"orange":{"apricot":4,"orange":2},"red":{"apple":10},"orange":3},"vegetable":{"orange":{"carrot":1}}}}
"associative"
	used to record text that's associated with a value i.e. coordinates
	further calls to the same key will append a new list to existing data
	calls:	SSblackbox.record_feedback("associative", "example", 1, list("text" = "example", "path" = /obj/item, "number" = 4))
			SSblackbox.record_feedback("associative", "example", 1, list("number" = 7, "text" = "example", "other text" = "sample"))
	json: {"data":{"1":{"text":"example","path":"/obj/item","number":"4"},"2":{"number":"7","text":"example","other text":"sample"}}}

Versioning
	If the format of a feedback variable is ever changed, i.e. how many levels of nesting are used or a new type of data is added to it, add it to the versions list
	When feedback is being saved if a key is in the versions list the value specified there will be used, otherwise all keys are assumed to be version = 1
	versions is an associative list, remember to use the same string in it as defined on a feedback variable, example:
	list/versions = list("round_end_stats" = 4,
						"admin_toggle" = 2,
						"gun_fired" = 2)
*/
/datum/controller/subsystem/blackbox/proc/record_feedback(key_type, key, increment, data, overwrite)
	if(sealed || !key_type || !istext(key) || !isnum(increment || !data))
>>>>>>> b078af7... fixes blackbox runtime and adds note about nested tally strings
		return
	var/datum/feedback_variable/FV = find_feedback_datum(variable)
	FV.set_value(value)

/datum/controller/subsystem/blackbox/proc/inc(variable, value)
	if(sealed)
		return
	var/datum/feedback_variable/FV = find_feedback_datum(variable)
	FV.inc(value)

/datum/controller/subsystem/blackbox/proc/dec(variable,value)
	if(sealed)
		return
	var/datum/feedback_variable/FV = find_feedback_datum(variable)
	FV.dec(value)

/datum/controller/subsystem/blackbox/proc/set_details(variable,details)
	if(sealed)
		return
	var/datum/feedback_variable/FV = find_feedback_datum(variable)
	FV.set_details(details)

/datum/controller/subsystem/blackbox/proc/add_details(variable,details)
	if(sealed)
		return
	var/datum/feedback_variable/FV = find_feedback_datum(variable)
	FV.add_details(details)

/datum/controller/subsystem/blackbox/proc/ReportDeath(mob/living/L)
	if(sealed)
		return
	if(!SSdbcore.Connect())
		return
	if(!L || !L.key || !L.mind)
		return
	var/area/placeofdeath = get_area(L)
	var/sqlname = sanitizeSQL(L.real_name)
	var/sqlkey = sanitizeSQL(L.ckey)
	var/sqljob = sanitizeSQL(L.mind.assigned_role)
	var/sqlspecial = sanitizeSQL(L.mind.special_role)
	var/sqlpod = sanitizeSQL(placeofdeath.name)
	var/laname = sanitizeSQL(L.lastattacker)
	var/lakey = sanitizeSQL(L.lastattackerckey)
	var/sqlbrute = sanitizeSQL(L.getBruteLoss())
	var/sqlfire = sanitizeSQL(L.getFireLoss())
	var/sqlbrain = sanitizeSQL(L.getBrainLoss())
	var/sqloxy = sanitizeSQL(L.getOxyLoss())
	var/sqltox = sanitizeSQL(L.getToxLoss())
	var/sqlclone = sanitizeSQL(L.getCloneLoss())
	var/sqlstamina = sanitizeSQL(L.getStaminaLoss())
	var/x_coord = sanitizeSQL(L.x)
	var/y_coord = sanitizeSQL(L.y)
	var/z_coord = sanitizeSQL(L.z)
	var/last_words = sanitizeSQL(L.last_words)
	var/suicide = sanitizeSQL(L.suiciding)
	var/map = sanitizeSQL(SSmapping.config.map_name)
	var/datum/DBQuery/query_report_death = SSdbcore.NewQuery("INSERT INTO [format_table_name("death")] (pod, x_coord, y_coord, z_coord, mapname, server_ip, server_port, round_id, tod, job, special, name, byondkey, laname, lakey, bruteloss, fireloss, brainloss, oxyloss, toxloss, cloneloss, staminaloss, last_words, suicide) VALUES ('[sqlpod]', '[x_coord]', '[y_coord]', '[z_coord]', '[map]', INET_ATON(IF('[world.internet_address]' LIKE '', '0', '[world.internet_address]')), '[world.port]', [GLOB.round_id], '[SQLtime()]', '[sqljob]', '[sqlspecial]', '[sqlname]', '[sqlkey]', '[laname]', '[lakey]', [sqlbrute], [sqlfire], [sqlbrain], [sqloxy], [sqltox], [sqlclone], [sqlstamina], '[last_words]', [suicide])")
	query_report_death.Execute()

/datum/controller/subsystem/blackbox/proc/Seal()
	if(sealed)
		return
	if(IsAdminAdvancedProcCall())
		var/msg = "[key_name_admin(usr)] sealed the blackbox!"
		message_admins(msg)
	log_game("Blackbox sealed[IsAdminAdvancedProcCall() ? " by [key_name(usr)]" : ""].")
	sealed = TRUE

//feedback variable datum, for storing all kinds of data
/datum/feedback_variable
	var/variable
	var/value
	var/list/details

/datum/feedback_variable/New(param_variable, param_value = 0)
	variable = param_variable
	value = param_value

/datum/feedback_variable/proc/inc(num = 1)
	if (isnum(value))
		value += num
	else
		value = text2num(value)
		if (isnum(value))
			value += num
		else
			value = num

/datum/feedback_variable/proc/dec(num = 1)
	if (isnum(value))
		value -= num
	else
		value = text2num(value)
		if (isnum(value))
			value -= num
		else
			value = -num

/datum/feedback_variable/proc/set_value(num)
	if (isnum(num))
		value = num

/datum/feedback_variable/proc/get_value()
	if (!isnum(value))
		return 0
	return value

/datum/feedback_variable/proc/get_variable()
	return variable

/datum/feedback_variable/proc/set_details(deets)
	details = list("\"[deets]\"")

/datum/feedback_variable/proc/add_details(deets)
	if (!details)
		set_details(deets)
	else
		details += "\"[deets]\""

/datum/feedback_variable/proc/get_details()
	return details ? details.Join(" | ") : null

/datum/feedback_variable/proc/get_parsed()
	return list(variable,value,details.Join(" | "))

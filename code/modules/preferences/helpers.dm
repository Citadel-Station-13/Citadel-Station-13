// Helper functions

/**
 * Tell someone why they're jobbanned from a job
 */
/datum/preferences/proc/jobbancheck(job, mob/user = parent?.mob)
	var/datum/db_query/query_get_jobban = SSdbcore.NewQuery({"
		SELECT reason, bantime, duration, expiration_time, IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey)
		FROM [format_table_name("ban")] WHERE ckey = :ckey AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned) AND job = :job
		"}, list("ckey" = ckey, "job" = job))
	if(!query_get_jobban.warn_execute())
		qdel(query_get_jobban)
		return
	if(query_get_jobban.NextRow())
		var/reason = query_get_jobban.item[1]
		var/bantime = query_get_jobban.item[2]
		var/duration = query_get_jobban.item[3]
		var/expiration_time = query_get_jobban.item[4]
		var/admin_key = query_get_jobban.item[5]
		var/text
		text = "<span class='redtext'>You, or another user of this computer, ([user.key]) is banned from playing [job]. The ban reason is:<br>[reason]<br>This ban was applied by [admin_key] on [bantime]"
		if(text2num(duration) > 0)
			text += ". The ban is for [duration] minutes and expires on [expiration_time] (server time)"
		text += ".</span>"
		to_chat(user, text, confidential = TRUE)
	qdel(query_get_jobban)

/**
 * Randomizes a character.
 */
/datum/preferences/proc/random_character(randomize_name = TRUE, randomize_gender = TRUE, randomize_species = TRUE, randomize_body = TRUE, randomize_underwear = TRUE, randomize_genitals = TRUE)
#warn implement
#warn call 3 stage randomization procs on collections
	var/list/collections = SScharacter_setup.collections
	for(var/datum/preferences_collection/C in collections)
		C.randomize_character_stage_1(src)
	for(var/datum/preferences_collection/C in collections)
		C.randomize_character_stage_2(src)
	for(var/datum/preferences_collection/C in collections)
		C.randomize_character_stage_3(src)
/*
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	underwear = random_underwear(gender)
	undie_color = random_short_color()
	undershirt = random_undershirt(gender)
	shirt_color = random_short_color()
	socks = random_socks()
	socks_color = random_short_color()
	use_custom_skin_tone = FALSE
	skin_tone = random_skin_tone()
	hair_style = random_hair_style(gender)
	facial_hair_style = random_facial_hair_style(gender)
	hair_color = random_short_color()
	facial_hair_color = hair_color
	var/random_eye_color = random_eye_color()
	left_eye_color = random_eye_color
	right_eye_color = random_eye_color
	if(!pref_species)
		var/rando_race = pick(GLOB.roundstart_races)
		pref_species = new rando_race()
	features = random_features(pref_species?.id, gender)
	age = rand(AGE_MIN,AGE_MAX)
*/

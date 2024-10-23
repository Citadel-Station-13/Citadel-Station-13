///Cooldown for the Reset Lobby Menu HUD verb
#define RESET_HUD_INTERVAL 15 SECONDS
/mob/dead/new_player
	var/ready = 0
	///Referenced when you want to delete the new_player later on in the code.
	var/spawning = 0

	flags_1 = NONE

	invisibility = INVISIBILITY_ABSTRACT

	density = FALSE
	stat = DEAD
	hud_type = /datum/hud/new_player
	hud_possible = list()

	///For instant transfer once the round is set up
	var/mob/living/new_character

	///Used to make sure someone doesn't get spammed with messages if they're ineligible for roles
	var/ineligible_for_roles = FALSE

	///Is there a result we want to read from the age gate
	var/age_gate_result
	///Cooldown for the Reset Lobby Menu HUD verb
	COOLDOWN_DECLARE(reset_hud_cooldown)

/mob/dead/new_player/Initialize(mapload)
	if(client && SSticker.state == GAME_STATE_STARTUP)
		var/atom/movable/screen/splash/S = new(client, TRUE, TRUE)
		S.Fade(TRUE)

	if(length(GLOB.newplayer_start))
		forceMove(pick(GLOB.newplayer_start))
	else
		forceMove(locate(1,1,1))

	ComponentInitialize()

	. = ..()

	GLOB.new_player_list += src
	add_verb(src, /mob/dead/new_player/proc/reset_menu_hud)

/mob/dead/new_player/Destroy()
	GLOB.new_player_list -= src

	return ..()

/mob/dead/new_player/prepare_huds()
	return

/mob/dead/new_player/proc/age_gate()
	var/list/dat = list("<center>")
	dat += "Enter your date of birth here, to confirm that you are over 18.<BR>"
	dat += "<b>Your date of birth is not saved, only the fact that you are over/under 18 is.</b><BR>"
	dat += "</center>"

	dat += "<form action='?src=[REF(src)]'>"
	dat += "<input type='hidden' name='src' value='[REF(src)]'>"
	dat += HrefTokenFormField()
	dat += "<select name = 'Month'>"
	var/monthList = list("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5, "June" = 6, "July" = 7, "August" = 8, "September" = 9, "October" = 10, "November" = 11, "December" = 12)
	for(var/month in monthList)
		dat += "<option value = [monthList[month]]>[month]</option>"
	dat += "</select>"
	dat += "<select name = 'Year' style = 'float:right'>"
	var/current_year = text2num(time2text(world.realtime, "YYYY"))
	var/start_year = 1920
	for(var/year in start_year to current_year)
		var/reverse_year = 1920 + (current_year - year)
		dat += "<option value = [reverse_year]>[reverse_year]</option>"
	dat += "</select>"
	dat += "<center><input type='submit' value='Submit information'></center>"
	dat += "</form>"

	winshow(src, "age_gate", TRUE)
	var/datum/browser/popup = new(src, "age_gate", "<div align='center'>Age Gate</div>", 400, 250)
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(src, "age_gate")

	while(age_gate_result == null)
		stoplag(1)

	popup.close()

	return age_gate_result

/mob/dead/new_player/proc/age_verify()
	if(CONFIG_GET(flag/age_verification) && !check_rights_for(client, R_ADMIN) && !(client.ckey in GLOB.bunker_passthrough)) //make sure they are verified
		if(!client.set_db_player_flags())
			message_admins("Blocked [src] from new player panel because age gate could not access player database flags.")
			return FALSE

		if(!(client.prefs.db_flags & DB_FLAG_AGE_CONFIRMATION_INCOMPLETE)) //completed? Skip
			return TRUE

		if(!client)
			return FALSE

		var/age_verification = age_gate()
		//ban them and kick them
		if(age_verification != 1)
			// this isn't code, this is paragraphs.
			var/player_ckey = ckey(client.ckey)
			// record all admins and non-admins online at the time
			var/list/clients_online = GLOB.clients.Copy()
			var/list/admins_online = GLOB.admins.Copy() //list() // remove the GLOB.admins.Copy() and the comments if you want the pure admins_online check
			// for(var/client/C in clients_online)
			// 	if(C.holder) //deadmins aren't included since they wouldn't show up on adminwho
			// 		admins_online += C
			var/who = clients_online.Join(", ")
			var/adminwho = admins_online.Join(", ")

			var/datum/db_query/query_add_ban = SSdbcore.NewQuery({"
				INSERT INTO [format_table_name("ban")]
				(bantime, server_ip, server_port , round_id, bantype, reason, job, duration, expiration_time, ckey, computerid, ip, a_ckey, a_computerid, a_ip, who, adminwho)
				VALUES (Now(), INET_ATON(:server_ip), :server_port, :round_id, :bantype_str, :reason, :role, :duration, Now() + INTERVAL :duration MINUTE, :ckey, :computerid, INET_ATON(:ip), :a_ckey, :a_computerid, INET_ATON(:a_ip), :who, :adminwho)"},
				list(
					// Server info
					"server_ip" = world.internet_address || 0,
					"server_port" = world.port,
					"round_id" = GLOB.round_id,
					// Client ban info
					"bantype_str" = "ADMIN_PERMABAN",
					"reason" = "SYSTEM BAN - Inputted date during join verification was under 18 years of age. Contact administration on discord for verification.",
					"role" = null,
					"duration" = -1,
					"ckey" = player_ckey,
					"ip" = client.address || null,
					"computerid" = client.computer_id || null,
					// Admin banning info
					"a_ckey" = "SYSTEM (Automated-Age-Gate)", // the server
					"a_ip" = null, //key_name
					"a_computerid" = "0",
					"who" = who,
					"adminwho" = adminwho
				))

			client.add_system_note("Automated-Age-Gate", "Failed automatic age gate process.")
			if(!query_add_ban.Execute())
				// this is the part where you should panic.
				qdel(query_add_ban)
				message_admins("WARNING! Failed to ban [ckey] for failing the automatic age gate.")
				send2tgs_adminless_only("WARNING! Failed to ban [ckey] for failing the automatic age gate.")
				qdel(client)
				return FALSE
			qdel(query_add_ban)

			create_message("note", player_ckey, "SYSTEM (Automated-Age-Gate)", "SYSTEM BAN - Inputted date during join verification was under 18 years of age. Contact administration on discord for verification.", null, null, 0, 0, null, 0, "high")

			// announce this
			message_admins("[ckey] has been banned for failing the automatic age gate.")
			send2tgs_adminless_only("[ckey] has been banned for failing the automatic age gate.")

			// removing the client disconnects them
			qdel(client)

			return FALSE

		//they claim to be of age, so allow them to continue and update their flags
		client.update_flag_db(DB_FLAG_AGE_CONFIRMATION_COMPLETE, TRUE)
		client.update_flag_db(DB_FLAG_AGE_CONFIRMATION_INCOMPLETE, FALSE)
		//log this
		message_admins("[ckey] has joined through the automated age gate process.")

	return TRUE

/mob/dead/new_player/Topic(href, href_list[])
	if(src != usr)
		return FALSE

	if(!client)
		return FALSE

	//don't let people get to this unless they are specifically not verified
	if(href_list["Month"] && (CONFIG_GET(flag/age_verification) && !check_rights_for(client, R_ADMIN) && !(client.ckey in GLOB.bunker_passthrough)))
		var/player_month = text2num(href_list["Month"])
		var/player_year = text2num(href_list["Year"])

		var/current_time = world.realtime
		var/current_month = text2num(time2text(current_time, "MM"))
		var/current_year = text2num(time2text(current_time, "YYYY"))

		var/player_total_months = (player_year * 12) + player_month

		var/current_total_months = (current_year * 12) + current_month

		var/months_in_eighteen_years = 18 * 12

		var/month_difference = current_total_months - player_total_months
		if(month_difference > months_in_eighteen_years)
			age_gate_result = TRUE // they're fine
		else
			if(month_difference < months_in_eighteen_years)
				age_gate_result = FALSE
			else
				//they could be 17 or 18 depending on the /day/ they were born in
				var/current_day = text2num(time2text(current_time, "DD"))
				var/days_in_months = list(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
				if((player_year % 4) == 0) // leap year so february actually has 29 days
					days_in_months[2] = 29
				var/total_days_in_player_month = days_in_months[player_month]
				var/list/days = list()
				for(var/number in 1 to total_days_in_player_month)
					days += number
				var/player_day = input(src, "What day of the month were you born in.") as anything in days
				if(player_day <= current_day)
					//their birthday has passed
					age_gate_result = TRUE
				else
					//it has NOT been their 18th birthday yet
					age_gate_result = FALSE

	if(!age_verify())
		return

	if(href_list["late_join"])
		if(!SSticker || !SSticker.IsRoundInProgress())
			to_chat(usr, "<span class='danger'>The round is either not ready, or has already finished...</span>")
			return
		LateChoices()
		return

	if(href_list["SelectedJob"])
		if(!SSticker || !SSticker.IsRoundInProgress())
			var/msg = "[key_name(usr)] attempted to join the round using a href that shouldn't be available at this moment!"
			log_admin(msg)
			message_admins(msg)
			to_chat(usr, "<span class='danger'>The round is either not ready, or has already finished...</span>")
			return

		if(!GLOB.enter_allowed)
			to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
			return

		//Determines Relevent Population Cap
		var/relevant_cap
		var/hpc = CONFIG_GET(number/hard_popcap)
		var/epc = CONFIG_GET(number/extreme_popcap)
		if(hpc && epc)
			relevant_cap = min(hpc, epc)
		else
			relevant_cap = max(hpc, epc)



		if(SSticker.queued_players.len && !(ckey(key) in GLOB.admin_datums))
			if((living_player_count() >= relevant_cap) || (src != SSticker.queued_players[1]))
				to_chat(usr, "<span class='warning'>Server is full.</span>")
				return

		AttemptLateSpawn(href_list["SelectedJob"])
		return

	if(href_list["JoinAsGhostRole"])
		if(!GLOB.enter_allowed)
			to_chat(usr, "<span class='notice'> There is an administrative lock on entering the game!</span>")

		//Determines Relevent Population Cap
		var/relevant_cap
		var/hpc = CONFIG_GET(number/hard_popcap)
		var/epc = CONFIG_GET(number/extreme_popcap)
		if(hpc && epc)
			relevant_cap = min(hpc, epc)
		else
			relevant_cap = max(hpc, epc)

		if(SSticker.queued_players.len && !(ckey(key) in GLOB.admin_datums))
			if((living_player_count() >= relevant_cap) || (src != SSticker.queued_players[1]))
				to_chat(usr, "<span class='warning'>Server is full.</span>")
				return

		var/obj/effect/mob_spawn/MS = pick(GLOB.mob_spawners[href_list["JoinAsGhostRole"]])
		if(MS.attack_ghost(src, latejoinercalling = TRUE))
			SSticker.queued_players -= src
			SSticker.queue_delay = 4
			qdel(src)

	if(href_list["pollid"])
		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid) && ISINTEGER(pollid))
			src.poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		//lets take data from the user to decide what kind of poll this is, without validating it
		//what could go wrong
		switch(votetype)
			if(POLLTYPE_OPTION)
				var/optionid = text2num(href_list["voteoptionid"])
				if(vote_on_poll(pollid, optionid))
					to_chat(usr, "<span class='notice'>Vote successful.</span>")
				else
					to_chat(usr, "<span class='danger'>Vote failed, please try again or contact an administrator.</span>")
			if(POLLTYPE_TEXT)
				var/replytext = href_list["replytext"]
				if(log_text_poll_reply(pollid, replytext))
					to_chat(usr, "<span class='notice'>Feedback logging successful.</span>")
				else
					to_chat(usr, "<span class='danger'>Feedback logging failed, please try again or contact an administrator.</span>")
			if(POLLTYPE_RATING)
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
												//(protip, this stops no exploits)
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating) || !ISINTEGER(rating))
								return

						if(!vote_on_numval_poll(pollid, optionid, rating))
							to_chat(usr, "<span class='danger'>Vote failed, please try again or contact an administrator.</span>")
							return
				to_chat(usr, "<span class='notice'>Vote successful.</span>")
			if(POLLTYPE_MULTI)
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						var/i = vote_on_multi_poll(pollid, optionid)
						switch(i)
							if(0)
								continue
							if(1)
								to_chat(usr, "<span class='danger'>Vote failed, please try again or contact an administrator.</span>")
								return
							if(2)
								to_chat(usr, "<span class='danger'>Maximum replies reached.</span>")
								break
				to_chat(usr, "<span class='notice'>Vote successful.</span>")
			if(POLLTYPE_IRV)
				if (!href_list["IRVdata"])
					to_chat(src, "<span class='danger'>No ordering data found. Please try again or contact an administrator.</span>")
					return
				var/list/votelist = splittext(href_list["IRVdata"], ",")
				if (!vote_on_irv_poll(pollid, votelist))
					to_chat(src, "<span class='danger'>Vote failed, please try again or contact an administrator.</span>")
					return
				to_chat(src, "<span class='notice'>Vote successful.</span>")

/mob/dead/new_player/get_status_tab_items()
	. = ..()
	if(!SSticker.HasRoundStarted()) //only show this when the round hasn't started yet
		. += "Readiness status: [ready ? "" : "Not "]Readied Up!"

//When you cop out of the round (NB: this HAS A SLEEP FOR PLAYER INPUT IN IT)
/mob/dead/new_player/proc/make_me_an_observer()
	if(QDELETED(src) || !src.client)
		ready = PLAYER_NOT_READY
		return FALSE

	var/mintime = max(CONFIG_GET(number/respawn_delay), (SSticker.round_start_time + (CONFIG_GET(number/respawn_minimum_delay_roundstart) * 600)) - world.time, 0)

	var/this_is_like_playing_right = alert(src,"Are you sure you wish to observe? You will not be able to respawn for [round(mintime / 600, 0.1)] minutes!!","Player Setup","Yes","No")

	if(QDELETED(src) || !src.client || this_is_like_playing_right != "Yes")
		ready = PLAYER_NOT_READY
		src << browse(null, "window=playersetup") //closes the player setup window
		return FALSE

	var/mob/dead/observer/observer = new()
	spawning = TRUE

	observer.started_as_observer = TRUE
	close_spawn_windows()
	var/obj/effect/landmark/observer_start/O = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	to_chat(src, "<span class='notice'>Now teleporting.</span>")
	if (O)
		observer.forceMove(O.loc)
	else
		to_chat(src, "<span class='notice'>Teleporting failed. Ahelp an admin please</span>")
		stack_trace("There's no freaking observer landmark available on this map or you're making observers before the map is initialised")
	transfer_ckey(observer, FALSE)
	observer.client = client
	observer.client.prefs?.respawn_time_of_death = world.time
	observer.set_ghost_appearance()
	if(observer.client && observer.client.prefs)
		observer.real_name = observer.client.prefs.real_name
		observer.name = observer.real_name
		observer.client.init_verbs()
	observer.update_icon()
	observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	QDEL_NULL(mind)
	qdel(src)
	return TRUE

/proc/get_job_unavailable_error_message(retval, jobtitle)
	switch(retval)
		if(JOB_AVAILABLE)
			return "[jobtitle] is available."
		if(JOB_UNAVAILABLE_GENERIC)
			return "[jobtitle] is unavailable."
		if(JOB_UNAVAILABLE_BANNED)
			return "You are currently banned from [jobtitle]."
		if(JOB_UNAVAILABLE_PLAYTIME)
			return "You do not have enough relevant playtime for [jobtitle]."
		if(JOB_UNAVAILABLE_ACCOUNTAGE)
			return "Your account is not old enough for [jobtitle]."
		if(JOB_UNAVAILABLE_SLOTFULL)
			return "[jobtitle] is already filled to capacity."
		if(JOB_UNAVAILABLE_SPECIESLOCK)
			return "Your species cannot play as a [jobtitle]."
	return "Error: Unknown job availability."

/mob/dead/new_player/proc/IsJobUnavailable(rank, latejoin = FALSE)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)
		return JOB_UNAVAILABLE_GENERIC
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		if(job.title == "Assistant")
			if(isnum(client.player_age) && client.player_age <= 14) //Newbies can always be assistants
				return JOB_AVAILABLE
			for(var/datum/job/J in SSjob.occupations)
				if(J && J.current_positions < J.total_positions && J.title != job.title)
					return JOB_UNAVAILABLE_SLOTFULL
		else
			return JOB_UNAVAILABLE_SLOTFULL
	if(jobban_isbanned(src,rank))
		return JOB_UNAVAILABLE_BANNED
	if(QDELETED(src))
		return JOB_UNAVAILABLE_GENERIC
	if(!job.player_old_enough(client))
		return JOB_UNAVAILABLE_ACCOUNTAGE
	if(job.required_playtime_remaining(client))
		return JOB_UNAVAILABLE_PLAYTIME
	if(latejoin && !job.special_check_latejoin(client))
		return JOB_UNAVAILABLE_GENERIC
	if(!client.prefs.pref_species.qualifies_for_rank(rank, client.prefs.features))
		return JOB_UNAVAILABLE_SPECIESLOCK
	return JOB_AVAILABLE

/mob/dead/new_player/proc/AttemptLateSpawn(rank)
	var/error = IsJobUnavailable(rank)
	if(error != JOB_AVAILABLE)
		alert(src, get_job_unavailable_error_message(error, rank))
		return FALSE

	if(SSticker.late_join_disabled)
		alert(src, "An administrator has disabled late join spawning.")
		return FALSE

	if(!respawn_latejoin_check(notify = TRUE))
		return FALSE

	var/arrivals_docked = TRUE
	if(SSshuttle.arrivals)
		close_spawn_windows()	//In case we get held up
		if(SSshuttle.arrivals.damaged && CONFIG_GET(flag/arrivals_shuttle_require_safe_latejoin))
			src << alert("The arrivals shuttle is currently malfunctioning! You cannot join.")
			return FALSE

		if(CONFIG_GET(flag/arrivals_shuttle_require_undocked))
			SSshuttle.arrivals.RequireUndocked(src)
		arrivals_docked = SSshuttle.arrivals.mode != SHUTTLE_CALL

	//Remove the player from the join queue if he was in one and reset the timer
	SSticker.queued_players -= src
	SSticker.queue_delay = 4

	SSjob.AssignRole(src, rank, 1)

	var/mob/living/character = create_character(TRUE)	//creates the human and transfers vars and mind
	var/datum/job/job = SSjob.GetJob(rank)

	var/equip = SSjob.EquipRank(character, rank, TRUE)
	job.after_latejoin_spawn(character)

	if(isliving(equip))	//Borgs get borged in the equip, so we need to make sure we handle the new mob.
		character = equip

	if(job && !job.override_latejoin_spawn(character))
		SSjob.SendToLateJoin(character)
		if(!arrivals_docked)
			var/atom/movable/screen/splash/Spl = new(character.client, TRUE)
			Spl.Fade(TRUE)
			character.playsound_local(get_turf(character), 'sound/voice/ApproachingTG.ogg', 25)

	job.standard_assign_skills(character.mind)

	SSticker.minds += character.mind
	character.client.init_verbs() // init verbs for the late join
	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character	//Let's retypecast the var to be human,

	if(humanc)	//These procs all expect humans
		GLOB.data_core.manifest_inject(humanc, humanc.client, humanc.client.prefs)
		if(SSshuttle.arrivals)
			SSshuttle.arrivals.QueueAnnounce(humanc, rank)
		else
			announce_arrival(humanc, rank)
		AddEmploymentContract(humanc)
		if(GLOB.highlander)
			to_chat(humanc, "<span class='userdanger'><i>THERE CAN BE ONLY ONE!!!</i></span>")
			humanc.make_scottish()

		if(GLOB.summon_guns_triggered)
			give_guns(humanc)
		if(GLOB.summon_magic_triggered)
			give_magic(humanc)
		if(GLOB.curse_of_madness_triggered)
			give_madness(humanc, GLOB.curse_of_madness_triggered)
		if(humanc.client)
			humanc.client.prefs.post_copy_to(humanc)

	GLOB.joined_player_list += character.ckey
	GLOB.latejoiners += character
	LAZYOR(character.client.prefs.slots_joined_as, character.client.prefs.default_slot)
	LAZYOR(character.client.prefs.characters_joined_as, character.real_name)

	if(CONFIG_GET(flag/allow_latejoin_antagonists) && humanc)	//Borgs aren't allowed to be antags. Will need to be tweaked if we get true latejoin ais.
		if(SSshuttle.emergency)
			switch(SSshuttle.emergency.mode)
				if(SHUTTLE_RECALL, SHUTTLE_IDLE)
					SSticker.mode.make_antag_chance(humanc)
				if(SHUTTLE_CALL)
					if(SSshuttle.emergency.timeLeft(1) > initial(SSshuttle.emergencyCallTime)*0.5)
						SSticker.mode.make_antag_chance(humanc)

	if(humanc && CONFIG_GET(flag/roundstart_traits))
		SSquirks.AssignQuirks(humanc, humanc.client, TRUE, FALSE, job, FALSE)

	log_manifest(character.mind.key,character.mind,character,latejoin = TRUE)

/mob/dead/new_player/proc/AddEmploymentContract(mob/living/carbon/human/employee)
	//TODO:  figure out a way to exclude wizards/nukeops/demons from this.
	for(var/C in GLOB.employmentCabinets)
		var/obj/structure/filingcabinet/employment/employmentCabinet = C
		if(!employmentCabinet.virgin)
			employmentCabinet.addFile(employee)


/mob/dead/new_player/proc/LateChoices()

	var/level = "green"
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			level = "green"
		if(SEC_LEVEL_BLUE)
			level = "blue"
		if(SEC_LEVEL_AMBER)
			level = "amber"
		if(SEC_LEVEL_RED)
			level = "red"
		if(SEC_LEVEL_DELTA)
			level = "delta"

	var/dat = "<div class='notice'>Round Duration: [DisplayTimeText(world.time - SSticker.round_start_time)]<br>Alert Level: [capitalize(level)]</div>"
	if(SSshuttle.emergency)
		switch(SSshuttle.emergency.mode)
			if(SHUTTLE_ESCAPE)
				dat += "<div class='notice red'>The station has been evacuated.</div><br>"
			if(SHUTTLE_CALL)
				if(!SSshuttle.canRecall())
					dat += "<div class='notice red'>The station is currently undergoing evacuation procedures.</div><br>"
	for(var/datum/job/prioritized_job in SSjob.prioritized_jobs)
		if(prioritized_job.current_positions >= prioritized_job.total_positions)
			SSjob.prioritized_jobs -= prioritized_job
	dat += "<center><table><tr><td valign='top'>"
	var/column_counter = 0
	var/free_space = 0
	for(var/list/category in list(GLOB.command_positions) + list(GLOB.supply_positions) + list(GLOB.engineering_positions) + list(GLOB.nonhuman_positions - "pAI") + list(GLOB.civilian_positions) + list(GLOB.medical_positions) + list(GLOB.science_positions) + list(GLOB.security_positions))
		var/cat_color = "fff" //random default
		cat_color = SSjob.name_occupations[category[1]].selection_color //use the color of the first job in the category (the department head) as the category color
		dat += "<fieldset style='width: 185px; border: 2px solid [cat_color]; display: inline'>"
		dat += "<legend align='center' style='color: [cat_color]'>[SSjob.name_occupations[category[1]].exp_type_department]</legend>"

		var/list/dept_dat = list()
		for(var/job in category)
			var/datum/job/job_datum = SSjob.name_occupations[job]
			if(job_datum && IsJobUnavailable(job_datum.title, TRUE) == JOB_AVAILABLE)
				// Get currently occupied slots
				var/num_positions_current = job_datum.current_positions

				// Get total slots that can be occupied
				var/num_positions_total = job_datum.total_positions

				// Change to lemniscate for infinite-slot jobs
				// This variable should only used to display text!
				num_positions_total = (num_positions_total == -1 ? "∞" : num_positions_total)

				var/command_bold = ""
				if(job in GLOB.command_positions)
					command_bold = " command"
				if(job_datum in SSjob.prioritized_jobs)
					dept_dat += "<a class='job[command_bold]' style='display:block;width:170px'  href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'><span class='priority'>[job_datum.title] ([num_positions_current]/[num_positions_total])</span></a>"
				else
					dept_dat += "<a class='job[command_bold]' style='display:block;width:170px' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'>[job_datum.title] ([num_positions_current]/[num_positions_total])</a>"
		if(!dept_dat.len)
			dept_dat += "<span class='nopositions'>No positions open.</span>"
		dat += jointext(dept_dat, "")
		dat += "</fieldset><br>"
		column_counter++
		if(free_space <=4)
			free_space++
			if(column_counter > 0 && (column_counter % 3 == 0))
				dat += "</td><td valign='top'>"
		if(free_space >= 5 && (free_space % 5 == 0) && (column_counter % 3 != 0))
			free_space = 0
			column_counter = 0
			dat += "</td><td valign='top'>"

	dat += "</td></tr></table></center></center>"

	var/available_ghosts = 0
	for(var/spawner in GLOB.mob_spawners)
		if(!LAZYLEN(spawner))
			continue
		var/obj/effect/mob_spawn/S = pick(GLOB.mob_spawners[spawner])
		if(!istype(S) || !S.can_latejoin())
			continue
		available_ghosts++
		break

	if(!available_ghosts)
		dat += "<div class='notice red'>There are currently no open ghost spawners.</div>"
	else
		var/list/categorizedJobs = list("Ghost Role" = list(jobs = list(), titles = GLOB.mob_spawners, color = "#ffffff"))
		for(var/spawner in GLOB.mob_spawners)
			if(!LAZYLEN(spawner))
				continue
			var/obj/effect/mob_spawn/S = pick(GLOB.mob_spawners[spawner])
			if(!istype(S) || !S.can_latejoin())
				continue
			categorizedJobs["Ghost Role"]["jobs"] += spawner

		dat += "<center><table><tr><td valign='top'>"
		for(var/jobcat in categorizedJobs)
			if(!length(categorizedJobs[jobcat]["jobs"]))
				continue
			var/color = categorizedJobs[jobcat]["color"]
			dat += "<fieldset style='border: 2px solid [color]; display: inline'>"
			dat += "<legend align='center' style='color: [color]'>[jobcat]</legend>"
			for(var/spawner in categorizedJobs[jobcat]["jobs"])
				dat += "<a class='otherPosition' style='display:block;width:170px' href='byond://?src=[REF(src)];JoinAsGhostRole=[spawner]'>[spawner]</a>"

			dat += "</fieldset><br>"
		dat += "</td></tr></table></center>"
		dat += "</div></div>"

	var/datum/browser/popup = new(src, "latechoices", "Choose Profession", 720, 600)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE) // FALSE is passed to open so that it doesn't use the onclose() proc

/mob/dead/new_player/proc/create_character(transfer_after)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/H = new(loc)

	var/frn = CONFIG_GET(flag/force_random_names)
	if(!frn)
		frn = jobban_isbanned(src, "appearance")
		if(QDELETED(src))
			return
	if(frn)
		client.prefs.random_character()
		client.prefs.real_name = client.prefs.pref_species.random_name(gender,1)
	var/cur_scar_index = client.prefs.scars_index
	if(client.prefs.persistent_scars && client.prefs.scars_list["[cur_scar_index]"])
		var/scar_string = client.prefs.scars_list["[cur_scar_index]"]
		var/valid_scars = ""
		for(var/scar_line in splittext(scar_string, ";"))
			if(H.load_scar(scar_line))
				valid_scars += "[scar_line];"

		client.prefs.scars_list["[cur_scar_index]"] = valid_scars
		client.prefs.save_character()

	client.prefs.copy_to(H, initial_spawn = TRUE)
	H.dna.update_dna_identity()
	if(mind)
		if(transfer_after)
			mind.late_joiner = TRUE
		mind.active = 0					//we wish to transfer the key manually
		mind.transfer_to(H)					//won't transfer key since the mind is not active
		mind.set_original_character(H)

	H.name = real_name
	client.init_verbs()
	. = H
	new_character = .
	if(transfer_after)
		transfer_character(TRUE)

/mob/dead/new_player/proc/transfer_character(late_transfer = FALSE)
	. = new_character
	if(.)
		new_character.key = key		//Manually transfer the key to log them in
		new_character.stop_sound_channel(CHANNEL_LOBBYMUSIC)
		SEND_SIGNAL(new_character, COMSIG_MOB_CLIENT_JOINED_FROM_LOBBY, new_character?.client, late_transfer)
		new_character = null
		qdel(src)

/mob/dead/new_player/proc/ViewManifest()
	if(!client)
		return
	if(world.time < client.crew_manifest_delay)
		return
	client.crew_manifest_delay = world.time + (1 SECONDS)

	if(!GLOB.crew_manifest_tgui)
		GLOB.crew_manifest_tgui = new /datum/crew_manifest(src)

	GLOB.crew_manifest_tgui.ui_interact(src)

/mob/dead/new_player/Move()
	return FALSE


/mob/dead/new_player/proc/close_spawn_windows()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window
	src << browse(null, "window=preferences") //closes job selection
	src << browse(null, "window=mob_occupation")
	src << browse(null, "window=latechoices") //closes late job selection

/*	Used to make sure that a player has a valid job preference setup, used to knock players out of eligibility for anything if their prefs don't make sense.
	A "valid job preference setup" in this situation means at least having one job set to low, or not having "return to lobby" enabled
	Prevents "antag rolling" by setting antag prefs on, all jobs to never, and "return to lobby if preferences not availible"
	Doing so would previously allow you to roll for antag, then send you back to lobby if you didn't get an antag role
	This also does some admin notification and logging as well, as well as some extra logic to make sure things don't go wrong
*/

/mob/dead/new_player/proc/check_preferences()
	if(!client)
		return FALSE //Not sure how this would get run without the mob having a client, but let's just be safe.
	if(client.prefs.joblessrole != RETURNTOLOBBY)
		return TRUE
	// If they have antags enabled, they're potentially doing this on purpose instead of by accident. Notify admins if so.
	var/has_antags = FALSE
	if(client.prefs.be_special.len > 0)
		has_antags = TRUE
	if(client.prefs.job_preferences.len == 0)
		if(!ineligible_for_roles)
			to_chat(src, "<span class='danger'>You have no jobs enabled, along with return to lobby if job is unavailable. This makes you ineligible for any round start role, please update your job preferences.</span>")
		ineligible_for_roles = TRUE
		ready = PLAYER_NOT_READY
		if(has_antags)
			log_admin("[src.ckey] just got booted back to lobby with no jobs, but antags enabled.")
			message_admins("[src.ckey] just got booted back to lobby with no jobs enabled, but antag rolling enabled. Likely antag rolling abuse.")

		return FALSE //This is the only case someone should actually be completely blocked from antag rolling as well
	return TRUE

///Resets the Lobby Menu HUD, recreating and reassigning it to the new player
/mob/dead/new_player/proc/reset_menu_hud()
	set name = "Reset Lobby Menu HUD"
	set category = "OOC"
	var/mob/dead/new_player/new_player = usr
	if(!COOLDOWN_FINISHED(new_player, reset_hud_cooldown))
		to_chat(new_player, span_warning("You must wait <b>[DisplayTimeText(COOLDOWN_TIMELEFT(new_player, reset_hud_cooldown))]</b> before resetting the Lobby Menu HUD again!"))
		return
	if(!new_player?.client)
		return
	COOLDOWN_START(new_player, reset_hud_cooldown, RESET_HUD_INTERVAL)
	qdel(new_player.hud_used)
	create_mob_hud()
	to_chat(new_player, span_info("Lobby Menu HUD reset. You may reset the HUD again in <b>[DisplayTimeText(RESET_HUD_INTERVAL)]</b>."))
	hud_used.show_hud(hud_used.hud_version)

#undef RESET_HUD_INTERVAL

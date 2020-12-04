SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	init_order = INIT_ORDER_STATPANELS
	priority = FIRE_PRIORITY_STATPANEL
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/list/currentrun = list()
	var/encoded_global_data
	var/mc_data_encoded
	var/list/cached_images = list()

/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if (!resumed)
		var/datum/map_config/cached = SSmapping.next_map_config
		var/round_time = world.time - SSticker.round_start_time
		var/list/global_data = list(
			"Map: [SSmapping.config?.map_name || "Loading..."]",
			cached ? "Next Map: [cached.map_name]" : null,
			"Round ID: [GLOB.round_id ? GLOB.round_id : "NULL"]",
			"Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
			"Round Time: [round_time > MIDNIGHT_ROLLOVER ? "[round(round_time/MIDNIGHT_ROLLOVER)]:[worldtime2text()]" : worldtime2text()]",
			"Station Time: [STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)]",
			"Time Dilation: [round(SStime_track.time_dilation_current,1)]% AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, [round(SStime_track.time_dilation_avg,1)]%, [round(SStime_track.time_dilation_avg_slow,1)]%)"
		)

		if(SSshuttle.emergency)
			var/ETA = SSshuttle.emergency.getModeStr()
			if(ETA)
				global_data += "[ETA] [SSshuttle.emergency.getTimerStr()]"

		encoded_global_data = url_encode(json_encode(global_data))
		src.currentrun = GLOB.clients.Copy()
		mc_data_encoded = null
	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/target = currentrun[length(currentrun)]
		currentrun.len--
		if(!target.statbrowser_ready)
			continue
		if(target.stat_tab == "Status")
			var/ping_str = url_encode("Ping: [round(target.lastping, 1)]ms (Average: [round(target.avgping, 1)]ms)")
			var/other_str = url_encode(json_encode(target.mob.get_status_tab_items()))
			target << output("[encoded_global_data];[ping_str];[other_str]", "statbrowser:update")
			if(SSvote.mode)
				var/list/vote_arry = list(
					list("Vote active!", "There is currently a vote running. Question: [SSvote.question]")
					) //see the MC on how this works.
				if(!(SSvote.vote_system in list(PLURALITY_VOTING, APPROVAL_VOTING, SCHULZE_VOTING, INSTANT_RUNOFF_VOTING)))
					vote_arry[++vote_arry.len] += list("STATPANEL VOTING DISABLED!", "The current vote system is not supported by statpanel rendering. Please vote manually by opening the vote popup using the action button or chat link.", "disabled")
					//does not return.
				else
					vote_arry[++vote_arry.len] += list("Time Left:", " [DisplayTimeText(SSvote.end_time - world.time)] seconds")
					vote_arry[++vote_arry.len] += list("Choices:", "")
					for(var/choice in SSvote.choice_statclicks)
						var/choice_id = SSvote.choice_statclicks[choice]
						if(target.ckey)
							switch(SSvote.vote_system)
								if(PLURALITY_VOTING, APPROVAL_VOTING)
									var/ivotedforthis = FALSE
									if(SSvote.vote_system == APPROVAL_VOTING)
										ivotedforthis = SSvote.voted[target.ckey] && (text2num(choice_id) in SSvote.voted[target.ckey])
									else
										ivotedforthis = (SSvote.voted[target.ckey] == text2num(choice_id))
									vote_arry[++vote_arry.len] += list(ivotedforthis ? "\[X\]" : "\[ \]", choice, "[REF(SSvote)];vote=[choice_id];statpannel=1")
								if(SCHULZE_VOTING, INSTANT_RUNOFF_VOTING)
									var/list/vote = SSvote.voted[target.ckey]
									var/vote_position = " "
									if(vote)
										vote_position = vote.Find(text2num(choice_id))
									vote_arry[++vote_arry.len] += list("\[[vote_position]\]", choice, "[REF(SSvote)];vote=[choice_id];statpannel=1")
				var/vote_str = url_encode(json_encode(vote_arry))
				target << output("[vote_str]", "statbrowser:update_voting")
			else
				var/null_bullet = url_encode(json_encode(list(list(null))))
				target << output("[null_bullet]", "statbrowser:update_voting")
		if(!target.holder)
			target << output("", "statbrowser:remove_admin_tabs")
		else
			if(!("MC" in target.panel_tabs) || !("Tickets" in target.panel_tabs))
				target << output("[url_encode(target.holder.href_token)]", "statbrowser:add_admin_tabs")
			if(target.stat_tab == "MC")
				var/turf/eye_turf = get_turf(target.eye)
				var/coord_entry = url_encode(COORD(eye_turf))
				if(!mc_data_encoded)
					generate_mc_data()
				target << output("[mc_data_encoded];[coord_entry]", "statbrowser:update_mc")
			if(target.stat_tab == "Tickets")
				var/list/ahelp_tickets = GLOB.ahelp_tickets.stat_entry()
				target << output("[url_encode(json_encode(ahelp_tickets))];", "statbrowser:update_tickets")
			if(!length(GLOB.sdql2_queries) && ("SDQL2" in target.panel_tabs))
				target << output("", "statbrowser:remove_sdql2")
			else if(length(GLOB.sdql2_queries) && (target.stat_tab == "SDQL2" || !("SDQL2" in target.panel_tabs)))
				var/list/sdql2A = list()
				sdql2A[++sdql2A.len] = list("", "Access Global SDQL2 List", REF(GLOB.sdql2_vv_statobj))
				var/list/sdql2B = list()
				for(var/i in GLOB.sdql2_queries)
					var/datum/SDQL2_query/Q = i
					sdql2B = Q.generate_stat()
				sdql2A += sdql2B
				target << output(url_encode(json_encode(sdql2A)), "statbrowser:update_sdql2")
		if(target.mob)
			var/mob/M = target.mob
			if((target.stat_tab in target.spell_tabs) || !length(target.spell_tabs) && (length(M.mob_spell_list) || length(M.mind?.spell_list)))
				var/list/proc_holders = M.get_proc_holders()
				target.spell_tabs.Cut()
				for(var/phl in proc_holders)
					var/list/proc_holder_list = phl
					target.spell_tabs |= proc_holder_list[1]
				var/proc_holders_encoded = ""
				if(length(proc_holders))
					proc_holders_encoded = url_encode(json_encode(proc_holders))
				target << output("[url_encode(json_encode(target.spell_tabs))];[proc_holders_encoded]", "statbrowser:update_spells")
			if(M?.listed_turf)
				var/mob/target_mob = M
				if(!target_mob.TurfAdjacent(target_mob.listed_turf))
					target << output("", "statbrowser:remove_listedturf")
					target_mob.listed_turf = null
				else if(target.stat_tab == M?.listed_turf.name || !(M?.listed_turf.name in target.panel_tabs))
					var/list/overrides = list()
					var/list/turfitems = list()
					for(var/img in target.images)
						var/image/target_image = img
						if(!target_image.loc || target_image.loc.loc != target_mob.listed_turf || !target_image.override)
							continue
						overrides += target_image.loc
					turfitems[++turfitems.len] = list("[target_mob.listed_turf]", REF(target_mob.listed_turf), icon2html(target_mob.listed_turf, target, sourceonly=TRUE))
					for(var/tc in target_mob.listed_turf)
						var/atom/movable/turf_content = tc
						if(turf_content.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
							continue
						if(turf_content.invisibility > target_mob.see_invisible)
							continue
						if(turf_content in overrides)
							continue
						if(turf_content.IsObscured())
							continue
						if(length(turfitems) < 30) // only create images for the first 30 items on the turf, for performance reasons
							if(!(REF(turf_content) in cached_images))
								cached_images += REF(turf_content)
								turf_content.RegisterSignal(turf_content, COMSIG_PARENT_QDELETING, /atom/.proc/remove_from_cache) // we reset cache if anything in it gets deleted
								if(ismob(turf_content) || length(turf_content.overlays) > 2)
									turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content), costly_icon2html(turf_content, target, sourceonly=TRUE))
								else
									turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content), icon2html(turf_content, target, sourceonly=TRUE))
							else
								turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content))
						else
							turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content))
					turfitems = url_encode(json_encode(turfitems))
					target << output("[turfitems];", "statbrowser:update_listedturf")
		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/statpanels/proc/generate_mc_data()
	var/list/mc_data = list(
		list("CPU:", world.cpu),
		list("Instances:", "[num2text(world.contents.len, 10)]"),
		list("World Time:", "[world.time]"),
		list("Globals:", GLOB.stat_entry(), "\ref[GLOB]"),
		list("[config]:", config.stat_entry(), "\ref[config]"),
		list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)"),
		list("Master Controller:", Master.stat_entry(), "\ref[Master]"),
		list("Failsafe Controller:", Failsafe.stat_entry(), "\ref[Failsafe]"),
		list("","")
	)
	for(var/ss in Master.subsystems)
		var/datum/controller/subsystem/sub_system = ss
		mc_data[++mc_data.len] = list("\[[sub_system.state_letter()]][sub_system.name]", sub_system.stat_entry(), "\ref[sub_system]")
	mc_data[++mc_data.len] = list("Camera Net", "Cameras: [GLOB.cameranet.cameras.len] | Chunks: [GLOB.cameranet.chunks.len]", "\ref[GLOB.cameranet]")
	mc_data_encoded = url_encode(json_encode(mc_data))

/atom/proc/remove_from_cache()
	SSstatpanels.cached_images -= REF(src)

/// verbs that send information from the browser UI
/client/verb/set_tab(tab as text|null)
	set name = "Set Tab"
	set hidden = TRUE

	stat_tab = tab

/client/verb/send_tabs(tabs as text|null)
	set name = "Send Tabs"
	set hidden = TRUE

	panel_tabs |= tabs

/client/verb/remove_tabs(tabs as text|null)
	set name = "Remove Tabs"
	set hidden = TRUE

	panel_tabs -= tabs

/client/verb/reset_tabs()
	set name = "Reset Tabs"
	set hidden = TRUE

	panel_tabs = list()

/client/verb/panel_ready()
	set name = "Panel Ready"
	set hidden = TRUE

	statbrowser_ready = TRUE

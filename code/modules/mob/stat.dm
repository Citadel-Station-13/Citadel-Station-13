/**
  * Returns a list of data to push to tgui statpanel.
  */
/mob/tguiStat()
	. = list()
	.["ping"] = round(client.lastping, 1)
	.["ping_avg"] = round(client.avgping, 1)
	.["mapname"] = SSmapping.stat_map_name
	.["round_id"] = GLOB.round_id || NULL
	.["time_dilation"] = list(SStime_track.time_dilation_current, SStime_track.time_dilation_avg_fast, SStime_track.time_dilation_avg, SStime_track.time_dilation_avg_slow)
	.["servertime"] = SStime_track.server_time_text
	.["roundtime"] = SStime_track.round_time_text
	.["stationtime"] = SStime_track.station_time_text
	.["emergency_shuttle"] = SSshuttle.emergency_shuttle_stat_text

/mob/Stat()
	..()

	SSvote?.render_statpanel(src)

	//This is only called from client/Stat(), let's assume client exists.

	if(client.holder)
		if(statpanel("MC"))
			var/turf/T = get_turf(client.eye)
			stat("Location:", COORD(T))
			stat("CPU:", "[world.cpu]")
			stat("Instances:", "[num2text(world.contents.len, 10)]")
			stat("World Time:", "[world.time]")
			GLOB.stat_entry()
			config.stat_entry()
			stat(null)
			if(Master)
				Master.stat_entry()
			else
				stat("Master Controller:", "ERROR")
			if(Failsafe)
				Failsafe.stat_entry()
			else
				stat("Failsafe Controller:", "ERROR")
			if(Master)
				stat(null)
				for(var/datum/controller/subsystem/SS in Master.statworthy_subsystems)
					SS.stat_entry()
			GLOB.cameranet.stat_entry()
		if(statpanel("Tickets"))
			GLOB.ahelp_tickets.stat_entry()
		if(length(GLOB.sdql2_queries))
			if(statpanel("SDQL2"))
				stat("Access Global SDQL2 List", GLOB.sdql2_vv_statobj)
				for(var/i in GLOB.sdql2_queries)
					var/datum/SDQL2_query/Q = i
					Q.generate_stat()
	if(listed_turf && client)
		if(!TurfAdjacent(listed_turf))
			listed_turf = null
		else
			statpanel(listed_turf.name, null, listed_turf)
			var/list/overrides = list()
			for(var/image/I in client.images)
				if(I.loc && I.loc.loc == listed_turf && I.override)
					overrides += I.loc
			for(var/atom/A in listed_turf)
				if(!A.mouse_opacity)
					continue
				if(A.invisibility > see_invisible)
					continue
				if(overrides.len && (A in overrides))
					continue
				if(A.IsObscured())
					continue
				statpanel(listed_turf.name, null, A)
	if(mind)
		add_spells_to_statpanel(mind.spell_list)
		var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			add_stings_to_statpanel(changeling.purchasedpowers)
	add_spells_to_statpanel(mob_spell_list)

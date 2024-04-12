/**
 * Run when a client is put in this mob or reconnets to byond and their client was on this mob
 *
 * Things it does:
 * * Adds player to player_list
 * * sets lastKnownIP
 * * sets computer_id
 * * logs the login
 * * tells the world to update it's status (for player count)
 * * create mob huds for the mob if needed
 * * reset next_move to 1
 * * parent call
 * * if the client exists set the perspective to the mob loc
 * * call on_log on the loc (sigh)
 * * reload the huds for the mob
 * * reload all full screen huds attached to this mob
 * * load any global alternate apperances
 * * sync the mind datum via sync_mind()
 * * call any client login callbacks that exist
 * * grant any actions the mob has to the client
 * * calls [auto_deadmin_on_login](mob.html#proc/auto_deadmin_on_login)
 * * send signal COMSIG_MOB_CLIENT_LOGIN
 * * attaches the ash listener element so clients can hear weather
 * client can be deleted mid-execution of this proc, chiefly on parent calls, with lag
 */
/mob/Login()
	if(!client)
		return FALSE
	add_to_player_list()
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Mob Login: [key_name(src)] was assigned to a [type]")
	world.update_status()
	client.screen = list()				//remove hud items just in case
	client.images = list()

	if(!hud_used)
		create_mob_hud()
	if(hud_used)
		hud_used.show_hud(hud_used.hud_version)
		hud_used.update_ui_style(ui_style2icon(client.prefs.UI_style))

	. = ..()

	if(!client)
		return FALSE

	// SEND_SIGNAL(src, COMSIG_MOB_LOGIN)

	if (key != client.key)
		key = client.key

	reset_perspective(loc)

	if(loc)
		loc.on_log(TRUE)

	//readd this mob's HUDs (antag, med, etc)
	reload_huds()

	sync_mind()

	//Reload alternate appearances
	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)

	update_client_colour()
	update_mouse_pointer()
	if(client)
		client.view_size?.resetToDefault()
		if(client.player_details && istype(client.player_details))
			if(client.player_details.player_actions.len)
				for(var/datum/action/A in client.player_details.player_actions)
					A.Grant(src)

			for(var/foo in client.player_details.post_login_callbacks)
				var/datum/callback/CB = foo
				CB.Invoke()
			auto_deadmin_on_login()

	mind?.hide_ckey = client?.prefs?.hide_ckey

	log_message("Client [key_name(src)] has taken ownership of mob [src]([src.type])", LOG_OWNERSHIP)
	SEND_SIGNAL(src, COMSIG_MOB_CLIENT_LOGIN, client)
	client.init_verbs()

	if(has_field_of_vision && CONFIG_GET(flag/use_field_of_vision))
		LoadComponent(/datum/component/field_of_vision, field_of_vision_type)

	// load rendering
	reload_rendering()

	AddElement(/datum/element/weather_listener, /datum/weather/ash_storm, ZTRAIT_ASHSTORM, GLOB.ash_storm_sounds)

	// optimized area sound effects. Enable during events (compile flag when 😳)
	// AddElement(/datum/element/weather_listener, /datum/weather/long_rain, ZTRAIT_STATION, GLOB.rain_sounds)

/mob/proc/auto_deadmin_on_login() //return true if they're not an admin at the end.
	if(!client?.holder)
		return TRUE
	if(CONFIG_GET(flag/auto_deadmin_players) || (client.prefs?.deadmin & DEADMIN_ALWAYS))
		return client.holder.auto_deadmin()
	if(mind.has_antag_datum(/datum/antagonist) && (CONFIG_GET(flag/auto_deadmin_antagonists) || client.prefs?.deadmin & DEADMIN_ANTAGONIST))
		return client.holder.auto_deadmin()
	if(job)
		return SSjob.handle_auto_deadmin_roles(client, job)

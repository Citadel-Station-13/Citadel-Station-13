/obj/machinery/jukebox
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
	req_one_access = list(ACCESS_BAR, ACCESS_KITCHEN, ACCESS_HYDROPONICS, ACCESS_ENGINE, ACCESS_CARGO, ACCESS_THEATRE)
	payment_department = ACCOUNT_SRV
	var/active = FALSE
	var/list/rangers = list()
	var/stop = 0
	var/volume = 70
	var/queuecost = PRICE_CHEAP //Set to -1 to make this jukebox require access for queueing
	var/datum/track/playing = null
	var/datum/track/selectedtrack = null
	var/list/queuedplaylist = list()
	var/queuecooldown //This var exists solely to prevent accidental repeats of John Mulaney's 'What's New Pussycat?' incident. Intentional, however......

/obj/machinery/jukebox/disco
	name = "radiant dance machine mark IV"
	desc = "The first three prototypes were discontinued after mass casualty incidents."
	icon_state = "disco"
	req_one_access = list(ACCESS_ENGINE)
	anchored = FALSE
	var/list/spotlights = list()
	var/list/sparkles = list()

/obj/machinery/jukebox/disco/indestructible
	name = "radiant dance machine mark V"
	desc = "Now redesigned with data gathered from the extensive disco and plasma research."
	req_one_access = null
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODECONSTRUCT_1

/obj/machinery/jukebox/Destroy()
	dance_over()
	return ..()

/obj/machinery/jukebox/attackby(obj/item/O, mob/user, params)
	if(!active && !(flags_1 & NODECONSTRUCT_1))
		if(O.tool_behaviour == TOOL_WRENCH)
			if(!anchored && !isinspace())
				to_chat(user,"<span class='notice'>You secure [src] to the floor.</span>")
				setAnchored(TRUE)
			else if(anchored)
				to_chat(user,"<span class='notice'>You unsecure and disconnect [src].</span>")
				setAnchored(FALSE)
			playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
			return
	return ..()

/obj/machinery/jukebox/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	queuecost = PRICE_FREE
	req_one_access = null
	to_chat(user, "<span class='notice'>You've bypassed [src]'s audio volume limiter, and enabled free play.</span>")
	return TRUE

/obj/machinery/jukebox/update_icon_state()
	if(active)
		icon_state = "[initial(icon_state)]-active"
	else
		icon_state = "[initial(icon_state)]"

/obj/machinery/jukebox/ui_status(mob/user)
	if(!anchored)
		to_chat(user,"<span class='warning'>This device must be anchored by a wrench!</span>")
		return UI_CLOSE
	if((queuecost < 0 && !allowed(user)) && !isobserver(user))
		to_chat(user,"<span class='warning'>Error: Access Denied.</span>")
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	if(!SSjukeboxes.songs.len && !isobserver(user))
		to_chat(user,"<span class='warning'>Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue.</span>")
		playsound(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	return ..()

/obj/machinery/jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", name)
		ui.open()

/obj/machinery/jukebox/ui_data(mob/user)
	var/list/data = list()
	data["active"] = active
	data["songs"] = list()
	for(var/datum/track/S in SSjukeboxes.songs)
		var/list/track_data = list(name = S.song_name)
		data["songs"] += list(track_data)
	data["queued_tracks"] = list()
	for(var/datum/track/S in queuedplaylist)
		var/list/track_data = list(name = S.song_name)
		data["queued_tracks"] += list(track_data)
	data["track_selected"] = null
	data["track_length"] = null
	if(playing)
		data["track_selected"] = playing.song_name
		data["track_length"] = DisplayTimeText(playing.song_length)
	data["volume"] = volume
	data["is_emagged"] = (obj_flags & EMAGGED)
	data["cost_for_play"] = queuecost
	data["has_access"] = allowed(user)
	return data

/obj/machinery/jukebox/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			if(QDELETED(src))
				return
			if(!allowed(usr))
				return
			if(!active && !playing)
				activate_music()
			else
				stop = 0
			return TRUE
		if("add_to_queue")
			if(QDELETED(src))
				return
			if(world.time < queuecooldown)
				return
			if(!istype(selectedtrack, /datum/track))
				return
			if(!allowed(usr) && queuecost)
				var/obj/item/card/id/C
				if(isliving(usr))
					var/mob/living/L = usr
					C = L.get_idcard(TRUE)
				if(!can_transact(C))
					queuecooldown = world.time + (1 SECONDS)
					playsound(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
					return
				if(!attempt_transact(C, queuecost))
					say("Insufficient funds.")
					queuecooldown = world.time + (1 SECONDS)
					playsound(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
					return
				to_chat(usr, "<span class='notice'>You spend [queuecost] credits to queue [selectedtrack.song_name].</span>")
				log_econ("[queuecost] credits were inserted into [src] by [key_name(usr)] (ID: [C.registered_name]) to queue [selectedtrack.song_name].")
			queuedplaylist += selectedtrack
			if(active)
				say("[selectedtrack.song_name] has been added to the queue.")
			else if(!playing)
				activate_music()
			playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
			queuecooldown = world.time + (3 SECONDS)
			return TRUE
		if("select_track")
			var/list/available = list()
			for(var/datum/track/S in SSjukeboxes.songs)
				available[S.song_name] = S
			var/selected = params["track"]
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/track))
				return
			selectedtrack = available[selected]
			return TRUE
		if("set_volume")
			if(!allowed(usr))
				return
			var/new_volume = params["volume"]
			if(new_volume  == "reset")
				volume = initial(volume)
			else if(new_volume == "min")
				volume = 0
			else if(new_volume == "max")
				volume = ((obj_flags & EMAGGED) ? 210 : 100)
			else if(text2num(new_volume) != null)
				volume = clamp(0, text2num(new_volume), ((obj_flags & EMAGGED) ? 210 : 100))
			var/wherejuke = SSjukeboxes.findjukeboxindex(src)
			if(wherejuke)
				SSjukeboxes.updatejukebox(wherejuke, jukefalloff = volume/35)
			return TRUE

/obj/machinery/jukebox/proc/activate_music()
	if(playing || !queuedplaylist.len)
		return FALSE
	playing = queuedplaylist[1]
	var/jukeboxslottotake = SSjukeboxes.addjukebox(src, playing, volume/35)
	if(jukeboxslottotake)
		active = TRUE
		update_icon()
		START_PROCESSING(SSobj, src)
		stop = world.time + playing.song_length
		queuedplaylist.Cut(1, 2)
		say("Now playing: [playing.song_name]")
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, TRUE)
		return TRUE
	else
		return FALSE

/obj/machinery/jukebox/disco/activate_music()
	. = ..()
	if(!.)
		return
	dance_setup()
	lights_spin()

/obj/machinery/jukebox/disco/proc/dance_setup()
	var/turf/cen = get_turf(src)
	FOR_DVIEW(var/turf/t, 3, get_turf(src),INVISIBILITY_LIGHTING)
		if(t.x == cen.x && t.y > cen.y)
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_RED
			L.light_power = 30-(get_dist(src,L)*8)
			L.range = 1+get_dist(src, L)
			spotlights+=L
			continue
		if(t.x == cen.x && t.y < cen.y)
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_PURPLE
			L.light_power = 30-(get_dist(src,L)*8)
			L.range = 1+get_dist(src, L)
			spotlights+=L
			continue
		if(t.x > cen.x && t.y == cen.y)
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_YELLOW
			L.light_power = 30-(get_dist(src,L)*8)
			L.range = 1+get_dist(src, L)
			spotlights+=L
			continue
		if(t.x < cen.x && t.y == cen.y)
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_GREEN
			L.light_power = 30-(get_dist(src,L)*8)
			L.range = 1+get_dist(src, L)
			spotlights+=L
			continue
		if((t.x+1 == cen.x && t.y+1 == cen.y) || (t.x+2==cen.x && t.y+2 == cen.y))
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_ORANGE
			L.light_power = 30-(get_dist(src,L)*8)
			L.range = 1.4+get_dist(src, L)
			spotlights+=L
			continue
		if((t.x-1 == cen.x && t.y-1 == cen.y) || (t.x-2==cen.x && t.y-2 == cen.y))
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_CYAN
			L.light_power = 30-(get_dist(src,L)*8)
			L.range = 1.4+get_dist(src, L)
			spotlights+=L
			continue
		if((t.x-1 == cen.x && t.y+1 == cen.y) || (t.x-2==cen.x && t.y+2 == cen.y))
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_BLUEGREEN
			L.light_power = 30-(get_dist(src,L)*8)
			L.range = 1.4+get_dist(src, L)
			spotlights+=L
			continue
		if((t.x+1 == cen.x && t.y-1 == cen.y) || (t.x+2==cen.x && t.y-2 == cen.y))
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_BLUE
			L.light_power = 30-(get_dist(src,L)*8)
			L.range = 1.4+get_dist(src, L)
			spotlights+=L
			continue
		continue
	FOR_DVIEW_END

/obj/machinery/jukebox/disco/proc/hierofunk()
	for(var/i in 1 to 10)
		spawn_atom_to_turf(/obj/effect/temp_visual/hierophant/telegraph/edge, src, 1, FALSE)
		sleep(5)
		if(QDELETED(src))
			return

#define DISCO_INFENO_RANGE (rand(85, 115)*0.01)

/obj/machinery/jukebox/disco/proc/lights_spin()
	for(var/i in 1 to 25)
		if(QDELETED(src) || !active)
			return
		var/obj/effect/overlay/sparkles/S = new /obj/effect/overlay/sparkles(src)
		S.alpha = 0
		sparkles += S
		switch(i)
			if(1 to 8)
				S.orbit(src, 30, TRUE, 60, 36, TRUE)
			if(9 to 16)
				S.orbit(src, 62, TRUE, 60, 36, TRUE)
			if(17 to 24)
				S.orbit(src, 95, TRUE, 60, 36, TRUE)
			if(25)
				S.pixel_y = 7
				S.forceMove(get_turf(src))
		sleep(7)
	if(playing.song_name == "Engineering's Ultimate High-Energy Hustle")
		sleep(280)
	for(var/obj/reveal in sparkles)
		reveal.alpha = 255
	while(active)
		for(var/obj/item/flashlight/spotlight/glow in spotlights) // The multiples reflects custom adjustments to each colors after dozens of tests
			if(QDELETED(src) || !active || QDELETED(glow))
				return
			if(glow.light_color == LIGHT_COLOR_RED)
				glow.light_color = LIGHT_COLOR_BLUE
				glow.light_power = glow.light_power * 1.48
				glow.light_range = 0
				glow.update_light()
				continue
			if(glow.light_color == LIGHT_COLOR_BLUE)
				glow.light_color = LIGHT_COLOR_GREEN
				glow.light_range = glow.range * DISCO_INFENO_RANGE
				glow.light_power = glow.light_power * 2 // Any changes to power must come in pairs to neutralize it for other colors
				glow.update_light()
				continue
			if(glow.light_color == LIGHT_COLOR_GREEN)
				glow.light_color = LIGHT_COLOR_ORANGE
				glow.light_power = glow.light_power * 0.5
				glow.light_range = 0
				glow.update_light()
				continue
			if(glow.light_color == LIGHT_COLOR_ORANGE)
				glow.light_color = LIGHT_COLOR_PURPLE
				glow.light_power = glow.light_power * 2.27
				glow.light_range = glow.range * DISCO_INFENO_RANGE
				glow.update_light()
				continue
			if(glow.light_color == LIGHT_COLOR_PURPLE)
				glow.light_color = LIGHT_COLOR_BLUEGREEN
				glow.light_power = glow.light_power * 0.44
				glow.light_range = 0
				glow.update_light()
				continue
			if(glow.light_color == LIGHT_COLOR_BLUEGREEN)
				glow.light_color = LIGHT_COLOR_YELLOW
				glow.light_range = glow.range * DISCO_INFENO_RANGE
				glow.update_light()
				continue
			if(glow.light_color == LIGHT_COLOR_YELLOW)
				glow.light_color = LIGHT_COLOR_CYAN
				glow.light_range = 0
				glow.update_light()
				continue
			if(glow.light_color == LIGHT_COLOR_CYAN)
				glow.light_color = LIGHT_COLOR_RED
				glow.light_power = glow.light_power * 0.68
				glow.light_range = glow.range * DISCO_INFENO_RANGE
				glow.update_light()
				continue
		if(prob(2))  // Unique effects for the dance floor that show up randomly to mix things up
			INVOKE_ASYNC(src, PROC_REF(hierofunk))
		sleep(playing.song_beat)

#undef DISCO_INFENO_RANGE

/obj/machinery/jukebox/disco/proc/dance(var/mob/living/M) //Show your moves
	set waitfor = FALSE
	switch(rand(0,9))
		if(0 to 1)
			dance2(M)
		if(2 to 3)
			dance3(M)
		if(4 to 6)
			dance4(M)
		if(7 to 9)
			dance5(M)

/obj/machinery/jukebox/disco/proc/dance2(var/mob/living/M)
	for(var/i = 1, i < 10, i++)
		for(var/d in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
			M.setDir(d)
			if(i == WEST)
				M.emote("flip")
			sleep(1)
		sleep(20)

/obj/machinery/jukebox/disco/proc/dance3(var/mob/living/M)
	var/matrix/initial_matrix = matrix(M.transform)
	for (var/i in 1 to 75)
		if (!M)
			return
		switch(i)
			if (1 to 15)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (16 to 30)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(1,-1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (31 to 45)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-1,-1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (46 to 60)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-1,1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (61 to 75)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(1,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		M.setDir(turn(M.dir, 90))
		switch (M.dir)
			if (NORTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (SOUTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,-3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (EAST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (WEST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		sleep(1)
	M.lying_fix()


/obj/machinery/jukebox/disco/proc/dance4(var/mob/living/M)
	var/speed = rand(1,3)
	set waitfor = 0
	var/time = 30
	while(time)
		sleep(speed)
		for(var/i in 1 to speed)
			M.setDir(pick(GLOB.cardinals))
			// update resting manually to avoid chat spam CITADEL EDIT - NO MORE RESTSPAM
			//for(var/mob/living/carbon/NS in rangers)
			//	NS.resting = !NS.resting
			//	NS.update_canmove()
		time--

/obj/machinery/jukebox/disco/proc/dance5(var/mob/living/M)
	animate(M, transform = matrix(180, MATRIX_ROTATE), time = 1, loop = 0)
	var/matrix/initial_matrix = matrix(M.transform)
	for (var/i in 1 to 60)
		if (!M)
			return
		if (i<31)
			initial_matrix = matrix(M.transform)
			initial_matrix.Translate(0,1)
			animate(M, transform = initial_matrix, time = 1, loop = 0)
		if (i>30)
			initial_matrix = matrix(M.transform)
			initial_matrix.Translate(0,-1)
			animate(M, transform = initial_matrix, time = 1, loop = 0)
		M.setDir(turn(M.dir, 90))
		switch (M.dir)
			if (NORTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (SOUTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,-3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (EAST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (WEST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		sleep(1)
	M.lying_fix()

/mob/living/proc/lying_fix()
	animate(src, transform = null, time = 1, loop = 0)
	lying_prev = 0

/obj/machinery/jukebox/proc/dance_over()
	var/position = SSjukeboxes.findjukeboxindex(src)
	if(!position)
		return
	SSjukeboxes.removejukebox(position)
	STOP_PROCESSING(SSobj, src)
	playing = null
	rangers = list()

/obj/machinery/jukebox/disco/dance_over()
	..()
	QDEL_LIST(spotlights)
	QDEL_LIST(sparkles)

/obj/machinery/jukebox/process()
	if(active)
		if(world.time >= stop)
			active = FALSE
			dance_over()
			if(stop && queuedplaylist.len)
				activate_music()
			else
				playsound(src,'sound/machines/terminal_off.ogg',50,1)
				update_icon()
				playing = null
				stop = 0
		else if(volume > 140) // BOOM BOOM BOOM BOOM
			for(var/mob/living/carbon/C in hearers(round(volume/35), src)) // I WANT YOU IN MY ROOM
				if(istype(C)) // LETS SPEND THE NIGHT TOGETHER
					C.adjustEarDamage(max((((volume/35) - sqrt(get_dist(C, src) * 4)) - C.get_ear_protection())*0.1, 0)) // FROM NOW UNTIL FOREVER


/obj/machinery/jukebox/disco/process()
	. = ..()
	if(active)
		for(var/mob/living/M in rangers)
			if(prob(5+(allowed(M)*4)) && CHECK_MOBILITY(M, MOBILITY_MOVE))
				dance(M)

//The gateway to Reebe, from which Ratvar emerges.
/obj/structure/destructible/clockwork/massive/celestial_gateway
	name = "Gateway to the Celestial Derelict"
	desc = "A massive, thrumming rip in spacetime."
	clockwork_desc = "A portal to the Celestial Derelict. Massive and intimidating, it is the only thing that can both transport Ratvar and withstand the massive amount of energy he emits."
	obj_integrity = 500
	max_integrity = 500
	mouse_opacity = 2
	icon = 'icons/effects/clockwork_effects.dmi'
	icon_state = "nothing"
	density = FALSE
	invisibility = INVISIBILITY_MAXIMUM
	resistance_flags = FIRE_PROOF | ACID_PROOF | INDESTRUCTIBLE
	can_be_repaired = FALSE
	var/progress_in_seconds = 0 //Once this reaches GATEWAY_RATVAR_ARRIVAL, it's game over
	var/purpose_fulfilled = FALSE
	var/first_sound_played = FALSE
	var/second_sound_played = FALSE
	var/third_sound_played = FALSE
	var/ratvar_portal = TRUE //if the gateway actually summons ratvar or just produces a hugeass conversion burst
	var/obj/effect/clockwork/overlay/gateway_glow/glow
	var/obj/effect/countdown/clockworkgate/countdown

/obj/structure/destructible/clockwork/massive/celestial_gateway/New()
	..()
	addtimer(CALLBACK(src, .proc/spawn_animation), 0)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/spawn_animation()
	var/turf/T = get_turf(src)
	var/objective_is_gateway = (ticker && ticker.mode && ticker.mode.clockwork_objective == CLOCKCULT_GATEWAY)
	new/obj/effect/clockwork/general_marker/inathneq(T)
	if(objective_is_gateway)
		hierophant_message("<span class='inathneq'>\"[text2ratvar("Engine, come forth and show your servants your mercy")]!\"</span>")
	else
		hierophant_message("<span class='inathneq'>\"[text2ratvar("We will show all the mercy of Engine")]!\"</span>")
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 30, 0)
	sleep(10)
	new/obj/effect/clockwork/general_marker/sevtug(T)
	if(objective_is_gateway)
		hierophant_message("<span class='sevtug'>\"[text2ratvar("Engine, come forth and show this station your decorating skills")]!\"</span>")
	else
		hierophant_message("<span class='sevtug'>\"[text2ratvar("We will show all Engine's decorating skills")]!\"</span>")
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 45, 0)
	sleep(10)
	new/obj/effect/clockwork/general_marker/nezbere(T)
	if(objective_is_gateway)
		hierophant_message("<span class='nezbere'>\"[text2ratvar("Engine, come forth and shine your light across this realm")]!!\"</span>")
	else
		hierophant_message("<span class='nezbere'>\"[text2ratvar("We will show all Engine's light")]!!\"</span>")
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 60, 0)
	sleep(10)
	new/obj/effect/clockwork/general_marker/nzcrentr(T)
	if(objective_is_gateway)
		hierophant_message("<span class='nzcrentr'>\"[text2ratvar("Engine, come forth")].\"</span>")
	else
		hierophant_message("<span class='nzcrentr'>\"[text2ratvar("We will show all Engine's power")].\"</span>")
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 75, 0)
	sleep(10)
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 100, 0)
	var/list/open_turfs = list()
	for(var/turf/open/OT in orange(1, T))
		if(!is_blocked_turf(OT, TRUE))
			open_turfs |= OT
	if(open_turfs.len)
		for(var/mob/living/L in T)
			L.forceMove(pick(open_turfs))
	resistance_flags &= ~INDESTRUCTIBLE
	density = TRUE
	invisibility = 0
	glow = new(get_turf(src))
	countdown = new(src)
	countdown.start()
	var/area/gate_area = get_area(src)
	hierophant_message("<span class='large_brass'><b>A gateway to the Celestial Derelict has been created in [gate_area.map_name]!</b></span>", FALSE, src)
	if(!objective_is_gateway)
		ratvar_portal = FALSE
		hierophant_message("<span class='big_brass'>This newly constructed gateway will not free Ratvar, \
		and will instead simply proselytize and convert everything and everyone on the station.</span>", TRUE)
	SSshuttle.registerHostileEnvironment(src)
	START_PROCESSING(SSprocessing, src)

/obj/structure/destructible/clockwork/massive/celestial_gateway/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(!purpose_fulfilled)
		var/area/gate_area = get_area(src)
		hierophant_message("<span class='large_brass'><b>A gateway to the Celestial Derelict has fallen at [gate_area.map_name]!</b></span>")
		send_to_playing_players(sound(null, 0, channel = 8))
	var/was_stranded = SSshuttle.emergency.mode == SHUTTLE_STRANDED
	SSshuttle.clearHostileEnvironment(src)
	if(!was_stranded && !purpose_fulfilled && second_sound_played)
		priority_announce("Massive energy anomaly no longer on short-range scanners.","Anomaly Alert")
	if(glow)
		qdel(glow)
		glow = null
	if(countdown)
		qdel(countdown)
		countdown = null
	. = ..()

/obj/structure/destructible/clockwork/massive/celestial_gateway/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		if(!disassembled)
			resistance_flags |= INDESTRUCTIBLE
			countdown.stop()
			visible_message("<span class='userdanger'>The [src] begins to pulse uncontrollably... you might want to run!</span>")
			send_to_playing_players(sound('sound/effects/clockcult_gateway_disrupted.ogg', 0, channel = 8, volume = 50))
			make_glow()
			glow.icon_state = "clockwork_gateway_disrupted"
			resistance_flags |= INDESTRUCTIBLE
			sleep(27)
			explosion(src, 1, 3, 8, 8)
	qdel(src)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/make_glow()
	if(!glow)
		glow = new /obj/effect/clockwork/overlay/gateway_glow(get_turf(src))
		glow.linked = src

/obj/structure/destructible/clockwork/massive/celestial_gateway/ex_act(severity)
	var/damage = max((obj_integrity * 0.70) / severity, 100) //requires multiple bombs to take down
	take_damage(damage, BRUTE, "bomb", 0)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/get_arrival_text(s_on_time)
	. = "IMMINENT"
	if(!obj_integrity)
		. = "DETONATING"
	else if(GATEWAY_RATVAR_ARRIVAL - progress_in_seconds > 0)
		. = "[round(max((GATEWAY_RATVAR_ARRIVAL - progress_in_seconds) / (GATEWAY_SUMMON_RATE), 0), 1)][s_on_time ? "S":""]"

/obj/structure/destructible/clockwork/massive/celestial_gateway/examine(mob/user)
	icon_state = "spatial_gateway" //cheat wildly by pretending to have an icon
	..()
	icon_state = initial(icon_state)
	if(is_servant_of_ratvar(user) || isobserver(user))
		user << "<span class='big'><b>Seconds until [ratvar_portal ? "Ratvar's arrival":"Proselytization"]:</b> [get_arrival_text(TRUE)]</span>"
		switch(progress_in_seconds)
			if(-INFINITY to GATEWAY_REEBE_FOUND)
				user << "<span class='heavy_brass'>It's still opening.</span>"
			if(GATEWAY_REEBE_FOUND to GATEWAY_RATVAR_COMING)
				user << "<span class='heavy_brass'>It's reached the Celestial Derelict and is drawing power from it.</span>"
			if(GATEWAY_RATVAR_COMING to INFINITY)
				user << "<span class='heavy_brass'>[ratvar_portal ? "Ratvar is coming through the gateway":"The gateway is glowing with massed power"]!</span>"
	else
		switch(progress_in_seconds)
			if(-INFINITY to GATEWAY_REEBE_FOUND)
				user << "<span class='warning'>It's a swirling mass of blackness.</span>"
			if(GATEWAY_REEBE_FOUND to GATEWAY_RATVAR_COMING)
				user << "<span class='warning'>It seems to be leading somewhere.</span>"
			if(GATEWAY_RATVAR_COMING to INFINITY)
				user << "<span class='boldwarning'>[ratvar_portal ? "Something is coming through":"It's glowing brightly"]!</span>"

/obj/structure/destructible/clockwork/massive/celestial_gateway/process()
	if(!progress_in_seconds || prob(7))
		for(var/M in player_list)
			if(M && !isnewplayer(M))
				M << "<span class='warning'><b>You hear otherworldly sounds from the [dir2text(get_dir(get_turf(M), get_turf(src)))]...</span>"
	if(!obj_integrity)
		return 0
	var/convert_dist = 1 + (round(Floor(progress_in_seconds, 15) * 0.067))
	for(var/t in RANGE_TURFS(convert_dist, loc))
		var/turf/T = t
		if(!T)
			continue
		if(get_dist(T, src) < 2)
			if(iswallturf(T))
				var/turf/closed/wall/W = T
				W.dismantle_wall()
			else if(t && (isclosedturf(T) || !is_blocked_turf(T)))
				T.ChangeTurf(/turf/open/floor/clockwork)
		var/dist = cheap_hypotenuse(T.x, T.y, x, y)
		if(dist < convert_dist)
			T.ratvar_act(FALSE, TRUE, 3)
	for(var/obj/O in orange(1, src))
		if(!O.pulledby && !istype(O, /obj/effect) && O.density)
			if(!step_away(O, src, 2) || get_dist(O, src) < 2)
				O.take_damage(50, BURN, "bomb")
			O.update_icon()
	progress_in_seconds += GATEWAY_SUMMON_RATE
	switch(progress_in_seconds)
		if(-INFINITY to GATEWAY_REEBE_FOUND)
			if(!first_sound_played)
				send_to_playing_players(sound('sound/effects/clockcult_gateway_charging.ogg', 1, channel = 8, volume = 30))
				first_sound_played = TRUE
			make_glow()
			glow.icon_state = "clockwork_gateway_charging"
		if(GATEWAY_REEBE_FOUND to GATEWAY_RATVAR_COMING)
			if(!second_sound_played)
				var/area/gate_area = get_area(src)
				priority_announce("Massive energy anomaly detected on short-range scanners. Location: [gate_area.map_name].", "Anomaly Alert")
				send_to_playing_players(sound('sound/effects/clockcult_gateway_active.ogg', 1, channel = 8, volume = 35))
				second_sound_played = TRUE
			make_glow()
			glow.icon_state = "clockwork_gateway_active"
		if(GATEWAY_RATVAR_COMING to GATEWAY_RATVAR_ARRIVAL)
			if(!third_sound_played)
				send_to_playing_players(sound('sound/effects/clockcult_gateway_closing.ogg', 1, channel = 8, volume = 40))
				third_sound_played = TRUE
			make_glow()
			glow.icon_state = "clockwork_gateway_closing"
		if(GATEWAY_RATVAR_ARRIVAL to INFINITY)
			if(!purpose_fulfilled)
				countdown.stop()
				resistance_flags |= INDESTRUCTIBLE
				purpose_fulfilled = TRUE
				make_glow()
				animate(glow, transform = matrix() * 1.5, alpha = 255, time = 125)
				send_to_playing_players(sound('sound/effects/ratvar_rises.ogg', 0, channel = 8)) //End the sounds
				sleep(125)
				make_glow()
				animate(glow, transform = matrix() * 3, alpha = 0, time = 5)
				var/turf/startpoint = get_turf(src)
				QDEL_IN(src, 3)
				clockwork_gateway_activated = TRUE
				if(ratvar_portal)
					sleep(3)
					new/obj/structure/destructible/clockwork/massive/ratvar(startpoint)
				else
					addtimer(CALLBACK(SSshuttle.emergency, /obj/docking_port/mobile/emergency.proc/request, null, 0), 0) //call the shuttle immediately
					sleep(3)
					send_to_playing_players("<span class='ratvar'>\"[text2ratvar("Behold")]!\"</span>\n<span class='inathneq_large'>\"[text2ratvar("See Engine's mercy")]!\"</span>\n\
					<span class='sevtug_large'>\"[text2ratvar("Observe Engine's design skills")]!\"</span>\n<span class='nezbere_large'>\"[text2ratvar("Behold Engine's light")]!!\"</span>\n\
					<span class='nzcrentr_large'>\"[text2ratvar("Gaze upon Engine's power")]!\"</span>")
					send_to_playing_players('sound/magic/clockwork/invoke_general.ogg')
					var/x0 = startpoint.x
					var/y0 = startpoint.y
					for(var/I in spiral_range_turfs(255, startpoint))
						var/turf/T = I
						if(!T)
							continue
						var/dist = cheap_hypotenuse(T.x, T.y, x0, y0)
						if(dist < 100)
							dist = TRUE
						else
							dist = FALSE
						T.ratvar_act(dist)
						CHECK_TICK
					for(var/mob/living/silicon/robot/R in silicon_mobs)
						if(R && R.stat != DEAD && !is_servant_of_ratvar(R))
							add_servant_of_ratvar(R)
					for(var/i in ai_list)
						var/mob/living/silicon/ai/A = i
						if(A && A.stat != DEAD && !is_servant_of_ratvar(A))
							add_servant_of_ratvar(A)
					for(var/I in all_clockwork_mobs)
						var/mob/M = I
						if(M.stat == CONSCIOUS)
							clockwork_say(M, text2ratvar(pick("Purge all untruths and honor Engine!", "All glory to Engine's light!", "Engine's power is unmatched!")))

//the actual appearance of the Gateway to the Celestial Derelict; an object so the edges of the gate can be clicked through.
/obj/effect/clockwork/overlay/gateway_glow
	icon = 'icons/effects/96x96.dmi'
	icon_state = "clockwork_gateway_charging"
	pixel_x = -32
	pixel_y = -32
	layer = BELOW_OPEN_DOOR_LAYER

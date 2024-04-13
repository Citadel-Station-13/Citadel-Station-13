/proc/clockwork_ark_active() //A helper proc so the Ark doesn't have to be typecast every time it's checked; returns null if there is no Ark and its active var otherwise
	var/obj/structure/destructible/clockwork/massive/celestial_gateway/G = GLOB.ark_of_the_clockwork_justiciar
	if(!G)
		return
	return G.active

//The gateway to Reebe, from which Ratvar emerges.
/obj/structure/destructible/clockwork/massive/celestial_gateway
	name = "\improper Ark of the Clockwork Justicar"
	desc = "A massive, hulking amalgamation of parts. It seems to be maintaining a very unstable bluespace anomaly."
	clockwork_desc = "Nezbere's magnum opus: a hulking clockwork machine capable of combining bluespace and steam power to summon Ratvar. Once activated, \
	its instability will alert the entire area, so be prepared to defend it at all costs."
	max_integrity = 500
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	icon = 'icons/effects/clockwork_effects.dmi'
	icon_state = "nothing"
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF | FREEZE_PROOF
	can_be_repaired = FALSE
	immune_to_servant_attacks = TRUE
	var/active = FALSE
	var/progress_in_seconds = 0 //Once this reaches GATEWAY_RATVAR_ARRIVAL, it's game over
	var/initial_activation_delay = 5 //How many seconds the Ark will have initially taken to activate
	var/seconds_until_activation = 5 //How many seconds until the Ark activates; if it should never activate, set this to -1
	var/purpose_fulfilled = FALSE
	var/first_sound_played = FALSE
	var/second_sound_played = FALSE
	var/third_sound_played = FALSE
	var/fourth_sound_played = FALSE
	var/obj/effect/clockwork/overlay/gateway_glow/glow
	var/obj/effect/countdown/clockworkgate/countdown
	var/last_scream = 0
	var/recalls_remaining = 1
	var/recalling

/obj/structure/destructible/clockwork/massive/celestial_gateway/Initialize(mapload)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(spawn_animation))
	glow = new(get_turf(src))
	if(!GLOB.ark_of_the_clockwork_justiciar)
		GLOB.ark_of_the_clockwork_justiciar = src

/obj/structure/destructible/clockwork/massive/celestial_gateway/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(!purpose_fulfilled)
		var/area/gate_area = get_area(src)
		hierophant_message("<span class='large_brass'><b>An Ark of the Clockwork Justicar has fallen at [gate_area.map_name]!</b></span>")
		send_to_playing_players(sound(null, 0, channel = CHANNEL_JUSTICAR_ARK))
	var/was_stranded = SSshuttle.emergency.mode == SHUTTLE_STRANDED
	SSshuttle.clearHostileEnvironment(src)
	if(!was_stranded && !purpose_fulfilled)
		priority_announce("Massive energy anomaly no longer on short-range scanners, bluespace distortions still detected.","Central Command Higher Dimensional Affairs")
	if(glow)
		QDEL_NULL(glow)
	if(countdown)
		QDEL_NULL(countdown)
	if(GLOB.ark_of_the_clockwork_justiciar == src)
		GLOB.ark_of_the_clockwork_justiciar = null
	. = ..()

/obj/structure/destructible/clockwork/massive/celestial_gateway/on_attack_hand(mob/user, act_intent, unarmed_attack_flags)
	if(!active  && is_servant_of_ratvar(user) && user.canUseTopic(src, !issilicon(user), NO_DEXTERY))
		if(alert(user, "Are you sure you want to activate the ark? Once enabled, there will be no turning back.", "Enabling the ark", "Activate!", "Cancel") == "Activate!")
			if(active)
				return
			log_game("[key_name(user)] has activated an Ark of the Clockwork Justicar at [COORD(src)].")
			START_PROCESSING(SSprocessing, src)
			SSshuttle.registerHostileEnvironment(src)
		else
			to_chat(user, "<span class='brass'>You decide against activating the ark.. for now.</span>")

/obj/structure/destructible/clockwork/massive/celestial_gateway/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.)
		flick("clockwork_gateway_damaged", glow)
		playsound(src, 'sound/machines/clockcult/ark_damage.ogg', 75, FALSE)
		if(last_scream < world.time)
			audible_message("<span class='boldwarning'>An unearthly screaming sound resonates throughout the area!</span>")
			for(var/V in GLOB.player_list)
				var/mob/M = V
				var/turf/T = get_turf(M)
				if((T && T.z == z) || is_servant_of_ratvar(M) || isobserver(M))
					M.playsound_local(M, 'sound/machines/clockcult/ark_scream.ogg', 100, FALSE, pressure_affected = FALSE)
			hierophant_message("<span class='big boldwarning'>The Ark is taking damage!</span>")
	last_scream = world.time + ARK_SCREAM_COOLDOWN

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/final_countdown(ark_time) //WE'RE LEAVING TOGETHEEEEEEEEER
	if(!ark_time)
		ark_time = 5 //5 minutes
	for(var/obj/item/clockwork/construct_chassis/cogscarab/C in GLOB.all_clockwork_objects)
		C.infinite_resources = FALSE
	GLOB.servants_active = TRUE
	SSshuttle.registerHostileEnvironment(src)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/let_slip_the_dogs()
	first_sound_played = TRUE
	active = TRUE
	visible_message("<span class='boldwarning'>[src] shudders and roars to life, its parts beginning to whirr and screech!</span>")
	priority_announce("Massive [Gibberish("bluespace", 100)] anomaly detected on all frequencies. All crew are directed to \
	@!$, [text2ratvar("PURGE ALL UNTRUTHS")] <&. the anomalies and destroy their source to prevent further damage to corporate property. This is \
	not a drill.", "Central Command Higher Dimensional Affairs", 'sound/magic/clockwork/ark_activation_sequence.ogg')
	set_security_level("Delta")
	for(var/V in SSticker.mode.servants_of_ratvar)
		var/datum/mind/M = V
		if(!M || !M.current)
			continue
		if(ishuman(M.current))
			M.current.add_overlay(mutable_appearance('icons/effects/genetics.dmi', "servitude", -ANTAG_LAYER))
	var/turf/T = get_turf(src)
	var/list/open_turfs = list()
	for(var/turf/open/OT in orange(1, T))
		if(!is_blocked_turf(OT, TRUE))
			open_turfs |= OT
	if(open_turfs.len)
		for(var/mob/living/L in T)
			L.forceMove(pick(open_turfs))

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/spawn_animation()
	var/turf/T = get_turf(src)
	new/obj/effect/clockwork/general_marker/inathneq(T)
	hierophant_message("<span class='inathneq'>\"[text2ratvar("Engine, come forth and show your servants your mercy")]!\"</span>")
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 30, 0)
	sleep(10)
	new/obj/effect/clockwork/general_marker/sevtug(T)
	hierophant_message("<span class='sevtug'>\"[text2ratvar("Engine, come forth and show this station your decorating skills")]!\"</span>")
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 45, 0)
	sleep(10)
	new/obj/effect/clockwork/general_marker/nezbere(T)
	hierophant_message("<span class='nezbere'>\"[text2ratvar("Engine, come forth and shine your light across this realm")]!!\"</span>")
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 60, 0)
	sleep(10)
	new/obj/effect/clockwork/general_marker/nzcrentr(T)
	hierophant_message("<span class='nzcrentr'>\"[text2ratvar("Engine, come forth")].\"</span>")
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
	glow = new(get_turf(src))
	var/area/gate_area = get_area(src)
	hierophant_message("<span class='large_brass'><b>An Ark of the Clockwork Justicar has been created in [gate_area?.map_name]!</b></span>", FALSE, src)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/initiate_mass_recall()
	recalling = TRUE
	sound_to_playing_players('sound/machines/clockcult/ark_recall.ogg', 75, FALSE)
	hierophant_message("<span class='bold large_brass'>The Eminence has initiated a mass recall! You are being transported to the Ark!</span>")
	addtimer(CALLBACK(src, PROC_REF(mass_recall)), 100)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/mass_recall()
	for(var/V in SSticker.mode.servants_of_ratvar)
		var/datum/mind/M = V
		if(!M || !M.current)
			continue
		if(isliving(M.current) && M.current.stat != DEAD)
			var/turf/t_turf = isAI(M.current) ? get_step(get_step(src, NORTH),NORTH) : get_turf(src) // AI too fat, must make sure it always ends up a 2 tiles north instead of on the ark.
			do_teleport(M.current, t_turf, channel = TELEPORT_CHANNEL_CULT, forced = TRUE)
			M.current.overlay_fullscreen("flash", /atom/movable/screen/fullscreen/tiled/flash)
			M.current.clear_fullscreen("flash", 5)
	playsound(src, 'sound/magic/clockwork/invoke_general.ogg', 50, FALSE)
	recalls_remaining--
	recalling = FALSE
	transform = matrix() * 2
	animate(src, transform = matrix() * 0.5, time = 30, flags = ANIMATION_END_NOW)



/obj/structure/destructible/clockwork/massive/celestial_gateway/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!disassembled)
			resistance_flags |= INDESTRUCTIBLE
			countdown.stop()
			visible_message("<span class='userdanger'>[src] begins to pulse uncontrollably... you might want to run!</span>")
			sound_to_playing_players(volume = 50, channel = CHANNEL_JUSTICAR_ARK, S = sound('sound/effects/clockcult_gateway_disrupted.ogg'))
			for(var/mob/M in GLOB.player_list)
				var/turf/T = get_turf(M)
				if((T && T.z == z) || is_servant_of_ratvar(M))
					M.playsound_local(M, 'sound/machines/clockcult/ark_deathrattle.ogg', 100, FALSE, pressure_affected = FALSE)
			make_glow()
			glow.icon_state = "clockwork_gateway_disrupted"
			resistance_flags |= INDESTRUCTIBLE
			addtimer(CALLBACK(src, PROC_REF(go_boom)), 2.7 SECONDS)
			return
	qdel(src)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/go_boom()
	if(QDELETED(src))
		return
	explosion(src, 1, 3, 8, 8)
	sound_to_playing_players('sound/effects/explosion_distant.ogg', volume = 50)
	qdel(src)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/make_glow()
	if(!glow)
		glow = new /obj/effect/clockwork/overlay/gateway_glow(get_turf(src))
		glow.linked = src

/obj/structure/destructible/clockwork/massive/celestial_gateway/ex_act(severity, target, origin)
	var/damage = max((obj_integrity * 0.7) / severity, 100) //requires multiple bombs to take down
	take_damage(damage, BRUTE, BOMB, 0)

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/get_arrival_time(var/deciseconds = TRUE)
	if(seconds_until_activation)
		. = seconds_until_activation
	else if(GATEWAY_RATVAR_ARRIVAL - progress_in_seconds > 0)
		. = round(max((GATEWAY_RATVAR_ARRIVAL - progress_in_seconds) / (GATEWAY_SUMMON_RATE), 0), 1)
	if(deciseconds)
		. *= 10

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/get_arrival_text(s_on_time)
	if(seconds_until_activation)
		return "[get_arrival_time()][s_on_time ? "S" : ""]"
	. = "IMMINENT"
	if(!obj_integrity)
		. = "DETONATING"
	else if(GATEWAY_RATVAR_ARRIVAL - progress_in_seconds > 0)
		. = "[round(max((GATEWAY_RATVAR_ARRIVAL - progress_in_seconds) / (GATEWAY_SUMMON_RATE), 0), 1)][s_on_time ? "S":""]"

/obj/structure/destructible/clockwork/massive/celestial_gateway/examine(mob/user)
	icon_state = "spatial_gateway" //cheat wildly by pretending to have an icon
	. = ..()
	icon_state = initial(icon_state)
	if(is_servant_of_ratvar(user) || isobserver(user))
		if(!active)
			. += "<span class='big'><b>Time until the Ark's activation:</b> [DisplayTimeText(get_arrival_time())]</span>"
		else
			. += "<span class='big'><b>Time until Ratvar's arrival:</b> [DisplayTimeText(get_arrival_time())]</span>"
			switch(progress_in_seconds)
				if(-INFINITY to GATEWAY_REEBE_FOUND)
					. += "<span class='heavy_brass'>The Ark is feeding power into the bluespace field.</span>"
				if(GATEWAY_REEBE_FOUND to GATEWAY_RATVAR_COMING)
					. += "<span class='heavy_brass'>The field is ripping open a copy of itself in Ratvar's prison.</span>"
				if(GATEWAY_RATVAR_COMING to INFINITY)
					. += "<span class='heavy_brass'>With the bluespace field established, Ratvar is preparing to come through!</span>"
	else
		if(!active)
			. += "<span class='warning'>Whatever it is, it doesn't seem to be active.</span>"
		else
			switch(progress_in_seconds)
				if(-INFINITY to GATEWAY_REEBE_FOUND)
					. += "<span class='warning'>You see a swirling bluespace anomaly steadily growing in intensity.</span>"
				if(GATEWAY_REEBE_FOUND to GATEWAY_RATVAR_COMING)
					. += "<span class='warning'>The anomaly is stable, and you can see flashes of something from it.</span>"
				if(GATEWAY_RATVAR_COMING to INFINITY)
					. += "<span class='boldwarning'>The anomaly is stable! Something is coming through!</span>"

/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/fulfill_purpose()
	set waitfor = FALSE
	countdown.stop()
	resistance_flags |= INDESTRUCTIBLE
	purpose_fulfilled = TRUE
	make_glow()
	animate(glow, transform = matrix() * 1.5, alpha = 255, time = 125)
	sound_to_playing_players('sound/effects/ratvar_rises.ogg', 90, FALSE, channel = CHANNEL_JUSTICAR_ARK)
	sleep(125)
	make_glow()
	animate(glow, transform = matrix() * 3, alpha = 0, time = 5)
	QDEL_IN(src, 3)
	sleep(3)
	GLOB.clockwork_gateway_activated = TRUE
	var/turf/T = SSmapping.get_station_center()
	new /obj/structure/destructible/clockwork/massive/ratvar(T)
	var/x0 = T.x
	var/y0 = T.y
	for(var/I in spiral_range_turfs(255, T, tick_checked = TRUE))
		var/turf/T2 = I
		if(!T2)
			continue
		var/dist = cheap_hypotenuse(T2.x, T2.y, x0, y0)
		if(dist < 100)
			dist = TRUE
		else
			dist = FALSE
		T.ratvar_act(dist)
		CHECK_TICK

/obj/structure/destructible/clockwork/massive/celestial_gateway/process()
	adjust_clockwork_power(2.5) //Provides weak power generation on its own
	if(seconds_until_activation)
		if(!countdown)
			countdown = new(src)
			countdown.start()
		seconds_until_activation--
		if(!seconds_until_activation)
			let_slip_the_dogs()
		return
	if(!first_sound_played || prob(7))
		for(var/mob/M in GLOB.player_list)
			if(!isnewplayer(M))
				var/turf/T = get_turf(M)
				if(T && T.z == z)
					to_chat(M, "<span class='warning'><b>You hear otherworldly sounds from the [dir2text(get_dir(get_turf(M), get_turf(src)))]...</span>")
				else
					to_chat(M, "<span class='boldwarning'>You hear otherworldly sounds from all around you...</span>")
	if(!obj_integrity)
		return
	for(var/turf/closed/wall/W in RANGE_TURFS(2, src))
		W.dismantle_wall()
	for(var/obj/O in orange(1, src))
		if(!O.pulledby && !iseffect(O) && O.density)
			if(!step_away(O, src, 2) || get_dist(O, src) < 2)
				O.take_damage(50, BURN, BOMB)
			O.update_icon()

	conversion_pulse() //Converts the nearby area into clockcult-style

	for(var/V in GLOB.player_list)
		var/mob/M = V
		var/turf/T = get_turf(M)
		if(is_servant_of_ratvar(M) && (!T || T.z != z))
			M.forceMove(get_step(src, SOUTH))
			M.overlay_fullscreen("flash", /atom/movable/screen/fullscreen/tiled/flash)
			M.clear_fullscreen("flash", 5)
	progress_in_seconds += GATEWAY_SUMMON_RATE
	switch(progress_in_seconds)
		if(-INFINITY to GATEWAY_REEBE_FOUND)
			if(!second_sound_played)
				sound_to_playing_players('sound/magic/clockwork/invoke_general.ogg', 30, FALSE)
				sound_to_playing_players('sound/effects/clockcult_gateway_charging.ogg', 10, FALSE, channel = CHANNEL_JUSTICAR_ARK)
				second_sound_played = TRUE
			make_glow()
			glow.icon_state = "clockwork_gateway_charging"
		if(GATEWAY_REEBE_FOUND to GATEWAY_RATVAR_COMING)
			if(!third_sound_played)
				sound_to_playing_players('sound/effects/clockcult_gateway_active.ogg', 30, FALSE, channel = CHANNEL_JUSTICAR_ARK)
				third_sound_played = TRUE
			make_glow()
			glow.icon_state = "clockwork_gateway_active"
		if(GATEWAY_RATVAR_COMING to GATEWAY_RATVAR_ARRIVAL)
			if(!fourth_sound_played)
				sound_to_playing_players('sound/effects/clockcult_gateway_closing.ogg', 70, FALSE, channel = CHANNEL_JUSTICAR_ARK)
				fourth_sound_played = TRUE
			make_glow()
			glow.icon_state = "clockwork_gateway_closing"
		if(GATEWAY_RATVAR_ARRIVAL to INFINITY)
			if(!purpose_fulfilled)
				fulfill_purpose()

//Converts nearby turfs into their clockwork equivalent, with ever-increasing range the closer the ark is to summoning Ratvar
/obj/structure/destructible/clockwork/massive/celestial_gateway/proc/conversion_pulse()
	var/convert_dist = 1 + (round(FLOOR(progress_in_seconds, 15) * 0.067))
	for(var/t in RANGE_TURFS(convert_dist, loc))
		var/turf/T = t
		if(!T)
			continue
		var/dist = cheap_hypotenuse(T.x, T.y, x, y)
		if(dist < convert_dist)
			T.ratvar_act(FALSE, TRUE, 3)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/structure/destructible/clockwork/massive/celestial_gateway/attack_ghost(mob/user)
	if(!IsAdminGhost(user))
		return ..()
	if(GLOB.servants_active)
		to_chat(user, "<span class='danger'>The Ark is already counting down.</span>")
		return ..()
	if(alert(user, "Activate the Ark's countdown?", name, "Yes", "No") == "Yes")
		if(alert(user, "REALLY activate the Ark's countdown?", name, "Yes", "No") == "Yes")
			if(alert(user, "You're REALLY SURE? This cannot be undone.", name, "Yes - Activate the Ark", "No") == "Yes - Activate the Ark")
				message_admins("<span class='danger'>Admin [key_name_admin(user)] started the Ark's countdown!</span>")
				log_admin("Admin [key_name(user)] started the Ark's countdown on a non-clockcult mode!")
				to_chat(user, "<span class='userdanger'>The gamemode is now being treated as clockwork cult, and the Ark is counting down from 5 \
				minutes. You will need to create servant players yourself.</span>")
				final_countdown(5)



//the actual appearance of the Ark of the Clockwork Justicar; an object so the edges of the gate can be clicked through.
/obj/effect/clockwork/overlay/gateway_glow
	icon = 'icons/effects/96x96.dmi'
	icon_state = "clockwork_gateway_components"
	pixel_x = -32
	pixel_y = -32
	layer = BELOW_OPEN_DOOR_LAYER
	light_range = 2
	light_power = 4
	light_color = "#6A4D2F"

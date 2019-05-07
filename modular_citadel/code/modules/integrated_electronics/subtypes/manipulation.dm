/obj/item/integrated_circuit/manipulation/electric_stimulator
	name = "electronic stimulation module"
	desc = "Used to induce sexual stimulation in a target via electricity."
	icon_state = "power_relay"
	extended_desc = "The circuit accepts a reference to a person, as well as a number representing the strength of the shock, and upon activation, attempts to stimulate them to orgasm. The number ranges from -35 to 35, with negative numbers reducing arousal and positive numbers increasing it by that amount."
	complexity = 15
	size = 2
	inputs = list("target" = IC_PINTYPE_REF, "strength" = IC_PINTYPE_NUMBER)
	outputs = list("arousal gain"=IC_PINTYPE_NUMBER)
	activators = list("fire" = IC_PINTYPE_PULSE_IN, "on success" = IC_PINTYPE_PULSE_OUT, "on fail" = IC_PINTYPE_PULSE_OUT, "on orgasm" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 500
	cooldown_per_use = 50
	ext_cooldown = 25

/obj/item/integrated_circuit/manipulation/electric_stimulator/do_work()
	..()
	set_pin_data(IC_OUTPUT, 1, 0)
	var/mob/living/M = get_pin_data_as_type(IC_INPUT, 1, /mob/living)
	if(!check_target(M))
		return

	var/arousal_gain = CLAMP(get_pin_data(IC_INPUT, 2),-35,35)
	set_pin_data(IC_OUTPUT, 1, arousal_gain)

	if(ismob(M) && M.canbearoused && arousal_gain != 0)
		var/orgasm = FALSE
		if(arousal_gain > 0)
			if(M.getArousalLoss() >= 100 && ishuman(M) && M.has_dna())
				var/mob/living/carbon/human/H = M
				var/orgasm_message = pick("A sharp pulse of electricity pushes you to orgasm!", "You feel a jolt of electricity force you into orgasm!")
				H.visible_message("<span class='warning'>\The [assembly] electrodes shock [H]!</span>", "<span class='warning'>[orgasm_message]</span>")
				playsound(src, "sound/effects/light_flicker.ogg", 30, 1)
				H.mob_climax(forced_climax=TRUE)
				orgasm = TRUE
			else
				M.adjustArousalLoss(arousal_gain)
				var/stimulate_message = pick("You feel a sharp warming tingle of electricity through your body!", "A burst of arousing electricity flows through your body!")
				M.visible_message("<span class='warning'>\The [assembly] electrodes shock [M]!</span>", "<span class='warning'>[stimulate_message]</span>")

		else
			var/stimulate_message = pick("You feel a dull prickle of electricity through your body!", "A burst of dull electricity flows through your body!")
			M.visible_message("<span class='warning'>\The [assembly] electrodes shock [M]!</span>", "<span class='warning'>[stimulate_message]</span>")
			M.adjustArousalLoss(arousal_gain)

		playsound(src, "sound/effects/light_flicker.ogg", 30, 1)
		push_data()
		activate_pin(2)
		if(orgasm) activate_pin(4)

	else
		visible_message("<span class='warning'>\The [assembly] electrodes fail to shock [M]!</span>")
		push_data()
		activate_pin(3)


/obj/item/integrated_circuit/manipulation/vibe
	name = "vibrator module"
	desc = "Used to induce sexual stimulation in a target via vibrations."
	icon_state = "power_relay"
	extended_desc = "The circuit accepts a reference to a person, as well as a number representing the strength of the vibration, and when enabled, will continue stimulating them to orgasm. The intensity ranges from 0 to 10."
	complexity = 15
	size = 2
	inputs = list("target" = IC_PINTYPE_REF, "intensity" = IC_PINTYPE_NUMBER, "enabled" = IC_PINTYPE_BOOLEAN)
	outputs = list()
	activators = list("on orgasm" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 5
	var/mob/living/target //need this to keep track, so that we don't spam the person with messages
	var/intensity = 1
	var/prev_intensity = 1
	var/delay = 1 SECONDS
	var/next_fire = 0
	var/is_running = FALSE
	var/datum/looping_sound/vibe/soundloop

/datum/looping_sound/vibe
	start_sound = ('modular_citadel/sound/misc/vibe_start.ogg')
	start_length = 20
	mid_sounds = list('modular_citadel/sound/misc/vibe_loop.ogg')
	mid_length = 55
	end_sound = null
	volume = 1

/obj/item/integrated_circuit/manipulation/vibe/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)
	set_pin_data(IC_INPUT, 2, 2)

/obj/item/integrated_circuit/manipulation/vibe/Destroy()
	if(is_running)
		STOP_PROCESSING(SSfastprocess, src)
	QDEL_NULL(soundloop)
	return ..()

/obj/item/integrated_circuit/manipulation/vibe/on_data_written()
	soundloop.stop()

	if(!assembly || !assembly.battery)
		return

	var/do_tick = get_pin_data(IC_INPUT, 3)
	if(do_tick && !is_running)
		is_running = TRUE
		tick()
	else if(!do_tick && is_running)
		is_running = FALSE

	var/intensity_input = get_pin_data(IC_INPUT, 2)
	if(isnum(intensity_input))
		intensity = CLAMP(intensity_input,0,10)

	if(is_running)
		if(intensity > 0)
			soundloop.volume = round(intensity/2)+5
			soundloop.start()

/obj/item/integrated_circuit/manipulation/vibe/proc/tick()
	if(!assembly || !assembly.battery)
		set_pin_data(IC_INPUT, 3, FALSE)
		is_running = FALSE
		soundloop.stop()
		return

	if(is_running)
		addtimer(CALLBACK(src, .proc/tick), delay)
		if(world.time > next_fire)
			next_fire = world.time + delay

		var/mob/living/M = get_pin_data_as_type(IC_INPUT, 1, /mob/living)
		if(!check_target(M))
			return

		var/arousal_gain
		if(intensity == 0)
			arousal_gain = -5 //something something denial
		else
			arousal_gain = intensity/2

		if(ismob(M) && M.canbearoused && arousal_gain != 0)
			if(intensity > prev_intensity)
				M.visible_message(null, "<span class='warning'>The vibrations of \the [assembly] speed up!</span>")
			else if(intensity < prev_intensity)
				M.visible_message(null, "<span class='warning'>The vibrations of \the [assembly] sloooow down.</span>")


			var/orgasm = FALSE
			if(arousal_gain > 0)
				if(M.getArousalLoss() >= 100 && ishuman(M) && M.has_dna())
					var/mob/living/carbon/human/H = M
					var/orgasm_message = pick("The constant stimulation pushes pushes you to orgasm!","The vibrating device finally forces you into orgasm!")
					H.visible_message(null, "<span class='warning'>[orgasm_message]</span>")
					H.mob_climax(forced_climax=TRUE)
					orgasm = TRUE
				else
					M.adjustArousalLoss(arousal_gain)
					if(M != target)
						var/stimulate_message = pick("\The [assembly] vibrates, stimulating you.", "A burst of arousing electricity flows through your body!")
						M.visible_message("", "<span class='warning'>[stimulate_message]</span>")
			else
				M.adjustArousalLoss(arousal_gain)
				if(intensity < prev_intensity)
					var/stimulate_message = pick("\The [assembly] slows down to a halt, denying you pleasure.", "You're suddenly denied any more stimulation from \the [assembly].")
					M.visible_message("", "<span class='warning'>[stimulate_message]</span>")


			push_data()
			if(orgasm) activate_pin(1)

		target = M
		prev_intensity = intensity

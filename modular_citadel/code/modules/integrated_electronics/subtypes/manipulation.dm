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

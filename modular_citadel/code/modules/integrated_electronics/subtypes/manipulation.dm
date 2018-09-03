/obj/item/integrated_circuit/manipulation/electric_stimulator
	name = "electronic stimulation module"
	desc = "Used to induce sexual stimulation with electricity."
	icon_state = "power_relay"
	extended_desc = "The circuit accepts a reference to a person and upon activation, attempts to stimulate them to orgasm."
	complexity = 10
	size = 3
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list()
	activators = list("fire" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 500
	cooldown_per_use = 50

/obj/item/integrated_circuit/manipulation/electric_stimulator/do_work()
	..()
	var/mob/living/M = get_pin_data_as_type(IC_INPUT, 1, /mob/living)
	if(!check_target(M))
		return
	if(ismob(M) && M.canbearoused)
		if(M.getArousalLoss() >= 100 && ishuman(M) && M.has_dna())
			var/mob/living/carbon/human/H = M
			var/orgasm_message = pick("A sharp pulse of electricity pushes you to orgasm!", "You feel a jolt of electricity force you into orgasm!")
			H.visible_message("<span class='warning'>\The [assembly] electrodes shock [H]!</span>", "<span class='warning'>[orgasm_message]</span>")
			playsound(src, "sound/effects/light_flicker.ogg", 30, 1)
			H.mob_climax(forced_climax=TRUE)
		else
			M.adjustArousalLoss(35)
			var/stimulate_message = pick("You feel a sharp warming tingle of electricity through your body!", "A burst of arousing electricity flows through your body!")
			M.visible_message("<span class='warning'>\The [assembly] electrodes shock [M]!</span>", "<span class='warning'>[stimulate_message]</span>")
			playsound(src, "sound/effects/light_flicker.ogg", 30, 1)
	else
		visible_message("<span class='warning'>\The [assembly] electrodes fail to shock [M]!</span>")

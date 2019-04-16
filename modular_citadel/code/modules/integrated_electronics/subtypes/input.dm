/obj/item/integrated_circuit/input/bonermeter
	name = "bonermeter"
	desc = "Detects the target's arousal and various statistics about the target's arousal levels. Invasive!"
	icon_state = "medscan"
	complexity = 4
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"current arousal" = IC_PINTYPE_NUMBER,
		"minimum arousal" = IC_PINTYPE_NUMBER,
		"maximum arousal" = IC_PINTYPE_NUMBER,
		"can be aroused" = IC_PINTYPE_BOOLEAN
		)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/bonermeter/do_work()

	var/mob/living/L = get_pin_data_as_type(IC_INPUT, 1, /mob/living)

	if(!istype(L) || !L.Adjacent(get_turf(src)) ) //Invalid input
		return

	set_pin_data(IC_OUTPUT,	1, L.getArousalLoss())
	set_pin_data(IC_OUTPUT,	2, L.min_arousal)
	set_pin_data(IC_OUTPUT,	3, L.max_arousal)
	set_pin_data(IC_OUTPUT,	4, L.canbearoused)
	push_data()
	activate_pin(2)
/obj/item/integrated_circuit/manipulation/activator
	name = "activator"
	desc = "Circuit which can activate things remotely!"
	icon_state = "pull_claw"
	extended_desc = "This circuit needs a reference to a thing to activate, it also needs to know who is activating said item."
	w_class = WEIGHT_CLASS_SMALL
	size = 3
	cooldown_per_use = 1
	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF, "person" = IC_PINTYPE_REF)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	ext_cooldown = 1

/obj/item/integrated_circuit/manipulation/activator/do_work(ord)
	var/obj/acting_object = get_pin_data_as_type(IC_INPUT, 1, /obj/)
	var/mob/person = get_pin_data_as_type(IC_INPUT, 2, /mob/)
	acting_object.interact(person)
	activate_pin(1)


/obj/item/integrated_circuit/manipulation/advactivator
	name = "advactivator"
	desc = "Circuit which can UI elements remotely!"
	icon_state = "pull_claw"
	extended_desc = "This circuit needs a reference to a to activate, as well as action and parems to pass! Use mode 1 for lists or 0 for single values."
	w_class = WEIGHT_CLASS_SMALL
	size = 3
	cooldown_per_use = 1
	complexity = 10

	//inputs = list("target" = IC_PINTYPE_REF, "action" = IC_PINTYPE_STRING, "params" = IC_PINTYPE_STRING)
	inputs = list("target" = IC_PINTYPE_REF, "action" = IC_PINTYPE_STRING, "mode" = IC_PINTYPE_NUMBER, "params" = IC_PINTYPE_STRING, "listparams" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	ext_cooldown = 1
	var/max_grab = GRAB_PASSIVE

/obj/item/integrated_circuit/manipulation/advactivator/do_work(ord)
	var/obj/acting_object = get_pin_data_as_type(IC_INPUT, 1, /obj/)
	var/action = get_pin_data(IC_INPUT, 2)
	var/mode = get_pin_data(IC_INPUT, 3)
	var/params = get_pin_data(IC_INPUT, 4)
	if(mode == 1)
		params = get_pin_data(IC_INPUT, 5)

	acting_object.ui_act(action, params)
	activate_pin(1)

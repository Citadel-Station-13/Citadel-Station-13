/*
It's like a regular ol' straight pipe, but you can turn it on and off.
*/

ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/binary/valve, "mvalve_map")
/obj/machinery/atmospherics/component/binary/valve
	icon_state = "mvalve_map"
	name = "manual valve"
	desc = "A pipe with a valve that can be used to disable flow of gas through it."

	can_unwrench = TRUE
	shift_underlay_only = FALSE

	interaction_flags_machine = INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_OPEN //Intentionally no allow_silicon flag
	pipe_flags = PIPE_CARDINAL_AUTONORMALIZE

	var/frequency = 0
	var/id = null

	var/valve_type = "m" //lets us have a nice, clean, OOP update_icon_nopipes()

	construction_type = /obj/item/pipe/binary
	pipe_state = "mvalve"

	var/switching = FALSE

/obj/machinery/atmospherics/component/binary/valve/update_icon_state()
	. = ..()
	icon_state = "[valve_type]valve_[on ? "on" : "off"]"

/obj/machinery/atmospherics/component/binary/valve/proc/toggle()
	if(on)
		on = FALSE
		update_icon()
		investigate_log("was closed by [usr ? key_name(usr) : "a remote signal"]", INVESTIGATE_ATMOS)
	else
		on = TRUE
		update_icon()
		MarkDirty()
		ImmediatePipelineUpdate(1)
		investigate_log("was opened by [usr ? key_name(usr) : "a remote signal"]", INVESTIGATE_ATMOS)

/obj/machinery/atmospherics/component/binary/valve/proc/switch_animation()
	flick("[valve_type]valve_[on][!on]", src)

/obj/machinery/atmospherics/component/binary/valve/interact(mob/user)
	add_fingerprint(usr)
	if(switching)
		return
	switch_animation()
	update_icon()
	switching = TRUE
	addtimer(CALLBACK(src, .proc/finish_interact), 10)

/obj/machinery/atmospherics/component/binary/valve/proc/finish_interact()
	toggle()
	switching = FALSE

ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/binary/valve/digital, "dvalve_map")
/obj/machinery/atmospherics/component/binary/valve/digital // can be controlled by AI
	icon_state = "dvalve_map"
	name = "digital valve"
	desc = "A digitally controlled valve."
	valve_type = "d"
	pipe_state = "dvalve"
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_OPEN | INTERACT_MACHINE_OPEN_SILICON

/obj/machinery/atmospherics/component/binary/valve/digital/update_icon_state()
	. = ..()
	if(!is_operational())
		icon_state = "dvalve_nopower"

ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/binary/valve/on, "mvalve_on_map")
/obj/machinery/atmospherics/component/binary/valve/on
	on = TRUE

ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/binary/valve/digital/on, "dvalve_on_map")
/obj/machinery/atmospherics/component/binary/valve/digital/on
	on = TRUE

ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/unary/heat_exchanger, "he_map")

/obj/machinery/atmospherics/component/unary/heat_exchanger
	icon = 'icons/modules/atmospherics/component/heat_exchanger.dmi'
	icon_state = "he1"

	name = "heat exchanger"
	desc = "Exchanges heat between two input gases. Set up for fast heat transfer."

	can_unwrench = TRUE
	shift_to_layer = TRUE
	double_layer_shift = FALSE

	layer = LOW_OBJ_LAYER

	var/obj/machinery/atmospherics/component/unary/heat_exchanger/partner = null
	var/update_cycle
	var/old_temperature = 0
	var/other_old_temperature = 0

	pipe_state = "heunary"

/obj/machinery/atmospherics/component/unary/heat_exchanger/update_icon_state()
	if(connected[1])
		icon_state = "he1"
		var/obj/machinery/atmospherics/node = connected[1]
		add_atom_colour(node.color, FIXED_COLOUR_PRIORITY)
	else
		icon_state = "he0"

/obj/machinery/atmospherics/component/unary/heat_exchanger/update_layer()
	. = ..()
	PIPE_LAYER_SHIFT(src, pipe_layer)

/obj/machinery/atmospherics/component/unary/heat_exchanger/Join()
	. = ..()
	if(partner)
		CRASH("Heat exchanger had a partner already on Join().")
	var/partner_connect = turn(dir, 180)
	for(var/obj/machinery/atmospherics/component/unary/heat_exchanger/target in get_step(src, partner_connect))
		if(!(target.pipe_flags & PIPE_NETWORK_JOINED))
			continue
		if(target.partner)
			continue
		partner = target
		target.partner = src

/obj/machinery/atmospherics/component/unary/heat_exchanger/Leave()
	. = ..()
	if(partner)
		if(partner.partner != src)
			stack_trace("Heat exchanger had a mismatching partner.")
		else
			partner.partner = null
		partner = null

/obj/machinery/atmospherics/component/unary/heat_exchanger/process_atmos()
	if(!partner || SSair.times_fired <= update_cycle)
		return

	update_cycle = SSair.times_fired
	partner.update_cycle = SSair.times_fired

	if(!QUANTIZE(heat_exchange_gas_to_gas(airs[1], partner.airs[1], null, 0.8)))
		return
	MarkDirty()
	partner.MarkDirty()

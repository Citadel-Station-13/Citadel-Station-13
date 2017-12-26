/obj/item/integrated_circuit/smart
	category_text = "Smart"

/obj/item/integrated_circuit/smart/basic_pathfinder
	name = "basic pathfinder"
	desc = "This complex circuit is able to determine what direction a given target is."
	extended_desc = "This circuit uses a miniturized, integrated camera to determine where the target is.  If the machine \
	cannot see the target, it will not be able to calculate the correct direction."
	icon_state = "numberpad"
	complexity = 25
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list("dir" = IC_PINTYPE_DIR)
	activators = list("calculate dir" = IC_PINTYPE_PULSE_IN, "on calculated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/smart/basic_pathfinder/do_work()
	var/datum/integrated_io/I = inputs[1]
	set_pin_data(IC_OUTPUT, 1, null)

	if(!isweakref(I.data))
		return
	var/atom/A = I.data.resolve()
	if(!A)
		return
	if(!(A in view(get_turf(src))))
		push_data()
		return // Can't see the target.

	set_pin_data(IC_OUTPUT, 1, get_dir(get_turf(src), get_step_towards2(get_turf(src),A)))
	push_data()
	activate_pin(2)

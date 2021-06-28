 /*
What are the archived variables for?
	Calculations are done using the archived variables with the results merged into the regular variables.
	This prevents race conditions that arise based on the order of tile processing.
*/
#define MINIMUM_HEAT_CAPACITY	0.0003
#define MINIMUM_MOLE_COUNT		0.01

//Unomos - global list inits for all of the meta gas lists.
//This setup allows procs to only look at one list instead of trying to dig around in lists-within-lists
GLOBAL_LIST_INIT(meta_gas_specific_heats, meta_gas_heat_list())
GLOBAL_LIST_INIT(meta_gas_names, meta_gas_name_list())
GLOBAL_LIST_INIT(meta_gas_visibility, meta_gas_visibility_list())
GLOBAL_LIST_INIT(meta_gas_overlays, meta_gas_overlay_list())
GLOBAL_LIST_INIT(meta_gas_dangers, meta_gas_danger_list())
GLOBAL_LIST_INIT(meta_gas_ids, meta_gas_id_list())
GLOBAL_LIST_INIT(meta_gas_fusions, meta_gas_fusion_list())
/datum/gas_mixture
	/// Never ever set this variable, hooked into vv_get_var for view variables viewing.
	var/gas_list_view_only
	var/initial_volume = CELL_VOLUME //liters
	var/list/reaction_results
	var/list/analyzer_results //used for analyzer feedback - not initialized until its used
	var/_extools_pointer_gasmixture = 0 // Contains the memory address of the shared_ptr object for this gas mixture in c++ land. Don't. Touch. This. Var.

/datum/gas_mixture/New(volume)
	if (!isnull(volume))
		initial_volume = volume
	ATMOS_EXTOOLS_CHECK
	__gasmixture_register()
	reaction_results = new

/datum/gas_mixture/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, _extools_pointer_gasmixture))
		return FALSE // please no. segfaults bad.
	if(var_name == NAMEOF(src, gas_list_view_only))
		return FALSE
	return ..()

/datum/gas_mixture/vv_get_var(var_name)
	. = ..()
	if(var_name == NAMEOF(src, gas_list_view_only))
		var/list/dummy = get_gases()
		for(var/gas in dummy)
			dummy[gas] = get_moles(gas)
		dummy["TEMP"] = return_temperature()
		dummy["PRESSURE"] = return_pressure()
		dummy["HEAT CAPACITY"] = heat_capacity()
		dummy["TOTAL MOLES"] = total_moles()
		dummy["VOLUME"] = return_volume()
		dummy["THERMAL ENERGY"] = thermal_energy()
		return debug_variable("gases (READ ONLY)", dummy, 0, src)

/datum/gas_mixture/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_PARSE_GASSTRING, "Parse Gas String")
	VV_DROPDOWN_OPTION(VV_HK_EMPTY, "Empty")
	VV_DROPDOWN_OPTION(VV_HK_SET_MOLES, "Set Moles")
	VV_DROPDOWN_OPTION(VV_HK_SET_TEMPERATURE, "Set Temperature")
	VV_DROPDOWN_OPTION(VV_HK_SET_VOLUME, "Set Volume")

/datum/gas_mixture/vv_do_topic(list/href_list)
	. = ..()
	if(!.)
		return
	if(href_list[VV_HK_PARSE_GASSTRING])
		var/gasstring = input(usr, "Input Gas String (WARNING: Advanced. Don't use this unless you know how these work.", "Gas String Parse") as text|null
		if(!istext(gasstring))
			return
		log_admin("[key_name(usr)] modified gas mixture [REF(src)]: Set to gas string [gasstring].")
		message_admins("[key_name(usr)] modified gas mixture [REF(src)]: Set to gas string [gasstring].")
		parse_gas_string(gasstring)
	if(href_list[VV_HK_EMPTY])
		log_admin("[key_name(usr)] emptied gas mixture [REF(src)].")
		message_admins("[key_name(usr)] emptied gas mixture [REF(src)].")
		clear()
	if(href_list[VV_HK_SET_MOLES])
		var/list/gases = get_gases()
		for(var/gas in gases)
			gases[gas] = get_moles(gas)
		var/gastype = input(usr, "What kind of gas?", "Set Gas") as null|anything in subtypesof(/datum/gas)
		if(!ispath(gastype, /datum/gas))
			return
		var/amount = input(usr, "Input amount", "Set Gas", gases[gastype] || 0) as num|null
		if(!isnum(amount))
			return
		amount = max(0, amount)
		log_admin("[key_name(usr)] modified gas mixture [REF(src)]: Set gas type [gastype] to [amount] moles.")
		message_admins("[key_name(usr)] modified gas mixture [REF(src)]: Set gas type [gastype] to [amount] moles.")
		set_moles(gastype, amount)
	if(href_list[VV_HK_SET_TEMPERATURE])
		var/temp = input(usr, "Set the temperature of this mixture to?", "Set Temperature", return_temperature()) as num|null
		if(!isnum(temp))
			return
		temp = max(2.7, temp)
		log_admin("[key_name(usr)] modified gas mixture [REF(src)]: Changed temperature to [temp].")
		message_admins("[key_name(usr)] modified gas mixture [REF(src)]: Changed temperature to [temp].")
		set_temperature(temp)
	if(href_list[VV_HK_SET_VOLUME])
		var/volume = input(usr, "Set the volume of this mixture to?", "Set Volume", return_volume()) as num|null
		if(!isnum(volume))
			return
		volume = max(0, volume)
		log_admin("[key_name(usr)] modified gas mixture [REF(src)]: Changed volume to [volume].")
		message_admins("[key_name(usr)] modified gas mixture [REF(src)]: Changed volume to [volume].")
		set_volume(volume)

/*
/datum/gas_mixture/Del()
	__gasmixture_unregister()
	. = ..()*/

/datum/gas_mixture/proc/__gasmixture_unregister()
/datum/gas_mixture/proc/__gasmixture_register()

/proc/gas_types()
	var/list/L = subtypesof(/datum/gas)
	for(var/gt in L)
		var/datum/gas/G = gt
		L[gt] = initial(G.specific_heat)
	return L

/datum/gas_mixture/proc/heat_capacity() //joules per kelvin

/datum/gas_mixture/proc/total_moles()

/datum/gas_mixture/proc/return_pressure() //kilopascals

/datum/gas_mixture/proc/return_temperature() //kelvins

/datum/gas_mixture/proc/set_min_heat_capacity(n)
/datum/gas_mixture/proc/set_temperature(new_temp)
/datum/gas_mixture/proc/set_volume(new_volume)
/datum/gas_mixture/proc/get_moles(gas_type)
/datum/gas_mixture/proc/set_moles(gas_type, moles)

// VV WRAPPERS - EXTOOLS HOOKED PROCS DO NOT TAKE ARGUMENTS FROM CALL() FOR SOME REASON.
/datum/gas_mixture/proc/vv_set_moles(gas_type, moles)
	return set_moles(gas_type, moles)
/datum/gas_mixture/proc/vv_get_moles(gas_type)
	return get_moles(gas_type)
/datum/gas_mixture/proc/vv_set_temperature(new_temp)
	return set_temperature(new_temp)
/datum/gas_mixture/proc/vv_set_volume(new_volume)
	return set_volume(new_volume)
/datum/gas_mixture/proc/vv_react(datum/holder)
	return react(holder)

/datum/gas_mixture/proc/scrub_into(datum/gas_mixture/target, list/gases)
/datum/gas_mixture/proc/mark_immutable()
/datum/gas_mixture/proc/get_gases()
/datum/gas_mixture/proc/multiply(factor)
/datum/gas_mixture/proc/get_last_share()
/datum/gas_mixture/proc/clear()

/datum/gas_mixture/proc/adjust_moles(gas_type, amt = 0)
	set_moles(gas_type, get_moles(gas_type) + amt)

/datum/gas_mixture/proc/return_volume() //liters

/datum/gas_mixture/proc/thermal_energy() //joules

/datum/gas_mixture/proc/archive()
	//Update archived versions of variables
	//Returns: 1 in all cases

/datum/gas_mixture/proc/merge(datum/gas_mixture/giver)
	//Merges all air from giver into self. giver is untouched.
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/remove(amount)
	//Removes amount of gas from the gas_mixture
	//Returns: gas_mixture with the gases removed

/datum/gas_mixture/proc/transfer_to(datum/gas_mixture/target, amount)
	//Transfers amount of gas to target. Equivalent to target.merge(remove(amount)) but faster.
	//Removes amount of gas from the gas_mixture

/datum/gas_mixture/proc/remove_ratio(ratio)
	//Proportionally removes amount of gas from the gas_mixture
	//Returns: gas_mixture with the gases removed

/datum/gas_mixture/proc/copy()
	//Creates new, identical gas mixture
	//Returns: duplicate gas mixture

/datum/gas_mixture/proc/copy_from(datum/gas_mixture/sample)
	//Copies variables from sample
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/copy_from_turf(turf/model)
	//Copies all gas info from the turf into the gas list along with temperature
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/parse_gas_string(gas_string)
	//Copies variables from a particularly formatted string.
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/share(datum/gas_mixture/sharer)
	//Performs air sharing calculations between two gas_mixtures assuming only 1 boundary length
	//Returns: amount of gas exchanged (+ if sharer received)

/datum/gas_mixture/proc/temperature_share(datum/gas_mixture/sharer, conduction_coefficient,temperature=null,heat_capacity=null)
	//Performs temperature sharing calculations (via conduction) between two gas_mixtures assuming only 1 boundary length
	//Returns: new temperature of the sharer

/datum/gas_mixture/proc/compare(datum/gas_mixture/sample)
	//Compares sample to self to see if within acceptable ranges that group processing may be enabled
	//Returns: a string indicating what check failed, or "" if check passes

/datum/gas_mixture/proc/react(datum/holder)
	//Performs various reactions such as combustion or fusion (LOL)
	//Returns: 1 if any reaction took place; 0 otherwise

/datum/gas_mixture/proc/__remove()
/datum/gas_mixture/remove(amount)
	var/datum/gas_mixture/removed = new type
	__remove(removed, amount)

	return removed

/datum/gas_mixture/proc/__remove_ratio()
/datum/gas_mixture/remove_ratio(ratio)
	var/datum/gas_mixture/removed = new type
	__remove_ratio(removed, ratio)

	return removed

/datum/gas_mixture/copy()
	var/datum/gas_mixture/copy = new type
	copy.copy_from(src)

	return copy

/datum/gas_mixture/copy_from_turf(turf/model)
	parse_gas_string(model.initial_gas_mix)

	//acounts for changes in temperature
	var/turf/model_parent = model.parent_type
	if(model.temperature != initial(model.temperature) || model.temperature != initial(model_parent.temperature))
		set_temperature(model.temperature)

	return 1

/datum/gas_mixture/parse_gas_string(gas_string)
	var/list/gas = params2list(gas_string)
	if(gas["TEMP"])
		set_temperature(text2num(gas["TEMP"]))
		gas -= "TEMP"
	clear()
	for(var/id in gas)
		var/path = id
		if(!ispath(path))
			path = gas_id2path(path) //a lot of these strings can't have embedded expressions (especially for mappers), so support for IDs needs to stick around
		set_moles(path, text2num(gas[id]))
	archive()
	return 1
/*
/datum/gas_mixture/react(datum/holder)
	. = NO_REACTION
	if(!total_moles())
		return
	var/list/reactions = list()
	for(var/datum/gas_reaction/G in SSair.gas_reactions)
		if(get_moles(G.major_gas))
			reactions += G
	if(!length(reactions))
		return
	reaction_results = new
	var/temp = return_temperature()
	var/ener = thermal_energy()

	reaction_loop:
		for(var/r in reactions)
			var/datum/gas_reaction/reaction = r

			var/list/min_reqs = reaction.min_requirements
			if((min_reqs["TEMP"] && temp < min_reqs["TEMP"]) \
			|| (min_reqs["ENER"] && ener < min_reqs["ENER"]))
				continue

			for(var/id in min_reqs)
				if (id == "TEMP" || id == "ENER")
					continue
				if(get_moles(id) < min_reqs[id])
					continue reaction_loop
			//at this point, all minimum requirements for the reaction are satisfied.

			/*	currently no reactions have maximum requirements, so we can leave the checks commented out for a slight performance boost
				PLEASE DO NOT REMOVE THIS CODE. the commenting is here only for a performance increase.
				enabling these checks should be as easy as possible and the fact that they are disabled should be as clear as possible
			var/list/max_reqs = reaction.max_requirements
			if((max_reqs["TEMP"] && temp > max_reqs["TEMP"]) \
			|| (max_reqs["ENER"] && ener > max_reqs["ENER"]))
				continue
			for(var/id in max_reqs)
				if(id == "TEMP" || id == "ENER")
					continue
				if(cached_gases[id] && cached_gases[id][MOLES] > max_reqs[id])
					continue reaction_loop
			//at this point, all requirements for the reaction are satisfied. we can now react()
			*/
			. |= reaction.react(src, holder)
			if (. & STOP_REACTIONS)
				break
*/
//Takes the amount of the gas you want to PP as an argument
//So I don't have to do some hacky switches/defines/magic strings
//eg:
//Tox_PP = get_partial_pressure(gas_mixture.toxins)
//O2_PP = get_partial_pressure(gas_mixture.oxygen)

/datum/gas_mixture/proc/get_breath_partial_pressure(gas_pressure)
	return (gas_pressure * R_IDEAL_GAS_EQUATION * return_temperature()) / BREATH_VOLUME
//inverse
/datum/gas_mixture/proc/get_true_breath_pressure(partial_pressure)
	return (partial_pressure * BREATH_VOLUME) / (R_IDEAL_GAS_EQUATION * return_temperature())

//Mathematical proofs:
/*
get_breath_partial_pressure(gas_pp) --> gas_pp/total_moles()*breath_pp = pp
get_true_breath_pressure(pp) --> gas_pp = pp/breath_pp*total_moles()
10/20*5 = 2.5
10 = 2.5/5*20
*/

/datum/gas_mixture/turf

/*
/mob/verb/profile_atmos()
	/world{loop_checks = 0;}
	var/datum/gas_mixture/A = new
	var/datum/gas_mixture/B = new
	A.parse_gas_string("o2=200;n2=800;TEMP=50")
	B.parse_gas_string("co2=500;plasma=500;TEMP=5000")
	var/pa
	var/pb
	pa = world.tick_usage
	for(var/I in 1 to 100000)
		B.transfer_to(A, 1)
		A.transfer_to(B, 1)
	pb = world.tick_usage
	var/total_time = (pb-pa) * world.tick_lag
	to_chat(src, "Total time (gas transfer): [total_time]ms")
	to_chat(src, "Operations per second: [100000 / (total_time/1000)]")
	pa = world.tick_usage
	for(var/I in 1 to 100000)
		B.total_moles();
	pb = world.tick_usage
	total_time = (pb-pa) * world.tick_lag
	to_chat(src, "Total time (total_moles): [total_time]ms")
	to_chat(src, "Operations per second: [100000 / (total_time/1000)]")
	pa = world.tick_usage
	for(var/I in 1 to 100000)
		new /datum/gas_mixture
	pb = world.tick_usage
	total_time = (pb-pa) * world.tick_lag
	to_chat(src, "Total time (new gas mixture): [total_time]ms")
	to_chat(src, "Operations per second: [100000 / (total_time/1000)]")
*/

/// Releases gas from src to output air. This means that it can not transfer air to gas mixture with higher pressure.
/// a global proc due to rustmos
/proc/release_gas_to(datum/gas_mixture/input_air, datum/gas_mixture/output_air, target_pressure)
	var/output_starting_pressure = output_air.return_pressure()
	var/input_starting_pressure = input_air.return_pressure()

	if(output_starting_pressure >= min(target_pressure,input_starting_pressure-10))
		//No need to pump gas if target is already reached or input pressure is too low
		//Need at least 10 KPa difference to overcome friction in the mechanism
		return FALSE

	//Calculate necessary moles to transfer using PV = nRT
	if((input_air.total_moles() > 0) && (input_air.return_temperature()>0))
		var/pressure_delta = min(target_pressure - output_starting_pressure, (input_starting_pressure - output_starting_pressure)/2)
		//Can not have a pressure delta that would cause output_pressure > input_pressure

		var/transfer_moles = pressure_delta*output_air.return_volume()/(input_air.return_temperature() * R_IDEAL_GAS_EQUATION)

		//Actually transfer the gas
		var/datum/gas_mixture/removed = input_air.remove(transfer_moles)
		output_air.merge(removed)

		return TRUE
	return FALSE

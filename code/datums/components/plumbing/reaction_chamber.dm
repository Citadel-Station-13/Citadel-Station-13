/datum/component/plumbing/reaction_chamber
	demand_connects = WEST
	supply_connects = EAST

/datum/component/plumbing/reaction_chamber/Initialize(start=TRUE, _turn_connects=TRUE)
	. = ..()
	if(!istype(parent, /obj/machinery/plumbing/reaction_chamber))
		return COMPONENT_INCOMPATIBLE

/datum/component/plumbing/reaction_chamber/can_give(amount, reagent)
	. = ..()
	var/obj/machinery/plumbing/reaction_chamber/RC = parent
	if(!. || !RC.emptying)
		return FALSE

/datum/component/plumbing/reaction_chamber/send_request(dir)
	var/obj/machinery/plumbing/reaction_chamber/RC = parent
	if(RC.emptying || !LAZYLEN(RC.required_reagents))
		return
	for(var/RTid in RC.required_reagents)
		var/has_reagent = FALSE
		for(var/A in reagents.reagent_list)
			var/datum/reagent/RD = A
			if(RTid == RD.id)
				has_reagent = TRUE
				if(RD.volume < RC.required_reagents[RTid])
					process_request(min(RC.required_reagents[RTid] - RD.volume, MACHINE_REAGENT_TRANSFER) , RTid, dir)
					return
		if(!has_reagent)
			process_request(min(RC.required_reagents[RTid], MACHINE_REAGENT_TRANSFER), RTid, dir)
			return

	RC.reagent_flags &= ~NO_REACT
	reagents.handle_reactions()
	Add when everything works:
	if(reagents.fermiIsReacting)
		return
	RC.emptying = TRUE

/datum/component/plumbing/reaction_chamber/can_give(amount, reagent, datum/ductnet/net)
	. = ..()
	var/obj/machinery/plumbing/reaction_chamber/RC = parent
	if(!. || !RC.emptying)
		return FALSE

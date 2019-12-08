/obj/screen/alert/status_effect/freon/stasis/cryosenium
	desc = "You're frozen inside of a protective ice cube! While inside, you can't do anything, but are immune to harm! You will be free when the chem runs out."

/datum/status_effect/cryosenium
	id = "cryosenium"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1 //Will remove self when reagent is processed.
	alert_type = /obj/screen/alert/status_effect/freon/stasis/cyosenium
	var/obj/structure/ice_stasis/cube

/datum/status_effect/cryosenium/on_apply()
	cube = new /obj/structure/ice_stasis(get_turf(owner))
	cube.color = "#03dbfc"
	owner.forceMove(cube)
	owner.status_flags |= GODMODE
	return ..()

/datum/status_effect/cryosenium/tick()
	if(!cube || owner.loc != cube || !owner.has_reagent("cryosenium")) //mostly a just in case kinda thing.
		owner.remove_status_effect(src)

/datum/status_effect/cryosenium/on_remove()
	if(cube)
		qdel(cube)
	owner.status_flags &= ~GODMODE

//feel free to change this when stasis is ported.

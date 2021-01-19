/datum/wires/firealarm
	holder_type = /obj/machinery/firealarm
	proper_name = "Fire alarm's"
	req_knowledge = JOB_SKILL_MASTER

/datum/wires/firealarm/New(atom/holder)
	wires = list(
		WIRE_FIRE_TOGGLE,
		WIRE_FIRE_DETECT,
		WIRE_FIRE_TRIGGER
	)
	add_duds(2)
	..()

/datum/wires/firealarm/interactable(mob/user)
	var/obj/machinery/firealarm/A = holder
	if(A.panel_open)
		return TRUE

/datum/wires/firealarm/get_status()
	var/obj/machinery/firealarm/A = holder
	var/list/status = list()
	status += "The alarm light is [A.alarm_active ? "blinking red" : "green"]."
	status += "The fire detection light is [A.detecting ? "on" : "off"]."
	status += "The button wire is [A.button_wire_cut ? "cut" : "connected"]."
	return status

/datum/wires/firealarm/on_pulse(wire)
	var/obj/machinery/firealarm/A = holder
	switch(wire)
		if(WIRE_FIRE_TOGGLE) // ohno, fire!
			if(A.alarm_active && !A.wire_override)
				A.reset()
			else if(!A.alarm_active)
				A.alarm() //no wire_override here, it's just a pulse.
		if(WIRE_FIRE_DETECT)
			A.detecting = !A.detecting
		if(WIRE_FIRE_TRIGGER)
			A.alarm()
			addtimer(CALLBACK(A, /obj/machinery/firealarm.proc/reset, wire), 1000)				

/datum/wires/firealarm/on_cut(index, mend)
	var/obj/machinery/firealarm/A = holder
	switch(index)
		if(WIRE_FIRE_TOGGLE)
			if(mend)
				A.wire_override = FALSE
				A.reset()
			else
				A.wire_override = TRUE
				A.alarm()
		if(WIRE_FIRE_DETECT)
			if(mend)
				A.detecting = TRUE
			else
				A.detecting = FALSE
		if(WIRE_FIRE_TRIGGER)
			if(mend)
				A.button_wire_cut = FALSE
			else
				A.button_wire_cut = TRUE

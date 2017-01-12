/datum/wires/robot
	holder_type = /mob/living/silicon/robot
	randomize = TRUE

/datum/wires/robot/New(atom/holder)
	wires = list(
		WIRE_AI, WIRE_CAMERA,
		WIRE_LAWSYNC, WIRE_LOCKDOWN
	)
	add_duds(2)
	..()

/datum/wires/robot/interactable(mob/user)
	var/mob/living/silicon/robot/R = holder
	if(R.wiresexposed)
		return TRUE

/datum/wires/robot/get_status()
	var/mob/living/silicon/robot/R = holder
	var/list/status = list()
	status += "The law sync module is [R.lawupdate ? "on" : "off"]."
	status += "The intelligence link display shows [R.connected_ai ? R.connected_ai.name : "NULL"]."
	status += "The camera light is [!isnull(R.camera) && R.camera.status ? "on" : "off"]."
	status += "The lockdown indicator is [R.lockcharge ? "on" : "off"]."
	return status

/datum/wires/robot/on_pulse(wire)
	var/mob/living/silicon/robot/R = holder
	switch(wire)
		if(WIRE_AI) // Pulse to pick a new AI.
			if(!R.emagged)
				var/new_ai = select_active_ai(R)
				if(new_ai && (new_ai != R.connected_ai))
					R.connected_ai = new_ai
					R.notify_ai(TRUE)
		if(WIRE_CAMERA) // Pulse to disable the camera.
			if(!isnull(R.camera) && !R.scrambledcodes)
				R.camera.toggle_cam(usr, 0)
				R.visible_message("[R]'s camera lense focuses loudly.", "Your camera lense focuses loudly.")
		if(WIRE_LAWSYNC) // Forces a law update if possible.
			if(R.lawupdate)
				R.visible_message("[R] gently chimes.", "LawSync protocol engaged.")
				R.lawsync()
				R.show_laws()
		if(WIRE_LOCKDOWN)
			R.SetLockdown(!R.lockcharge) // Toggle

/datum/wires/robot/on_cut(wire, mend)
	var/mob/living/silicon/robot/R = holder
	switch(wire)
		if(WIRE_AI) // Cut the AI wire to reset AI control.
			if(!mend)
				R.connected_ai = null
		if(WIRE_LAWSYNC) // Cut the law wire, and the borg will no longer receive law updates from its AI. Repair and it will re-sync.
			if(mend)
				if(!R.emagged)
					R.lawupdate = TRUE
			else
				R.lawupdate = FALSE
		if (WIRE_CAMERA) // Disable the camera.
			if(!isnull(R.camera) && !R.scrambledcodes)
				R.camera.status = mend
				R.camera.toggle_cam(usr, 0)
				R.visible_message("[R]'s camera lense focuses loudly.", "Your camera lense focuses loudly.")
		if(WIRE_LOCKDOWN) // Simple lockdown.
			R.SetLockdown(!mend)

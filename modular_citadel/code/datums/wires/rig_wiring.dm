/datum/wires/rig
	holder_type = /obj/item/storage/backpack/rig
	proper_name = "Hardsuit Maintenance"

/datum/wires/rig/New(atom/holder)
	wires = list(
		WIRE_HACK,
		WIRE_SHOCK,
		WIRE_ZAP,
		WIRE_RIG_INTERFACE_LOCK,
		WIRE_RIG_AI_OVERRIDE,
	)
	add_duds(6)
	..()

/datum/wires/rig/interactable(mob/user)
	var/obj/item/storage/backpack/rig/A = holder
	if(A.panel_open)
		return TRUE

/datum/wires/rig/get_status()
	var/obj/item/storage/backpack/rig/A = holder
	var/list/status = list()
	status += "The red light is [A.disabled ? "on" : "off"]."
	status += "The blue light is [A.hacked ? "on" : "off"]."
	status += "The green light is [A.aicontrol ? "on" : "off"]."
	status += "The control interface is [A.locked ? "unlocked" : "locked"]."
	return status

//Pulsing Wires
/datum/wires/rig/on_pulse(wire)
	var/obj/item/storage/backpack/rig/A = holder
	switch(wire)
		if(WIRE_HACK)
			A.adjust_hacked(!A.hacked)
			addtimer(CALLBACK(A, /obj/item/storage/backpack/rig.proc/reset, wire), 60)
		if(WIRE_SHOCK)
			A.shocked = !A.shocked
			addtimer(CALLBACK(A, /obj/item/storage/backpack/rig.proc/reset, wire), 60)
		if(WIRE_DISABLE)
			A.disabled = !A.disabled
			addtimer(CALLBACK(A, /obj/item/storage/backpack/rig.proc/reset, wire), 60)
		if(WIRE_RIG_INTERFACE_LOCK)
			A.locked = !A.locked
			addtimer(CALLBACK(A, /obj/item/storage/backpack/rig.proc/reset, wire), 60)

//Cutting Wires
var/obj/item/storage/backpack/rig/A = holder
	switch(wire)
		if(WIRE_HACK)
			A.adjust_hacked(!mend)
		if(WIRE_HACK)
			A.shocked = !mend
		if(WIRE_DISABLE)
			A.disabled = !mend
		if(WIRE_RIG_INTERFACE_LOCK)
			A.locked = !mend
		if(WIRE_ZAP)
			A.shock(usr, 50)

/*/datum/wires/rig/get_status()
	var/obj/item/storage/backpack/rig/A = holder
	var/list/status = list()
	status += "The red light is [A.disabled ? "on" : "off"]."
	status += "The blue light is [A.hacked ? "on" : "off"]."
	return status


/*#define RIG_SECURITY 1
#define RIG_AI_OVERRIDE 2
#define RIG_SYSTEM_CONTROL 4
#define RIG_INTERFACE_LOCK 8
#define RIG_INTERFACE_SHOCK 16

 * Rig security can be snipped to disable ID access checks on rig.
 * Rig AI override can be pulsed to toggle whether or not the AI can take control of the suit.
 * System control can be pulsed to toggle some malfunctions.
 * Interface lock can be pulsed to toggle whether or not the interface can be accessed.
 *

/datum/wires/rig/UpdateCut(var/index, var/mended)

	var/obj/item/weapon/rig/rig = holder
	switch(index)
		if(RIG_SECURITY)
			if(mended)
				rig.req_access = initial(rig.req_access)
				rig.req_one_access = initial(rig.req_one_access)
		if(RIG_INTERFACE_SHOCK)
			rig.electrified = mended ? 0 : -1
			rig.shock(usr,100)

/datum/wires/rig/UpdatePulsed(var/index)

	var/obj/item/weapon/rig/rig = holder
	switch(index)
		if(RIG_SECURITY)
			rig.security_check_enabled = !rig.security_check_enabled
			rig.visible_message("\The [rig] twitches as several suit locks [rig.security_check_enabled?"close":"open"].")
		if(RIG_AI_OVERRIDE)
			rig.ai_override_enabled = !rig.ai_override_enabled
			rig.visible_message("A small red light on [rig] [rig.ai_override_enabled?"goes dead":"flickers on"].")
		if(RIG_SYSTEM_CONTROL)
			rig.malfunctioning += 10
			if(rig.malfunction_delay <= 0)
				rig.malfunction_delay = 20
			rig.shock(usr,100)
		if(RIG_INTERFACE_LOCK)
			rig.interface_locked = !rig.interface_locked
			rig.visible_message("\The [rig] clicks audibly as the software interface [rig.interface_locked?"darkens":"brightens"].")
		if(RIG_INTERFACE_SHOCK)
			if(rig.electrified != -1)
				rig.electrified = 30
			rig.shock(usr,100)

/datum/wires/rig/CanUse(var/mob/living/L)
	var/obj/item/weapon/rig/rig = holder
	if(rig.open)
		return 1
	return 0*/

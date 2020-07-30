/obj/item/assembly/signaler/nanite
	var/datum/nanite_program/signaler/program

/obj/item/assembly/signaler/nanite/New(_program)
	..()
	program = _program
	if(!istype(program))
		qdel(src)

/obj/item/assembly/signaler/nanite/signal()
//Almost the same as the original; altered log message
	if(!radio_connection)
		return

	var/datum/signal/signal = new(list("code" = code))
	radio_connection.post_signal(src, signal)

	if(program.host_mob) // Sanity
		var/time = time2text(world.realtime,"hh:mm:ss")
		var/turf/T = get_turf(program.host_mob)
		GLOB.lastsignalers.Add("[time] <B>:</B> A nanite signaler program in [program.host_mob.key] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")
	return

/obj/item/assembly/signaler/nanite/receive_signal(datum/signal/signal)
//Got rid of beep and suicide in relation to the original.
	. = FALSE
	if(!signal)
		return
	if(signal.data["code"] != code)
		return
	if(!(src.wires & WIRE_RADIO_RECEIVE))
		return
	program.send_code()
	return TRUE

/datum/nanite_program/signaler
	name = "Signaler"
	desc = "The nanites receive and send radio signals. Trigger to send a radio signal; when a radio signal is received, sends a signal to the nanites."
	can_trigger = TRUE
	trigger_cost = 2
	trigger_cooldown = 3 SECONDS
	rogue_types = list(/datum/nanite_program/toxic)
	var/obj/item/assembly/signaler/nanite/signaler //needed because radio code works with objects, not datums.

/datum/nanite_program/signaler/register_extra_settings()
	extra_settings["Frequency"] = new /datum/nanite_extra_setting/number(FREQ_SIGNALER, MIN_FREE_FREQ, MAX_FREE_FREQ)
	extra_settings["Radio Code"] = new /datum/nanite_extra_setting/number(DEFAULT_SIGNALER_CODE, 1, 100)
	extra_settings["Nanite Code"] = new /datum/nanite_extra_setting/number(0, 1, 9999)

/datum/nanite_program/signaler/proc/send_code()
	if(activated)
		var/datum/nanite_extra_setting/nanite_code = extra_settings["Nanite Code"]
		SEND_SIGNAL(host_mob, COMSIG_NANITE_SIGNAL, nanite_code.value, "a [name] program")

/datum/nanite_program/signaler/on_mob_add()
	..()
	signaler = new(src)
	signaler.set_frequency(get_extra_setting_value("Frequency"))
	signaler.code = get_extra_setting_value("Radio Code")

/datum/nanite_program/signaler/copy_programming(datum/nanite_program/target, copy_activated)
	..()
	var/datum/nanite_program/signaler/T = target
	if(!istype(T))
		return //how did we even get here?

	if(!T.signaler)
		return //don't need to copy, we're prolly a program in a cloud or something

	T.signaler.set_frequency(get_extra_setting_value("Frequency"))
	T.signaler.code = get_extra_setting_value("Radio Code")

/datum/nanite_program/signaler/on_mob_remove()
	..()
	qdel(signaler)

/datum/nanite_program/signaler/on_trigger(comm_message)
	signaler.signal()

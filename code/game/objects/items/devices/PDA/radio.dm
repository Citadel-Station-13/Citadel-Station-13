// Radio Cartridge, essentially a remote signaler with limited spectrum.
/obj/item/integrated_signaler
	name = "\improper PDA radio module"
	desc = "An electronic radio system of Nanotrasen origin."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"

<<<<<<< HEAD
	var/on = FALSE //Are we currently active??
	var/menu_message = ""

/obj/item/radio/integrated/Initialize()
	. = ..()

/obj/item/radio/integrated/Destroy()
	return ..()

/*
 *	Radio Cartridge, essentially a signaler.
 */


/obj/item/radio/integrated/signal
	var/frequency = 1457
	var/code = 30
=======
/obj/item/integrated_signaler
	var/frequency = FREQ_SIGNALER
	var/code = DEFAULT_SIGNALER_CODE
>>>>>>> 71659b1... Tidy non-telecomms radio code (#33381)
	var/last_transmission
	var/datum/radio_frequency/radio_connection

/obj/item/integrated_signaler/Destroy()
	radio_connection = null
	return ..()

/obj/item/integrated_signaler/Initialize()
	. = ..()
<<<<<<< HEAD
	if (src.frequency < 1200 || src.frequency > 1600)
		src.frequency = sanitize_frequency(src.frequency)

=======
	if (frequency < MIN_FREE_FREQ || frequency > MAX_FREE_FREQ)
		frequency = sanitize_frequency(frequency)
>>>>>>> 71659b1... Tidy non-telecomms radio code (#33381)
	set_frequency(frequency)

/obj/item/integrated_signaler/proc/set_frequency(new_frequency)
	frequency = new_frequency
<<<<<<< HEAD
	radio_connection = SSradio.add_object(src, frequency)

/obj/item/radio/integrated/signal/proc/send_signal(message="ACTIVATE")
=======
	radio_connection = SSradio.return_frequency(frequency)
>>>>>>> 71659b1... Tidy non-telecomms radio code (#33381)

/obj/item/integrated_signaler/proc/send_activation()
	if(last_transmission && world.time < (last_transmission + 5))
		return
	last_transmission = world.time

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = get_turf(src)
	GLOB.lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")

	var/datum/signal/signal = new(list("code" = code))
	radio_connection.post_signal(src, signal, filter = RADIO_SIGNALER)

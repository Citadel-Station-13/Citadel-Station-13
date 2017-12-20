/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/

/obj/machinery/telecomms/allinone
	name = "telecommunications mainframe"
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE
	idle_power_usage = 0
	var/intercept = FALSE  // If true, only works on the Syndicate frequency.

/obj/machinery/telecomms/allinone/Initialize()
	..()
	if (intercept)
		freq_listening = list(FREQ_SYNDICATE)

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/subspace/signal)
	if(!istype(signal) || signal.transmission_method != TRANSMISSION_SUBSPACE)  // receives on subspace only
		return
	if(!on || !(z in signal.levels) || !is_freq_listening(signal))  // has to be on to receive messages
		return

<<<<<<< HEAD
	if(is_freq_listening(signal)) // detect subspace signals

		signal.data["done"] = 1 // mark the signal as being broadcasted
		signal.data["compression"] = 0

		// Search for the original signal and mark it as done as well
		var/datum/signal/original = signal.data["original"]
		if(original)
			original.data["done"] = 1

		if(signal.data["slow"] > 0)
			sleep(signal.data["slow"]) // simulate the network lag if necessary




		/* ###### Copy all syndie communications to the Syndicate Frequency ###### */
		if(intercept && signal.frequency == GLOB.SYND_FREQ)
			Broadcast_Message(signal.data["mob"],
							  signal.data["vmask"],
							  signal.data["radio"], signal.data["message"],
							  signal.data["name"], signal.data["job"],
							  signal.data["realname"],, signal.data["compression"], list(0, z), GLOB.SYND_FREQ, signal.data["spans"],
							  signal.data["verb_say"], signal.data["verb_ask"], signal.data["verb_exclaim"], signal.data["verb_yell"],
							  signal.data["language"])
		/* ###### Broadcast a message using signal.data ###### */
		else if(!intercept)
			Broadcast_Message(signal.data["mob"],
					  signal.data["vmask"],
					  signal.data["radio"], signal.data["message"],
					  signal.data["name"], signal.data["job"],
					  signal.data["realname"],, signal.data["compression"], list(0, z), signal.frequency, signal.data["spans"],
					  signal.data["verb_say"], signal.data["verb_ask"], signal.data["verb_exclaim"], signal.data["verb_yell"],
					  signal.data["language"])
=======
	// Decompress the signal and mark it done
	signal.data["compression"] = 0
	signal.mark_done()
	if(signal.data["slow"] > 0)
		sleep(signal.data["slow"]) // simulate the network lag if necessary
	signal.broadcast()
>>>>>>> 911cb97... Tidy telecomms radio code, make PDA server real telecomms machinery (#33647)

/obj/machinery/telecomms/allinone/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/device/multitool))
		attack_hand(user)

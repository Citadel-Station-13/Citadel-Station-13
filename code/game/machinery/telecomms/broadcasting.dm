
/**

	Here is the big, bad function that broadcasts a message given the appropriate
	parameters.

	@param M:
		Reference to the mob/speaker, stored in signal.data["mob"]

	@param vmask:
		Boolean value if the mob is "hiding" its identity via voice mask, stored in
		signal.data["vmask"]

	@param vmessage:
		If specified, will display this as the message; such as "chimpering"
		for monkeys if the mob is not understood. Stored in signal.data["vmessage"].

	@param radio:
		Reference to the radio broadcasting the message, stored in signal.data["radio"]

	@param message:
		The actual string message to display to mobs who understood mob M. Stored in
		signal.data["message"]

	@param name:
		The name to display when a mob receives the message. signal.data["name"]

	@param job:
		The name job to display for the AI when it receives the message. signal.data["job"]

	@param realname:
		The "real" name associated with the mob. signal.data["realname"]

	@param vname:
		If specified, will use this name when mob M is not understood. signal.data["vname"]

	@param data:
		If specified:
				1 -- Will only broadcast to intercoms
				2 -- Will only broadcast to intercoms and station-bounced radios
				3 -- Broadcast to syndicate frequency
				4 -- AI can't track down this person. Useful for imitation broadcasts where you can't find the actual mob

	@param compression:
		If 0, the signal is audible
		If nonzero, the signal may be partially inaudible or just complete gibberish.

	@param level:
		The list of Z levels that the sending radio is broadcasting to. Having 0 in the list broadcasts on all levels

	@param freq
		The frequency of the signal

**/

// Subtype of /datum/signal with additional processing information.
/datum/signal/subspace
	transmission_method = TRANSMISSION_SUBSPACE
	var/server_type = /obj/machinery/telecomms/server
	var/datum/signal/subspace/original
	var/list/levels

/datum/signal/subspace/New(data)
	src.data = data || list()

/datum/signal/subspace/proc/copy()
	var/datum/signal/subspace/copy = new
	copy.original = src
	copy.source = source
	copy.levels = levels
	copy.frequency = frequency
	copy.server_type = server_type
	copy.transmission_method = transmission_method
	copy.data = data.Copy()
	return copy

/datum/signal/subspace/proc/mark_done()
	var/datum/signal/subspace/current = src
	while (current)
		current.data["done"] = TRUE
		current = current.original

/datum/signal/subspace/proc/send_to_receivers()
	for(var/obj/machinery/telecomms/receiver/R in GLOB.telecomms_list)
		R.receive_signal(src)
	for(var/obj/machinery/telecomms/allinone/R in GLOB.telecomms_list)
		R.receive_signal(src)

/datum/signal/subspace/proc/broadcast()
	set waitfor = FALSE

// Vocal transmissions (i.e. using saycode).
// Despite "subspace" in the name, these transmissions can also be RADIO
// (intercoms and SBRs) or SUPERSPACE (CentCom).
/datum/signal/subspace/vocal
	var/atom/movable/virtualspeaker/virt
	var/datum/language/language

/datum/signal/subspace/vocal/New(
	obj/source,  // the originating radio
	frequency,  // the frequency the signal is taking place on
	atom/movable/virtualspeaker/speaker,  // representation of the method's speaker
	datum/language/language,  // the langauge of the message
	message,  // the text content of the message
	spans  // the list of spans applied to the message
)
	src.source = source
	src.frequency = frequency
	src.language = language
	virt = speaker
	var/datum/language/lang_instance = GLOB.language_datum_instances[language]
	data = list(
		"name" = speaker.name,
		"job" = speaker.job,
		"message" = message,
		"compression" = rand(35, 65),
		"language" = lang_instance.name,
		"spans" = spans
	)
	var/turf/T = get_turf(source)
	levels = list(T.z)

/datum/signal/subspace/vocal/copy()
	var/datum/signal/subspace/vocal/copy = new(source, frequency, virt, language)
	copy.original = src
	copy.data = data.Copy()
	copy.levels = levels
	return copy

// This is the meat function for making radios hear vocal transmissions.
/datum/signal/subspace/vocal/broadcast()
	set waitfor = FALSE

	// Perform final composition steps on the message.
	var/message = copytext(data["message"], 1, MAX_BROADCAST_LEN)
	if(!message)
		return
	var/compression = data["compression"]
	if(compression > 0)
		message = Gibberish(message, compression + 40)

<<<<<<< HEAD
	// --- Broadcast only to intercom devices ---

	if(data == 1)
		for(var/obj/item/device/radio/intercom/R in GLOB.all_radios["[freq]"])
			if(R.receive_range(freq, level) > -1)
				radios += R

	// --- Broadcast only to intercoms and station-bounced radios ---

	else if(data == 2)

		for(var/obj/item/device/radio/R in GLOB.all_radios["[freq]"])
			if(R.subspace_transmission)
				continue

			if(R.receive_range(freq, level) > -1)
				radios += R

	// --- This space left blank for Syndicate data ---

	// --- CentCom radio, yo. ---

	else if(data == 5)

		for(var/obj/item/device/radio/R in GLOB.all_radios["[freq]"])
			if(!R.independent)
				continue

			if(R.receive_range(freq, level) > -1)
				radios += R

	// --- Broadcast to ALL radio devices ---

	else
		for(var/obj/item/device/radio/R in GLOB.all_radios["[freq]"])
			if(R.receive_range(freq, level) > -1)
				radios += R

		var/freqtext = num2text(freq)
		for(var/obj/item/device/radio/R in GLOB.all_radios["[GLOB.SYND_FREQ]"]) //syndicate radios use magic that allows them to hear everything. this was already the case, now it just doesn't need the allinone anymore. solves annoying bugs that aren't worth solving.
			if(R.receive_range(GLOB.SYND_FREQ, list(R.z)) > -1 && freqtext in GLOB.reverseradiochannels)
				radios |= R

	// Get a list of mobs who can hear from the radios we collected.
	var/list/receive = get_mobs_in_radio_ranges(radios) //this includes all hearers.

	for(var/mob/R in receive) //Filter receiver list.
		if (R.client && R.client.holder && !(R.client.prefs.chat_toggles & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
=======
	// Assemble the list of radios
	var/list/radios = list()
	switch (transmission_method)
		if (TRANSMISSION_SUBSPACE)
			// Reaches any radios on the levels
			for(var/obj/item/device/radio/R in GLOB.all_radios["[frequency]"])
				if(R.can_receive(frequency, levels))
					radios += R

			// Syndicate radios can hear all well-known radio channels
			if (num2text(frequency) in GLOB.reverseradiochannels)
				for(var/obj/item/device/radio/R in GLOB.all_radios["[FREQ_SYNDICATE]"])
					if(R.can_receive(FREQ_SYNDICATE, list(R.z)))
						radios |= R

		if (TRANSMISSION_RADIO)
			// Only radios not currently in subspace mode
			for(var/obj/item/device/radio/R in GLOB.all_radios["[frequency]"])
				if(!R.subspace_transmission && R.can_receive(frequency, levels))
					radios += R

		if (TRANSMISSION_SUPERSPACE)
			// Only radios which are independent
			for(var/obj/item/device/radio/R in GLOB.all_radios["[frequency]"])
				if(R.independent && R.can_receive(frequency, levels))
					radios += R

	// From the list of radios, find all mobs who can hear those.
	var/list/receive = get_mobs_in_radio_ranges(radios)

	// Cut out mobs with clients who are admins and have radio chatter disabled.
	for(var/mob/R in receive)
		if (R.client && R.client.holder && !(R.client.prefs.chat_toggles & CHAT_RADIO))
>>>>>>> 911cb97... Tidy telecomms radio code, make PDA server real telecomms machinery (#33647)
			receive -= R

	// Add observers who have ghost radio enabled.
	for(var/mob/dead/observer/M in GLOB.player_list)
		if(M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTRADIO))
			receive |= M

	// Render the message and have everybody hear it.
	// Always call this on the virtualspeaker to avoid issues.
	var/spans = data["spans"]
	var/rendered = virt.compose_message(virt, language, message, frequency, spans)
	for(var/atom/movable/hearer in receive)
		hearer.Hear(rendered, virt, language, message, frequency, spans)

	// This following recording is intended for research and feedback in the use of department radio channels
	if(length(receive))
<<<<<<< HEAD
		// --- This following recording is intended for research and feedback in the use of department radio channels ---
		SSblackbox.LogBroadcast(freq)

	sleep(50)
	if(!QDELETED(virt)) //It could happen to YOU
		qdel(virt)

//Use this to test if an obj can communicate with a Telecommunications Network

/atom/proc/test_telecomms()
	var/datum/signal/signal = telecomms_process()
	var/turf/position = get_turf(src)
	return (position.z in signal.data["level"] && signal.data["done"])

/atom/proc/telecomms_process()

	// First, we want to generate a new radio signal
	var/datum/signal/signal = new
	signal.transmission_method = 2 // 2 would be a subspace transmission.
	var/turf/pos = get_turf(src)

	// --- Finally, tag the actual signal with the appropriate values ---
	signal.data = list(
		"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
		"message" = "TEST",
		"compression" = rand(45, 50), // If the signal is compressed, compress our message too.
		"traffic" = 0, // dictates the total traffic sum that the signal went through
		"type" = 4, // determines what type of radio input it is: test broadcast
		"reject" = 0,
		"done" = 0,
		"level" = pos.z // The level it is being broadcasted at.
	)
	signal.frequency = 1459// Common channel

  //#### Sending the signal to all subspace receivers ####//
	for(var/obj/machinery/telecomms/receiver/R in GLOB.telecomms_list)
		R.receive_signal(signal)

	sleep(rand(10,25))
=======
		SSblackbox.LogBroadcast(frequency)
>>>>>>> 911cb97... Tidy telecomms radio code, make PDA server real telecomms machinery (#33647)

	QDEL_IN(virt, 50)  // Make extra sure the virtualspeaker gets qdeleted

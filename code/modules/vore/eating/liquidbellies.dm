//CHOMP vore additions.

/obj/belly
	//CHOMP - liquid bellies
	var/reagentbellymode = FALSE			// Belly has abilities to make liquids from digested/absorbed/drained prey and/or nutrition
	var/reagent_mode_flags = 0

	var/tmp/static/list/reagent_mode_flag_list= list(
		"Produce Liquids" = DM_FLAG_REAGENTSNUTRI,
		"Digestion Liquids" = DM_FLAG_REAGENTSDIGEST,
		"Absorption Liquids" = DM_FLAG_REAGENTSABSORB,
		"Draining Liquids" = DM_FLAG_REAGENTSDRAIN
		)

	var/show_liquids = FALSE //Moved from vorepanel_ch to be a belly var
	var/show_fullness_messages = FALSE //Moved from vorepanel_ch to be a belly var

	var/nutri_reagent_gen = FALSE					//if belly produces reagent over time using nutrition, needs to be optimized to use subsystem - Jack
	var/list/generated_reagents = list("water" = 1) //Any number of reagents, the associated value is how many units are generated per process()
	var/reagent_name = "water" 						//What is shown when reagents are removed, doesn't need to be an actual reagent
	var/reagentid = "water"							//Selected reagent's id, for use in puddle system currently
	var/reagentcolor = "#0064C877"					//Selected reagent's color, for use in puddle system currently
	var/gen_cost = 1 								//amount of nutrient taken from the host everytime nutrition is used to make reagents
	var/gen_amount = 1							//Does not actually influence amount produced, but is used as a way to tell the system how much total reagent it has to take into account when filling a belly

	var/gen_interval = 0							//Interval in seconds for generating fluids, once it reaches the value of gen_time one cycle of reagents generation will occur
	var/gen_time = 5								//Time it takes in seconds to produce one cycle of reagents, technically add 1 second to it for the tick where the fluid is produced
	var/gen_time_display = "1 hour"					//The displayed time it takes from a belly to go from 0 to 100
	var/custom_max_volume = 100						//Variable for people to limit amount of liquid they can receive/produce in a belly
	var/digest_nutri_gain = 0						//variable to store temporary nutrition gain from digestion and allow a seperate proc to ease up on the wall of code
	var/reagent_transfer_verb = "injects"			//verb for transfer of reagent from a vore belly

	var/vorefootsteps_sounds = FALSE				//If this belly can make sounds when someone walks around
	var/liquid_fullness1_messages = FALSE
	var/liquid_fullness2_messages = FALSE
	var/liquid_fullness3_messages = FALSE
	var/liquid_fullness4_messages = FALSE
	var/liquid_fullness5_messages = FALSE
	var/vorespawn_blacklist = FALSE

	var/list/fullness1_messages = list(
		"%pred's %belly looks empty"
		)
	var/list/fullness2_messages = list(
		"%pred's %belly looks filled"
		)
	var/list/fullness3_messages = list(
		"%pred's %belly looks like it's full of liquid"
		)
	var/list/fullness4_messages = list(
		"%pred's %belly is quite full!"
		)
	var/list/fullness5_messages = list(
		"%pred's %belly is completely filled to it's limit!"
		)

	// Stuff to add in future!
	/*
	var/list/empty_message = list("You feel as though your internal reagent implant is almost empty.")
	var/list/full_message = "You feel as though your internal reagent implant is full."

	var/list/emote_descriptor = list("tranfers something") //In format of [x] [emote_descriptor] into [container]
	var/list/self_emote_descriptor = list("transfer") //In format of You [self_emote_descriptor] some [generated_reagent] into [container]
	*/

	var/tmp/reagent_chosen = "Water"				// variable for switch to figure out what to set variables when a certain reagent is selected
	var/tmp/static/list/reagent_choices = list(		// List of reagents people can chose, maybe one day expand so it covers criterias like dogborgs who can make meds, booze, etc - Jack
	"Water",
	"Milk",
	"Cream",
	"Honey",
	"Cherry Jelly"
	)



///////////////////// NUTRITION REAGENT PRODUCTION /////////////////

/obj/belly/proc/HandleBellyReagents()
	if(reagentbellymode && reagent_mode_flags & DM_FLAG_REAGENTSNUTRI && reagents.total_volume < custom_max_volume) //Removed if(reagentbellymode == TRUE) since that's less optimized
		if(owner.nutrition >= gen_cost && gen_interval >= gen_time)
			GenerateBellyReagents()
			gen_interval = 0
		else
			gen_interval++

/obj/belly/proc/GenerateBellyReagents()
	owner.nutrition -= gen_cost
	for(var/reagent in generated_reagents)
		reagents.add_reagent(reagent, generated_reagents[reagent])

//////////////////////////// REAGENT_DIGEST ////////////////////////

/obj/belly/proc/GenerateBellyReagents_digesting()	//The rate isnt based on selected reagent, due to the fact that the price of the reagent is already paid by nutrient not gained.
	if(reagents.total_volume + (digest_nutri_gain * gen_amount) <= custom_max_volume) //By default a reagent with an amount of 1 should result in pred getting 100 units from a full health prey
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] * digest_nutri_gain)
	else
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] / gen_amount * (custom_max_volume - reagents.total_volume))

/obj/belly/proc/GenerateBellyReagents_digested()
	if(reagents.total_volume <= custom_max_volume - 25 * gen_amount)
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] * 25)
	else
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] / gen_amount * (custom_max_volume - reagents.total_volume))

//////////////////////////// REAGENT_ABSORB ////////////////////////

/obj/belly/proc/GenerateBellyReagents_absorbing()
	if(reagents.total_volume <= custom_max_volume - 1.5 * gen_amount) //Going for 1.5 amount of reagent per cycle, can be adjusted in future if need adjustments
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] * 1.5)
	else
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] / gen_amount * (custom_max_volume - reagents.total_volume))

/obj/belly/proc/GenerateBellyReagents_absorbed()
	if(reagents.total_volume <= custom_max_volume - 25 * gen_amount) //Going for 25 amount of reagent for absorbing the prey, can be adjusted in future if need adjustments
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] * 10)
	else
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] / gen_amount * (custom_max_volume - reagents.total_volume))

//////////////////////////// REAGENT_DRAIN ///////////////////////// //Currently not needed, maybe later a specific proc for drain needs to be made - Jack



//////////////////////////// REAGENT SELECTION /////////////////////

//This is gonna end up a long proc, but its gonna have to make do for now

/obj/belly/proc/ReagentSwitch()
	switch(reagent_chosen)
		if("Water")
			generated_reagents = list("water" = 1)
			reagent_name = "water"
			gen_amount = 1
			gen_cost = 1
			reagentid = "water"
			reagentcolor = "#0064C877"
		if("Milk")
			generated_reagents = list("milk" = 1)
			reagent_name = "milk"
			gen_amount = 1
			gen_cost = 5
			reagentid = "milk"
			reagentcolor = "#DFDFDF"
		if("Cream")
			generated_reagents = list("cream" = 1)
			reagent_name = "cream"
			gen_amount = 1
			gen_cost = 5
			reagentid = "cream"
			reagentcolor = "#DFD7AF"
		if("Honey")
			generated_reagents = list("honey" = 1)
			reagent_name = "honey"
			gen_amount = 1
			gen_cost = 10
			reagentid = "honey"
			reagentcolor = "#FFFF00"
		if("Cherry Jelly")	//Kinda WIP, allows slime like folks something to stuff others with, should make a generic jelly in future
			generated_reagents = list("cherryjelly" = 1)
			reagent_name = "cherry jelly"
			gen_amount = 1
			gen_cost = 10
			reagentid = "cherryjelly"
			reagentcolor = "#801E28"

/////////////////////// FULLNESS MESSAGES //////////////////////

// Get the line that should show up in Examine message if the owner of this belly is examined.
// Returns a string which shoul be appended to the Examine output.
// Yes I know it doesnt look great with 5 almost identical procs in a row, I didnt have a better idea at the time - Jack
/obj/belly/proc/get_reagent_examine_msg1()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness1_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return("<span class='warning'>[formatted_message]</span><BR>")

/obj/belly/proc/get_reagent_examine_msg2()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness2_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return("<span class='warning'>[formatted_message]</span><BR>")

/obj/belly/proc/get_reagent_examine_msg3()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness3_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return("<span class='warning'>[formatted_message]</span><BR>")

/obj/belly/proc/get_reagent_examine_msg4()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness4_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return("<span class='warning'>[formatted_message]</span><BR>")

/obj/belly/proc/get_reagent_examine_msg5()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness5_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return("<span class='warning'>[formatted_message]</span><BR>")


// The next function gets the messages set on the belly, in human-readable format.
// This is useful in customization boxes and such. The delimiter right now is \n\n so
// in message boxes, this looks nice and is easily delimited.
/obj/belly/proc/get_reagent_messages(type, delim = "\n\n")
	ASSERT(type == "full1" || type == "full2" || type == "full3" || type == "full4" || type == "full5")
	var/list/raw_messages

	switch(type)
		if("full1")
			raw_messages = fullness1_messages
		if("full2")
			raw_messages = fullness2_messages
		if("full3")
			raw_messages = fullness3_messages
		if("full4")
			raw_messages = fullness4_messages
		if("full5")
			raw_messages = fullness5_messages

	var/messages = raw_messages.Join(delim)
	return messages

// The next function sets the messages on the belly, from human-readable var
// replacement strings and linebreaks as delimiters (two \n\n by default).
// They also sanitize the messages.
/obj/belly/proc/set_reagent_messages(raw_text, type, delim = "\n\n")
	ASSERT(type == "full1" || type == "full2" || type == "full3" || type == "full4" || type == "full5")

	var/list/raw_list = splittext(html_encode(raw_text),delim)
	if(raw_list.len > 10)
		raw_list.Cut(11)
		log_runtime("[owner] tried to set [lowertext(name)] with 11+ messages")

	for(var/i = 1, i <= raw_list.len, i++)
		if(length(raw_list[i]) > 160 || length(raw_list[i]) < 10) //160 is fudged value due to htmlencoding increasing the size
			raw_list.Cut(i,i)
			log_runtime("[owner] tried to set [lowertext(name)] with >121 or <10 char message")
		else
			raw_list[i] = readd_quotes(raw_list[i])
			//Also fix % sign for var replacement
			raw_list[i] = replacetext(raw_list[i],"&#37;","%")

	ASSERT(raw_list.len <= 10) //Sanity

	switch(type)
		if("full1")
			fullness1_messages = raw_list
		if("full2")
			fullness2_messages = raw_list
		if("full3")
			fullness3_messages = raw_list
		if("full4")
			fullness4_messages = raw_list
		if("full5")
			fullness5_messages = raw_list

	return

/////////////////////////// Process Cycle Lite /////////////////////////// CHOMP PCL
/obj/belly/proc/quick_cycle() //For manual belly cycling without straining the bellies subsystem.
	HandleBellyReagents()	//CHOMP reagent belly stuff.
	// VERY early exit
	if(!contents.len)
		return

	var/to_update = FALSE //Did anything update worthy happen?

/////////////////////////// Exit Early //////////////////////////// CHOMP PCL
	var/list/touchable_atoms = contents - items_preserved
	if(!length(touchable_atoms))
		return

	var/datum/digest_mode/DM = GLOB.digest_modes["[digest_mode]"]
	if(!DM)
		log_runtime("Digest mode [digest_mode] didn't exist in the digest_modes list!!")
		return FALSE
	if(DM.handle_atoms(src, touchable_atoms))
		updateVRPanels()
		return

	var/list/touchable_mobs = null

	var/list/hta_returns = handle_touchable_atoms(touchable_atoms)
	if(islist(hta_returns))
		if(hta_returns["touchable_mobs"])
			touchable_mobs = hta_returns["touchable_mobs"]
		if(hta_returns["to_update"])
			to_update = hta_returns["to_update"]

	if(!LAZYLEN(touchable_mobs))
		return

///////////////////// Time to actually process mobs ///////////////////// CHOMP PCL
	for(var/target in touchable_mobs)
		var/mob/living/L = target
		if(!istype(L))
			continue
		var/list/returns = DM.process_mob(src, target)
		if(istype(returns) && returns["to_update"])
			to_update = TRUE

	if(to_update)
		updateVRPanels()
/////////////////////////// CHOMP PCL END ///////////////////////////

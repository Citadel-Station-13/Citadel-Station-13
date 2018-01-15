//
//	The belly object is what holds onto a mob while they're inside a predator.
//	It takes care of altering the pred's decription, digesting the prey, relaying struggles etc.
//

// If you change what variables are on this, then you need to update the copy() proc.

//
// Parent type of all the various "belly" varieties.
//
/datum/belly
	var/name								// Name of this location
	var/inside_flavor						// Flavor text description of inside sight/sound/smells/feels.
	var/vore_sound = 'sound/vore/pred/swallow_01.ogg'	// Sound when ingesting someone
	var/vore_verb = "ingest"				// Verb for eating with this in messages
	var/human_prey_swallow_time = 10 SECONDS		// Time in deciseconds to swallow /mob/living/carbon/human
	var/nonhuman_prey_swallow_time = 5 SECONDS		// Time in deciseconds to swallow anything else
	var/emoteTime = 30 SECONDS				// How long between stomach emotes at prey
	var/digest_brute = 0					// Brute damage per tick in digestion mode
	var/digest_burn = 1						// Burn damage per tick in digestion mode
	var/digest_tickrate = 9					// Modulus this of air controller tick number to iterate gurgles on
	var/immutable = FALSE					// Prevents this belly from being deleted
	var/escapable = FALSE					// Belly can be resisted out of at any time
	var/escapetime = 60 SECONDS				// Deciseconds, how long to escape this belly
	var/digestchance = 0					// % Chance of stomach beginning to digest if prey struggles
//	var/silenced = FALSE					// Will the heartbeat/fleshy internal loop play?
	var/escapechance = 0 					// % Chance of prey beginning to escape if prey struggles.

	var/datum/belly/transferlocation = null	// Location that the prey is released if they struggle and get dropped off.
	var/transferchance = 0 					// % Chance of prey being transferred to transfer location when resisting
	var/autotransferchance = 0 				// % Chance of prey being autotransferred to transfer location
	var/autotransferwait = 10 				// Time between trying to transfer.
	var/can_taste = FALSE					// If this belly prints the flavor of prey when it eats someone.

	var/tmp/digest_mode = DM_HOLD			// Whether or not to digest. Default to not digest.
	var/tmp/list/digest_modes = list(DM_HOLD,DM_DIGEST,DM_HEAL,DM_NOISY)	// Possible digest modes
	var/tmp/mob/living/owner				// The mob whose belly this is.
	var/tmp/list/internal_contents = list()	// People/Things you've eaten into this belly!
	var/tmp/is_full							// Flag for if digested remeans are present. (for disposal messages)
	var/tmp/emotePend = FALSE				// If there's already a spawned thing counting for the next emote
	var/swallow_time = 10 SECONDS			// for mob transfering automation
	var/vore_capacity = 1				// The capacity (in people) this person can hold

	// Don't forget to watch your commas at the end of each line if you change these.
	var/list/struggle_messages_outside = list(
		"%pred's %belly wobbles with a squirming meal.",
		"%pred's %belly jostles with movement.",
		"%pred's %belly briefly swells outward as someone pushes from inside.",
		"%pred's %belly fidgets with a trapped victim.",
		"%pred's %belly jiggles with motion from inside.",
		"%pred's %belly sloshes around.",
		"%pred's %belly gushes softly.",
		"%pred's %belly lets out a wet squelch.")

	var/list/struggle_messages_inside = list(
		"Your useless squirming only causes %pred's slimy %belly to squelch over your body.",
		"Your struggles only cause %pred's %belly to gush softly around you.",
		"Your movement only causes %pred's %belly to slosh around you.",
		"Your motion causes %pred's %belly to jiggle.",
		"You fidget around inside of %pred's %belly.",
		"You shove against the walls of %pred's %belly, making it briefly swell outward.",
		"You jostle %pred's %belly with movement.",
		"You squirm inside of %pred's %belly, making it wobble around.")

	var/list/digest_messages_owner = list(
		"You feel %prey's body succumb to your digestive system, which breaks it apart into soft slurry.",
		"You hear a lewd glorp as your %belly muscles grind %prey into a warm pulp.",
		"Your %belly lets out a rumble as it melts %prey into sludge.",
		"You feel a soft gurgle as %prey's body loses form in your %belly. They're nothing but a soft mass of churning slop now.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your thighs.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your rump.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your belly.",
		"Your %belly groans as %prey falls apart into a thick soup. You can feel their remains soon flowing deeper into your body to be absorbed.",
		"Your %belly kneads on every fiber of %prey, softening them down into mush to fuel your next hunt.",
		"Your %belly churns %prey down into a hot slush. You can feel the nutrients coursing through your digestive track with a series of long, wet glorps.")

	var/list/digest_messages_prey = list(
		"Your body succumbs to %pred's digestive system, which breaks you apart into soft slurry.",
		"%pred's %belly lets out a lewd glorp as their muscles grind you into a warm pulp.",
		"%pred's %belly lets out a rumble as it melts you into sludge.",
		"%pred feels a soft gurgle as your body loses form in their %belly. You're nothing but a soft mass of churning slop now.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's thighs.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's rump.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's belly.",
		"%pred's %belly groans as you fall apart into a thick soup. Your remains soon flow deeper into %pred's body to be absorbed.",
		"%pred's %belly kneads on every fiber of your body, softening you down into mush to fuel their next hunt.",
		"%pred's %belly churns you down into a hot slush. Your nutrient-rich remains course through their digestive track with a series of long, wet glorps.")

	var/list/examine_messages = list(
		"They have something solid in their %belly!",
		"It looks like they have something in their %belly!")

	//Mostly for being overridden on precreated bellies on mobs. Could be VV'd into
	//a carbon's belly if someone really wanted. No UI for carbons to adjust this.
	//List has indexes that are the digestion mode strings, and keys that are lists of strings.
	var/list/emote_lists = list()

// Constructor that sets the owning mob
/datum/belly/New(var/mob/living/owning_mob)
	owner = owning_mob

// Toggle digestion on/off and notify user of the new setting.
// If multiple digestion modes are avaliable (i.e. unbirth) then user should be prompted.
/datum/belly/proc/toggle_digestion()
	return

// Checks if any mobs are present inside the belly
// return True if the belly is empty.
/datum/belly/proc/is_empty()
	return internal_contents.len == 0

// Release all contents of this belly into the owning mob's location.
// If that location is another mob, contents are transferred into whichever of its bellies the owning mob is in.
// Returns the number of mobs so released.
/datum/belly/proc/release_all_contents()
	if (internal_contents.len == 0)
		return 0
	for (var/atom/movable/M in internal_contents)
		M.forceMove(owner.loc)  // Move the belly contents into the same location as belly's owner.
		M << sound(null, repeat = 0, wait = 0, volume = 80, channel = CHANNEL_PREYLOOP)
		internal_contents.Remove(M)  // Remove from the belly contents

		var/datum/belly/B = check_belly(owner) // This makes sure that the mob behaves properly if released into another mob
		if(B)
			B.internal_contents.Add(M)

	owner.visible_message("<font color='green'><b>[owner] expels everything from their [lowertext(name)]!</b></font>")
	return TRUE

// Release a specific atom from the contents of this belly into the owning mob's location.
// If that location is another mob, the atom is transferred into whichever of its bellies the owning mob is in.
// Returns the number of atoms so released.
/datum/belly/proc/release_specific_contents(var/atom/movable/M)
	if (!(M in internal_contents))
		return FALSE // They weren't in this belly anyway

	M.forceMove(owner.loc)  // Move the belly contents into the same location as belly's owner.
	M << sound(null, repeat = 0, wait = 0, volume = 80, channel = CHANNEL_PREYLOOP)
	src.internal_contents.Remove(M)  // Remove from the belly contents

	var/datum/belly/B = check_belly(owner)
	if(B)
		B.internal_contents.Add(M)

	owner.visible_message("<font color='green'><b>[owner] expels [M] from their [lowertext(name)]!</b></font>")
//	owner.regenerate_icons()
	return TRUE

// Actually perform the mechanics of devouring the tasty prey.
// The purpose of this method is to avoid duplicate code, and ensure that all necessary
// steps are taken.
/datum/belly/proc/nom_mob(var/mob/prey, var/mob/user)
//	if (prey.buckled)
//		prey.buckled.unbuckle_mob()

	prey.forceMove(owner)
	internal_contents.Add(prey)

//	var/datum/belly/B = check_belly(owner)
//	if(B.silenced == FALSE) //this needs more testing later
	prey << sound('sound/vore/prey/loop.ogg', repeat = 1, wait = 0, volume = 35, channel = CHANNEL_PREYLOOP)

	// Handle prey messages
	if(inside_flavor)
		to_chat(prey, "<span class='warning'><B>[src.inside_flavor]</B></span>")
	if(isliving(prey))
		var/mob/living/M = prey
		if(can_taste && M.get_taste_message(0))
			to_chat(owner, "<span class='notice'>[M] tastes of [M.get_taste_message(0)].</span>")

	// Setup the autotransfer checks if needed
	if(transferlocation && autotransferchance > 0)
		addtimer(CALLBACK(src, /datum/belly/.proc/check_autotransfer, prey), autotransferwait)

/datum/belly/proc/check_autotransfer(var/mob/prey)
	// Some sanity checks
	if(transferlocation && (autotransferchance > 0) && (prey in internal_contents))
		if(prob(autotransferchance))
			// Double check transferlocation isn't insane
			if(verify_transferlocation())
				transfer_contents(prey, transferlocation)
		else
			// Didn't transfer, so wait before retrying
			addtimer(CALLBACK(src, /datum/belly/.proc/check_autotransfer, prey), autotransferwait)

/datum/belly/proc/verify_transferlocation()
	for(var/I in owner.vore_organs)
		var/datum/belly/B = owner.vore_organs[I]
		if(B == transferlocation)
			return TRUE

	for(var/I in owner.vore_organs)
		var/datum/belly/B = owner.vore_organs[I]
		if(B.name == transferlocation.name)
			transferlocation = B
			return TRUE
	return FALSE

// Get the line that should show up in Examine message if the owner of this belly
// is examined.   By making this a proc, we not only take advantage of polymorphism,
// but can easily make the message vary based on how many people are inside, etc.
// Returns a string which shoul be appended to the Examine output.
/datum/belly/proc/get_examine_msg()
	if(internal_contents.len && examine_messages.len)
		var/formatted_message
		var/raw_message = pick(examine_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)
		formatted_message = replacetext(formatted_message,"%prey",english_list(internal_contents))

		return("<span class='warning'>[formatted_message]</span><BR>")

// The next function gets the messages set on the belly, in human-readable format.
// This is useful in customization boxes and such. The delimiter right now is \n\n so
// in message boxes, this looks nice and is easily delimited.
/datum/belly/proc/get_messages(var/type, var/delim = "\n\n")
	ASSERT(type == "smo" || type == "smi" || type == "dmo" || type == "dmp" || type == "em")
	var/list/raw_messages

	switch(type)
		if("smo")
			raw_messages = struggle_messages_outside
		if("smi")
			raw_messages = struggle_messages_inside
		if("dmo")
			raw_messages = digest_messages_owner
		if("dmp")
			raw_messages = digest_messages_prey
		if("em")
			raw_messages = examine_messages

	var/messages = list2text(raw_messages,delim)
	return messages

// The next function sets the messages on the belly, from human-readable var
// replacement strings and linebreaks as delimiters (two \n\n by default).
// They also sanitize the messages.
/datum/belly/proc/set_messages(var/raw_text, var/type, var/delim = "\n\n")
	ASSERT(type == "smo" || type == "smi" || type == "dmo" || type == "dmp" || type == "em")

	var/list/raw_list = text2list(html_encode(raw_text),delim)
	if(raw_list.len > 10)
		raw_list.Cut(11)

	for(var/i = 1, i <= raw_list.len, i++)
		if(length(raw_list[i]) > 160 || length(raw_list[i]) < 10) //160 is fudged value due to htmlencoding increasing the size
			raw_list.Cut(i,i)
		else
			raw_list[i] = readd_quotes(raw_list[i])
			//Also fix % sign for var replacement
			raw_list[i] = replacetext(raw_list[i],"&#37;","%")

	ASSERT(raw_list.len <= 10) //Sanity

	switch(type)
		if("smo")
			struggle_messages_outside = raw_list
		if("smi")
			struggle_messages_inside = raw_list
		if("dmo")
			digest_messages_owner = raw_list
		if("dmp")
			digest_messages_prey = raw_list
		if("em")
			examine_messages = raw_list

	return

// Handle the death of a mob via digestion.
// Called from the process_Life() methods of bellies that digest prey.
// Default implementation calls M.death() and removes from internal contents.
// Indigestable items are removed, and M is deleted.
/datum/belly/proc/digestion_death(var/mob/living/M)
	is_full = TRUE
	internal_contents.Remove(M)
	M << sound(null, repeat = 0, wait = 0, volume = 80, channel = CHANNEL_PREYLOOP)
	// If digested prey is also a pred... anyone inside their bellies gets moved up.
	if(is_vore_predator(M))
		for(var/bellytype in M.vore_organs)
			var/datum/belly/belly = M.vore_organs[bellytype]
			for (var/obj/thing in belly.internal_contents)
				thing.loc = owner
				internal_contents.Add(thing)
			for (var/mob/subprey in belly.internal_contents)
				subprey.loc = owner
				internal_contents.Add(subprey)
				to_chat(subprey, "As [M] melts away around you, you find yourself in [owner]'s [name]")

	//Drop all items into the belly/floor.
	for(var/obj/item/W in M)
		if(!M.dropItemToGround(W))
			qdel(W)

	message_admins("[key_name(owner)] digested [key_name(M)].")
	log_attack("[key_name(owner)] digested [key_name(M)].")

	// Delete the digested mob
	qdel(M)

//Handle a mob struggling
// Called from /mob/living/carbon/relaymove()
/datum/belly/proc/relay_resist(var/mob/living/R)
	if (!(R in internal_contents))
		return  // User is not in this belly, or struggle too soon.

	R.setClickCooldown(50)
	var/sound/prey_struggle = sound(get_sfx("prey_struggle"))

	if(owner.stat) //If owner is stat (dead, KO) we can actually escape
		to_chat(R, "<span class='warning'>You attempt to climb out of \the [name]. (This will take around [escapetime/10] seconds.)</span>")
		to_chat(owner, "<span class='warning'>Someone is attempting to climb out of your [name]!</span>")

		if(do_after(R, escapetime, owner))
			if((owner.stat || escapable) && (R in internal_contents)) //Can still escape?
				release_specific_contents(R)
				return
			else if(!(R in internal_contents)) //Aren't even in the belly. Quietly fail.
				return
			else //Belly became inescapable or mob revived
				to_chat(R, "<span class='warning'>Your attempt to escape [name] has failed!</span>")
				to_chat(owner, "<span class='notice'>The attempt to escape from your [name] has failed!</span>")
				return
			return
	var/struggle_outer_message = pick(struggle_messages_outside)
	var/struggle_user_message = pick(struggle_messages_inside)

	struggle_outer_message = replacetext(struggle_outer_message,"%pred",owner)
	struggle_outer_message = replacetext(struggle_outer_message,"%prey",R)
	struggle_outer_message = replacetext(struggle_outer_message,"%belly",lowertext(name))

	struggle_user_message = replacetext(struggle_user_message,"%pred",owner)
	struggle_user_message = replacetext(struggle_user_message,"%prey",R)
	struggle_user_message = replacetext(struggle_user_message,"%belly",lowertext(name))

	struggle_outer_message = "<span class='alert'>" + struggle_outer_message + "</span>"
	struggle_user_message = "<span class='alert'>" + struggle_user_message + "</span>"

//	for(var/mob/M in hearers(4, owner))
//		M.visible_message(struggle_outer_message) // hearable
	R.visible_message( "<span class='alert'>[struggle_outer_message]</span>", "<span class='alert'>[struggle_user_message]</span>")
	playsound(get_turf(owner),"struggle_sound",35,0,-6,1,channel=151)
	R.stop_sound_channel(151)
	R.playsound_local(get_turf(R), null, 45, S = prey_struggle)

	if(escapable && R.a_intent != "help") //If the stomach has escapable enabled and the person is actually trying to kick out
		to_chat(R, "<span class='warning'>You attempt to climb out of \the [name].</span>")
		to_chat(owner, "<span class='warning'>Someone is attempting to climb out of your [name]!</span>")
		if(prob(escapechance)) //Let's have it check to see if the prey escapes first.
			if(do_after(R, escapetime))
				if((escapable) && (R in internal_contents)) //Does the owner still have escapable enabled?
					release_specific_contents(R)
					to_chat(R, "<span class='warning'>You climb out of \the [name].</span>")
					to_chat(owner, "<span class='warning'>[R] climbs out of your [name]!</span>")
					for(var/mob/M in viewers(4, owner))
						M.visible_message("<span class='warning'>[R] climbs out of [owner]'s [name]!</span>", 2)
					return
				else if(!(R in internal_contents)) //Aren't even in the belly. Quietly fail.
					return
			else //Belly became inescapable.
				to_chat(R, "<span class='warning'>Your attempt to escape [name] has failed!</span>")
				to_chat(owner, "<span class='notice'>The attempt to escape from your [name] has failed!/span>")
				return

		else if(prob(transferchance) && istype(transferlocation)) //Next, let's have it see if they end up getting into an even bigger mess then when they started.
			var/location_ok = verify_transferlocation()

			if(!location_ok)
				to_chat(owner, "<span class='warning'>Something went wrong with your belly transfer settings.</span>")
				transferlocation = null
				return

			to_chat(R, "<span class='warning'>Your attempt to escape [name] has failed and your struggles only results in you sliding into [owner]'s [transferlocation]!</span>")
			to_chat(owner, "<span class='warning'>Someone slid into your [transferlocation] due to their struggling inside your [name]!</span>")
			transfer_contents(R, transferlocation)
			return

		else if(prob(digestchance)) //Finally, let's see if it should run the digest chance.)
			to_chat(R, "<span class='warning'>In response to your struggling, \the [name] begins to get more active...</span>")
			to_chat(owner, "<span class='warning'>You feel your [name] beginning to become active!</span>")
			digest_mode = DM_DIGEST
			return
		else //Nothing interesting happened.
			to_chat(R, "<span class='warning'>But make no progress in escaping [owner]'s [name].</span>")
			to_chat(owner, "<span class='warning'>But appears to be unable to make any progress in escaping your [name].</span>")
			return

//Transfers contents from one belly to another
/datum/belly/proc/transfer_contents(var/atom/movable/content, var/datum/belly/target, silent = 0)
	if(!(content in internal_contents))
		return
	internal_contents.Remove(content)
	// Re-use nom_mob
	target.nom_mob(content, target.owner)
	if(!silent)
		for(var/mob/hearer in range(1,owner))
			hearer << sound(target.vore_sound,volume=80)
/*
//Handles creation of temporary 'vore chest' upon digestion
/datum/belly/proc/slimy_mass(var/obj/item/content, var/mob/living/M)
	if(!content in internal_contents)
		return
	internal_contents += new /obj/structure/closet/crate/vore(src)
	internal_contents.Remove(content)
	M.transferItemToLoc(content, /obj/structure/closet/crate/vore)
	if(!M.transferItemToLoc(W))
		qdel(W)

/datum/belly/proc/regurgitate_items(var/obj/structure/closet/crate/vore/C)
	*/

// Belly copies and then returns the copy
// Needs to be updated for any var changes
/datum/belly/proc/copy(mob/new_owner)
	var/datum/belly/dupe = new /datum/belly(new_owner)

	//// Non-object variables
	dupe.name = name
	dupe.inside_flavor = inside_flavor
	dupe.vore_sound = vore_sound
	dupe.vore_verb = vore_verb
	dupe.human_prey_swallow_time = human_prey_swallow_time
	dupe.nonhuman_prey_swallow_time = nonhuman_prey_swallow_time
	dupe.emoteTime = emoteTime
	dupe.digest_brute = digest_brute
	dupe.digest_burn = digest_burn
	dupe.digest_tickrate = digest_tickrate
	dupe.immutable = immutable
	dupe.can_taste = can_taste
	dupe.escapable = escapable
	dupe.escapetime = escapetime
	dupe.digestchance = digestchance
	dupe.escapechance = escapechance
	dupe.transferchance = transferchance
	dupe.transferlocation = transferlocation
	dupe.autotransferchance = autotransferchance
	dupe.autotransferwait = autotransferwait

	//// Object-holding variables
	//struggle_messages_outside - strings
	dupe.struggle_messages_outside.Cut()
	for(var/I in struggle_messages_outside)
		dupe.struggle_messages_outside += I

	//struggle_messages_inside - strings
	dupe.struggle_messages_inside.Cut()
	for(var/I in struggle_messages_inside)
		dupe.struggle_messages_inside += I

	//digest_messages_owner - strings
	dupe.digest_messages_owner.Cut()
	for(var/I in digest_messages_owner)
		dupe.digest_messages_owner += I

	//digest_messages_prey - strings
	dupe.digest_messages_prey.Cut()
	for(var/I in digest_messages_prey)
		dupe.digest_messages_prey += I

	//examine_messages - strings
	dupe.examine_messages.Cut()
	for(var/I in examine_messages)
		dupe.examine_messages += I

	//emote_lists - index: digest mode, key: list of strings
	dupe.emote_lists.Cut()
	for(var/K in emote_lists)
		dupe.emote_lists[K] = list()
		for(var/I in emote_lists[K])
			dupe.emote_lists[K] += I

	return dupe

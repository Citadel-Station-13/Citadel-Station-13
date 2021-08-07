//////////////////////////////////////
//SYSTEM CORRUPTION FOR ROBOT-PEOPLE//
//////////////////////////////////////

//Moved into its own file for easier accessability & less cluttering of carbon/life.dm. Used in BiologicalLife()


#define CORRUPTION_CHECK_INTERVAL 10   //Life() is called once every second, so ten seconds interval.
#define CORRUPTION_THRESHHOLD_MINOR 10 //Above: Annoyances, to remind you you should get your corruption fixed.
#define CORRUPTION_THRESHHOLD_MAJOR 35 //Above: Very annoying stuff, go get fixed.
#define CORRUPTION_THRESHHOLD_CRITICAL 65 //Above: Extremely annoying stuff, possibly life-threatening

/mob/living/carbon/proc/handle_corruption()
	if(!HAS_TRAIT(src, TRAIT_ROBOTIC_ORGANISM)) //Only robot-people need to care about this
		return
	corruption_timer++
	var/corruption = getToxLoss(toxins_type = TOX_SYSCORRUPT)
	var/corruption_state
	var/timer_req = CORRUPTION_CHECK_INTERVAL
	switch(corruption)
		if(0 to CORRUPTION_THRESHHOLD_MINOR)
			timer_req = INFINITY //Below minor corruption you are fiiine
			corruption_state = "<font color='green'>None</font>" //This should never happen, but have it anyways.
		if(CORRUPTION_THRESHHOLD_MINOR to CORRUPTION_THRESHHOLD_MAJOR)
			corruption_state = "<font color='blue'>Minor</font>"
		if(CORRUPTION_THRESHHOLD_MAJOR to CORRUPTION_THRESHHOLD_CRITICAL)
			timer_req -= 1
			corruption_state = "<font color='orange'>Major</font>"
		if(CORRUPTION_THRESHHOLD_CRITICAL to INFINITY)
			timer_req -= 2
			corruption_state = "<font color='red'>Critical</font>"
	if(corruption_timer < timer_req)
		return
	corruption_timer = 0
	if(!prob(corruption)) //Lucky you beat the rng roll!
		return
	var/list/whatmighthappen = list()
	whatmighthappen += list("avoided" = 3, "dropthing" = 1, "movetile" = 1, "shortdeaf" = 1, "flopover" = 1, "nutriloss" = 1, "selfflash" = 1, "harmies" = 1)
	if(corruption >= CORRUPTION_THRESHHOLD_MAJOR)
		whatmighthappen += list("longdeaf" = 1, "longknockdown" = 1, "shortlimbdisable" = 1, "shortblind" = 1, "shortstun" = 1, "shortmute" = 1, "vomit" = 1, "halluscinate" = 1)
	if(corruption >= CORRUPTION_THRESHHOLD_CRITICAL)
		whatmighthappen += list("receporgandamage" = 1, "longlimbdisable" = 1, "blindmutedeaf" = 1, "longstun" = 1, "sleep" = 1, "inducetrauma" = 1, "amplifycorrupt" = 1, "changetemp" = 1)
	var/event = pickweight(whatmighthappen)
	log_message("has been affected by [event] due to system corruption of [corruption], with a corruption state of [corruption_state]", LOG_ATTACK)
	switch(event)
		if("avoided")
			to_chat(src, "<span class='notice'>System malfunction avoided by hardware safeguards - intervention recommended.</span>")
			adjustToxLoss(-0.2, toxins_type = TOX_SYSCORRUPT) //If you roll this, your system safeguards caught onto the system corruption and neutralised a bit of it.
		if("dropthing")
			drop_all_held_items()
			to_chat(src, "<span class='warning'>Error - Malfunction in arm circuitry.</span>")
		if("movetile")
			if(CHECK_MOBILITY(src, MOBILITY_MOVE) && !ismovable(loc))
				step(src, pick(GLOB.cardinals))
				to_chat(src, "<span class='warning'>Error - Malfunction in movement control subsystem.</span>")
		if("shortdeaf")
			ADD_TRAIT(src, TRAIT_DEAF, CORRUPTED_SYSTEM)
			addtimer(CALLBACK(src, .proc/reenable_hearing), 5 SECONDS)
			to_chat(src, "<span class='hear'><b>ZZZZT</b></span>")
		if("flopover")
			DefaultCombatKnockdown(1)
			to_chat(src, "<span class='warning'>Error - Malfunction in actuator circuitry.</span>")
		if("nutriloss")
			nutrition = max(0, nutrition - 50)
			to_chat(src, "<span class='warning'>Power surge detected in internal battery cell.</span>")
		if("selfflash")
			if(flash_act(override_protection = 1))
				confused += 4
				to_chat(src, "<span class='warning'>Error - Sensory system overload detected!</span>")
		if("harmies")
			a_intent_change(INTENT_HARM)
			to_chat(src, "<span class='notice'>Intent subsystem successfully recalibrated.</span>")
		if("longdeaf")
			ADD_TRAIT(src, TRAIT_DEAF, CORRUPTED_SYSTEM)
			addtimer(CALLBACK(src, .proc/reenable_hearing), 20 SECONDS)
			to_chat(src, "<span class='notice'>Hearing subsystem successfully shutdown.</span>")
		if("longknockdown")
			DefaultCombatKnockdown(50)
			to_chat(src, "<span class='warning'>Significant error in actuator subsystem - Rebooting.</span>")
		if("shortlimbdisable")
			var/disabled_type = pick(list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG))
			ADD_TRAIT(src, disabled_type, CORRUPTED_SYSTEM)
			update_disabled_bodyparts()
			addtimer(CALLBACK(src, .proc/reenable_limb, disabled_type), 5 SECONDS)
			to_chat(src, "<span class='warning'>Error - Limb control subsystem partially shutdown, rebooting.</span>")
		if("shortblind")
			become_blind(CORRUPTED_SYSTEM)
			addtimer(CALLBACK(src, .proc/reenable_vision), 5 SECONDS)
			to_chat(src, "<span class='warning'>Visual receptor shutdown detected - Initiating reboot.</span>")
		if("shortstun")
			Stun(30)
			to_chat(src, "<span class='warning'>Deadlock detected in primary systems, error code [rand(101, 999)].</span>")
		if("shortmute")
			ADD_TRAIT(src, TRAIT_MUTE, CORRUPTED_SYSTEM)
			addtimer(CALLBACK(src, .proc/reenable_speech), 5 SECONDS)
			to_chat(src, "<span class='notice'>Communications matrix successfully shutdown for maintenance.</span>")
		if("vomit")
			to_chat(src, "<span class='notice'>Ejecting contaminant.</span>")
			vomit()
		if("halluscinate")
			hallucination += 20 //Doesn't give a cue
		if("receporgandamage")
			adjustOrganLoss(ORGAN_SLOT_EARS, rand(10, 20))
			adjustOrganLoss(ORGAN_SLOT_EYES, rand(10, 20))
			to_chat(src, "<span class='warning'>Power spike detected in auditory and visual systems!</span>")
		if("longlimbdisable")
			var/disabled_type = pick(list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG))
			ADD_TRAIT(src, disabled_type, CORRUPTED_SYSTEM)
			update_disabled_bodyparts()
			addtimer(CALLBACK(src, .proc/reenable_limb, disabled_type), 25 SECONDS)
			to_chat(src, "<span class='warning'>Fatal error in limb control subsystem - rebooting.</span>")
		if("blindmutedeaf")
			become_blind(CORRUPTED_SYSTEM)
			addtimer(CALLBACK(src, .proc/reenable_vision), (rand(10, 25)) SECONDS)
			ADD_TRAIT(src, TRAIT_DEAF, CORRUPTED_SYSTEM)
			addtimer(CALLBACK(src, .proc/reenable_hearing), (rand(15, 35)) SECONDS)
			ADD_TRAIT(src, TRAIT_MUTE, CORRUPTED_SYSTEM)
			addtimer(CALLBACK(src, .proc/reenable_speech), (rand(20, 45)) SECONDS)
			to_chat(src, "<span class='warning'>Fatal error in multiple systems - Performing recovery.</span>")
		if("longstun")
			Stun(80)
			to_chat(src, "<span class='warning'Critical divide-by-zero error detected - Failsafe initiated.</span>")
		if("sleep")
			addtimer(CALLBACK(src, .proc/forcesleep), (rand(6, 10)) SECONDS)
			to_chat(src, "<span class='warning'>Priority 1 shutdown order received in operating system - Preparing powerdown.</span>")
		if("inducetrauma")
			to_chat(src, "<span class='warning'>Major interference detected in main operating matrix - Complications possible.</span>")
			var/resistance = pick(
				65;TRAUMA_RESILIENCE_BASIC,
				35;TRAUMA_RESILIENCE_SURGERY)

			var/trauma_type = pickweight(list(
				BRAIN_TRAUMA_MILD = 80,
				BRAIN_TRAUMA_SEVERE = 10))
			gain_trauma_type(trauma_type, resistance) //Gaining the trauma will inform them, but we'll tell them too so they know what the reason was.
		if("amplifycorrupt")
			adjustToxLoss(5, toxins_type = TOX_SYSCORRUPT)
			to_chat(src, "<span class='warning'>System safeguards failing - Action urgently required.</span>")
		if("changetemp")
			adjust_bodytemperature(rand(150, 250))
			to_chat(src, "<span class='warning'>Warning - Fatal coolant flow error at node [rand(6, 99)]!</span>") //This is totally not a reference to anything.

/mob/living/carbon/proc/reenable_limb(disabled_limb)
	REMOVE_TRAIT(src, disabled_limb, CORRUPTED_SYSTEM)
	update_disabled_bodyparts()
	to_chat(src, "<span class='notice'>Limb control subsystem successfully rebooted.</span>")

/mob/living/carbon/proc/reenable_hearing()
	REMOVE_TRAIT(src, TRAIT_DEAF, CORRUPTED_SYSTEM)
	to_chat(src, "<span class='notice'>Hearing restored.</span>")

/mob/living/carbon/proc/reenable_vision()
	cure_blind(CORRUPTED_SYSTEM)
	to_chat(src, "<span class='notice'>Visual receptors back online.</span>")

/mob/living/carbon/proc/reenable_speech()
	REMOVE_TRAIT(src, TRAIT_MUTE, CORRUPTED_SYSTEM)
	to_chat(src, "<span class='notice'>Communications subsystem operational.</span>")

/mob/living/carbon/proc/forcesleep(time = 100)
	to_chat(src, "<span class='notice'>Preparations complete, powering down.</span>")
	Sleeping(time, 0)


#undef CORRUPTION_CHECK_INTERVAL
#undef CORRUPTION_THRESHHOLD_MINOR
#undef CORRUPTION_THRESHHOLD_MAJOR
#undef CORRUPTION_THRESHHOLD_CRITICAL

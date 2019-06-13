/datum/status_effect/chem/SGDF
	id = "SGDF"
	var/mob/living/fermi_Clone
	alert_type = null

/datum/status_effect/chem/SGDF/on_apply()
	investigate_log("SGDF status appied on [owner], ID: [owner.id]")
	var/typepath = owner.type
	fermi_Clone = new typepath(owner.loc)
	var/mob/living/carbon/M = owner
	var/mob/living/carbon/C = fermi_Clone

	if(istype(C) && istype(M))
		C.real_name = M.real_name
		M.dna.transfer_identity(C, transfer_SE=1)
		C.updateappearance(mutcolor_update=1)
	return ..()

/datum/status_effect/chem/SGDF/tick()
	if(owner.stat == DEAD)
		if((fermi_Clone && fermi_Clone.stat != DEAD) || (fermi_Clone == null))
			if(owner.mind)
				investigate_log("SGDF mind shift applied. [owner] is now playing as their clone and should not have memories after their clone split (look up SGDF status applied). ID: [owner.id]")
				owner.mind.transfer_to(fermi_Clone)
				to_chat(owner, "<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
				to_chat(fermi_Clone, "<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
				fermi_Clone = null
				owner.remove_status_effect(src)
	..()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/status_effect/chem/breast_enlarger
	id = "breast_enlarger"
	alert_type = null
	var/moveCalc = 1
	var/cachedmoveCalc = 1

/datum/status_effect/chem/breast_enlarger/on_apply(mob/living/carbon/human/H)//Removes clothes, they're too small to contain you. You belong to space now.
	investigate_log("[owner]'s breasts has reached comical sizes. ID: [owner.id]")
	var/mob/living/carbon/human/o = owner
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			to_chat(o, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling breasts! Unless you manage to reduce the size of your breasts, there's no way you're going to be able to put anything on over these melons..!</b></span>")
			o.visible_message("<span class='boldnotice'>[o]'s chest suddenly bursts forth, ripping their clothes off!'</span>")
		else
			to_chat(o, "<span class='notice'>Your bountiful bosom is so rich with mass, you seriously doubt you'll be able to fit any clothes over it.</b></span>")
		return ..()

/datum/status_effect/chem/breast_enlarger/tick(mob/living/carbon/human/H)//If you try to wear clothes, you fail. Slows you down if you're comically huge
	var/mob/living/carbon/human/o = owner
	var/obj/item/organ/genital/breasts/B = o.getorganslot("breasts")
	moveCalc = 1+((round(B.cached_size) - 9)/3) //Afffects how fast you move, and how often you can click.
	if(!B)
		o.remove_movespeed_modifier("megamilk")
		sizeMoveMod(1)
		owner.remove_status_effect(src)
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			to_chat(owner, "<span class='warning'>Your enormous breasts are way too large to fit anything over them!</b></span>")
	if (B.size == "huge")
		if(prob(1))
			to_chat(owner, "<span class='notice'>Your back is feeling a little sore.</span>")
			var/target = o.get_bodypart(BODY_ZONE_CHEST)
			o.apply_damage(0.1, BRUTE, target)
		if(!B.cached_size == B.breast_values[B.prev_size])
			o.add_movespeed_modifier("megamilk", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = moveCalc)
			sizeMoveMod(moveCalc)
		return ..()
	else if (B.breast_values[B.size] > B.breast_values[B.prev_size])
		o.add_movespeed_modifier("megamilk", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = moveCalc)
		sizeMoveMod(moveCalc)
	else if (B.breast_values[B.size] < B.breast_values[B.prev_size])
		o.add_movespeed_modifier("megamilk", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = moveCalc)
		sizeMoveMod(moveCalc)
	if((B.cached_size) < 16)
		switch(round(B.cached_size))
			if(9)
				if (GLOB.breasts_size_list[B.prev_size] != GLOB.breasts_size_list[B.size])
					to_chat(o, "<span class='notice'>Your expansive chest has become a more managable size, liberating your movements.</b></span>")
			if(10 to INFINITY)
				if (GLOB.breasts_size_list[B.prev_size] != GLOB.breasts_size_list[B.size])
					to_chat(H, "<span class='warning'>Your indulgent busom is so substantial, it's affecting your movements!</b></span>")
		if(prob(2))
			to_chat(owner, "<span class='notice'>Your back is feeling a little sore.</span>")
		..()

/datum/status_effect/chem/breast_enlarger/on_remove(mob/living/carbon/M)
	investigate_log("[owner]'s breasts has reduced to an acceptable size. ID: [owner.id]")
	owner.remove_movespeed_modifier("megamilk")
	sizeMoveMod(1)

/datum/status_effect/chem/breast_enlarger/proc/sizeMoveMod(var/value)
	if(cachedmoveCalc == value)
		return
	owner.next_move_modifier /= cachedmoveCalc
	owner.next_move_modifier *= value
	cachedmoveCalc = value

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/status_effect/chem/penis_enlarger
	id = "penis_enlarger"
	alert_type = null
	var/bloodCalc
	var/moveCalc

/datum/status_effect/chem/penis_enlarger/on_apply(mob/living/carbon/human/H)//Removes clothes, they're too small to contain you. You belong to space now.
	investigate_log("[owner]'s dick has reached comical sizes. ID: [owner.id]")
	var/mob/living/carbon/human/o = owner
	var/items = o.get_contents()
	if(o.w_uniform || o.wear_suit)
		to_chat(o, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling pecker! Unless you manage to reduce the size of your emancipated trouser snake, there's no way you're going to be able to put anything on over this girth..!</b></span>")
		owner.visible_message("<span class='boldnotice'>[o]'s schlong suddenly bursts forth, ripping their clothes off!'</span>")
	else
		to_chat(o, "<span class='notice'>Your emancipated trouser snake is so ripe with girth, you seriously doubt you'll be able to fit any clothes over it.</b></span>")
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	return ..()


/datum/status_effect/chem/penis_enlarger/tick(mob/living/carbon/M)
	var/mob/living/carbon/human/o = owner
	var/obj/item/organ/genital/penis/P = o.getorganslot("penis")
	moveCalc = 1+((round(P.length) - 21)/3) //effects how fast you can move
	bloodCalc = 1+((round(P.length) - 21)/10) //effects how much blood you need (I didn' bother adding an arousal check because I'm spending too much time on this organ already.)
	if(!P)
		o.remove_movespeed_modifier("hugedick")
		o.ResetBloodVol()
		owner.remove_status_effect(src)
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			to_chat(owner, "<span class='warning'>Your enormous package is way to large to fit anything over!</b></span>")
	switch(round(P.cached_length))
		if(21)
			to_chat(o, "<span class='notice'>Your rascally willy has become a more managable size, liberating your movements.</b></span>")
			o.remove_movespeed_modifier("hugedick")
			o.AdjustBloodVol(bloodCalc)
		if(22 to INFINITY)
			if(prob(2))
				to_chat(o, "<span class='warning'>Your indulgent johnson is so substantial, it's taking all your blood and affecting your movements!</b></span>")
			o.add_movespeed_modifier("hugedick", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = moveCalc)
			o.AdjustBloodVol(bloodCalc)
	..()

/datum/status_effect/chem/penis_enlarger/on_remove(mob/living/carbon/human/o)
	investigate_log("[owner]'s dick has reduced to an acceptable size. ID: [owner.id]")
	owner.remove_movespeed_modifier("hugedick")
	owner.ResetBloodVol()


/*//////////////////////////////////////////
		Mind control functions
///////////////////////////////////////////
*/

//Preamble
/mob/living
	var/lewd = TRUE

/mob/living/verb/toggle_lewd()
	set category = "IC"
	set name = "Toggle Lewdchem"
	set desc = "Allows you to toggle if you'd like lewd flavour messages."
	lewd = !(lewd)
	to_chat(usr, "You [(lewd?"will":"no longer")] receive lewdchem messages.")

/datum/status_effect/chem/enthrall
	id = "enthrall"
	alert_type = null
	var/enthrallTally = 1 //Keeps track of the enthralling process
	var/resistanceTally = 0 //Keeps track of the resistance
	var/deltaResist //The total resistance added per resist click

	var/phase = 1 //-1: resisted state, due to be removed.0: sleeper agent, no effects unless triggered 1: initial, 2: 2nd stage - more commands, 3rd: fully enthralled, 4th Mindbroken

	var/status = null //status effects
	var/statusStrength = 0 //strength of status effect

	var/mob/living/master //Enchanter's person
	var/enthrallID //Enchanter's ckey
	var/enthrallGender //Use master or mistress

	var/mental_capacity //Higher it is, lower the cooldown on commands, capacity reduces with resistance.
	var/datum/weakref/redirect_component //resistance

	var/distancelist = list(2,1.5,1,0.8,0.6,0.5,0.4,0.3,0.2) //Distance multipliers

	var/withdrawal = FALSE //withdrawl
	var/withdrawalTick = 0 //counts how long withdrawl is going on for

	var/list/customTriggers = list() //the list of custom triggers

	var/cooldown = 0 //cooldown on commands
	var/cooldownMsg = TRUE //If cooldown message has been sent
	var/cTriggered = FALSE //If someone is triggered (so they can't trigger themselves with what they say for infinite loops)
	var/resistGrowth = 0 //Resistance accrues over time
	var/DistApart = 1 //Distance between master and owner
	var/tranceTime = 0 //how long trance effects apply on trance status

/datum/status_effect/chem/enthrall/on_apply()
	var/mob/living/carbon/M = owner
	var/datum/reagent/fermi/enthrall/E = locate(/datum/reagent/fermi/enthrall) in M.reagents.reagent_list
	if(!E)
		message_admins("WARNING: FermiChem: No master found in thrall, did you bus in the chem? You need to set up the vars manually if it's not reacted/bussed. Someone set up the reaction incorrectly if not (Don't use donor blood). Console them with a fermiplush maybe?")
		owner.remove_status_effect(src)
	enthrallID = E.creatorID
	enthrallGender = E.creatorGender
	master = get_mob_by_key(enthrallID)
	//if(M.ckey == enthrallID)
	//	owner.remove_status_effect(src)//At the moment, a user can enthrall themselves, toggle this back in if that should be removed.
	redirect_component = WEAKREF(owner.AddComponent(/datum/component/redirect, list(COMSIG_LIVING_RESIST = CALLBACK(src, .proc/owner_resist)))) //Do resistance calc if resist is pressed#
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, .proc/owner_hear)
	var/obj/item/organ/brain/B = M.getorganslot(ORGAN_SLOT_BRAIN) //It's their brain!
	mental_capacity = 500 - B.get_brain_damage()
	var/mob/living/carbon/human/H = owner
	if(H)//Prefs
		if(!H.canbearoused)
			H.lewd = FALSE
	var/message = "[(owner.lewd?"I am a good pet for [enthrallGender].":"[master] is a really inspirational person!")]"
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "enthrall", /datum/mood_event/enthrall, message)
	to_chat(owner, "<span class='[(owner.lewd?"big love":"big warning")]'><b>You feel inexplicably drawn towards [master], their words having a demonstrable effect on you. It seems the closer you are to them, the stronger the effect is. However you aren't fully swayed yet and can resist their effects by repeatedly resisting as much as you can!</b></span>")
	investigate_log("MKULTRA: Status applied on [owner] ckey: [owner.id] with a master of [master] ckey: [enthrallID].")
	return ..()

/datum/status_effect/chem/enthrall/tick()
	var/mob/living/carbon/M = owner

	//chem calculations
	if (owner.reagents.has_reagent("enthrall"))
		if (phase >= 2)
			enthrallTally += phase
	else
		if (phase < 3 && phase != 0)
			deltaResist += 3//If you've no chem, then you break out quickly
			if(prob(10))
				to_chat(owner, "<span class='notice'><i>Your mind starts to restore some of it's clarity as you feel the effects of the drug wain.</i></span>")
	if (mental_capacity <= 500 || phase == 4)
		if (owner.reagents.has_reagent("mannitol"))
			mental_capacity += 5
		if (owner.reagents.has_reagent("neurine"))
			mental_capacity += 10

	//mindshield check
	if(M.has_trait(TRAIT_MINDSHIELD))//If you manage to enrapture a head, wow, GJ. (resisting gives a bigger bonus with a mindshield)
		resistanceTally += 2
		if(prob(10))
			to_chat(owner, "<span class='notice'><i>You feel lucidity returning to your mind as the mindshield buzzes, attempting to return your brain to normal function.</i></span>")
		if(phase == 4)
			mental_capacity += 5

	//phase specific events
	switch(phase)
		if(-1)//fully removed
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrall")
			owner.remove_status_effect(src)
			investigate_log("MKULTRA: Status REMOVED from [owner] ckey: [owner.id] with a master of [master] ckey: [enthrallID].")
		if(0)// sleeper agent
			if (cooldown > 0)
				cooldown -= 1
			return
		if(1)//Initial enthrallment
			if (enthrallTally > 125)
				phase += 1
				mental_capacity -= resistanceTally//leftover resistance per step is taken away from mental_capacity.
				resistanceTally /= 2
				enthrallTally = 0
				if(owner.lewd)
					to_chat(owner, "<span class='hypnophrase'><i>Your conciousness slips, as you sink deeper into trance and servitude.</i></span>")
				else

			else if (resistanceTally > 150)
				phase = -1
				to_chat(owner, "<span class='warning'><i>You break free of the influence in your mind, your thoughts suddenly turning lucid!</i></span>")
				if(DistApart < 10)
					to_chat(master, "<span class='warning'>[(master.lewd?"Your pet":"Your thrall")] seems to have broken free of your enthrallment!</i></span>")
				owner.remove_status_effect(src) //If resisted in phase 1, effect is removed.
			if(prob(10))
				if(owner.lewd)
					to_chat(owner, "<span class='small hypnophrase'><i>[pick("It feels so good to listen to [master].", "You can't keep your eyes off [master].", "[master]'s voice is making you feel so sleepy.",  "You feel so comfortable with [master]", "[master] is so dominant, it feels right to obey them.")].</b></span>")
		if (2) //partially enthralled
			if (enthrallTally > 250)
				phase += 1
				mental_capacity -= resistanceTally//leftover resistance per step is taken away from mental_capacity.
				enthrallTally = 0
				resistanceTally /= 2
				if(owner.lewd)
					to_chat(owner, "<span class='userlove'><i>Your mind gives, eagerly obeying and serving [master].</i></span>")
					to_chat(owner, "<span class='big warning'><b>You are now fully enthralled to [master], and eager to follow their commands. However you find that in your intoxicated state you are unable to resort to violence. Equally you are unable to commit suicide, even if ordered to, as you cannot serve your [enthrallGender] in death. </i></span>")//If people start using this as an excuse to be violent I'll just make them all pacifists so it's not OP.
				else
					to_chat(owner, "<span class='big nicegreen'><i>You are unable to put up a resistance any longer, and now are under the control of [master]. However you find that in your intoxicated state you are unable to resort to violence. Equally you are unable to commit suicide, even if ordered to, as you cannot serve your [master] in death. </i></span>")
				owner.add_trait(TRAIT_PACIFISM, "MKUltra") //IMPORTANT
				investigate_log("MKULTRA: Status on [owner] ckey: [owner.id] has been fully entrhalled (state 3) with a master of [master] ckey: [enthrallID].")
			else if (resistanceTally > 200)
				enthrallTally *= 0.5
				phase -= 1
				resistanceTally = 0
				resistGrowth = 0
				to_chat(owner, "<span class='notice'><i>You manage to shake some of the effects from your addled mind, however you can still feel yourself drawn towards [master].</i></span>")
			if(prob(10))
				if(owner.lewd)
					to_chat(owner, "<span class='hypnophrase'><i>[pick("It feels so good to listen to [enthrallGender].", "You can't keep your eyes off [enthrallGender].", "[enthrallGender]'s voice is making you feel so sleepy.",  "You feel so comfortable with [enthrallGender]", "[enthrallGender] is so dominant, it feels right to obey them.")].</i></span>")
		if (3)//fully entranced
			if ((resistanceTally >= 200 && withdrawalTick >= 150) || (M.has_trait(TRAIT_MINDSHIELD) && (resistanceTally >= 100)))
				enthrallTally = 0
				phase -= 1
				resistanceTally = 0
				resistGrowth = 0
				to_chat(owner, "<span class='notice'><i>The separation from [(owner.lewd?"your [enthrallGender]":"[master]")] sparks a small flame of resistance in yourself, as your mind slowly starts to return to normal.</i></span>")
				owner.remove_trait(TRAIT_PACIFISM, "MKUltra")
			if(prob(2))
				if(owner.lewd)
					to_chat(owner, "<span class='love'><i>[pick("I belong to [enthrallGender].", "[enthrallGender] knows whats best for me.", "Obedence is pleasure.",  "I exist to serve [enthrallGender].", "[enthrallGender] is so dominant, it feels right to obey them.")].</i></span>")
		if (4) //mindbroken
			if (mental_capacity >= 499 && (owner.getBrainLoss() >=20 || M.has_trait(TRAIT_MINDSHIELD)) && !owner.reagents.has_reagent("MKUltra"))
				phase = 2
				mental_capacity = 500
				customTriggers = list()
				to_chat(owner, "<span class='notice'><i>Your mind starts to heal, fixing the damage caused by the massive amounts of chem injected into your system earlier, returning clarity to your mind. Though, you still feel drawn towards [master]'s words...'</i></span>")
				M.slurring = 0
				M.confused = 0
				resistGrowth = 0
			else
				if (cooldown > 0)
					cooldown -= (0.8 + (mental_capacity/500))
					cooldownMsg = FALSE
				else if (cooldownMsg == FALSE)
					if(DistApart < 10)
						if(master.lewd)
							to_chat(master, "<span class='notice'><i>Your pet [owner] appears to have finished internalising your last command.</i></span>")
						else
							to_chat(master, "<span class='notice'><i>Your thrall [owner] appears to have finished internalising your last command.</i></span>")
				return//If you break the mind of someone, you can't use status effects on them.


	//distance calculations
	DistApart = get_dist(master, owner)
	switch(DistApart)
		if(0 to 8)//If the enchanter is within range, increase enthrallTally, remove withdrawal subproc and undo withdrawal effects.
			if(phase <= 2)
				enthrallTally += distancelist[get_dist(master, owner)+1]
			withdrawal = FALSE
			if(withdrawalTick > 0)
				withdrawalTick -= 2
			M.hallucination = max(0, M.hallucination - 2)
			M.stuttering = max(0, M.stuttering - 2)
			M.jitteriness = max(0, M.jitteriness - 2)
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing1")
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing2")
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
		if(9 to INFINITY)//If they're not nearby, enable withdrawl effects.
			withdrawal = TRUE

	//Withdrawal subproc:
	if (withdrawal == TRUE)//Your minions are really REALLY needy.
		switch(withdrawalTick)//denial
			if(5)//To reduce spam
				to_chat(owner, "<span class='big warning'><b>You are unable to complete your [master]'s orders without their presence, and any commands and objectives given to you prior are not in effect until you are back with them.</b></span>")
			if(10 to 35)//Gives wiggle room, so you're not SUPER needy
				if(prob(5))
					to_chat(owner, "<span class='notice'><i>You're starting to miss [(owner.lewd?"your [enthrallGender]":"[master]")].</i></span>")
				if(prob(5))
					owner.adjustBrainLoss(0.5)
					to_chat(owner, "<i>[(owner.lewd?"[enthrallGender]":"[master]")] will surely be back soon</i>") //denial
			if(36)
				var/message = "[(owner.lewd?"I feel empty when [enthrallGender]'s not around..":"I miss [master]'s presence")]"
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing1", /datum/mood_event/enthrallmissing1, message)
			if(37 to 65)//barganing
				if(prob(10))
					to_chat(owner, "<i>They are coming back, right...?</i>")
					owner.adjustBrainLoss(1)
				if(prob(10))
					if(owner.lewd)
						to_chat(owner, "<i>I just need to be a good pet for [enthrallGender], they'll surely return if I'm a good pet.</i>")
					owner.adjustBrainLoss(-1)
			if(66)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing1")
				var/message = "[(owner.lewd?"I feel so lost in this complicated world without [enthrallGender]..":"I have to return to [master]!")]"
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing2", /datum/mood_event/enthrallmissing2, message)
				owner.stuttering += 200
				owner.jitteriness += 200
			if(67 to 90) //anger
				if(prob(10))
					addtimer(CALLBACK(M, /mob/verb/a_intent_change, INTENT_HARM), 2)
					addtimer(CALLBACK(M, /mob/proc/click_random_mob), 2)
					if(owner.lewd)
						to_chat(owner, "<span class='warning'>You are overwhelmed with anger at the lack of [enthrallGender]'s presence and suddenly lash out!</span>")
					else
						to_chat(owner, "<span class='warning'>You are overwhelmed with anger and suddenly lash out!</span>")
					owner.adjustBrainLoss(1)
			if(90)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing2")
				var/message = "[(owner.lewd?"Where are you [enthrallGender]??!":"I need to find [master]!")]"
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing3", /datum/mood_event/enthrallmissing3, message)
				if(owner.lewd)
					to_chat(owner, "<span class='warning'><i>You need to find your [enthrallGender] at all costs, you can't hold yourself back anymore!</i></span>")
				else
					to_chat(owner, "<span class='warning'><i>You need to find [master] at all costs, you can't hold yourself back anymore!</i></span>")
			if(91 to 120)//depression
				if(prob(20))
					owner.adjustBrainLoss(2.5)
					owner.stuttering += 20
					owner.jitteriness += 20
				if(prob(25))
					M.hallucination += 20
			if(121)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
				var/message = "[(owner.lewd?"I'm all alone, It's so hard to continute without [enthrallGender]...":"I really need to find [master]!!!")]"
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing4", /datum/mood_event/enthrallmissing4, message)
				to_chat(owner, "<span class='warning'><i>You can hardly find the strength to continue without your [enthrallGender].</i></span>")
			if(120 to 140) //depression 2, revengeance
				if(prob(15))
					owner.Stun(50)
					owner.emote("cry")//does this exist?
					if(owner.lewd)
						to_chat(owner, "<span class='warning'><i>You're unable to hold back your tears, suddenly sobbing as the desire to see your [enthrallGender] oncemore overwhelms you.</i></span>")
					else
						to_chat(owner, "<span class='warning'><i>You are overwheled with withdrawl from [master].</i></span>")
					owner.adjustBrainLoss(5)
					owner.stuttering += 20
					owner.jitteriness += 20
				if(prob(5))
					deltaResist += 5
			if(140 to INFINITY) //acceptance
				if(prob(15))
					deltaResist += 5
					if(prob(20))
						if(owner.lewd)
							to_chat(owner, "<i><span class='small green'>Maybe you'll be okay without your [enthrallGender].</i></span>")
						else
							to_chat(owner, "<i><span class='small green'>You feel your mental functions slowly begin to return.</i></span>")
				if(prob(10))
					owner.adjustBrainLoss(2)
					M.hallucination += 50

		withdrawalTick += 0.5//Usually enough to leave you with a major brain trauma, but not kill you.

	//Status subproc - statuses given to you from your Master
	//currently 3 statuses; antiresist -if you press resist, increases your enthrallment instead, HEAL - which slowly heals the pet, CHARGE - which breifly increases speed, PACIFY - makes pet a pacifist, ANTIRESIST - frustrates resist presses.
	if (status)

		if(status == "Antiresist")
			if (statusStrength < 0)
				status = null
				to_chat(owner, "<span class='notice'><i>Your mind feels able to resist oncemore.</i></span>")
			else
				statusStrength -= 1

		else if(status == "heal")
			if (statusStrength < 0)
				status = null
				to_chat(owner, "<span class='notice'><i>You finish licking your wounds.</i></span>")
			else
				statusStrength -= 1
				owner.heal_overall_damage(1, 1, 0, FALSE, FALSE)
				cooldown += 1 //Cooldown doesn't process till status is done

		else if(status == "charge")
			owner.add_trait(TRAIT_GOTTAGOFAST, "MKUltra")
			status = "charged"
			if(master.lewd)
				to_chat(owner, "<span class='notice'><i>Your [enthrallGender]'s order fills you with a burst of speed!</i></span>")
			else
				to_chat(owner, "<span class='notice'><i>[master]'s command fills you with a burst of speed!</i></span>")

		else if (status == "charged")
			if (statusStrength < 0)
				status = null
				owner.remove_trait(TRAIT_GOTTAGOFAST, "MKUltra")
				owner.Knockdown(50)
				to_chat(owner, "<span class='notice'><i>Your body gives out as the adrenaline in your system runs out.</i></span>")
			else
				statusStrength -= 1
				cooldown += 1 //Cooldown doesn't process till status is done

		else if (status == "pacify")
			owner.add_trait(TRAIT_PACIFISM, "MKUltraStatus")
			status = null

			//Truth serum?
			//adrenals?

	//final tidying
	resistanceTally  += deltaResist
	deltaResist = 0
	if (cooldown > 0)
		cooldown -= (0.8 + (mental_capacity/500))
		cooldownMsg = FALSE
	else if (cooldownMsg == FALSE)
		if(DistApart < 10)
			if(master.lewd)
				to_chat(master, "<span class='notice'><i>Your pet [owner] appears to have finished internalising your last command.</i></span>")
			else
				to_chat(master, "<span class='notice'><i>Your thrall [owner] appears to have finished internalising your last command.</i></span>")
		cooldownMsg = TRUE
		cooldown = 0
	if (tranceTime > 0) //custom trances only last 50 ticks.
		tranceTime -= 1
	else if (!tranceTime == null) //remove trance after.
		M.remove_status_effect(/datum/status_effect/trance)
		tranceTime = null
	//..()

//Remove all stuff
/datum/status_effect/chem/enthrall/on_remove()
	var/mob/living/carbon/M = owner
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrall")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrallpraise")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrallscold")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing1")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing2")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing4")
	qdel(redirect_component.resolve())
	redirect_component = null
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	owner.remove_trait(TRAIT_PACIFISM, "MKUltra")
	to_chat(owner, "<span class='big redtext'><i>You're now free of [master]'s influence, and fully independant oncemore!'</i></span>")
	//UnregisterSignal(owner, COMSIG_GLOB_LIVING_SAY_SPECIAL) //Should still make custom commands work after freedom, need to check.


/datum/status_effect/chem/enthrall/proc/owner_hear(var/hearer, message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	if (cTriggered == TRUE)
		return
	var/mob/living/carbon/C = owner
	raw_message = lowertext(raw_message)
	for (var/trigger in customTriggers)
		var/cached_trigger = lowertext(trigger)
		if (findtext(raw_message, cached_trigger))//if trigger1 is the message
			cTriggered = TRUE
			investigate_log("MKULTRA: [owner] ckey: [owner.id] has been triggered with [cached_trigger] from [speaker] saying: \"[message]\". (their master being [master] ckey: [enthrallID].)")

			//Speak (Forces player to talk) works
			if (lowertext(customTriggers[trigger][1]) == "speak")//trigger2
				var/saytext = "Your mouth moves on it's own before you can even catch it."
				if(C.has_trait(TRAIT_NYMPHO))
					saytext += " You find yourself fully believing in the validity of what you just said and don't think to question it."
				to_chat(C, "<span class='notice'><i>[saytext]</i></span>")
				(C.say(customTriggers[trigger][2]))//trigger3
				investigate_log("MKULTRA: [owner] ckey: [owner.id] has been forced to say: \"[customTriggers[trigger][2]]\" from previous trigger.")


			//Echo (repeats message!) works
			else if (lowertext(customTriggers[trigger][1]) == "echo")//trigger2
				(to_chat(owner, "<span class='hypnophrase'><i>[customTriggers[trigger][2]]</i></span>"))//trigger3

			//Shocking truth! works
			else if (lowertext(customTriggers[trigger]) == "shock")
				if (C.canbearoused)
					C.electrocute_act(10, src, 1, FALSE, FALSE, FALSE, TRUE)//I've no idea how strong this is
					C.adjustArousalLoss(5)
					to_chat(owner, "<span class='warning'><i>Your muscles seize up, then start spasming wildy!</i></span>")
				else
					C.electrocute_act(15, src, 1, FALSE, FALSE, FALSE, TRUE)//To make up for the lack of effect

			//wah intensifies wah-rks
			else if (lowertext(customTriggers[trigger]) == "cum")//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				if (C.has_trait(TRAIT_NYMPHO))
					if (C.getArousalLoss() > 80)
						C.mob_climax(forced_climax=TRUE)
						C.SetStun(10)//We got your stun effects in somewhere, Kev.
					else
						C.adjustArousalLoss(10)
				else
					C.throw_at(get_step_towards(speaker,C), 3, 1) //cut this if it's too hard to get working

			//kneel (knockdown)
			else if (lowertext(customTriggers[trigger]) == "kneel")//as close to kneeling as you can get, I suppose.
				to_chat(owner, "<span class='notice'><i>You drop to the ground unsurreptitiously.</i></span>")
				C.lay_down()

			//strip (some) clothes
			else if (lowertext(customTriggers[trigger]) == "strip")//This wasn't meant to just be a lewd thing oops, is this pref breaking?
				var/mob/living/carbon/human/o = owner
				var/items = o.get_contents()
				for(var/obj/item/W in items)
					if(W == o.w_uniform || W == o.wear_suit)
						o.dropItemToGround(W, TRUE)
				to_chat(owner,"<span class='notice'><i>You feel compelled to strip your clothes.</i></span>")

			//trance
			else if (lowertext(customTriggers[trigger]) == "trance")//Maaaybe too strong. Weakened it, only lasts 50 ticks.
				var/mob/living/carbon/human/o = owner
				o.apply_status_effect(/datum/status_effect/trance, 200, TRUE)
				tranceTime = 50
				investigate_log("MKULTRA: [owner] ckey: [owner.id] has been tranced from previous trigger.")


			cTriggered = FALSE
	return

/datum/status_effect/chem/enthrall/proc/owner_resist()
	var/mob/living/carbon/M = owner
	to_chat(owner, "<span class='notice'><i>You attempt to fight against against [(owner.lewd?"[enthrallGender]":"[master]")]'s influence!'</i></span>")

	//Able to resist checks
	if (status == "Sleeper" || phase == 0)
		return
	else if (phase == 4)
		if(owner.lewd)
			to_chat(owner, "<span class='warning'><i>Your mind is too far gone to even entertain the thought of resisting. Unless you can fix the brain damage, you won't be able to break free of your [enthrallGender]'s control.</i></span>")
		else
			to_chat(owner, "<span class='warning'><i>Your brain is too overwhelmed with from the high volume of chemicals in your system, rendering you unable to resist, unless you can fix the brain damage.</i></span>")
		return
	else if (phase == 3 && withdrawal == FALSE)
		if(owner.lewd)
			to_chat(owner, "<span class='hypnophrase'><i>The presence of your [enthrallGender] fully captures the horizon of your mind, removing any thoughts of resistance. Try getting away from them.</i></span>")
		else
			to_chat(owner, "<span class='hypnophrase'><i>You are unable to resist [master] in your current state. Try getting away from them.</i></span>")
		return
	else if (status == "Antiresist")//If ordered to not resist; resisting while ordered to not makes it last longer, and increases the rate in which you are enthralled.
		if (statusStrength > 0)
			if(owner.lewd)
				to_chat(owner, "<span class='warning'><i>The order from your [enthrallGender] to give in is conflicting with your attempt to resist, drawing you deeper into trance! You'll have to wait a bit before attemping again, lest your attempts become frustrated again.</i></span>")
			else
				to_chat(owner, "<span class='warning'><i>The order from your [master] to give in is conflicting with your attempt to resist. You'll have to wait a bit before attemping again, lest your attempts become frustrated again.</i></span>")
			statusStrength += 1
			enthrallTally += 1
			return
		else
			status = null

	//base resistance
	if (deltaResist != 0)//So you can't spam it, you get one deltaResistance per tick.
		deltaResist += 0.1 //Though I commend your spamming efforts.
		return
	else
		deltaResist = 1.8 + resistGrowth
		resistGrowth += 0.05

	//distance modifer
	switch(DistApart)
		if(0)
			deltaResist *= 0.8
		if(1 to 8)//If they're far away, increase resistance.
			deltaResist *= (1+(DistApart/10))
		if(9 to INFINITY)//If
			deltaResist *= 2


	if(prob(5))
		M.emote("me",1,"squints, shaking their head for a moment.")//shows that you're trying to resist sometimes
		deltaResist *= 1.5
	to_chat(owner, "You attempt to shake the mental cobwebs from your mind!")
	//nymphomania
	if (M.canbearoused && M.has_trait(TRAIT_NYMPHO))//I'm okay with this being removed.
		deltaResist*= 0.5-(((2/200)*M.arousalloss)/1)//more aroused you are, the weaker resistance you can give, the less you are, the more you gain. (+/- 0.5)

	//chemical resistance, brain and annaphros are the key to undoing, but the subject has to to be willing to resist.
	if (owner.reagents.has_reagent("mannitol"))
		deltaResist *= 1.25
	if (owner.reagents.has_reagent("neurine"))
		deltaResist *= 1.5
	if (!owner.has_trait(TRAIT_CROCRIN_IMMUNE) && M.canbearoused)
		if (owner.reagents.has_reagent("anaphro"))
			deltaResist *= 1.5
		if (owner.reagents.has_reagent("anaphro+"))
			deltaResist *= 2
		if (owner.reagents.has_reagent("aphro"))
			deltaResist *= 0.75
		if (owner.reagents.has_reagent("aphro+"))
			deltaResist *= 0.5

	//Antag resistance
	//cultists are already brainwashed by their god
	if(iscultist(owner))
		deltaResist *= 1.3
	else if (is_servant_of_ratvar(owner))
		deltaResist *= 1.3
	//antags should be able to resist, so they can do their other objectives. This chem does frustrate them, but they've all the tools to break free when an oportunity presents itself.
	else if (owner.mind.assigned_role in GLOB.antagonists)
		deltaResist *= 1.2

	//role resistance
	//Chaplains are already brainwashed by their god
	if(owner.mind.assigned_role == "Chaplain")
		deltaResist *= 1.2
	//Command staff has authority,
	if(owner.mind.assigned_role in GLOB.command_positions)
		deltaResist *= 1.1
	//Chemists should be familiar with drug effects
	if(owner.mind.assigned_role == "Chemist")
		deltaResist *= 1.2

	//Happiness resistance
	//Your Thralls are like pets, you need to keep them happy.
	if(owner.nutrition < 300)
		deltaResist += (300-owner.nutrition)/6
	if(owner.health < 100)//Harming your thrall will make them rebel harder.
		deltaResist *= ((120-owner.health)/100)+1
	//if(owner.mood.mood) //datum/component/mood TO ADD in FERMICHEM 2
	//Add cold/hot, oxygen, sanity, happiness? (happiness might be moot, since the mood effects are so strong)
	//Mental health could play a role too in the other direction

	//If you've a collar, you get a sense of pride
	if(istype(M.wear_neck, /obj/item/clothing/neck/petcollar))
		deltaResist *= 0.5
	if(M.has_trait(TRAIT_MINDSHIELD))
		deltaResist += 5//even faster!

	message_admins("Enthrall processing for [M]: enthrallTally: [enthrallTally], resistanceTally: [resistanceTally], delta: [deltaResist]")
	return

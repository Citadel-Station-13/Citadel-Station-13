/datum/status_effect/chem/SGDF
	id = "SGDF"
	var/mob/living/fermi_Clone
	alert_type = null

/*
/obj/screen/alert/status_effect/SDGF
	name = "SDGF"
	desc = "You've cloned yourself! How cute."
	icon_state = "SDGF"
*/

/datum/status_effect/chem/SGDF/on_apply()
	message_admins("SGDF status appied")
	var/typepath = owner.type
	fermi_Clone = new typepath(owner.loc)
	var/mob/living/carbon/M = owner
	var/mob/living/carbon/C = fermi_Clone

	//fermi_Clone = new typepath(get_turf(M))
	//var/mob/living/carbon/C = fermi_Clone
	//var/mob/living/carbon/SM = fermi_Gclone

	if(istype(C) && istype(M))
		C.real_name = M.real_name
		M.dna.transfer_identity(C, transfer_SE=1)
		C.updateappearance(mutcolor_update=1)
	return ..()

/datum/status_effect/chem/SGDF/tick()
	//message_admins("SDGF ticking")
	if(owner.stat == DEAD)
		//message_admins("SGDF status swapping")
		if(fermi_Clone && fermi_Clone.stat != DEAD)
			if(owner.mind)
				owner.mind.transfer_to(fermi_Clone)
				owner.visible_message("<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
				fermi_Clone.visible_message("<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
				fermi_Clone = null
				owner.remove_status_effect(src)
		//	to_chat(owner, "<span class='notice'>[linked_extract] desperately tries to move your soul to a living body, but can't find one!</span>")
	..()

/datum/status_effect/chem/BElarger
	id = "BElarger"
	alert_type = null
	//var/list/items = list()
	//var/items = o.get_contents()

//mob/living/carbon/M = M tried, no dice
//owner, tried, no dice
/datum/status_effect/chem/BElarger/on_apply(mob/living/carbon/human/H)//Removes clothes, they're too small to contain you. You belong to space now.
	var/mob/living/carbon/human/o = owner
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	//message_admins("BElarge started!")

	if(o.w_uniform || o.wear_suit)
		to_chat(o, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling breasts! Unless you manage to reduce the size of your breasts, there's no way you're going to be able to put anything on over these melons..!</b></span>")
		o.visible_message("<span class='boldnotice'>[o]'s chest suddenly bursts forth, ripping their clothes off!'</span>")
	else
		to_chat(o, "<span class='notice'>Your bountiful bosom is so rich with mass, you seriously doubt you'll be able to fit any clothes over it.</b></span>")
	return ..()

/datum/status_effect/chem/BElarger/tick(mob/living/carbon/human/H)//If you try to wear clothes, you fail. Slows you down if you're comically huge
	var/mob/living/carbon/human/o = owner
	var/obj/item/organ/genital/breasts/B = o.getorganslot("breasts")
	if(!B)
		o.remove_movespeed_modifier("megamilk")
		o.next_move_modifier = 1
		owner.remove_status_effect(src)
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			to_chat(owner, "<span class='warning'>Your enormous breasts are way too large to fit anything over them!</b></span>")
	//message_admins("BElarge tick!")
	/*
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W)
		//items |= owner.get_equipped_items(TRUE)

		//owner.dropItemToGround(owner.wear_suit)
		//owner.dropItemToGround(owner.w_uniform)
	*/
	switch(round(B.cached_size))
		if(9)
			if (!(B.breast_sizes[B.prev_size] == B.size))
				o.remove_movespeed_modifier("megamilk")
				o.next_move_modifier = 1
		if(10 to INFINITY)
			if (!(B.breast_sizes[B.prev_size] == B.size))
				to_chat(H, "<span class='warning'>Your indulgent busom is so substantial, it's affecting your movements!</b></span>")
				o.add_movespeed_modifier("megamilk", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = (round(B.cached_size) - 8))
				o.next_move_modifier = (round(B.cached_size) - 8)
	..()

/datum/status_effect/chem/BElarger/on_remove(mob/living/carbon/M)
	owner.remove_movespeed_modifier("megamilk")
	owner.next_move_modifier = 1


/datum/status_effect/chem/PElarger
	id = "PElarger"
	alert_type = null

/datum/status_effect/chem/PElarger/on_apply(mob/living/carbon/human/H)//Removes clothes, they're too small to contain you. You belong to space now.
	message_admins("PElarge started!")
	var/mob/living/carbon/human/o = owner
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	if(o.w_uniform || o.wear_suit)
		to_chat(o, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling pecker! Unless you manage to reduce the size of your emancipated trouser snake, there's no way you're going to be able to put anything on over this girth..!</b></span>")
		owner.visible_message("<span class='boldnotice'>[o]'s schlong suddenly bursts forth, ripping their clothes off!'</span>")
	else
		to_chat(o, "<span class='notice'>Your emancipated trouser snake is so ripe with girth, you seriously doubt you'll be able to fit any clothes over it.</b></span>")
	return ..()


/datum/status_effect/chem/PElarger/tick(mob/living/carbon/M)
	var/mob/living/carbon/human/o = owner
	var/obj/item/organ/genital/penis/P = o.getorganslot("penis")
	if(!P)
		o.remove_movespeed_modifier("hugedick")
		o.next_move_modifier = 1
		owner.remove_status_effect(src)
	message_admins("PElarge tick!")
	var/items = o.get_contents()
	for(var/obj/item/W in items)
		if(W == o.w_uniform || W == o.wear_suit)
			o.dropItemToGround(W, TRUE)
			playsound(o.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			to_chat(owner, "<span class='warning'>Your enormous package is way to large to fit anything over!</b></span>")
	switch(round(P.cached_length))
		if(11)
			if (!(P.prev_size == P.size))
				to_chat(o, "<span class='warning'>Your rascally willy has become a more managable size, liberating your movements.</b></span>")
				o.remove_movespeed_modifier("hugedick")
				o.next_move_modifier = 1
		if(12 to INFINITY)
			if (!(P.prev_size == P.size))
				to_chat(o, "<span class='warning'>Your indulgent johnson is so substantial, it's affecting your movements!</b></span>")
				o.add_movespeed_modifier("hugedick", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = (P.length - 11.1))
				o.next_move_modifier = (round(P.length) - 11)
	..()


/*//////////////////////////////////////////
		Mind control functions
///////////////////////////////////////////
*/

/datum/status_effect/chem/enthrall
	id = "enthrall"
	alert_type = null
	var/mob/living/E //E for enchanter
	//var/mob/living/V = list() //V for victims
	var/enthrallTally = 1 //Keeps track of the enthralling process
	var/resistanceTally = 0 //Keeps track of the resistance
	var/deltaResist //The total resistance added per resist click
	//var/deltaEnthrall //currently unused (i think)
	var/phase = 1 //-1: resisted state, due to be removed.0: sleeper agent, no effects unless triggered 1: initial, 2: 2nd stage - more commands, 3rd: fully enthralled, 4th Mindbroken
	var/status = null //status effects
	var/statusStrength = 0 //strength of status effect
	var/mob/living/master //Enchanter's person
	var/enthrallID //Enchanter's ckey
	var/enthrallGender //Use master or mistress
	//var/mob/living/master == null
	var/mental_capacity //Higher it is, lower the cooldown on commands, capacity reduces with resistance.
	//var/mental_cost //Current cost of custom triggers
	//var/mindbroken = FALSE //Not sure I use this, replaced with phase 4
	var/datum/weakref/redirect_component1 //resistance
	var/datum/weakref/redirect_component2 //say
	var/distancelist = list(4,3,2,1.5,1,0.8,0.6,0.4,0.2) //Distance multipliers
	var/withdrawal = FALSE //withdrawl
	var/withdrawalTick = 0 //counts how long withdrawl is going on for
	var/list/customTriggers = list() //the list of custom triggers (maybe have to split into two)
	var/cooldown = 0

/datum/status_effect/chem/enthrall/on_apply(mob/living/carbon/M)
	if(M.key == enthrallID)
		owner.remove_status_effect(src)//This shouldn't happen, but just in case
	redirect_component1 = WEAKREF(owner.AddComponent(/datum/component/redirect, list(COMSIG_LIVING_RESIST = CALLBACK(src, .proc/owner_resist)))) //Do resistance calc if resist is pressed#
	redirect_component2 = WEAKREF(owner.AddComponent(/datum/component/redirect, list(COMSIG_LIVING_SAY = CALLBACK(src, .proc/owner_say)))) //Do resistance calc if resist is pressed
	//Might need to add redirect component for listening too.
	var/obj/item/organ/brain/B = M.getorganslot(ORGAN_SLOT_BRAIN) //It's their brain!
	mental_capacity = 500 - B.get_brain_damage()
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "enthrall", /datum/mood_event/enthrall)

/datum/status_effect/chem/enthrall/tick(mob/living/carbon/M)

	//chem calculations
	if (owner.reagents.has_reagent("MKUltra"))
		if (phase >= 2)
			enthrallTally += phase
	else
		if (phase < 3)
			deltaResist += 5//If you've no chem, then you break out quickly
			if(prob(20))
				to_chat(owner, "<span class='notice'><i>Your mind starts to restore some of it's clarity as you feel the effects of the drug wain.</i></span>")
	if (mental_capacity <= 500 || phase == 4)
		if (owner.reagents.has_reagent("mannitol"))
			mental_capacity += 1
		if (owner.reagents.has_reagent("neurine"))
			mental_capacity += 2

	//mindshield check
	if(M.has_trait(TRAIT_MINDSHIELD))
		resistanceTally += 5
		if(prob(20))
			to_chat(owner, "<span class='notice'><i>You feel lucidity returning to your mind as the mindshield buzzes, attempting to return your brain to normal function.</i></span>")

	//phase specific events
	switch(phase)
		if(-1)//fully removed
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "enthrall")
			owner.remove_status_effect(src)
		else if(0)// sleeper agent
			return
		else if(1)//Initial enthrallment
			if (enthrallTally > 100)
				phase += 1
				mental_capacity -= resistanceTally//leftover resistance per step is taken away from mental_capacity.
				enthrallTally = 0
				to_chat(owner, "<span class='notice'><i>Your conciousness slips, as you sink deeper into trance.</i></span>")
			else if (resistanceTally > 100)
				enthrallTally *= 0.5
				phase = -1
				resistanceTally = 0
				to_chat(owner, "<span class='notice'><i>You break free of the influence in your mind, your thoughts suddenly turning lucid!</i></span>")
				owner.remove_status_effect(src) //If resisted in phase 1, effect is removed.
			if(prob(10))
				to_chat(owner, "<span class='notice'><i>[pick("It feels so good to listen to [master.name].", "You can't keep your eyes off [master.name].", "[master.name]'s voice is making you feel so sleepy.",  "You feel so comfortable with [master.name]", "[master.name] is so sexy and dominant, it feels right to obey them.")].</i></span>")
		else if (2) //partially enthralled
			if (enthrallTally > 150)
				phase += 1
				mental_capacity -= resistanceTally//leftover resistance per step is taken away from mental_capacity.
				enthrallTally = 0
				to_chat(owner, "<span class='notice'><i>Your mind gives, eagerly obeying and serving [master.name].</i></span>")
				to_chat(owner, "<span class='warning'><i>You are now fully enthralled to [master.name], and eager to follow their commands. However you find that in your intoxicated state you are much less likely to resort to violence, unless it is to defend your [enthrallGender]. Equally you are unable to commit suicide, even if ordered to, as you cannot server your [enthrallGender] in death. </i></span>")//If people start using this as an excuse to be violent I'll just make them all pacifists so it's not OP.
			else if (resistanceTally > 150)
				enthrallTally *= 0.5
				phase -= 1
				resistanceTally = 0
				to_chat(owner, "<span class='notice'><i>You manage to shake some of the entrancement from your addled mind, however you can still feel yourself drawn towards [master.name].</i></span>")
				//owner.remove_status_effect(src) //If resisted in phase 1, effect is removed. Not at the moment,
		else if (3)//fully entranced
			if (resistanceTally >= 250 && withdrawalTick >= 150)
				enthrallTally = 0
				phase -= 1
				resistanceTally = 0
				to_chat(owner, "<span class='notice'><i>The separation from you [enthrallGender] sparks a small flame of resistance in yourself, as your mind slowly starts to return to normal.</i></span>")
		else if (4) //mindbroken
			if (mental_capacity >= 499 || owner.getBrainLoss() >=20 || !owner.reagents.has_reagent("MKUltra"))
				phase = 2
				mental_capacity = 500
				customTriggers = list()
				to_chat(owner, "<span class='notice'><i>Your mind starts to heal, fixing the damage caused by the massive ammounts of chem injected into your system earlier, .</i></span>")
				M.slurring = 0
				M.confused = 0
			else
				return//If you break the mind of someone, you can't use status effects on them.


	//distance calculations
	switch(get_dist(master, owner))
		if(0 to 8)//If the enchanter is within range, increase enthrallTally, remove withdrawal subproc and undo withdrawal effects.
			enthrallTally += distancelist[get_dist(master, owner)+1]
			withdrawal = FALSE
			if(withdrawalTick > 0)
				withdrawalTick -= 2
			M.hallucination = max(0, M.hallucination - 2)
			M.stuttering = max(0, M.stuttering - 2)
			M.jitteriness = max(0, M.jitteriness - 2)
		if(9 to INFINITY)//If
			withdrawal = TRUE

	//Withdrawal subproc:
	if (withdrawal == TRUE)//Your minions are really REALLY needy.
		switch(withdrawalTick)//denial
			if(20 to 40)//Gives wiggle room, so you're not SUPER needy
				if(prob(10))
					to_chat(owner, "You're starting to miss your [enthrallGender].")
				if(prob(10))
					owner.adjustBrainLoss(0.5)
					to_chat(owner, "They'll surely be back soon") //denial
			if(41)
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing1", /datum/mood_event/enthrallmissing1)
			if(42 to 65)//barganing
				if(prob(10))
					to_chat(owner, "They are coming back, right...?")
					owner.adjustBrainLoss(1)
				if(prob(20))
					to_chat(owner, "I just need to be a good pet for [enthrallGender], they'll surely return if I'm a good pet.")
					owner.adjustBrainLoss(-2)
			if(66)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing1") //Why does this not work?
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing2", /datum/mood_event/enthrallmissing2)
				owner.stuttering += 20
				owner.jitteriness += 20
			if(67 to 90) //anger
				if(prob(30))
					addtimer(CALLBACK(M, /mob/verb/a_intent_change, INTENT_HARM), 2)
					addtimer(CALLBACK(M, /mob/proc/click_random_mob), 2)
					to_chat(owner, "You suddenly lash out at the station in anger for it keeping you away from your [enthrallGender].")
			if(90)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing2") //Why does this not work?
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing3", /datum/mood_event/enthrallmissing3)
				to_chat(owner, "<span class='warning'><i>You need to find your [enthrallGender] at all costs, you can't hold yourself back anymore.</i></span>")
			if(91 to 120)//depression
				if(prob(20))
					owner.adjustBrainLoss(1)
					owner.stuttering += 2
					owner.jitteriness += 2
				if(prob(25))
					M.hallucination += 2
			if(121)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "EnthMissing3")
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "EnthMissing4", /datum/mood_event/enthrallmissing4)
				to_chat(owner, "<span class='warning'><i>You can hardly find the strength to continue without your [enthrallGender].</i></span>")
			if(120 to 140) //depression
				if(prob(25))
					owner.SetStun(20, 0)
					owner.emote("cry")//does this exist?
					to_chat(owner, "You're unable to hold back your tears, suddenly sobbing as the desire to see your [enthrallGender] oncemore overwhelms you.")
					owner.adjustBrainLoss(2)
					owner.stuttering += 2
					owner.jitteriness += 2
				if(prob(10))
					deltaResist += 5
			if(140 to INFINITY) //acceptance
				if(prob(20))
					deltaResist += 5
					if(prob(20))
						to_chat(owner, "Maybe you'll be okay without your [enthrallGender].")
				if(prob(10))
					owner.adjustBrainLoss(1)
					M.hallucination += 5

		withdrawalTick++

	//Status subproc - statuses given to you from your Master
	//currently 3 statuses; antiresist -if you press resist, increases your enthrallment instead, HEAL - which slowly heals the pet, CHARGE - which breifly increases speed, PACIFY - makes pet a pacifist.
	if (!status == null)

		switch(status)
			if("Antiresist")
				if (statusStrength == 0)
					status = null
					to_chat(owner, "You feel able to resist oncemore.")
				else
					statusStrength -= 1

			else if("heal")
				if (statusStrength == 0)
					status = null
					to_chat(owner, "You finish licking your wounds.")
				else
					statusStrength -= 1
					owner.heal_overall_damage(1, 1, 0, FALSE, FALSE)
					cooldown += 1 //Cooldown doesn't process till status is done

			else if("charge")
				owner.add_trait(TRAIT_GOTTAGOFAST, "MKUltra")
				status = "charged"
				to_chat(owner, "Your [enthrallGender]'s order fills you with a burst of speed!")

			else if ("charged")
				if (statusStrength == 0)
					status = null
					owner.remove_trait(TRAIT_GOTTAGOFAST, "MKUltra")
					owner.Knockdown(30)
					to_chat(owner, "Your body gives out as the adrenaline in your system runs out.")
				else
					statusStrength -= 1
					cooldown += 1 //Cooldown doesn't process till status is done

			else if ("pacify")
				owner.add_trait(TRAIT_PACIFISM, "MKUltra")
				status = null

			//Truth serum?
			//adrenals?
			//M.next_move_modifier *= 0.5
			//M.adjustStaminaLoss(-5*REM)

	//final tidying
	resistanceTally  += deltaResist
	deltaResist = 0
	if (cooldown > 0)
		cooldown -= (1 + (mental_capacity/1000 ))
	else
		to_chat(master, "<span class='notice'><i>Your pet [owner.name] appears to have finished internalising your last command.</i></span>")

//Check for proximity of master DONE
//Place triggerreacts here - create a dictionary of triggerword and effect.
//message enthrallID "name appears to have mentally processed their last command."

/datum/status_effect/chem/enthrall/on_remove(mob/living/carbon/M)
	qdel(redirect_component1.resolve())
	redirect_component1 = null
	qdel(redirect_component2.resolve())
	redirect_component2 = null

/*
/datum/status_effect/chem/enthrall/mob/say(message, bubble_type, var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
		    if(enthrallID.name in message || enthrallID.first_name in message)
		        return
		    else
		        . = ..()
*/

/datum/status_effect/chem/enthrall/proc/on_hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	var/mob/living/carbon/C = owner
	for (var/trigger in customTriggers)
		if (trigger == message)//if trigger1 is the message

			//Speak (Forces player to talk)
			if (customTriggers[trigger][1] == "speak")//trigger2
				C.visible_message("<span class='notice'>Your mouth moves on it's own, before you can even catch it. Though you find yourself fully believing in the validity of what you just said and don't think to question it.</span>")
				(C.say(customTriggers[trigger][2]))//trigger3


			//Echo (repeats message!)
			else if (customTriggers[trigger][1] == "echo")//trigger2
				(to_chat(owner, customTriggers[trigger][2]))//trigger3

			//Shocking truth!
			else if (customTriggers[trigger] == "shock")
				if (C.canbearoused)
					C.electrocute_act(10, src, 1, FALSE, FALSE, FALSE, TRUE)//I've no idea how strong this is
					C.adjustArousalLoss(5)
					to_chat(owner, "<span class='notice'><i>Your muscles seize up, then start spasming wildy!</i></span>")
				else
					C.electrocute_act(15, src, 1, FALSE, FALSE, FALSE, TRUE)//To make up for the lack of effect

			//wah intensifies
			else if (customTriggers[trigger][1] == "cum")//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				if (C.canbearoused)
					if (C.getArousalLoss() > 80)
						C.mob_climax(forced_climax=TRUE)
					else
						C.adjustArousalLoss(10)
				else
					C.throw_at(get_step_towards(speaker,C), 3, 1) //cut this if it's too hard to get working

			//kneel (knockdown)
			else if (customTriggers[trigger][1] == "kneel")//as close to kneeling as you can get, I suppose.
				C.Knockdown(20)

			//strip (some) clothes
			else if (customTriggers[trigger][1] == "strip")//This wasn't meant to just be a lewd thing oops
				var/mob/living/carbon/human/o = owner
				var/items = o.get_contents()
				for(var/obj/item/W in items)
					if(W == o.w_uniform || W == o.wear_suit)
						o.dropItemToGround(W, TRUE)
				C.visible_message("<span class='notice'>You feel compelled to strip your clothes.</span>")

		//add more fun stuff!


	return
/*
/datum/status_effect/chem/enthrall/proc/owner_withdrawal(mob/living/carbon/M)
	//3 stages, each getting worse
*/
/datum/status_effect/chem/enthrall/proc/owner_resist(mob/living/carbon/M)
	if (status == "Sleeper" || phase == 0)
		return
	else if (phase == 4)
		to_chat(owner, "<span class='notice'><i>Your mind is too far gone to even entertain the thought of resisting.</i></span>")
		return
	else if (phase == 3 || withdrawal == FALSE)
		to_chat(owner, "<span class='notice'><i>The presence of your [enthrallGender] fully captures the horizon of your mind, removing any thoughts of resistance.</i></span>")
		return
	else if (status == "Antiresist")//If ordered to not resist; resisting while ordered to not makes it last longer, and increases the rate in which you are enthralled.
		if (statusStrength > 0)
			to_chat(owner, "<span class='notice'><i>The order from your [enthrallGender] to give in is conflicting with your attempt to resist, drawing you deeper into trance.</i></span>")
			statusStrength += 1
			enthrallTally += 1
			return
		else
			status = null
	if (deltaResist != 0)//So you can't spam it, you get one deltaResistance per tick.
		deltaResist += 0.1 //Though I commend your spamming efforts.
		return

	if(prob(10))
		M.emote("me",1,"squints, shaking their head for a moment.")//shows that you're trying to resist sometimes
	to_chat(owner, "You attempt to shake the mental cobwebs from your mind!")
	//base resistance
	if (M.canbearoused)
		deltaResist*= ((100 - M.arousalloss/100)/100)//more aroused you are, the weaker resistance you can give
	else
		deltaResist *= 0.2
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
		deltaResist *= 2
	else if (is_servant_of_ratvar(owner))
		deltaResist *= 2
	//antags should be able to resist, so they can do their other objectives. This chem does frustrate them, but they've all the tools to break free when an oportunity presents itself.
	else if (owner.mind.assigned_role in GLOB.antagonists)
		deltaResist *= 1.8

	//role resistance
	//Chaplains are already brainwashed by their god
	if(owner.mind.assigned_role == "Chaplain")
		deltaResist *= 1.5
	//Command staff has authority,
	if(owner.mind.assigned_role in GLOB.command_positions)
		deltaResist *= 1.4
		//if(owner.has_status == "sub"); power_multiplier *= 0.8 //for skylar //I'm kidding <3
	//Chemists should be familiar with drug effects
	if(owner.mind.assigned_role == "Chemist")
		deltaResist *= 1.3

	//Happiness resistance
	//Your Thralls are like pets, you need to keep them happy.
	if(owner.nutrition < 250)
		deltaResist += (250-owner.nutrition)/100
	if(owner.health < 100)//Harming your thrall will make them rebel harder.
		deltaResist *= ((120-owner.health)/100)+1
	//Add cold/hot, oxygen, sanity, happiness? (happiness might be moot, since the mood effects are so strong)
	//Mental health could play a role too in the other direction

	//If master gives you a collar, you get a sense of pride
	if(istype(M.wear_neck, /obj/item/clothing/neck/petcollar))
		deltaResist *= 0.5

	if(owner.has_trait(TRAIT_CROCRIN_IMMUNE) || !owner.canbearoused)
		deltaResist *= 0.75//Immune/asexual players are immune to the arousal based multiplier, this is to offset that so they can still be affected. Their unfamiliarty with desire makes it more on them.

	if (deltaResist>0)//just in case
		deltaResist /= phase//later phases require more resistance

/datum/status_effect/chem/enthrall/proc/owner_say(message) //I can only hope this works
	var/static/regex/owner_words = regex("[master.real_name]|[master.first_name()]")
	if(findtext(message, owner_words))
		message = replacetext(lowertext(message), lowertext(master.real_name), "[enthrallGender]")
		message = replacetext(lowertext(message), lowertext(master.name), "[enthrallGender]")
	return message
/*
/datum/status_effect/chem/OwO
	id = "OwO"

/datum/status_effect/chem/PElarger/tick(message)
	if(copytext(message, 1, 2) != "*")
		message = replacetext(message, "ne", "nye")
		message = replacetext(message, "nu", "nyu")
		message = replacetext(message, "na", "nya")
		message = replacetext(message, "no", "nyo")
		message = replacetext(message, "ove", "uv")
		message = replacetext(message, "ove", "uv")
		message = replacetext(message, "th", "ff")
		message = replacetext(message, "l", "w")
		message = replacetext(message, "r", "w")
		if(prob(20))
			message = replacetext(message, ".", "OwO.")
		else if(prob(30))
			message = replacetext(message, ".", "uwu.")
		message = lowertext(message)
*/
/*Doesn't work
/datum/status_effect/chem/SDGF/candidates
	id = "SGDFCandi"
	var/mob/living/fermi_Clone
	var/list/candies = list()

/datum/status_effect/chem/SDGF/candidates/on_apply()
	candies = pollGhostCandidates("Do you want to play as a clone and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 300) // see poll_ignore.dm, should allow admins to ban greifers or bullies
	return ..()
*/

/*
//////////////////////////////////////
Oversensitive

	Slightly more Noticable.
	Slightly more Resistant
	Progresses faster.
	Less transmittable
	Intense Level.
	Low severity
Bonus
	Increases arousal.
	Makes the user a bit needy.
//////////////////////////////////////
*/

/datum/symptom/oversensitive

	name = "Oversensitive"
	stealth = -1
	resistance = 1
	stage_speed = 2
	transmittable = -1
	level = 4
	severity = 1
	var/aroused_thoughts = list("You feel like love is in the air.","You feel frisky.", "You're having trouble suppressing your urges.", "You feel in the mood.","You feel a bit hot.","You feel horny.","You feel strong sexual urges.")

/datum/symptom/oversensitive/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob

		switch(A.stage)
			if(1)
				M.emote("blush")
			if(2)
				M.emote("blush")
				M.adjustArousalLoss(1)
			if(3)
				M.emote(pick("blush","drool"))
				M.adjustArousalLoss(2)
			if(4)
				M.emote(pick("blush","drool","moan"))
				to_chat(M,"<span class='love'>[pick(aroused_thoughts)]</span>")
				M.adjustArousalLoss(3)
			else
				M.emote(pick("blush","drool","moan"))
				to_chat(M,"<span class='love'>[pick(aroused_thoughts)]</span>")
				M.adjustArousalLoss(6)
	return

/datum/symptom/oversensitive/Start(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	to_chat(M,"<span class='love'>You feel your loins tingle slightly...</span>")
	return

/datum/symptom/oversensitive/End(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	to_chat(M,"<span class='notice'>You feel your loins calm down.</span>")
	return


/*
//////////////////////////////////////
Desensitize

	Less Noticable.
	Slightly Less Resistant
	Progresses faster.
	More transmittable
	Intense Level.
	Low severity
Bonus
	Decreases arousal.
	Makes the user a unable to feel physical sensations properly.
//////////////////////////////////////
*/

/datum/symptom/desensitize

	name = "Desensitize"
	stealth = 2
	resistance = -1
	stage_speed = 2
	transmittable = 2
	level = 4
	severity = 1
	var/uncomfortable_thoughts = list("You feel a bit uncomfortable.","You feel like your clothes don't fit properly.","Your skin feels oddly stiff.")
	var/discouraged_thoughts = list("You feel numbed.","Your skin feels like soft plastic.","You can't feel any pain.","You feel like nothing is real anymore.")

/datum/symptom/desensitize/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob

		switch(A.stage)
			if(1)
				to_chat(M,"<span class='notice'>[pick(uncomfortable_thoughts)]</span>")
			if(2)
				M.adjustArousalLoss(-1)
				to_chat(M,"<span class='notice'>[pick(uncomfortable_thoughts)]</span>")
			if(3)
				M.adjustArousalLoss(-2)
				to_chat(M,"<span class='notice'>[pick(uncomfortable_thoughts)]</span>")
			if(4)
				to_chat(M,"<span class='notice'>[pick(discouraged_thoughts)]</span>")
				M.adjustArousalLoss(-3)
			else
				to_chat(M,"<span class='notice'>[pick(discouraged_thoughts)]</span>")
				M.adjustArousalLoss(-6)
	return

/datum/symptom/desensitize/Start(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	to_chat(M,"<span class='notice'>You feel strangely uncomfortable.</span>")
	return

/datum/symptom/desensitize/End(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	to_chat(M,"<span class='notice'>You feel less numb again.</span>")
	return


/*
//////////////////////////////////////
Extendong

	Obviously noticable
	Increases Resistance
	Slightly faster (quickshot, *laughtrack noises*)
	Lowers transmission
	Pretty low Level.
	Not severe
Bonus
	Contrary to popular belief, this makes all genitals increase in size
	The bane of tiny traps
//////////////////////////////////////
*/

/datum/symptom/macro_genitals

	name = "Extendong"
	stealth = -3
	resistance = 2
	stage_speed = 1
	transmittable = -2
	level = 2
	severity = 1
	var/big_thoughts = list("You feel a bit stiff.","Your loins itch.","You feel like you don't want to wear clothing.")


/datum/symptom/macro_genitals/proc/grow_genitalia(mob/living/carbon/human/M)
	if(M.has_penis())
		var/obj/item/organ/genital/penis/O = M.getorganslot("penis")
		if(O.length < COCK_SIZE_MAX) //Couldn't find a macro or anything for the max size of a dong, so hardcoded, sadly.
			O.length = O.length + 1
			O.update()
			to_chat(M,"<span class='warning'>[pick("You feel your cock grow.","Your penis twitches and grows larger.","You feel your dong extend.")]</span>")
/* REMOVING UNTIL GENITAL FIX PR IS MERGED
	if(M.has_breasts())
		var/obj/item/organ/genital/breasts/O = M.getorganslot("breasts")
		var/size = breasts_size_list.find(O.size)
			O.size = breasts_size_list(size + 1)
			O.update()
			to_chat(M,"<span class='warning'>[pick("Your boobs suddenly gain several cupsizes!","You breasts rapidly expand outward.","You feel your chest grow much larger.")]</span>")
*/
	return

/datum/symptom/macro_genitals/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		//I think genitalia code is implemented on human level only, so let's not mess up
		var/mob/living/carbon/human/M = A.affected_mob
		if(M)
			switch(A.stage)
					to_chat(M,"<span class='notice'>[pick(big_thoughts)]</span>")
				else
					grow_genitalia(M)
	return



/*
//////////////////////////////////////

	Obviously noticable
	Increases Resistance
	Slightly faster (quickshot, *laughtrack noises*)
	Lowers transmission
	Pretty low Level.
	Not severe
Bonus
	Shrinks genitalia
	Most vile disease, brings ruin to rounds of extendong
//////////////////////////////////////
*/

/datum/symptom/micro_genitals

	name = "Micro genitalia"
	stealth = -3
	resistance = 2
	stage_speed = 1
	transmittable = -2
	level = 2
	severity = 1
	var/small_thoughts = list("You feel a bit stiff.","Your loins itch.","You feel like moving is a bit easier.")


/datum/symptom/micro_genitals/proc/shrink(mob/living/carbon/human/M)
	if(M.has_penis())
		var/obj/item/organ/genital/penis/O = M.getorganslot("penis")
		if(O.length > COCK_SIZE_MIN) //Couldn't find a macro or anything for the max size of a dong, so hardcoded, sadly.
			O.length = O.length - 1
			O.update()
			to_chat(M,"<span class='warning'>[pick("Your dick begins shrinking.","Suddenly your dick becomes smaller!","Your cock is rapidly disappearing.")]</span>")
/* REMOVING UNTIL GENITAL FIX PR IS MERGED
	if(M.has_breasts())
		var/obj/item/organ/genital/breasts/O = M.getorganslot("breasts")
		var/size = breasts_size_list.find(O.size)
		if(size != breasts_size_list[1]) //This should be the smallest boob size
			O.size = breasts_size_list(size - 1)
			O.update()
			to_chat(M,"<span class='warning'>[pick("You feel lighter, as you lose several cupsizes.","Your chest shrinks rapidly!","Your boobs become much smaller.")]</span>")
*/
	return



/datum/symptom/micro_genitals/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		//I think genitalia code is implemented on human level only, so let's not mess up
		var/mob/living/carbon/human/M = A.affected_mob
		if(M)
			switch(A.stage)
					to_chat(M,"<span class='notice'>[pick(small_thoughts)]</span>")
				else
					shrink(M)
	return

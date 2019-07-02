/datum/mutation/human/antenna
	name = "Antenna"
	desc = "The affected person sprouts an antenna. This is known to allow them to access common radio channels passively."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>You feel an antenna sprout from your forehead.</span>"
	text_lose_indication = "<span class='notice'>Your antenna shrinks back down.</span>"
	instability = 5
	difficulty = 8
	var/obj/item/implant/radio/antenna/linked_radio

/obj/item/implant/radio/antenna
	name = "internal antenna organ"
	desc = "The internal organ part of the antenna. Science has not yet given it a good name."
	icon = 'icons/obj/radio.dmi'//maybe make a unique sprite later. not important
	icon_state = "walkietalkie"

/obj/item/implant/radio/antenna/Initialize(mapload)
	..()
	radio.name = "internal antenna"

/datum/mutation/human/antenna/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	linked_radio = new(owner)
	linked_radio.implant(owner, null, TRUE, TRUE)

/datum/mutation/human/antenna/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	if(linked_radio)
		linked_radio.Destroy()

/datum/mutation/human/antenna/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "antenna", -FRONT_MUTATIONS_LAYER+1))//-MUTATIONS_LAYER+1

/datum/mutation/human/antenna/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/mindreader
	name = "Mind Reader"
	desc = "The affected person can look into the recent memories of others. Can cause headaches at high dna instability."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>You hear distant voices at the corners of your mind.</span>"
	text_lose_indication = "<span class='notice'>The distant voices fade.</span>"
	power = /obj/effect/proc_holder/spell/targeted/mindread
	instability = 35
	difficulty = 8
	locked = TRUE
	power_coeff = 1
	synchronizer_coeff = 1

/obj/effect/proc_holder/spell/targeted/mindread
	name = "Mindread"
	desc = "Read the target's mind."
	charge_max = 50
	range = 7
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_icon_state = "mindread"

/obj/effect/proc_holder/spell/targeted/mindread/cast(list/targets, mob/living/carbon/human/user = usr)
	for(var/mob/living/M in targets)
		if(istype(usr.get_item_by_slot(SLOT_HEAD), /obj/item/clothing/head/foilhat) || istype(M.get_item_by_slot(SLOT_HEAD), /obj/item/clothing/head/foilhat))
			to_chat(usr, "<span class='warning'>As you reach out with your mind, you're suddenly stopped by a vision of a massive tinfoil wall that streches beyond visible range. It seems you've been foiled.</span>")
			return
		if(M.stat == DEAD)
			to_chat(user, "<span class='boldnotice'>[M] is dead!</span>")
			return
		if(M.mind)
			var/dat = "<span class='boldnotice'>You plunge into [M]'s mind...</span>"
			if(prob(20 * GET_MUTATION_SYNCHRONIZER(associated_mutation)))
				to_chat(M, "<span class='danger'>You feel something foreign enter your mind.</span>")//chance to alert the read-ee
			var/list/recent_speech = list()
			var/list/say_log = list()
			var/log_source = M.logging
			for(var/log_type in log_source)//this whole loop puts the read-ee's say logs into say_log in an easy to access way
				var/nlog_type = text2num(log_type)
				if(nlog_type & LOG_SAY)
					var/list/reversed = log_source[log_type]
					if(islist(reversed))
						say_log = reverseRange(reversed.Copy())
						break
			if(LAZYLEN(say_log))
				for(var/spoken_memory in say_log)
					if(recent_speech.len >= 3)//up to 3 random lines of speech, favoring more recent speech
						break
					if(prob(50))
						recent_speech[spoken_memory] = say_log[spoken_memory]
			if(recent_speech.len)
				dat += "\nYou catch some drifting memories of their past conversations..."
				for(var/spoken_memory in recent_speech)
					dat += "\n[recent_speech[spoken_memory]]"
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				dat += "\nYou find that their intent is to [C.a_intent]..."
				var/datum/dna/the_dna = C.has_dna()
				if(the_dna && (!IS_GENETIC_MUTATION(associated_mutation) || IS_MUT_EMPOWERED(associated_mutation)))
					dat += "You uncover that their true identity is [the_dna.real_name]."
			dat += "</span>"
			to_chat(user, dat)
			if(IS_GENETIC_MUTATION(associated_mutation) && prob(GET_DNA_INSTABILITY(user.dna) * GET_MUTATION_SYNCHRONIZER(associated_mutation) * 0.3))
				user.confused += 3
				user.Dizzy(5)
				user.adjustBrainLoss(rand(5,10))
		else
			to_chat(user, "<span class='boldnotice'>You can't find a mind to read inside of [M].</span>")

/datum/mutation/human/mindreader/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "antenna", -FRONT_MUTATIONS_LAYER+1))

/datum/mutation/human/mindreader/get_visual_indicator()
	return visual_indicators[type][1]
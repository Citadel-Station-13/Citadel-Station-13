 //Fermichem!!
//Fun chems for all the family

/datum/reagent/fermi
	name = "Fermi" //This should never exist, but it does so that it can exist in the case of errors..
	taste_description	= "affection and love!"
	can_synth = FALSE
	value = 20
	impure_chem 			= /datum/reagent/impure/fermiTox // What chemical is metabolised with an inpure reaction
	inverse_chem_val 		= 0.25		// If the impurity is below 0.5, replace ALL of the chem with inverse_chemupon metabolising
	inverse_chem			= /datum/reagent/impure/fermiTox


//This should process fermichems to find out how pure they are and what effect to do.
/datum/reagent/fermi/on_mob_add(mob/living/carbon/M, amount)
	. = ..()

//When merging two fermichems, see above
/datum/reagent/fermi/on_merge(data, amount, mob/living/carbon/M, purity)//basically on_mob_add but for merging
	. = ..()


////////////////////////////////////////////////////////////////////////////////////////////////////
//										HATIMUIM
///////////////////////////////////////////////////////////////////////////////////////////////////
//Adds a heat upon your head, and tips their hat
//Also has a speech alteration effect when the hat is there
//Increase armour; 1 armour per 10u
//but if you OD it becomes negative.


/datum/reagent/fermi/hatmium //for hatterhat
	name = "Hat growth serium"
	description = "A strange substance that draws in a hat from the hat dimention."
	color = "#7c311a" // rgb: , 0, 255
	taste_description = "like jerky, whiskey and an off aftertaste of a crypt."
	metabolization_rate = 0.2
	overdose_threshold = 25
	chemical_flags = REAGENT_DONOTSPLIT
	pH = 4
	can_synth = TRUE


/datum/reagent/fermi/hatmium/on_mob_add(mob/living/carbon/human/M)
	. = ..()
	if(M.head)
		var/obj/item/W = M.head
		M.dropItemToGround(W, TRUE)
	var/hat = new /obj/item/clothing/head/hattip()
	M.equip_to_slot(hat, SLOT_HEAD, 1, 1)


/datum/reagent/fermi/hatmium/on_mob_life(mob/living/carbon/human/M)
	if(!istype(M.head, /obj/item/clothing/head/hattip))
		return ..()
	var/hatArmor = 0
	if(!overdosed)
		hatArmor = (cached_purity/10)
	else
		hatArmor = (cached_purity/10)
	if(hatArmor > 90)
		return ..()
	var/obj/item/W = M.head
	W.armor = W.armor.modifyAllRatings(hatArmor)
	..()

/datum/reagent/fermi/hatmium/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 5)
		new /obj/item/clothing/head/hattip(T)
	..()

////////////////////////////////////////////////////////////////////////////////////////////////////
//										FURRANIUM
///////////////////////////////////////////////////////////////////////////////////////////////////
//OwO whats this?
//Makes you nya and awoo
//At a certain amount of time in your system it gives you a fluffy tongue, if pure enough, it's permanent.

/datum/reagent/fermi/furranium
	name = "Furranium"
	description = "OwO whats this?"
	color = "#f9b9bc" // rgb: , 0, 255
	taste_description = "dewicious degenyewacy"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	inverse_chem_val 		= 0
	var/obj/item/organ/tongue/nT
	chemical_flags = REAGENT_DONOTSPLIT
	pH = 5
	var/obj/item/organ/tongue/T
	can_synth = TRUE

/datum/reagent/fermi/furranium/reaction_mob(mob/living/carbon/human/M, method=INJECT, reac_volume)
	if(method == INJECT)
		var/turf/T = get_turf(M)
		M.adjustOxyLoss(15)
		M.DefaultCombatKnockdown(50)
		M.Stun(50)
		M.emote("cough")
		var/obj/item/toy/plush/P = pick(subtypesof(/obj/item/toy/plush))
		new P(T)
		to_chat(M, "<span class='warning'>You feel a lump form in your throat, as you suddenly cough up what seems to be a hairball?</b></span>")
		var/list/seen = viewers(8, T)
		for(var/mob/S in seen)
			to_chat(S, "<span class='warning'>[M] suddenly coughs up a [P.name]!</b></span>")
		var/T2 = get_random_station_turf()
		P.throw_at(T2, 8, 1)
	..()

/datum/reagent/fermi/furranium/on_mob_life(mob/living/carbon/M)

	switch(current_cycle)
		if(1 to 9)
			if(prob(20))
				to_chat(M, "<span class='notice'>Your tongue feels... fluffy</span>")
		if(10 to 15)
			if(prob(10))
				to_chat(M, "You find yourself unable to supress the desire to meow!")
				M.emote("nya")
			if(prob(10))
				to_chat(M, "You find yourself unable to supress the desire to howl!")
				M.emote("awoo")
			if(prob(20))
				var/list/seen = viewers(5, get_turf(M))//Sound and sight checkers
				for(var/victim in seen)
					if((istype(victim, /mob/living/simple_animal/pet/)) || (victim == M) || (!isliving(victim)))
						seen = seen - victim
				if(LAZYLEN(seen))
					to_chat(M, "You notice [pick(seen)]'s bulge [pick("OwO!", "uwu!")]")
		if(16)
			T = M.getorganslot(ORGAN_SLOT_TONGUE)
			var/obj/item/organ/tongue/nT = new /obj/item/organ/tongue/fluffy
			T.Remove()
			nT.Insert(M)
			T.moveToNullspace()//To valhalla
			to_chat(M, "<span class='big warning'>Your tongue feels... weally fwuffy!!</span>")
		if(17 to INFINITY)
			if(prob(5))
				to_chat(M, "You find yourself unable to supress the desire to meow!")
				M.emote("nya")
			if(prob(5))
				to_chat(M, "You find yourself unable to supress the desire to howl!")
				M.emote("awoo")
			if(prob(5))
				var/list/seen = viewers(5, get_turf(M))//Sound and sight checkers
				for(var/victim in seen)
					if((istype(victim, /mob/living/simple_animal/pet/)) || (victim == M) || (!isliving(victim)))
						seen = seen - victim
				if(LAZYLEN(seen))
					to_chat(M, "You notice [pick(seen)]'s bulge [pick("OwO!", "uwu!")]")
	..()

/datum/reagent/fermi/furranium/on_mob_delete(mob/living/carbon/M)
	if(cached_purity < 0.95)//Only permanent if you're a good chemist.
		nT = M.getorganslot(ORGAN_SLOT_TONGUE)
		nT.Remove()
		qdel(nT)
		T.Insert(M)
		to_chat(M, "<span class='notice'>You feel your tongue.... unfluffify...?</span>")
		M.say("Pleh!")
	else
		log_game("FERMICHEM: [M] ckey: [M.key]'s tongue has been made permanent")


///////////////////////////////////////////////////////////////////////////////////////////////
//Nanite removal
//Writen by Trilby!! Embellsished a little by me.

/datum/reagent/fermi/nanite_b_gone
	name = "Nanite bane"
	description = "A stablised EMP that is highly volatile, shocking small nano machines that will kill them off at a rapid rate in a patient's system."
	color = "#708f8f"
	overdose_threshold = 15
	impure_chem 			= /datum/reagent/fermi/nanite_b_goneTox //If you make an inpure chem, it stalls growth
	inverse_chem_val 		= 0.25
	inverse_chem		= /datum/reagent/fermi/nanite_b_goneTox //At really impure vols, it just becomes 100% inverse
	taste_description = "what can only be described as licking a battery."
	pH = 9
	value = 90
	can_synth = FALSE
	var/react_objs = list()

/datum/reagent/fermi/nanite_b_gone/on_mob_life(mob/living/carbon/C)
	var/datum/component/nanites/N = C.GetComponent(/datum/component/nanites)
	if(isnull(N))
		return ..()
	N.nanite_volume += -cached_purity*5//0.5 seems to be the default to me, so it'll neuter them.
	..()

/datum/reagent/fermi/nanite_b_gone/overdose_process(mob/living/carbon/C)
	//var/component/nanites/N = M.GetComponent(/datum/component/nanites)
	var/datum/component/nanites/N = C.GetComponent(/datum/component/nanites)
	if(prob(5))
		to_chat(C, "<span class='warning'>The residual voltage from the nanites causes you to seize up!</b></span>")
		C.electrocute_act(10, (get_turf(C)), 1, SHOCK_ILLUSION)
	if(prob(10))
		var/atom/T = C
		T.emp_act(EMP_HEAVY)
		to_chat(C, "<span class='warning'>You feel a strange tingling sensation come from your core.</b></span>")
	if(isnull(N))
		return ..()
	N.nanite_volume += -10*cached_purity
	..()

datum/reagent/fermi/nanite_b_gone/reaction_obj(obj/O, reac_volume)
	for(var/active_obj in react_objs)
		if(O == active_obj)
			return
	react_objs += O
	O.emp_act(EMP_HEAVY)

/datum/reagent/fermi/nanite_b_goneTox
	name = "Electromagnetic crystals"
	description = "Causes items upon the patient to sometimes short out, as well as causing a shock in the patient, if the residual charge between the crystals builds up to sufficient quantities"
	metabolization_rate = 0.5
	chemical_flags = REAGENT_INVISIBLE

//Increases shock events.
/datum/reagent/fermi/nanite_b_goneTox/on_mob_life(mob/living/carbon/C)//Damages the taker if their purity is low. Extended use of impure chemicals will make the original die. (thus can't be spammed unless you've very good)
	if(prob(15))
		to_chat(C, "<span class='warning'>The residual voltage in your system causes you to seize up!</b></span>")
		C.electrocute_act(10, (get_turf(C)), 1, SHOCK_ILLUSION)
	if(prob(50))
		var/atom/T = C
		T.emp_act(EMP_HEAVY)
		to_chat(C, "<span class='warning'>You feel your hair stand on end as you glow brightly for a moment!</b></span>")
	..()


///////////////////////////////////////////////////////////////////////////////////////////////
//				MISC FERMICHEM CHEMS FOR SPECIFIC INTERACTIONS ONLY
///////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/fermi/fermiAcid
	name = "Acid vapour"
	description = "Someone didn't do like an otter, and add acid to water."
	taste_description = "acid burns, ow"
	color = "#FFFFFF"
	pH = 0
	can_synth = FALSE

/datum/reagent/fermi/fermiAcid/reaction_mob(mob/living/carbon/C, method)
	var/target = C.get_bodypart(BODY_ZONE_CHEST)
	var/acidstr
	if(!C.reagents.pH || C.reagents.pH >5)
		acidstr = 3
	else
		acidstr = ((5-C.reagents.pH)*2) //runtime - null.pH ?
	C.adjustFireLoss(acidstr/2, 0)
	if((method==VAPOR) && (!C.wear_mask))
		if(prob(20))
			to_chat(C, "<span class='warning'>You can feel your lungs burning!</b></span>")
		C.adjustOrganLoss(ORGAN_SLOT_LUNGS, acidstr*2)
		C.apply_damage(acidstr/5, BURN, target)
	C.acid_act(acidstr, volume)
	..()

/datum/reagent/fermi/fermiAcid/reaction_obj(obj/O, reac_volume)
	if(ismob(O.loc)) //handled in human acid_act()
		return
	if((holder.pH > 5) || (volume < 0.1)) //Shouldn't happen, but just in case
		return
	reac_volume = round(volume,0.1)
	var/acidstr = (5-holder.pH)*2 //(max is 10)
	O.acid_act(acidstr, volume)
	..()

/datum/reagent/fermi/fermiAcid/reaction_turf(turf/T, reac_volume)
	if (!istype(T))
		return
	reac_volume = round(volume,0.1)
	var/acidstr = (5-holder.pH)
	T.acid_act(acidstr, volume)
	..()

/datum/reagent/fermi/fermiTest
	name = "Fermis Test Reagent"
	description = "You should be really careful with this...! Also, how did you get this?"
	chemical_flags = REAGENT_FORCEONNEW
	can_synth = FALSE

/datum/reagent/fermi/fermiTest/on_new(datum/reagents/holder)
	..()
	if(LAZYLEN(holder.reagent_list) == 1)
		return
	else
		holder.del_reagent(type)//Avoiding recurrsion
	var/location = get_turf(holder.my_atom)
	if(cached_purity < 0.34 || cached_purity == 1)
		var/datum/effect_system/foam_spread/s = new()
		s.set_up(volume*2, location, holder)
		s.start()
	if((cached_purity < 0.67 && cached_purity >= 0.34)|| cached_purity == 1)
		var/datum/effect_system/smoke_spread/chem/s = new()
		s.set_up(holder, volume*2, location)
		s.start()
	if(cached_purity >= 0.67)
		for (var/datum/reagent/reagent in holder.reagent_list)
			if (istype(reagent, /datum/reagent/fermi))
				var/datum/chemical_reaction/fermi/Ferm  = GLOB.chemical_reagents_list[reagent.type]
				Ferm.FermiExplode(src, holder.my_atom, holder, holder.total_volume, holder.chem_temp, holder.pH)
			else
				var/datum/chemical_reaction/Ferm  = GLOB.chemical_reagents_list[reagent.type]
				Ferm.on_reaction(holder, reagent.volume)
	for(var/mob/M in viewers(8, location))
		to_chat(M, "<span class='danger'>The solution reacts dramatically, with a meow!</span>")
		playsound(get_turf(M), 'sound/voice/merowr.ogg', 50, 1)
	holder.clear_reagents()

/datum/reagent/fermi/acidic_buffer
	name = "Acidic buffer"
	description = "This reagent will consume itself and move the pH of a beaker towards acidity when added to another."
	color = "#fbc314"
	pH = 0
	can_synth = TRUE

//Consumes self on addition and shifts pH
/datum/reagent/fermi/acidic_buffer/on_new(datapH)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return ..()
	data = datapH
	if(LAZYLEN(holder.reagent_list) == 1)
		return ..()
	holder.pH = ((holder.pH * holder.total_volume)+(pH * (volume)))/(holder.total_volume + (volume))
	var/list/seen = viewers(5, get_turf(holder))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The beaker fizzes as the pH changes!</b></span>")
	playsound(get_turf(holder.my_atom), 'sound/FermiChem/bufferadd.ogg', 50, 1)
	holder.remove_reagent(type, volume, ignore_pH = TRUE)
	..()

/datum/reagent/fermi/basic_buffer
	name = "Basic buffer"
	description = "This reagent will consume itself and move the pH of a beaker towards alkalinity when added to another."
	color = "#3853a4"
	pH = 14
	can_synth = TRUE

/datum/reagent/fermi/basic_buffer/on_new(datapH)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return ..()
	data = datapH
	if(LAZYLEN(holder.reagent_list) == 1)
		return ..()
	holder.pH = ((holder.pH * holder.total_volume)+(pH * (volume)))/(holder.total_volume + (volume))
	var/list/seen = viewers(5, get_turf(holder))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The beaker froths as the pH changes!</b></span>")
	playsound(get_turf(holder.my_atom), 'sound/FermiChem/bufferadd.ogg', 50, 1)
	holder.remove_reagent(type, volume, ignore_pH = TRUE)
	..()

//Turns you into a cute catto while it's in your system.
//If you manage to gamble perfectly, makes you have cat ears after you transform back. But really, you shouldn't end up with that with how random it is.
/datum/reagent/fermi/secretcatchem //Should I hide this from code divers? A secret cit chem?
	name = "secretcatchem" //an attempt at hiding it
	description = "An illegal and hidden chem that turns people into cats. It's said that it's so rare and unstable that having it means you've been blessed. If used on someone in crit, it will turn them into a cat permanently, until the cat is killed."
	taste_description = "hairballs and cream"
	color = "#ffc224"
	var/catshift = FALSE
	var/perma = FALSE
	var/mob/living/simple_animal/pet/cat/custom_cat/catto = null
	can_synth = FALSE

/datum/reagent/fermi/secretcatchem/New()
	name = "Catbalti[pick("a","u","e","y")]m [pick("apex", "prime", "meow")]"//rename

/datum/reagent/fermi/secretcatchem/on_mob_add(mob/living/carbon/human/H)
	. = ..()
	if(cached_purity >= 0.9)//ONLY if purity is high, and given the stuff is random. It's very unlikely to get this to 1.
		//exception(al) handler:
		H.dna.features["ears"]  = "Cat"
		H.dna.features["mam_ears"] = "Cat"
		H.verb_say = "mewls"
		catshift = TRUE
		playsound(get_turf(H), 'sound/voice/merowr.ogg', 50, 1, -1)
	to_chat(H, "<span class='notice'>You suddenly turn into a cat!</span>")
	catto = new(get_turf(H.loc))
	H.mind.transfer_to(catto)
	catto.name = H.name
	catto.desc = "A cute catto! They remind you of [H] somehow."
	catto.color = "#[H.dna.features["mcolor"]]"
	catto.pseudo_death = TRUE
	H.forceMove(catto)
	log_game("FERMICHEM: [H] ckey: [H.key] has been made into a cute catto.")
	SSblackbox.record_feedback("tally", "fermi_chem", 1, "cats")
	if(H.InCritical())
		perma = TRUE
		volume = 5
		H.stat = DEAD
		catto.origin = H

/datum/reagent/fermi/secretcatchem/on_mob_life(mob/living/carbon/H)
	if(!catto)
		metabolization_rate = 5
		return ..()
	if(catto.health <= 0) //So the dead can't ghost
		if(prob(10))
			to_chat(catto, "<span class='notice'>You feel your body start to slowly shift back from it's dead form.</span>")
		perma = FALSE
		metabolization_rate = 1
	else if(prob(5))
		playsound(get_turf(catto), 'sound/voice/merowr.ogg', 50, 1, -1)
		catto.say("lets out a meowrowr!*")
	..()

/datum/reagent/fermi/secretcatchem/on_mob_delete(mob/living/carbon/H)
	if(perma)
		to_chat(H, "<span class='notice'>You feel your body settle into it's new form. You won't be able to shift back on death anymore.</span>")
		return
	var/words = "Your body shifts back to normal."
	H.forceMove(catto.loc)
	catto.mind.transfer_to(H)
	if(catshift == TRUE)
		words += " ...But wait, are those cat ears?"
		H.say("*wag")//force update sprites.
	to_chat(H, "<span class='notice'>[words]</span>")
	qdel(catto)
	log_game("FERMICHEM: [H] ckey: [H.key] has returned to normal")


/datum/reagent/fermi/secretcatchem/reaction_mob(var/mob/living/L)
	if(istype(L, /mob/living/simple_animal/pet/cat/custom_cat) && cached_purity >= 0.85)
		var/mob/living/simple_animal/pet/cat/custom_cat/catto = L
		if(catto.origin)
			var/mob/living/carbon/human/H = catto.origin
			H.stat = CONSCIOUS
			log_game("FERMICHEM: [catto] ckey: [catto.key] has returned to normal.")
			to_chat(catto, "<span class='notice'>Your body shifts back to normal!</span>")
			H.forceMove(catto.loc)
			catto.mind.transfer_to(H)
			if(!L.mind) //Just in case
				qdel(L)
			else //This should never happen, but just in case, so their game isn't ruined.
				catto.icon_state = "custom_cat"
				catto.health = 50

/*
////////////////////////////////////////////////////////////////////////////////////////////////////
//										ASTROGEN
///////////////////////////////////////////////////////////////////////////////////////////////////
More fun chems!
When you take it, it spawns a ghost that the player controls. (No access to deadchat)
This ghost moves pretty quickly and is mostly invisible, but is still visible for people with eyes.
When it's out of your system, you return back to yourself. It doesn't last long and metabolism of the chem is exponential.
Addiction is particularlly brutal, it slowly turns you invisible with flavour text, then kills you at a low enough alpha. (i've also added something to prevent geneticists speeding this up)
There's afairly major catch regarding the death though. I'm not gonna say here, go read the code, it explains it and puts my comments on it in context. I know that anyone reading it without understanding it is going to freak out so, this is my attempt to get you to read it and understand it.
I'd like to point out from my calculations it'll take about 60-80 minutes to die this way too. Plenty of time to visit chem and ask for some pills to quench your addiction.
*/



/datum/reagent/fermi/astral // Gives you the ability to astral project for a moment!
	name = "Astrogen"
	description = "An opalescent murky liquid that is said to distort your soul from your being."
	color = "#A080H4" // rgb: , 0, 255
	taste_description = "your mind"
	metabolization_rate = 0//Removal is exponential, see code
	overdose_threshold = 20
	addiction_threshold = 24.5
	addiction_stage1_end = 9999//Should never end. There is no escape make your time
	var/mob/living/carbon/origin
	var/mob/living/simple_animal/astral/G = null
	var/datum/mind/originalmind
	var/antiGenetics = 255
	var/sleepytime = 0
	inverse_chem_val = 0.25
	can_synth = FALSE
	var/datum/action/chem/astral/AS = new/datum/action/chem/astral()

/datum/action/chem/astral
	name = "Return to body"
	var/mob/living/carbon/origin
	var/datum/mind/originalmind

/datum/action/chem/astral/Trigger()
	if(origin.mind && origin.mind != originalmind)
		to_chat(originalmind.current, "<span class='warning'><b><i>There's a foreign presence in your body blocking your return!</b></i></span>")
		return ..()
	if(origin.reagents.has_reagent(/datum/reagent/fermi/astral) )
		var/datum/reagent/fermi/astral/As = locate(/datum/reagent/fermi/astral) in origin.reagents.reagent_list
		if(As.current_cycle < 10)
			to_chat(originalmind.current, "<span class='warning'><b><i>The intensity of the astrogen in your body is too much allow you to return to yourself yet!</b></i></span>")
			return ..()
	originalmind.transfer_to(origin)
	if(origin.mind == originalmind)
		qdel(src)


/datum/reagent/fermi/astral/reaction_turf(turf/T, reac_volume)
	if(isplatingturf(T) || istype(T, /turf/open/floor/plasteel))
		var/turf/open/floor/F = T
		F.PlaceOnTop(/turf/open/floor/fakespace, flags = CHANGETURF_INHERIT_AIR)
	..()

/datum/reagent/fermi/astral/reaction_obj(obj/O, reac_volume)
	if(istype(O, /obj/item/bedsheet))
		new /obj/item/bedsheet/cosmos(get_turf(O))
		qdel(O)
	..()

/datum/reagent/fermi/astral/on_mob_life(mob/living/carbon/M) // Gives you the ability to astral project for a moment!
	M.alpha = 255
	if(current_cycle == 0)
		originalmind = M.mind
		log_game("FERMICHEM: [M] ckey: [M.key] became an astral ghost")
		origin = M
		if (G == null)
			G = new(get_turf(M.loc))
		G.name = "[M]'s astral projection"
		//var/datum/action/chem/astral/AS = new(G)
		AS.Grant(G)
		AS.origin = M
		AS.originalmind = originalmind

		if(M.mind)
			M.mind.transfer_to(G)
		SSblackbox.record_feedback("tally", "fermi_chem", 1, "Astral projections")
		//INSURANCE
		M.apply_status_effect(/datum/status_effect/chem/astral_insurance)
		var/datum/status_effect/chem/astral_insurance/AI = M.has_status_effect(/datum/status_effect/chem/astral_insurance)
		AI.original = M
		AI.originalmind = M.mind

	if(overdosed)
		if(prob(50))
			to_chat(G, "<span class='warning'>The high conentration of Astrogen in your blood causes you to lapse your concentration for a moment, bringing your projection back to yourself!</b></span>")
			do_teleport(G, M.loc)
	metabolization_rate = current_cycle/10 //exponential
	sleepytime+=5
	if(G)//This is a mess because of how slow qdel is, so this is all to stop runtimes.
		if(G.mind)
			if(G.stat == DEAD || G.pseudo_death == TRUE)
				G.mind.transfer_to(M)
				qdel(G)
	..()

/datum/reagent/fermi/astral/on_mob_delete(mob/living/carbon/M)
	if(!G)
		if(M.mind)
			var/mob/living/simple_animal/astral/G2 = new(get_turf(M.loc))
			M.mind.transfer_to(G2)//Just in case someone else is inside of you, it makes them a ghost and should hopefully bring them home at the end.
			to_chat(G, "<span class='warning'>[M]'s conciousness snaps back to them as their astrogen runs out, kicking your projected mind out!'</b></span>")
			log_game("FERMICHEM: [M]'s possesser has been booted out into a astral ghost!")
			if(!G2.mind)
				qdel(G2)
		originalmind.transfer_to(M)
	else if(G.mind)
		G.mind.transfer_to(origin)
		qdel(G)
	if(overdosed)
		to_chat(M, "<span class='warning'>The high volume of astrogen you just took causes you to black out momentarily as your mind snaps back to your body.</b></span>")
		M.Sleeping(sleepytime, 0)
	antiGenetics = 255
	if(G)//just in case
		qdel(G)
	log_game("FERMICHEM: [M] has astrally returned to their body!")
	if(M.mind && M.mind == originalmind)
		M.remove_status_effect(/datum/status_effect/chem/astral_insurance)
	//AS.Remove(M)
	..()

//Okay so, this might seem a bit too good, but my counterargument is that it'll likely take all round to eventually kill you this way, then you have to be revived without a body. It takes approximately 50-80 minutes to die from this.
/datum/reagent/fermi/astral/addiction_act_stage1(mob/living/carbon/M)
	if(addiction_stage < 2)
		antiGenetics = 255
		M.alpha = 255 //Antigenetics is to do with stopping geneticists from turning people invisible to kill them.
	if(prob(75))
		M.alpha--
		antiGenetics--
	switch(antiGenetics)
		if(245)
			to_chat(M, "<span class='warning'>You notice your body starting to disappear, maybe you took too much Astrogen...?</b></span>")
			M.alpha--
			antiGenetics--
			log_game("FERMICHEM: [M] ckey: [M.key] has become addicted to Astrogen")
		if(220)
			to_chat(M, "<span class='notice'>Your addiction is only getting worse as your body disappears. Maybe you should get some more, and fast?</b></span>")
			M.alpha--
			antiGenetics--
		if(200)
			to_chat(M, "<span class='notice'>You feel a substantial part of your soul flake off into the ethereal world, rendering yourself unclonable.</b></span>")
			M.alpha--
			antiGenetics--
			ADD_TRAIT(M, TRAIT_NOCLONE, "astral") //So you can't scan yourself, then die, to metacomm. You can only use your memories if you come back as something else.
			M.hellbound = TRUE
		if(180)
			to_chat(M, "<span class='notice'>You feel fear build up in yourself as more and more of your body and consciousness begins to fade.</b></span>")
			M.alpha--
			antiGenetics--
		if(120)
			to_chat(M, "<span class='notice'>As you lose more and more of yourself, you start to think that maybe shedding your mortality isn't too bad.</b></span>")
			M.alpha--
			antiGenetics--
		if(80)
			to_chat(M, "<span class='notice'>You feel a thrill shoot through your body as what's left of your mind contemplates your forthcoming oblivion.</b></span>")
			M.alpha--
			antiGenetics--
		if(45)
			to_chat(M, "<span class='warning'>The last vestiges of your mind eagerly await your imminent annihilation.</b></span>")
			M.alpha--
			antiGenetics--
		if(-INFINITY to 30)
			to_chat(M, "<span class='warning'>Your body disperses from existence, as you become one with the universe.</b></span>")
			to_chat(M, "<span class='userdanger'>As your body disappears, your consciousness doesn't. Should you find a way back into the mortal coil, your memories of your previous life remain with you. (At the cost of staying in character while dead. Failure to do this may get you banned from this chem. You are still obligated to follow your directives if you play a midround antag, you do not remember the afterlife IC)</span>")//Legalised IC OOK? I have a suspicion this won't make it past the review. At least it'll be presented as a neat idea! If this is unacceptable how about the player can retain living memories across lives if they die in this way only.
			deadchat_broadcast("<span class='warning'>[M] has become one with the universe, meaning that their IC conciousness is continuous in a new life. If they find a way back to life, they are allowed to remember their previous life. Be careful what you say. If they abuse this, bwoink the FUCK outta them.</span>")
			M.visible_message("[M] suddenly disappears, their body evaporating from existence, freeing [M] from their mortal coil.")
			message_admins("[M] (ckey: [M.ckey]) has become one with the universe, and have continuous memories thoughout their lives should they find a way to come back to life (such as an inteligence potion, midround antag, ghost role).")
			SSblackbox.record_feedback("tally", "fermi_chem", 1, "Astral obliterations")
			qdel(M) //Approx 60minutes till death from initial addiction
			log_game("FERMICHEM: [M] ckey: [M.key] has been obliterated from Astrogen addiction")
	..()

////////////////////////////////////////////////////////////////////////////////////////////////////
//										EIGENSTASIUM
///////////////////////////////////////////////////////////////////////////////////////////////////
//eigenstate Chem
//Teleports you to chemistry and back
//OD teleports you randomly around the Station
//Addiction send you on a wild ride and replaces you with an alternative reality version of yourself.
//During the process you get really hungry, then your items start teleporting randomly,
//then alternative versions of yourself are brought in from a different universe and they yell at you.
//and finally you yourself get teleported to an alternative universe, and character your playing is replaced with said alternative

/datum/reagent/fermi/eigenstate
	name = "Eigenstasium"
	description = "A strange mixture formed from a controlled reaction of bluespace with plasma, that causes localised eigenstate fluxuations within the patient"
	taste_description = "wiggly cosmic dust."
	color = "#5020F4" // rgb: 50, 20, 255
	overdose_threshold = 15
	addiction_threshold = 15
	metabolization_rate = 1 * REAGENTS_METABOLISM
	addiction_stage2_end = 30
	addiction_stage3_end = 41
	addiction_stage4_end = 44 //Incase it's too long
	data = list("location_created" = null)
	var/turf/location_created
	var/obj/effect/overlay/holo_pad_hologram/Eigenstate
	var/turf/open/location_return = null
	var/addictCyc3 = 0
	var/mob/living/carbon/fermi_Tclone = null
	var/teleBool = FALSE
	pH = 3.7
	can_synth = TRUE

/datum/reagent/fermi/eigenstate/on_new(list/data)
	location_created = data["location_created"]

//Main functions
/datum/reagent/fermi/eigenstate/on_mob_life(mob/living/M) //Teleports to chemistry!
	if(current_cycle == 0)
		log_game("FERMICHEM: [M] ckey: [M.key] took eigenstasium")

		//make hologram at return point
		Eigenstate = new(loc)
		Eigenstate.appearance = M.appearance
		Eigenstate.alpha = 170
		Eigenstate.add_atom_colour("#77abff", FIXED_COLOUR_PRIORITY)
		Eigenstate.mouse_opacity = MOUSE_OPACITY_TRANSPARENT//So you can't click on it.
		Eigenstate.layer = FLY_LAYER//Above all the other objects/mobs. Or the vast majority of them.
		Eigenstate.setAnchored(TRUE)//So space wind cannot drag it.
		Eigenstate.name = "[M]'s' eigenstate"//If someone decides to right click.
		Eigenstate.set_light(2)	//hologram lighting

		location_return = get_turf(M)	//sets up return point
		to_chat(M, "<span class='userdanger'>You feel your wavefunction split!</span>")
		if(cached_purity > 0.9) //Teleports you home if it's pure enough
			if(!location_created && data) //Just in case
				location_created = data["location_created"]
			log_game("FERMICHEM: [M] ckey: [M.key] returned to [location_created] using eigenstasium")
			do_sparks(5,FALSE,M)
			do_teleport(M, location_created, 0, asoundin = 'sound/effects/phasein.ogg')
			do_sparks(5,FALSE,M)
			SSblackbox.record_feedback("tally", "fermi_chem", 1, "Pure eigentstate jumps")


	if(prob(20))
		do_sparks(5,FALSE,M)
	..()

/datum/reagent/fermi/eigenstate/on_mob_delete(mob/living/M) //returns back to original location
	do_sparks(5,FALSE,M)
	to_chat(M, "<span class='userdanger'>You feel your wavefunction collapse!</span>")
	if(!M.reagents.has_reagent(/datum/reagent/stabilizing_agent))
		do_teleport(M, location_return, 0, asoundin = 'sound/effects/phasein.ogg') //Teleports home
		do_sparks(5,FALSE,M)
	qdel(Eigenstate)
	..()

/datum/reagent/fermi/eigenstate/overdose_start(mob/living/M) //Overdose, makes you teleport randomly
	. = ..()
	to_chat(M, "<span class='userdanger'>Oh god, you feel like your wavefunction is about to tear.</span>")
	log_game("FERMICHEM: [M] ckey: [M.key] has overdosed on eigenstasium")
	M.Jitter(20)
	metabolization_rate += 0.5 //So you're not stuck forever teleporting.

/datum/reagent/fermi/eigenstate/overdose_process(mob/living/M) //Overdose, makes you teleport randomly, probably one of my favourite effects. Sometimes kills you.
	do_sparks(5,FALSE,M)
	do_teleport(M, get_turf(M), 10, asoundin = 'sound/effects/phasein.ogg')
	do_sparks(5,FALSE,M)
	..()

//Addiction
/datum/reagent/fermi/eigenstate/addiction_act_stage1(mob/living/M) //Welcome to Fermis' wild ride.
	if(addiction_stage == 1)
		to_chat(M, "<span class='userdanger'>Your wavefunction feels like it's been ripped in half. You feel empty inside.</span>")
		log_game("FERMICHEM: [M] ckey: [M.key] has become addicted to eigenstasium")
		M.Jitter(10)
	M.nutrition = M.nutrition - (M.nutrition/15)
	..()

/datum/reagent/fermi/eigenstate/addiction_act_stage2(mob/living/M)
	if(addiction_stage == 11)
		to_chat(M, "<span class='userdanger'>You start to convlse violently as you feel your consciousness split and merge across realities as your possessions fly wildy off your body.</span>")
		M.Jitter(200)
		M.DefaultCombatKnockdown(200)
		M.Stun(80)
	var/items = M.get_contents()
	if(!LAZYLEN(items))
		return ..()
	var/obj/item/I = pick(items)
	if(istype(I, /obj/item/implant))
		qdel(I)
		to_chat(M, "<span class='userdanger'>You feel your implant rip itself out of you, sent flying off to another dimention!</span>")
	else
		M.dropItemToGround(I, TRUE)
	do_sparks(5,FALSE,I)
	do_teleport(I, get_turf(I), 5, no_effects=TRUE);
	do_sparks(5,FALSE,I)
	..()

/datum/reagent/fermi/eigenstate/addiction_act_stage3(mob/living/M)//Pulls multiple copies of the character from alternative realities while teleporting them around!
	//Clone function - spawns a clone then deletes it - simulates multiple copies of the player teleporting in
	switch(addictCyc3) //Loops 0 -> 1 -> 2 -> 1 -> 2 -> 1 ...ect.
		if(0)
			M.Jitter(100)
			to_chat(M, "<span class='userdanger'>Your eigenstate starts to rip apart, causing a localised collapsed field as you're ripped from alternative universes, trapped around the densisty of the event horizon.</span>")
		if(1)
			var/typepath = M.type
			fermi_Tclone = new typepath(M.loc)
			var/mob/living/carbon/C = fermi_Tclone
			fermi_Tclone.appearance = M.appearance
			C.real_name = M.real_name
			M.visible_message("[M] collapses in from an alternative reality!")
			do_teleport(C, get_turf(C), 2, no_effects=TRUE) //teleports clone so it's hard to find the real one!
			do_sparks(5,FALSE,C)
			C.emote("spin")
			M.emote("spin")
			M.emote("me",1,"flashes into reality suddenly, gasping as they gaze around in a bewildered and highly confused fashion!",TRUE)
			C.emote("me",1,"[pick("says", "cries", "mewls", "giggles", "shouts", "screams", "gasps", "moans", "whispers", "announces")], \"[pick("Bugger me, whats all this then?", "Hot damn, where is this?", "sacre bleu! Ou suis-je?!", "Yee haw! This is one hell of a hootenanny!", "WHAT IS HAPPENING?!", "Picnic!", "Das ist nicht deutschland. Das ist nicht akzeptabel!!!", "I've come from the future to warn you to not take eigenstasium! Oh no! I'm too late!", "You fool! You took too much eigenstasium! You've doomed us all!", "What...what's with these teleports? It's like one of my Japanese animes...!", "Ik stond op het punt om mehki op tafel te zetten, en nu, waar ben ik?", "This must be the will of Stein's gate.", "Fermichem was a mistake", "This is one hell of a beepsky smash.", "Now neither of us will be virgins!")]\"")
		if(2)
			var/mob/living/carbon/C = fermi_Tclone
			do_sparks(5,FALSE,C)
			qdel(C) //Deletes CLONE, or at least I hope it is.
			M.visible_message("[M] is snapped across to a different alternative reality!")
			addictCyc3 = 0 //counter
			fermi_Tclone = null
	addictCyc3++
	do_teleport(M, get_turf(M), 2, no_effects=TRUE) //Teleports player randomly
	do_sparks(5,FALSE,M)
	..()

/datum/reagent/fermi/eigenstate/addiction_act_stage4(mob/living/M) //Thanks for riding Fermis' wild ride. Mild jitter and player buggery.
	if(addiction_stage == 42)
		do_sparks(5,FALSE,M)
		do_teleport(M, get_turf(M), 2, no_effects=TRUE) //teleports clone so it's hard to find the real one!
		do_sparks(5,FALSE,M)
		M.Sleeping(100, 0)
		M.Jitter(50)
		M.DefaultCombatKnockdown(100)
		to_chat(M, "<span class='userdanger'>You feel your eigenstate settle, snapping an alternative version of yourself into reality. All your previous memories are lost and replaced with the alternative version of yourself. This version of you feels more [pick("affectionate", "happy", "lusty", "radical", "shy", "ambitious", "frank", "voracious", "sensible", "witty")] than your previous self, sent to god knows what universe.</span>")
		M.emote("me",1,"flashes into reality suddenly, gasping as they gaze around in a bewildered and highly confused fashion!",TRUE)
		log_game("FERMICHEM: [M] ckey: [M.key] has become an alternative universe version of themselves.")
		M.reagents.remove_all_type(/datum/reagent, 100, 0, 1)
		/*
		for(var/datum/mood_event/Me in M)
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, Me) //Why does this not work?
		*/
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "Alternative dimension", /datum/mood_event/eigenstate)
		SSblackbox.record_feedback("tally", "fermi_chem", 1, "Wild rides ridden")

	if(prob(20))
		do_sparks(5,FALSE,M)
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "[type]_overdose")//holdover until above fix works
	..()

/datum/reagent/fermi/eigenstate/reaction_turf(turf/T, reac_volume)
	//if(cached_purity < 0.99) To add with next batch of fixes and tweaks.
	var/obj/structure/closet/First
	var/obj/structure/closet/Previous
	for(var/obj/structure/closet/C in T.contents)
		if(C.eigen_teleport == TRUE)
			C.visible_message("[C] fizzes, it's already linked to something else!")
			continue
		if(!Previous)
			First = C
			Previous = C
			continue
		C.eigen_teleport = TRUE
		C.eigen_target = Previous
		C.color = "#9999FF" //Tint the locker slightly.
		C.alpha = 200
		do_sparks(5,FALSE,C)
		Previous = C
	if(!First)
		return
	if(Previous == First)
		return
	First.eigen_teleport = TRUE
	First.eigen_target = Previous
	First.color = "#9999FF"
	First.alpha = 200
	do_sparks(5,FALSE,First)
	First.visible_message("The lockers' eigenstates spilt and merge, linking each of their contents together.")

//eigenstate END

////////////////////////////////////////////////////////////////////////////////////////////////////
//										BREAST ENLARGE
///////////////////////////////////////////////////////////////////////////////////////////////////
//Other files that are relivant:
//modular_citadel/code/datums/status_effects/chems.dm
//modular_citadel/code/modules/arousal/organs/breasts.dm

//breast englargement
//Honestly the most requested chems
//I'm not a very kinky person, sorry if it's not great
//I tried to make it interesting..!!

//Normal function increases your breast size by 0.05, 10units = 1 cup.
//If you get stupid big, it presses against your clothes, causing brute and oxydamage. Then rips them off.
//If you keep going, it makes you slower, in speed and action.
//decreasing your size will return you to normal.
//(see the status effect in chem.dm)
//Overdosing on (what is essentially space estrogen) makes you female, removes balls and shrinks your dick.
//OD is low for a reason. I'd like fermichems to have low ODs, and dangerous ODs, and since this is a meme chem that everyone will rush to make, it'll be a lesson learnt early.

/datum/reagent/fermi/breast_enlarger
	name = "Succubus milk"
	description = "A volatile collodial mixture derived from milk that encourages mammary production via a potent estrogen mix."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "a milky ice cream like flavour."
	overdose_threshold = 17
	metabolization_rate = 0.25
	impure_chem 			= /datum/reagent/fermi/BEsmaller //If you make an inpure chem, it stalls growth
	inverse_chem_val 		= 0.35
	inverse_chem		= /datum/reagent/fermi/BEsmaller //At really impure vols, it just becomes 100% inverse
	can_synth = FALSE
	var/message_spam = FALSE

/datum/reagent/fermi/breast_enlarger/on_mob_metabolize(mob/living/M)
	. = ..()
	if(!ishuman(M)) //The monkey clause
		if(volume >= 15) //To prevent monkey breast farms
			var/turf/T = get_turf(M)
			var/obj/item/organ/genital/breasts/B = new /obj/item/organ/genital/breasts(T)
			M.visible_message("<span class='warning'>A pair of breasts suddenly fly out of the [M]!</b></span>")
			var/T2 = get_random_station_turf()
			M.adjustBruteLoss(25)
			M.DefaultCombatKnockdown(50)
			M.Stun(50)
			B.throw_at(T2, 8, 1)
		M.reagents.del_reagent(type)
		return
	var/mob/living/carbon/human/H = M
	if(!H.getorganslot(ORGAN_SLOT_BREASTS) && H.emergent_genital_call())
		H.genital_override = TRUE

/datum/reagent/fermi/breast_enlarger/on_mob_life(mob/living/carbon/M) //Increases breast size
	if(!ishuman(M))//Just in case
		return..()

	var/mob/living/carbon/human/H = M
	//If they've opted out, then route processing though liver.
	if(!(H.client?.prefs.cit_toggles & BREAST_ENLARGEMENT))
		var/obj/item/organ/liver/L = H.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.applyOrganDamage(0.25)
		else
			H.adjustToxLoss(1)
		return..()
	var/obj/item/organ/genital/breasts/B = M.getorganslot(ORGAN_SLOT_BREASTS)
	//otherwise proceed as normal
	if(!B) //If they don't have breasts, give them breasts.

		B = new
		if(H.dna.species.use_skintones && H.dna.features["genitals_use_skintone"])
			B.color = SKINTONE2HEX(H.skin_tone)
		else if(M.dna.features["breasts_color"])
			B.color = "#[M.dna.features["breasts_color"]]"
		else
			B.color = SKINTONE2HEX(H.skin_tone)
		B.size = "flat"
		B.cached_size = 0
		B.prev_size = 0
		to_chat(H, "<span class='warning'>Your chest feels warm, tingling with newfound sensitivity.</b></span>")
		H.reagents.remove_reagent(type, 5)
		B.Insert(H)

	//If they have them, increase size. If size is comically big, limit movement and rip clothes.
	B.modify_size(0.05)

	if (ISINRANGE_EX(B.cached_size, 8.5, 9) && (H.w_uniform || H.wear_suit))
		var/target = H.get_bodypart(BODY_ZONE_CHEST)
		if(!message_spam)
			to_chat(H, "<span class='danger'>Your breasts begin to strain against your clothes tightly!</b></span>")
			message_spam = TRUE
		H.adjustOxyLoss(5, 0)
		H.apply_damage(1, BRUTE, target)
	return ..()

/datum/reagent/fermi/breast_enlarger/overdose_process(mob/living/carbon/M) //Turns you into a female if male and ODing, doesn't touch nonbinary and object genders.
	if(!(M.client?.prefs.cit_toggles & FORCED_FEM))
		var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.applyOrganDamage(0.25)
		return ..()

	var/obj/item/organ/genital/penis/P = M.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/genital/testicles/T = M.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/genital/vagina/V = M.getorganslot(ORGAN_SLOT_VAGINA)
	var/obj/item/organ/genital/womb/W = M.getorganslot(ORGAN_SLOT_WOMB)

	if(M.gender == MALE)
		M.set_gender(FEMALE)

	if(P)
		P.modify_size(-0.05)
	if(T)
		qdel(T)
	if(!V)
		V = new
		V.Insert(M)
	if(!W)
		W = new
		W.Insert(M)
	return ..()

/datum/reagent/fermi/BEsmaller
	name = "Modesty milk"
	description = "A volatile collodial mixture derived from milk that encourages mammary reduction via a potent estrogen mix. Produced by reacting impure Succubus milk."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "a milky ice cream like flavour."
	metabolization_rate = 0.25
	can_synth = FALSE

/datum/reagent/fermi/BEsmaller/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/genital/breasts/B = M.getorganslot(ORGAN_SLOT_BREASTS)
	if(!(M.client?.prefs.cit_toggles & BREAST_ENLARGEMENT) || !B)
		var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.applyOrganDamage(-0.25)
		return ..()
	B.modify_size(-0.05)
	return ..()

/datum/reagent/fermi/BEsmaller_hypo
	name = "Rectify milk" //Rectify
	color = "#E60584"
	taste_description = "a milky ice cream like flavour."
	metabolization_rate = 0.25
	description = "A medicine used to treat organomegaly in a patient's breasts."
	var/sizeConv =  list("a" =  1, "b" = 2, "c" = 3, "d" = 4, "e" = 5)
	can_synth = TRUE

/datum/reagent/fermi/BEsmaller_hypo/on_mob_metabolize(mob/living/M)
	. = ..()
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(!H.getorganslot(ORGAN_SLOT_VAGINA) && H.dna.features["has_vag"])
		H.give_genital(/obj/item/organ/genital/vagina)
	if(!H.getorganslot(ORGAN_SLOT_WOMB) && H.dna.features["has_womb"])
		H.give_genital(/obj/item/organ/genital/womb)

/datum/reagent/fermi/BEsmaller_hypo/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/genital/breasts/B = M.getorganslot(ORGAN_SLOT_BREASTS)
	if(!B)
		return..()
	var/optimal_size = B.breast_values[M.dna.features["breasts_size"]]
	if(!optimal_size)//Fast fix for those who don't want it.
		B.modify_size(-0.1)
	else if(B.cached_size > optimal_size)
		B.modify_size(-0.05, optimal_size)
	else if(B.cached_size < optimal_size)
		B.modify_size(0.05, 0, optimal_size)
	return ..()

////////////////////////////////////////////////////////////////////////////////////////////////////
//										PENIS ENLARGE
///////////////////////////////////////////////////////////////////////////////////////////////////
//See breast explanation, it's the same but with taliwhackers
//instead of slower movement and attacks, it slows you and increases the total blood you need in your system.
//Since someone else made this in the time it took me to PR it, I merged them.
/datum/reagent/fermi/penis_enlarger // Due to popular demand...!
	name = "Incubus draft"
	description = "A volatile collodial mixture derived from various masculine solutions that encourages a larger gentleman's package via a potent testosterone mix, formula derived from a collaboration from Fermichem  and Doctor Ronald Hyatt, who is well known for his phallus palace." //The toxic masculinity thing is a joke because I thought it would be funny to include it in the reagents, but I don't think many would find it funny? dumb
	color = "#888888" // This is greyish..?
	taste_description = "chinese dragon powder"
	overdose_threshold = 17 //ODing makes you male and removes female genitals
	metabolization_rate = 0.5
	impure_chem 			= /datum/reagent/fermi/PEsmaller //If you make an inpure chem, it stalls growth
	inverse_chem_val 		= 0.35
	inverse_chem		= /datum/reagent/fermi/PEsmaller //At really impure vols, it just becomes 100% inverse and shrinks instead.
	can_synth = FALSE
	var/message_spam = FALSE

/datum/reagent/fermi/penis_enlarger/on_mob_metabolize(mob/living/M)
	. = ..()
	if(!ishuman(M)) //Just monkeying around.
		if(volume >= 15) //to prevent monkey penis farms
			var/turf/T = get_turf(M)
			var/obj/item/organ/genital/penis/P = new /obj/item/organ/genital/penis(T)
			M.visible_message("<span class='warning'>A penis suddenly flies out of the [M]!</b></span>")
			var/T2 = get_random_station_turf()
			M.adjustBruteLoss(25)
			M.DefaultCombatKnockdown(50)
			M.Stun(50)
			P.throw_at(T2, 8, 1)
		M.reagents.del_reagent(type)
		return
	var/mob/living/carbon/human/H = M
	if(!H.getorganslot(ORGAN_SLOT_PENIS) && H.emergent_genital_call())
		H.genital_override = TRUE

/datum/reagent/fermi/penis_enlarger/on_mob_life(mob/living/carbon/M) //Increases penis size, 5u = +1 inch.
	if(!ishuman(M))
		return ..()
	var/mob/living/carbon/human/H = M
	if(!(H.client?.prefs.cit_toggles & PENIS_ENLARGEMENT))
		var/obj/item/organ/liver/L = H.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.applyOrganDamage(0.25)
		else
			H.adjustToxLoss(1)
		return ..()
	var/obj/item/organ/genital/penis/P = H.getorganslot(ORGAN_SLOT_PENIS)
	//otherwise proceed as normal
	if(!P)//They do have a preponderance for escapism, or so I've heard.

		P = new
		P.length = 1
		to_chat(H, "<span class='warning'>Your groin feels warm, as you feel a newly forming bulge down below.</b></span>")
		P.prev_length = 1
		H.reagents.remove_reagent(type, 5)
		P.Insert(H)

	P.modify_size(0.1)
	if (ISINRANGE_EX(P.length, 20.5, 21) && (H.w_uniform || H.wear_suit))
		var/target = H.get_bodypart(BODY_ZONE_CHEST)
		if(!message_spam)
			to_chat(H, "<span class='danger'>Your cock begin to strain against your clothes tightly!</b></span>")
			message_spam = TRUE
		H.apply_damage(2.5, BRUTE, target)

	return ..()

/datum/reagent/fermi/penis_enlarger/overdose_process(mob/living/carbon/human/M) //Turns you into a male if female and ODing, doesn't touch nonbinary and object genders.
	if(!istype(M))
		return ..()
	if(!(M.client?.prefs.cit_toggles & FORCED_MASC))
		var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.applyOrganDamage(0.25)
		return..()

	var/obj/item/organ/genital/breasts/B = M.getorganslot(ORGAN_SLOT_BREASTS)
	var/obj/item/organ/genital/testicles/T = M.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/genital/vagina/V = M.getorganslot(ORGAN_SLOT_VAGINA)
	var/obj/item/organ/genital/womb/W = M.getorganslot(ORGAN_SLOT_WOMB)

	if(M.gender == FEMALE)
		M.set_gender(MALE)

	if(B)
		B.modify_size(-0.05)
	if(M.getorganslot(ORGAN_SLOT_VAGINA))
		qdel(V)
	if(W)
		qdel(W)
	if(!T)
		T = new
		T.Insert(M)
	return ..()

/datum/reagent/fermi/PEsmaller // Due to cozmo's request...!
	name = "Chastity draft"
	description = "A volatile collodial mixture derived from various masculine solutions that encourages a smaller gentleman's package via a potent testosterone mix. Produced by reacting impure Incubus draft."
	color = "#888888" // This is greyish..?
	taste_description = "chinese dragon powder"
	metabolization_rate = 0.5
	can_synth = FALSE

/datum/reagent/fermi/PEsmaller/on_mob_life(mob/living/carbon/M)
	if(!ishuman(M))
		return ..()
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/penis/P = H.getorganslot(ORGAN_SLOT_PENIS)
	if(!(H.client?.prefs.cit_toggles & PENIS_ENLARGEMENT) || !P)
		var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.applyOrganDamage(-0.25)
		return..()

	P.modify_size(-0.1)
	..()

/datum/reagent/fermi/PEsmaller_hypo
	name = "Rectify draft"
	color = "#888888" // This is greyish..?
	taste_description = "chinese dragon powder"
	description = "A medicine used to treat organomegaly in a patient's penis."
	metabolization_rate = 0.5
	can_synth = TRUE

/datum/reagent/fermi/PEsmaller_hypo/on_mob_metabolize(mob/living/M)
	. = ..()
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(!H.getorganslot(ORGAN_SLOT_PENIS) && H.dna.features["has_cock"])
		H.give_genital(/obj/item/organ/genital/penis)
	if(!H.getorganslot(ORGAN_SLOT_TESTICLES) && H.dna.features["has_balls"])
		H.give_genital(/obj/item/organ/genital/testicles)

/datum/reagent/fermi/PEsmaller_hypo/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/genital/penis/P = M.getorganslot(ORGAN_SLOT_PENIS)
	if(!P)
		return ..()
	var/optimal_size = M.dna.features["cock_length"]
	if(!optimal_size)//Fast fix for those who don't want it.
		P.modify_size(-0.2)
	else if(P.length > optimal_size)
		P.modify_size(-0.1, optimal_size)
	else if(P.length < optimal_size)
		P.modify_size(0.1, 0, optimal_size)
	return ..()

/datum/reagent/fermi/yamerol
	name = "Yamerol"
	description = "For when you've trouble speaking or breathing, just yell YAMEROL! A chem that helps soothe any congestion problems and at high concentrations restores damaged lungs and tongues!"
	taste_description = "a weird, syrupy flavour, yamero"
	color = "#68e83a"
	pH = 8.6
	overdose_threshold = 35
	impure_chem 			= /datum/reagent/impure/yamerol_tox
	inverse_chem_val 		= 0.4
	inverse_chem		= /datum/reagent/impure/yamerol_tox
	can_synth = TRUE

/datum/reagent/fermi/yamerol/on_mob_life(mob/living/carbon/C)
	var/obj/item/organ/tongue/T = C.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)

	if(T)
		T.applyOrganDamage(-2)
	if(L)
		C.adjustOrganLoss(ORGAN_SLOT_LUNGS, -5)
		C.adjustOxyLoss(-2)
	else
		C.adjustOxyLoss(-10)

	if(T)
		if(T.name == "fluffy tongue")
			var/obj/item/organ/tongue/nT
			if(C.dna && C.dna.species && C.dna.species.mutanttongue)
				nT = new C.dna.species.mutanttongue()
			else
				nT = new()
			T.Remove()
			qdel(T)
			nT.Insert(C)
			to_chat(C, "<span class='notice'>You feel your tongue.... unfluffify...?</span>")
			holder.remove_reagent(type, 10)
	..()

/datum/reagent/fermi/yamerol/overdose_process(mob/living/carbon/C)
	var/obj/item/organ/tongue/oT = C.getorganslot(ORGAN_SLOT_TONGUE)
	if(current_cycle == 1)
		to_chat(C, "<span class='notice'>You feel the Yamerol sooth your tongue and lungs.</span>")
	if(current_cycle > 10)
		if(!C.getorganslot(ORGAN_SLOT_TONGUE))
			var/obj/item/organ/tongue/T
			if(C.dna && C.dna.species && C.dna.species.mutanttongue)
				T = new C.dna.species.mutanttongue()
			else
				T = new()
			T.Insert(C)
			to_chat(C, "<span class='notice'>You feel your tongue reform in your mouth.</span>")
			holder.remove_reagent(type, 10)
		else
			if((oT.name == "fluffy tongue") && (purity == 1))
				var/obj/item/organ/tongue/T
				if(C.dna && C.dna.species && C.dna.species.mutanttongue)
					T = new C.dna.species.mutanttongue()
				else
					T = new()
				oT.Remove()
				qdel(oT)
				T.Insert(C)
				to_chat(C, "<span class='notice'>You feel your tongue.... unfluffify...?</span>")
				holder.remove_reagent(type, 10)

		if(!C.getorganslot(ORGAN_SLOT_LUNGS))
			var/obj/item/organ/lungs/yamerol/L = new()
			L.Insert(C)
			to_chat(C, "<span class='notice'>You feel the yamerol merge in your chest.</span>")
			holder.remove_reagent(type, 10)
	C.adjustOxyLoss(-3)
	..()

/datum/reagent/impure/yamerol_tox
	name = "Yamer oh no"
	description = "A dangerous, cloying toxin that stucks to a patient’s respiratory system, damaging their tongue, lungs and causing suffocation."
	taste_description = "a weird, syrupy flavour, yamero"
	color = "#68e83a"
	pH = 8.6

/datum/reagent/impure/yamerol_tox/on_mob_life(mob/living/carbon/C)
	var/obj/item/organ/tongue/T = C.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)

	if(T)
		T.applyOrganDamage(1)
	if(L)
		C.adjustOrganLoss(ORGAN_SLOT_LUNGS, 4)
		C.adjustOxyLoss(3)
	else
		C.adjustOxyLoss(10)
	..()

/*
////////////////////////////////////////
//				MKULTA				  //
////////////////////////////////////////
The magnum opus of FermiChem -
Long and complicated, I highly recomend you look at the two other files heavily involved in this
modular_citadel/code/datums/status_effects/chems.dm - handles the subject's reactions
code/modules/surgery/organs/vocal_cords.dm - handles the enchanter speaking

HOW IT WORKS
Fermis_Reagent.dm
There's 3 main ways this chemical works; I'll start off with discussing how it's set up.
Upon reacting with blood as a catalyst, the blood is used to define who the enthraller is - thus only the creator is/can choose who the master will be. As a side note, you can't adminbus this chem, even admins have to earn it.
This uses the fermichem only proc; FermiCreate, which is basically the same as On_new, except it doesn't require "data" which is something to do with blood and breaks everything so I said bugger it and made my own proc. It basically sets up vars.
When it's first made, the creator has to drink some of it, in order to give them the vocal chords needed.
When it's given to someone, it gives them the status effect and kicks off that side of things. For every metabolism tick, it increases the enthrall tally.
Finally, if you manage to pump 100u into some poor soul, you overload them, and mindbreak them. Making them your willing, but broken slave. Which can only be reversed by; fixing their brain with mannitol and neurine (100 / 50u respectively) (or less with both),

vocal_cords.dm
This handles when the enchanter speaks - basically uses code from voice of god, but only for people with the staus effect. Most of the words are self explainitory, and has a smaller range of commands. If you're not sure what one does, it likely affects the enthrall tally, or the resist tally.
list of commands:

-mixables-
enthral_words
reward_words
punish_words
0
saymyname_words
wakeup_words
1
silence_words
antiresist_words
resist_words
forget_words
attract_words
orgasm_words
2
awoo_words
nya_words
sleep_words
strip_words
walk_words
run_words
knockdown_words
3
statecustom_words
custom_words
objective_words
heal_words
stun_words
hallucinate_words
hot_words
cold_words
getup_words
pacify_words
charge_words

Mixables can be used intersperced with other commands, 0 is commands that work on sleeper against (i.e. players enthralled to state 3, then ordered to wake up and forget, they can be triggered back instantly)
1 is for players who immediately are injected with the chem - no stuns, only a silence and something that draws them towrds them. This is the best time to try to fight it and you're likely to win by spamming resist, unless the enchantress has plans.
2 is the seconds stage, which allows removal of clothes, slowdown and light stunning. You can also make them nya and awoo, because cute.
3 is the finaly state, which allows application of a few status effects (see chem.dm) and allows custom triggers to be installed (kind of like nanites), again, see chem.dm
In a nutshell, this is the way you enthrall people, by typing messages into chat and managing cooldowns on the stronger words. You have to type words and your message strength is increases with the number of characters - if you type short messages the cooldown will be too much and the other player will overcome the chem.
I suppose people could spam gdjshogndjoadphgiuaodp but, the truth of this chem is that it mostly allows a casus beli for subs to give in, and everyones a sub on cit (mostly), so if you aujigbnadjgipagdsjk then they might resist harder cause you're a baddie and baddies don't deserve pets.
Also, the use of this chem as a murder aid is antithetic to it's design, the subject gains bonus resistance if they're hurt or hungry (I'd like to expland this more, I like the idea that you have to look after all of them otherwise they aren't as effective, kind of like tamagachis!). If this becomes a problem, I'll deal with it, I'm not happy with people abusing this chem for an easy murder. (I might make it so you an't strike your pet when health is too low.)
Additionaly, in lieu of previous statement - the pet is ordered to not kill themselves, even if ordered to.

chem.dm
oof
There's a few basic things that have to be understood with this status effect
1. There is a min loop which calculates the enthrall state of the subject, when the entrall tally is over a certain amount, it will push you up 1 phase.
0 - Sleeper
1 - initial
2 - enthralled
3 - Fully entranced
4 - mindbroken
4 can only be reached via OD, whereas you can increment up from 1 > 2 > 3. 0 is only obtainable on a state 3 pet, and it toggles between the two.

1.5 Chem warfare
Since this is a chem, it's expected that you will use all of the chemicals at your disposal. Using aphro and aphro+ will weaken the resistance of the subject, while ananphro, anaphro+, mannitol and neurine will strengthen it.
Additionally, the more aroused you are, the weaker your resistance will be, as a result players immune to aphro and anaphro give a flat bonus to the enthraller.
using furranium and hatmium on the enchanter weakens their power considerably, because they sound rediculous. "Youwe fweewing wery sweepy uwu" This completely justifies their existance.
The impure toxin for this chem increases resistance too, so if they're a bad chemist it'll be unlikely they have a good ratio (and as a secret bonus, really good chemists cann purposely make the impure chem, to use either to combat the use of it against them, or as smoke grenades to deal with a large party)

2. There is a resistance proc which occurs whenever the player presses resist. You have to press it a lot, this is intentional. If you're trying to fight the enchanter, then you can't click both. You usually will win if you just mash resist and the enchanter does nothing, so you've got to react.
Each step futher it becomes harder to resist, in state 2 it's longer, but resisting is still worthwhile. If you're not in state 3, and you've not got MKultra inside of you, you generate resistance very fast. So in some cases the better option will be to stall out any attempts to entrance you.
At the moment, resistance doesn't affect the commands - mostly because it's a way to tell if a state 3 is trying to resist. But this might change if it gets too hard to fight them off.
Durign state 3, it's impossible to resist if the enthraller is in your presence (8 tiles), you generate no resistance if so. If they're out of your range, then you start to go into the addiction processed
As your resistance is tied to your arousal, sometimes your best option is to wah

3. The addition process starts when the enthraller is out of range, it roughtly follows the five stages of grief; denial, anger, bargaining, depression and acceptance.
What it mostly does makes you sad, hurts your brain, and sometimes you lash out in anger.
Denial - minor brain damaged
bargaining - 50:50 chance of brain damage and brain healing
anger - randomly lashing out and hitting people
depression - massive mood loss, stuttering, jittering, hallucinations and brain damage
depression, again - random stunning and crying, brain damage, and resistance
acceptance - minor brain damage and resistance.
You can also resist while out of range, but you can only break free of a stange 3 enthrallment by hitting the acceptance phase with a high enough resistance.
Finally, being near your enthraller reverts the damages caused.
It is expected that if you intend to break free you'll need to use psicodine and mannitol or you'll end up in a bad, but not dead, state. This gives more work for medical!! Finally the true rational of this complicated chem comes out.

4. Status effects in status effects.
There's a few commands that give status effects, such as antiresist, which will cause resistance presses to increase the enthrallment instead, theses are called from the vocal chords.
They're mostly self explainitory; antiresist, charge, pacify and heal. Heals quite weak for obvious reasons. I'd like to add more, maybe some weak adneals with brute/exhaustion costs after the status is over. A truth serum might be neat too.
State 4 pets don't get status effects.

5. Custom triggers
Because it wasnt complicated enough already.
Custom triggers are set by stating a trigger word, which will call a sub proc, which is also defined when the trigger is Called
The effects avalible at the moment are:
Speak - forces pet to say a preallocated phrase in response to the trigger
Echo - sends a message to that player only (i.e. makes them think something)
Shock - gives them a seizure/zaps them
You can look this one up yourself - it's what you expect, it's cit
kneel - gives a short knockdown
strip - strips jumpsuit only
objective - gives the pet a new objective. This requires a high ammount of mental capasity - which is determined by how much you resist. If you resist enough during phase 1 and 2, then they can't give you an objective.
Feel free to add more.
triggers work when said by ANYONE, not just the enchanter.
This is only state 3 pets, state 4 pets cannot get custom triggers, you broke them you bully.

7. If you're an antage you get a bonus to resistance AND to enthralling. Thus it can be worth using this on both sides. It shouldn't be hard to resist as an antag. There are futher bonuses to command, Chaplains and chemist.
If you give your pet a collar then their resistance reduced too.
(I think thats everything?)

Failstates:
Blowing up the reaction produces a gas that causes everyone to fall in love with one another.

Creating a chem with a low purity will make you permanently fall in love with someone, and tasked with keeping them safe. If someone else drinks it, you fall for them.
*/

/datum/reagent/fermi/enthrall
	name = "MKUltra"
	description = "A forbidden deep red mixture that increases a person's succeptability to another's words. When taken by the creator, it will enhance the draw of their voice to those affected by it."
	color = "#660015" // rgb: , 0, 255
	taste_description = "synthetic chocolate, a base tone of alcohol, and high notes of roses"
	overdose_threshold = 100 //If this is too easy to get 100u of this, then double it please.
	metabolization_rate = 0.1//It has to be slow, so there's time for the effect.
	data = list("creatorID" = null, "creatorGender" = null, "creatorName" = null)
	var/creatorID  //ckey
	var/creatorGender
	var/creatorName
	var/mob/living/creator
	pH = 10
	chemical_flags = REAGENT_ONMOBMERGE | REAGENT_DONOTSPLIT //Procs on_mob_add when merging into a human
	can_synth = FALSE


/datum/reagent/fermi/enthrall/test
	name = "MKUltraTest"
	description = "A forbidden deep red mixture that makes you like Fermis a little too much. Unobtainable and due to be removed from the wiki."
	data = list("creatorID" = "honkatonkbramblesnatch", "creatorGender" = "Mistress", "creatorName" = "Fermis Yakumo")
	creatorID  = "honkatonkbramblesnatch"//ckey
	creatorGender = "Mistress"
	creatorName = "Fermis Yakumo"
	purity = 1

/datum/reagent/fermi/enthrall/test/on_new()
	..()
	creator = get_mob_by_key(creatorID)

/datum/reagent/fermi/enthrall/on_new(list/data)
	creatorID = data["creatorID"]
	creatorGender = data["creatorGender"]
	creatorName = data["creatorName"]
	creator = get_mob_by_key(creatorID)

/datum/reagent/fermi/enthrall/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(M.client?.prefs.cit_toggles & NEVER_HYPNO) // Just in case people are opting out of this
		holder.del_reagent(type)
		return
	if(!ishuman(M))//Just to make sure screwy stuff doesn't happen.
		return
	if(!creatorID)
		//This happens when the reaction explodes.
		return
	if(purity < 0.5)//Impure chems don't function as you expect
		return
	var/datum/status_effect/chem/enthrall/E = M.has_status_effect(/datum/status_effect/chem/enthrall)
	if(E)
		if(E.enthrallID == M.ckey && creatorID != M.ckey)//If you're enthralled to yourself (from OD) and someone else tries to enthrall you, you become thralled to them instantly.
			E.enthrallID = creatorID
			E.enthrallGender = creatorGender
			E.master = get_mob_by_key(creatorID)
			to_chat(M, "<span class='big love'><i>Your addled, plastic, mind bends under the chemical influence of a new [(E.lewd?"master":"leader")]. Your highest priority is now to stay by [creatorName]'s side, following and aiding them at all costs.</i></span>") //THIS SHOULD ONLY EVER APPEAR IF YOU MINDBREAK YOURSELF AND THEN GET INJECTED FROM SOMEONE ELSE.
			log_game("FERMICHEM: Narcissist [M] ckey: [M.key] been rebound to [creatorName], ID: [creatorID]")
			return
	if((M.ckey == creatorID) && (creatorName == M.real_name)) //same name AND same player - same instance of the player. (should work for clones?)
		log_game("FERMICHEM: [M] ckey: [M.key] has been given velvetspeech")
		var/obj/item/organ/vocal_cords/Vc = M.getorganslot(ORGAN_SLOT_VOICE)
		var/obj/item/organ/vocal_cords/nVc = new /obj/item/organ/vocal_cords/velvet
		if(Vc)
			Vc.Remove()
		nVc.Insert(M)
		qdel(Vc)
		to_chat(M, "<span class='notice'><i>You feel your vocal chords tingle you speak in a more charasmatic and sultry tone.</i></span>")
	else
		log_game("FERMICHEM: MKUltra: [creatorName], [creatorID], is enthralling [M.name], [M.ckey]")
		M.apply_status_effect(/datum/status_effect/chem/enthrall)
	log_game("FERMICHEM: [M] ckey: [M.key] has taken MKUltra")

/datum/reagent/fermi/enthrall/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(purity < 0.5)//DO NOT SPLIT INTO DIFFERENT CHEM: This relies on DoNotSplit - has to be done this way.

		if (M.ckey == creatorID && creatorName == M.real_name)//If the creator drinks it, they fall in love randomly. If someone else drinks it, the creator falls in love with them.
			if(M.has_status_effect(STATUS_EFFECT_INLOVE))//Can't be enthralled when enthralled, so to speak.
				return
			var/list/seen = viewers(7, get_turf(M))
			for(var/victim in seen)
				if(ishuman(victim))
					var/mob/living/carbon/V = victim
					if((V == M) || (!V.client) || (V.stat == DEAD))
						seen = seen - victim
				else
					seen = seen - victim

			if(LAZYLEN(seen))
				return
			M.reagents.del_reagent(type)
			FallInLove(M, pick(seen))
			return

		else // If someone else drinks it, the creator falls in love with them!
			var/mob/living/carbon/C = get_mob_by_key(creatorID)
			if(M.has_status_effect(STATUS_EFFECT_INLOVE))
				return
			if((C in viewers(7, get_turf(M))) && (C.client))
				M.reagents.del_reagent(type)
				FallInLove(C, M)
			return
	if (M.ckey == creatorID && creatorName == M.real_name)//If you yourself drink it, it supresses the vocal effects, for stealth. NEVERMIND ADD THIS LATER I CAN'T GET IT TO WORK
		return
	if(!M.client)
		metabolization_rate = 0 //Stops powergamers from quitting to avoid affects. but prevents affects on players that don't exist for performance.
		return
	if(metabolization_rate == 0)
		metabolization_rate = 0.1
	var/datum/status_effect/chem/enthrall/E = M.has_status_effect(/datum/status_effect/chem/enthrall)//If purity is over 5, works as intended
	if(!E)
		return
	else
		E.enthrallTally += 1
	..()

/datum/reagent/fermi/enthrall/overdose_start(mob/living/carbon/M)//I made it so the creator is set to gain the status for someone random.
	. = ..()
	metabolization_rate = 1//Mostly to manage brain damage and reduce server stress
	if (M.ckey == creatorID && creatorName == M.real_name)//If the creator drinks 100u, then you get the status for someone random (They don't have the vocal chords though, so it's limited.)
		if (!M.has_status_effect(/datum/status_effect/chem/enthrall))
			to_chat(M, "<span class='love'><i>You are unable to resist your own charms anymore, and become a full blown narcissist.</i></span>")
	ADD_TRAIT(M, TRAIT_PACIFISM, "MKUltra")
	var/datum/status_effect/chem/enthrall/E
	if (!M.has_status_effect(/datum/status_effect/chem/enthrall))
		M.apply_status_effect(/datum/status_effect/chem/enthrall)
		E = M.has_status_effect(/datum/status_effect/chem/enthrall)
		E.enthrallID = creatorID
		E.enthrallGender = creatorGender
		E.master = creator
	else
		E = M.has_status_effect(/datum/status_effect/chem/enthrall)
	if(E.lewd)
		to_chat(M, "<span class='big love'><i>Your mind shatters under the volume of the mild altering chem inside of you, breaking all will and thought completely. Instead the only force driving you now is the instinctual desire to obey and follow [creatorName]. Your highest priority is now to stay by their side and protect them at all costs.</i></span>")
	else
		to_chat(M, "<span class='big warning'><i>The might volume of chemicals in your system overwhelms your mind, and you suddenly agree with what [creatorName] has been saying. Your highest priority is now to stay by their side and protect them at all costs.</i></span>")
	log_game("FERMICHEM: [M] ckey: [M.key] has been mindbroken for [creatorName] ckey: [creatorID]")
	M.slurring = 100
	M.confused = 100
	E.phase = 4
	E.mental_capacity = 0
	E.customTriggers = list()
	SSblackbox.record_feedback("tally", "fermi_chem", 1, "Thralls mindbroken")

/datum/reagent/fermi/enthrall/overdose_process(mob/living/carbon/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2)//should be ~30 in total
	..()

//Creates a gas cloud when the reaction blows up, causing everyone in it to fall in love with someone/something while it's in their system.
/datum/reagent/fermi/enthrallExplo//Created in a gas cloud when it explodes
	name = "Gaseous MKUltra"
	description = "A forbidden deep red gas that overwhelms a foreign body, causing the person they next lay their eyes on to become more interesting. Studies have shown that people are 66% more likely to make friends with this in the air. Produced when MKUltra explodes."
	color = "#2C051A" // rgb: , 0, 255
	metabolization_rate = 0.1
	taste_description = "synthetic chocolate, a base tone of alcohol, and high notes of roses."
	chemical_flags = REAGENT_DONOTSPLIT
	can_synth = FALSE
	var/mob/living/carbon/love
	var/lewd = FALSE

/datum/reagent/fermi/enthrallExplo/on_mob_life(mob/living/carbon/M)//Love gas, only affects while it's in your system,Gives a positive moodlet if close, gives brain damagea and a negative moodlet if not close enough.
	if(HAS_TRAIT(M, TRAIT_MINDSHIELD))
		return ..()
	if(!M.has_status_effect(STATUS_EFFECT_INLOVE))
		var/list/seen = viewers(7, get_turf(M))//Sound and sight checkers
		for(var/victim in seen)
			if((istype(victim, /mob/living/simple_animal/pet/)) || (victim == M) || (M.stat == DEAD) || (!isliving(victim)))
				seen = seen - victim
		if(seen.len == 0)
			return
		love = pick(seen)
		if(!love)
			return
		M.apply_status_effect(STATUS_EFFECT_INLOVE, love)
		lewd = (M.client?.prefs.cit_toggles & HYPNO) && (love.client?.prefs.cit_toggles & HYPNO)
		to_chat(M, "[(lewd?"<span class='love'>":"<span class='warning'>")][(lewd?"You develop a sudden crush on [love], your heart beginning to race as you look upon them with new eyes.":"You suddenly feel like making friends with [love].")] You feel strangely drawn towards them.</span>")
		log_game("FERMICHEM: [M] ckey: [M.key] has temporarily bonded with [love] ckey: [love.key]")
		SSblackbox.record_feedback("tally", "fermi_chem", 1, "Times people have bonded")
	else
		if(get_dist(M, love) < 8)
			var/message = "[(lewd?"I'm next to my crush..! Eee!":"I'm making friends with [love]!")]"
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "InLove", /datum/mood_event/InLove, message)
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "MissingLove")
		else
			var/message = "[(lewd?"I can't keep my crush off my mind, I need to see them again!":"I really want to make friends with [love]!")]"
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "MissingLove", /datum/mood_event/MissingLove, message)
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "InLove")
			if(prob(5))
				M.Stun(10)
				M.emote("whimper")//does this exist?
				to_chat(M, "[(lewd?"<span class='love'>":"<span class='warning'>")] You're overcome with a desire to see [love].</span>")
				M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5)//I found out why everyone was so damaged!
	..()

/datum/reagent/fermi/enthrallExplo/on_mob_delete(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_MINDSHIELD))
		return ..()
	M.remove_status_effect(STATUS_EFFECT_INLOVE)
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "InLove")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "MissingLove")
	to_chat(M, "[(lewd?"<span class='love'>":"<span class='warning'>")]Your feelings for [love] suddenly vanish!")
	log_game("FERMICHEM: [M] ckey: [M.key] is no longer in temp bond")
	..()

/datum/reagent/fermi/proc/FallInLove(mob/living/carbon/Lover, mob/living/carbon/Love)
	if(Lover.client?.prefs.cit_toggles & NEVER_HYPNO)
		return // doesn't even give a message, it's just ignored
	if(Lover.has_status_effect(STATUS_EFFECT_INLOVE))
		to_chat(Lover, "<span class='warning'>You are already fully devoted to someone else!</span>")
		return
	var/lewd = (Lover.client?.prefs.cit_toggles & HYPNO) && (Love.client?.prefs.cit_toggles & HYPNO)
	to_chat(Lover, "[(lewd?"<span class='love'>":"<span class='warning'>")]You develop a deep and sudden bond with [Love][(lewd?", your heart beginning to race as your mind filles with thoughts about them.":".")] You are determined to keep them safe and happy, and feel drawn towards them.</span>")
	if(Lover.mind)
		Lover.mind.store_memory("You are in love with [Love].")
	Lover.faction |= "[REF(Love)]"
	Lover.apply_status_effect(STATUS_EFFECT_INLOVE, Love)
	forge_valentines_objective(Lover, Love, TRUE)
	SSblackbox.record_feedback("tally", "fermi_chem", 1, "Times people have become infatuated.")
	log_game("FERMICHEM: [Lover] ckey: [Lover.key] has been chemically made to fall for [Love] ckey: [Love.key]")
	return

//For addiction see chem.dm
//For vocal commands see vocal_cords.dm

/*SDGF
////////////////////////////////////////////////////
// 		synthetic-derived growth factor			 //
//////////////////////////////////////////////////
other files that are relivant:
modular_citadel/code/datums/status_effects/chems.dm - SDGF
WHAT IT DOES

Several outcomes are possible (in priority order):

Before the chem is even created, there is a risk of the reaction "exploding", which produces an angry teratoma that attacks the player.
0. Before the chem is activated, the purity is checked, if the purity of the reagent is less than 0.5, then sythetic-derived zombie factor is metabolised instead
	0.1 If SDZF is injected, the chem appears to act the same as normal, with nutrition gain, until the end, where it becomes toxic instead, giving a short window of warning to the player
		0.1.2 If the player can take pent in time, the player will spawn a hostile teratoma on them (less damaging), if they don't, then a zombie is spawned instead, with a small defence increase propotional to the volume
	0.2 If the purity is above 0.5, then the remaining impure volume created SDGFtox instead, which reduces blood volume and causes clone damage
1.Normal function creates a (another)player controlled clone of the player, which is spawned nude, with damage to the clone
	1.1 The remaining volume is transferred to the clone, which heals it over time, thus the player has to make a substantial ammount of the chem in order to produce a healthy clone
	1.2 If the player is infected with a zombie tumor, the tumor is transferred to the ghost controlled clone ONLY.
2. If no player can be found, a brainless clone is created over a long period of time, this body has no controller.
	2.1 If the player dies with a clone, then they play as the clone instead. However no memories are retained after splitting.
3. If there is already a clone, then SDGF heals clone, fire and brute damage slowly. This shouldn't normalise this chem as the de facto clone healing chem, as it will always try to make a ghost clone, and then a brainless clone first.
4. If there is insuffient volume to complete the cloning process, there are two outcomes
	4.1 At lower volumes, the players nutrition and blood is refunded, with light healing
	4.2 At higher volumes a stronger heal is applied to the user

IMPORTANT FACTORS TO CONSIDER WHILE BALANCING
1. The most important factor is the required volume, this is easily edited with the metabolism rate, this chem is HARD TO MAKE, You need to make a lot of it and it's a substantial effort on the players part. There is also a substantial risk; you could spawn a hotile teratoma during the reation, you could damage yourself with clone damage, you could accidentally spawn a zombie... Basically, you've a good chance of killing yourself.
	1.1 Additionally, if you're trying to make SDZF purposely, you've no idea if you have or not, and that reaction is even harder to do. Plus, the player has a huge time window to get to medical to deal with it. If you take pent while it's in you, it'll be removed before it can spawn, and only spawns a teratoma if it's late stage.
2. The rate in which the clone is made, This thing takes time to produce fruits, it slows you down and makes you useless in combat/working. Basically you can't do anything during it. It will only get you killed if you use it in combat, If you do use it and you spawn a player clone, they're gimped for a long time, as they have to heal off the clone damage.
3. The healing - it's pretty low and a cyropod is more Useful
4. If you're an antag, you've a 50% chance of making a clone that will help you with your efforts, and you've no idea if they will or not. While clones can't directly harm you and care for you, they can hinder your efforts.
5. If people are being arses when they're a clone, slap them for it, they are told to NOT bugger around with someone else character, if it gets bad I'll add a blacklist, or do a check to see if you've played X amount of hours.
	5.1 Another solution I'm okay with is to rename the clone to [M]'s clone, so it's obvious, this obviously ruins anyone trying to clone themselves to get an alibi however. I'd prefer this to not be the case.
	5.2 Additionally, this chem is a soft buff to changelings, which apparently need a buff!
	5.3 Other similar things exist already though in the codebase; impostors, split personalites, abductors, ect.
6. Giving this to someone without concent is against space law and gets you sent to gulag.
*/

//Clone serum #chemClone
/datum/reagent/fermi/SDGF //vars, mostly only care about keeping track if there's a player in the clone or not.
	name = "synthetic-derived growth factor"
	description = "A rapidly diving mass of Embryonic stem cells. These cells are missing a nucleus and quickly replicate a host’s DNA before growing to form an almost perfect clone of the host. In some cases neural replication takes longer, though the underlying reason underneath has yet to be determined."
	color = "#a502e0" // rgb: 96, 0, 255
	var/playerClone = FALSE
	var/unitCheck = FALSE
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "a weird chemical fleshy flavour"
	var/list/candies = list()
	var/pollStarted = FALSE
	var/startHunger
	impure_chem 			= /datum/reagent/impure/SDGFtox
	inverse_chem_val 		= 0.5
	inverse_chem		= /datum/reagent/impure/SDZF
	can_synth = TRUE


//Main SDGF chemical
/datum/reagent/fermi/SDGF/on_mob_life(mob/living/carbon/M) //Clones user, then puts a ghost in them! If that fails, makes a braindead clone.
	//Setup clone
	switch(current_cycle)
		if(1)
			startHunger = M.nutrition
			if(pollStarted == FALSE)
				pollStarted = TRUE
				candies = pollGhostCandidates("Do you want and agree to play as a clone of [M], respect their character and not engage in ERP without permission from the original?", ignore_category = POLL_IGNORE_CLONE)
				log_game("FERMICHEM: [M] ckey: [M.key] has taken SDGF, and ghosts have been polled.")
		if(20 to INFINITY)
			if(LAZYLEN(candies) && playerClone == FALSE) //If there's candidates, clone the person and put them in there!
				to_chat(M, "<span class='warning'>The cells reach a critical micelle concentration, nucleating rapidly within your body!</span>")
				var/typepath = M.type
				var/mob/living/carbon/human/fermi_Gclone = new typepath(M.loc)
				var/mob/living/carbon/human/SM = fermi_Gclone
				if(istype(SM) && istype(M))
					SM.real_name = M.real_name
					M.dna.transfer_identity(SM)
					SM.updateappearance(mutcolor_update=1)

				//Process the willing ghosts, and make sure they're actually in the body when they're moved into it!
				candies = shuffle(candies)//Shake those ghosts up!
				for(var/mob/dead/observer/C2 in candies)
					if(C2.key && C2)
						C2.transfer_ckey(SM, FALSE)
						message_admins("Ghost candidate found! [C2] key [C2.key] is becoming a clone of [M] key: [M.key] (They agreed to respect the character they're becoming, and agreed to not ERP without express permission from the original.)")
						log_game("FERMICHEM: [M] ckey: [M.key] is creating a clone, controlled by [C2]")
						break
					else
						candies -= C2
				if(!SM.mind) //Something went wrong, use alt mechanics
					return ..()
				SM.mind.enslave_mind_to_creator(M)
				SM.mind.store_memory(M.mind.memory)

				//If they're a zombie, they can try to negate it with this.
				//I seriously wonder if anyone will ever use this function.
				if(M.getorganslot(ORGAN_SLOT_ZOMBIE))//sure, it "treats" it, but "you've" still got it. Doesn't always work as well; needs a ghost.
					var/obj/item/organ/zombie_infection/ZI = M.getorganslot(ORGAN_SLOT_ZOMBIE)
					ZI.Remove()
					ZI.Insert(SM)
					log_game("FERMICHEM: [M] ckey: [M.key]'s zombie_infection has been transferred to their clone")

				to_chat(SM, "<span class='warning'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with your original, a perfect clone of your origin.</span>")

				if(prob(50))
					to_chat(SM, "<span class='userdanger'>While you find your newfound existence strange, you share the same memories as [M.real_name]. However, You find yourself indifferent to the goals you previously had, and take more interest in your newfound independence, but still have an indescribable care for the safety of your original.</span>")
					log_game("FERMICHEM: [SM] ckey: [SM.key]'s is not bound by [M] ckey [M.key]'s will, and is free to determine their own goals, while respecting and acting as their origin.")
				else
					to_chat(SM, "<span class='userdanger'>While you find your newfound existence strange, you share the same memories as [M.real_name]. Your mind has not deviated from the tasks you set out to do, and now that there's two of you the tasks should be much easier.</span>")
					log_game("FERMICHEM: [SM] ckey: [SM.key]'s is bound by [M] ckey [M.key]'s objectives, and is encouraged to help them complete them.")

				to_chat(M, "<span class='warning'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself.</span>")
				M.visible_message("[M] suddenly shudders, and splits into two identical twins!")
				SM.copy_known_languages_from(M, FALSE)
				playerClone =  TRUE
				M.next_move_modifier = 1
				M.nutrition -= 500

				//Damage the clone
				SM.blood_volume = (BLOOD_VOLUME_NORMAL*SM.blood_ratio)/2
				SM.adjustCloneLoss(60, 0)
				SM.setOrganLoss(ORGAN_SLOT_BRAIN, 40)
				SM.nutrition = startHunger/2

				//Transfer remaining reagent to clone. I think around 30u will make a healthy clone, otherwise they'll have clone damage, blood loss, brain damage and hunger.
				SM.reagents.add_reagent(/datum/reagent/fermi/SDGFheal, volume)
				M.reagents.remove_reagent(type, volume)
				log_game("FERMICHEM: [volume]u of SDGFheal has been transferred to the clone")
				SSblackbox.record_feedback("tally", "fermi_chem", 1, "Sentient clones made")
				return ..()

			else if(playerClone == FALSE) //No candidates leads to two outcomes; if there's already a braincless clone, it heals the user, as well as being a rare souce of clone healing (thematic!).
				unitCheck = TRUE
				if(M.has_status_effect(/datum/status_effect/chem/SGDF)) // Heal the user if they went to all this trouble to make it and can't get a clone, the poor fellow.
					switch(current_cycle)
						if(21)
							to_chat(M, "<span class='notice'>The cells fail to catalyse around a nucleation event, instead merging with your cells.</span>") //This stuff is hard enough to make to rob a user of some benefit. Shouldn't replace Rezadone as it requires the user to not only risk making a player controlled clone, but also requires them to have split in two (which also requires 30u of SGDF).
							REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC)
							log_game("FERMICHEM: [M] ckey: [M.key] is being healed by SDGF")
						if(22 to INFINITY)
							M.adjustCloneLoss(-1, 0)
							M.adjustBruteLoss(-1, 0)
							M.adjustFireLoss(-1, 0)
							M.heal_bodypart_damage(1,1)
							M.reagents.remove_reagent(type, 1)//faster rate of loss.
				else //If there's no ghosts, but they've made a large amount, then proceed to make flavourful clone, where you become fat and useless until you split.
					switch(current_cycle)
						if(21)
							to_chat(M, "<span class='notice'>You feel the synethic cells rest uncomfortably within your body as they start to pulse and grow rapidly.</span>")
						if(22 to 29)
							M.nutrition = M.nutrition + (M.nutrition/10)
						if(30)
							to_chat(M, "<span class='notice'>You feel the synethic cells grow and expand within yourself, bloating your body outwards.</span>")
						if(31 to 49)
							M.nutrition = M.nutrition + (M.nutrition/5)
						if(50)
							to_chat(M, "<span class='notice'>The synthetic cells begin to merge with your body, it feels like your body is made of a viscous water, making your movements difficult.</span>")
							M.next_move_modifier += 4//If this makes you fast then please fix it, it should make you slow!!
							//candidates = pollGhostCandidates("Do you want to play as a clone of [M.name] and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 300) // see poll_ignore.dm, should allow admins to ban greifers or bullies
						if(51 to 79)
							M.nutrition = M.nutrition + (M.nutrition/2)
						if(80)
							to_chat(M, "<span class='notice'>The cells begin to precipitate outwards of your body, you feel like you'll split soon...</span>")
							if (M.nutrition < 20000)
								M.nutrition = 20000 //https://www.youtube.com/watch?v=Bj_YLenOlZI
						if(86)//Upon splitting, you get really hungry and are capable again. Deletes the chem after you're done.
							M.nutrition = 15//YOU BEST BE EATTING AFTER THIS YOU CUTIE
							M.next_move_modifier -= 4
							to_chat(M, "<span class='notice'>Your body splits away from the cell clone of yourself, leaving you with a drained and hollow feeling inside.</span>")

							//clone
							var/typepath = M.type
							var/mob/living/fermi_Clone = new typepath(M.loc)
							var/mob/living/carbon/C = fermi_Clone

							if(istype(C) && istype(M))
								C.real_name = M.real_name
								M.dna.transfer_identity(C, transfer_SE=1)
								C.updateappearance(mutcolor_update=1)
							C.apply_status_effect(/datum/status_effect/chem/SGDF)
							var/datum/status_effect/chem/SGDF/S = C.has_status_effect(/datum/status_effect/chem/SGDF)
							S.original = M
							S.originalmind = M.mind
							S.status_set = TRUE

							log_game("FERMICHEM: [M] ckey: [M.key] has created a mindless clone of themselves")
							SSblackbox.record_feedback("tally", "fermi_chem", 1, "Braindead clones made")
						if(87 to INFINITY)
							M.reagents.remove_reagent(type, volume)//removes SGDF on completion. Has to do it this way because of how i've coded it. If some madlab gets over 1k of SDGF, they can have the clone healing.


	..()

/datum/reagent/fermi/SDGF/on_mob_delete(mob/living/M) //When the chem is removed, a few things can happen, mostly consolation prizes.
	pollStarted = FALSE
	if (playerClone == TRUE)//If the player made a clone with it, then thats all they get.
		playerClone = FALSE
		return
	if (M.next_move_modifier == 4 && !M.has_status_effect(/datum/status_effect/chem/SGDF))//checks if they're ingested over 20u of the stuff, but fell short of the required 30u to make a clone.
		to_chat(M, "<span class='notice'>You feel the cells begin to merge with your body, unable to reach nucleation, they instead merge with your body, healing any wounds.</span>")
		M.adjustCloneLoss(-10, 0) //I don't want to make Rezadone obsolete.
		M.adjustBruteLoss(-25, 0)// Note that this takes a long time to apply and makes you fat and useless when it's in you, I don't think this small burst of healing will be useful considering how long it takes to get there.
		M.adjustFireLoss(-25, 0)
		M.blood_volume += 250
		M.heal_bodypart_damage(1,1)
		M.next_move_modifier = 1
		if (M.nutrition < 1500)
			M.nutrition += 250
	else if (unitCheck == TRUE && !M.has_status_effect(/datum/status_effect/chem/SGDF))// If they're ingested a little bit (10u minimum), then give them a little healing.
		unitCheck = FALSE
		to_chat(M, "<span class='notice'>the cells fail to hold enough mass to generate a clone, instead diffusing into your system.</span>")
		M.adjustBruteLoss(-10, 0)
		M.adjustFireLoss(-10, 0)
		M.blood_volume += 100
		M.next_move_modifier = 1
		if (M.nutrition < 1500)
			M.nutrition += 500

/datum/reagent/fermi/SDGF/reaction_mob(mob/living/carbon/human/M, method=TOUCH, reac_volume)
	if(volume<5)
		M.visible_message("<span class='warning'>The growth factor froths upon [M]'s body, failing to do anything of note.</span>")
		return
	if(M.stat == DEAD)
		if(M.suiciding || (HAS_TRAIT(M, TRAIT_NOCLONE)) || M.hellbound)
			M.visible_message("<span class='warning'>The growth factor inertly sticks to [M]'s body, failing to do anything of note.</span>")
			return
		if(!M.mind)
			M.visible_message("<span class='warning'>The growth factor shudders, merging with [M]'s body, but is unable to replicate properly.</span>")

		var/bodydamage = (M.getBruteLoss() + M.getFireLoss())
		var/typepath = M.type
		volume =- 5

		var/mob/living/carbon/human/fermi_Gclone = new typepath(M.loc)
		var/mob/living/carbon/human/SM = fermi_Gclone
		if(istype(SM) && istype(M))
			SM.real_name = M.real_name
			M.dna.transfer_identity(SM)
			SM.updateappearance(mutcolor_update=1)
		M.mind.transfer_to(SM)
		M.visible_message("<span class='warning'>[M]'s body shudders, the growth factor rapidly splitting into a new clone of [M].</span>")

		if(bodydamage>50)
			SM.adjustOxyLoss(-(bodydamage/10), 0)
			SM.adjustToxLoss(-(bodydamage/10), 0)
			SM.blood_volume = (BLOOD_VOLUME_NORMAL*SM.blood_ratio)/1.5
			SM.adjustCloneLoss((bodydamage/10), 0)
			SM.setOrganLoss(ORGAN_SLOT_BRAIN, (bodydamage/10))
			SM.nutrition = 400
		if(bodydamage>200)
			SM.gain_trauma_type(BRAIN_TRAUMA_MILD)
		if(bodydamage>300)
			var/obj/item/bodypart/l_arm = SM.get_bodypart(BODY_ZONE_L_ARM) //We get the body parts we want this way.
			var/obj/item/bodypart/r_arm = SM.get_bodypart(BODY_ZONE_R_ARM)
			l_arm.drop_limb()
			r_arm.drop_limb()
		if(bodydamage>400)
			var/obj/item/bodypart/l_leg = SM.get_bodypart(BODY_ZONE_L_LEG) //We get the body parts we want this way.
			var/obj/item/bodypart/r_leg = SM.get_bodypart(BODY_ZONE_R_LEG)
			l_leg.drop_limb()
			r_leg.drop_limb()
		if(bodydamage>500)
			SM.gain_trauma_type(BRAIN_TRAUMA_SEVERE)
		if(bodydamage>600)
			var/datum/species/mutation = pick(subtypesof(/datum/species))
			SM.set_species(mutation)

		//Transfer remaining reagent to clone. I think around 30u will make a healthy clone, otherwise they'll have clone damage, blood loss, brain damage and hunger.
		SM.reagents.add_reagent(/datum/reagent/fermi/SDGFheal, volume)
		log_combat(M, M, "SDGF clone-vived", src)
		M.reagents.del_reagent(type)
		SM.updatehealth()
		SM.emote("gasp")
		return
	..()

//Unobtainable, used in clone spawn.
/datum/reagent/fermi/SDGFheal
	name = "synthetic-derived healing factor"
	description = "Leftover SDGF is transferred into the resulting clone, which quickly heals up the stresses from suddenly splitting. Restores blood, nutrition, and repaires brain and clone damage quickly. Only obtainable from using excess SDGF, and only enters the cloned body."
	metabolization_rate = 0.8
	can_synth = FALSE

/datum/reagent/fermi/SDGFheal/on_mob_life(mob/living/carbon/M)//Used to heal the clone after splitting, the clone spawns damaged. (i.e. insentivies players to make more than required, so their clone doesn't have to be treated)
	if(M.blood_volume < (BLOOD_VOLUME_NORMAL*M.blood_ratio))
		M.blood_volume += 10
	M.adjustCloneLoss(-2, 0)
	M.setOrganLoss(ORGAN_SLOT_BRAIN, -1)
	M.nutrition += 10
	..()

//Unobtainable, used if SDGF is impure but not too impure
/datum/reagent/impure/SDGFtox
	name = "Synthetic-derived apoptosis factor"
	description = "Impure synthetic-derived growth factor causes certain cells to undergo cell death, causing clone damage, and damaging blood cells."//i.e. tell me please, figure it's a good way to get pinged for bugfixes.
	metabolization_rate = 1
	can_synth = FALSE

/datum/reagent/impure/SDGFtox/on_mob_life(mob/living/carbon/M)//Damages the taker if their purity is low. Extended use of impure chemicals will make the original die. (thus can't be spammed unless you've very good)
	M.blood_volume -= 10
	M.adjustCloneLoss(2, 0)
	..()

//Fail state of SDGF
/datum/reagent/impure/SDZF
	name = "synthetic-derived zombie factor"
	description = "A horribly peverse mass of Embryonic stem cells made real by the hands of a failed chemist. Emulates normal synthetic-derived growth factor, but produces a hostile zombie at the end of it."
	color = "#a502e0" // rgb: 96, 0, 255
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	var/startHunger
	can_synth = TRUE
	taste_description = "a weird chemical fleshy flavour"
	chemical_flags = REAGENT_SNEAKYNAME

/datum/reagent/impure/SDZF/on_mob_life(mob/living/carbon/M) //If you're bad at fermichem, turns your clone into a zombie instead.
	switch(current_cycle)//Pretends to be normal
		if(20)
			to_chat(M, "<span class='notice'>You feel the synethic cells rest uncomfortably within your body as they start to pulse and grow rapidly.</span>")
			startHunger = M.nutrition
		if(21 to 29)
			M.nutrition = M.nutrition + (M.nutrition/10)
		if(30)
			to_chat(M, "<span class='notice'>You feel the synethic cells grow and expand within yourself, bloating your body outwards.</span>")
		if(31 to 49)
			M.nutrition = M.nutrition + (M.nutrition/5)
		if(50)
			to_chat(M, "<span class='notice'>The synethic cells begin to merge with your body, it feels like your body is made of a viscous water, making your movements difficult.</span>")
			M.next_move_modifier = 4//If this makes you fast then please fix it, it should make you slow!!
		if(51 to 73)
			M.nutrition = M.nutrition + (M.nutrition/2)
		if(74)
			to_chat(M, "<span class='notice'>The cells begin to precipitate outwards of your body, but... something is wrong, the sythetic cells are beginnning to rot...</span>")
			if (M.nutrition < 20000) //whoever knows the maxcap, please let me know, this seems a bit low.
				M.nutrition = 20000 //https://www.youtube.com/watch?v=Bj_YLenOlZI
		if(75 to 85)
			M.adjustToxLoss(1, 0)// the warning!

		if(86)//mean clone time!
			if (!M.reagents.has_reagent(/datum/reagent/medicine/pen_acid))//Counterplay is pent.)
				message_admins("(non-infectious) SDZF: Zombie spawned at [M] [COORD(M)]!")
				M.nutrition = startHunger - 500//YOU BEST BE RUNNING AWAY AFTER THIS YOU BADDIE
				M.next_move_modifier = 1
				to_chat(M, "<span class='warning'>Your body splits away from the cell clone of yourself, your attempted clone birthing itself violently from you as it begins to shamble around, a terrifying abomination of science.</span>")
				M.visible_message("[M] suddenly shudders, and splits into a funky smelling copy of themselves!")
				M.emote("scream")
				M.adjustToxLoss(30, 0)
				var/mob/living/simple_animal/hostile/unemployedclone/ZI = new(get_turf(M.loc))
				ZI.damage_coeff = list(BRUTE = ((1 / volume)**0.25) , BURN = ((1 / volume)**0.1), TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
				ZI.real_name = M.real_name//Give your offspring a big old kiss.
				ZI.name = M.real_name
				ZI.desc = "[M]'s clone, gone horribly wrong."
				log_game("FERMICHEM: [M] ckey: [M.key]'s clone has become a horrifying zombie instead")
				M.reagents.remove_reagent(type, 20)

			else//easier to deal with
				to_chat(M, "<span class='notice'>The pentetic acid seems to have stopped the decay for now, clumping up the cells into a horrifying tumour!</span>")
				M.nutrition = startHunger - 500
				var/mob/living/simple_animal/slime/S = new(get_turf(M.loc),"grey") //TODO: replace slime as own simplemob/add tumour slime cores for science/chemistry interplay
				S.damage_coeff = list(BRUTE = ((1 / volume)**0.1) , BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
				S.name = "Living teratoma"
				S.real_name = "Living teratoma"//horrifying!!
				S.rabid = 1//Make them an angery boi
				M.reagents.remove_reagent(type, volume)
				to_chat(M, "<span class='warning'>A large glob of the tumour suddenly splits itself from your body. You feel grossed out and slimey...</span>")
				log_game("FERMICHEM: [M] ckey: [M.key]'s clone has become a horrifying teratoma instead")
				SSblackbox.record_feedback("tally", "fermi_chem", 1, "Zombie clones made!")

		if(87 to INFINITY)
			M.adjustToxLoss(2, 0)
			M.reagents.remove_reagent(type, 1)
	..()

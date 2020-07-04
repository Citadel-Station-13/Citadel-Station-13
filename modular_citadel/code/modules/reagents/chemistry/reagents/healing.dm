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
	value = REAGENT_VALUE_VERY_RARE

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


/datum/reagent/synthtissue
	name = "Synthtissue"
	description = "Synthetic tissue used for grafting onto damaged organs during surgery, or for treating limb damage. Has a very tight growth window between 305-320, any higher and the temperature will cause the cells to die. Additionally, growth time is considerably long, so chemists are encouraged to leave beakers with said reaction ongoing, while they tend to their other duties."
	pH = 7.6
	metabolization_rate = 0.05 //Give them time to graft
	data = list("grown_volume" = 0, "injected_vol" = 0)
	var/borrowed_health
	color = "#FFDADA"
	value = REAGENT_VALUE_COMMON

/datum/reagent/synthtissue/reaction_mob(mob/living/M, method=TOUCH, reac_volume,show_message = 1)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/healing_factor = (((data["grown_volume"] / 100) + 1)*reac_volume)
		if(method in list(PATCH, TOUCH))
			if (M.stat == DEAD)
				M.visible_message("The synthetic tissue rapidly grafts into [M]'s wounds, attemping to repair the damage as quickly as possible.")
				borrowed_health += healing_factor
				M.adjustBruteLoss(-healing_factor*2)
				M.adjustFireLoss(-healing_factor*2)
				M.adjustToxLoss(-healing_factor)
				M.adjustCloneLoss(-healing_factor)
				M.updatehealth()
				if(data["grown_volume"] > 135 && ((C.health + C.oxyloss)>=80))
					if(M.revive())
						M.emote("gasp")
						borrowed_health *= 2
						if(borrowed_health < 100)
							borrowed_health = 100
						log_combat(M, M, "revived", src)
			else
				M.adjustBruteLoss(-healing_factor)
				M.adjustFireLoss(-healing_factor)
				to_chat(M, "<span class='danger'>You feel your flesh merge with the synthetic tissue! It stings like hell!</span>")
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "painful_medicine", /datum/mood_event/painful_medicine)
		if(method==INJECT)
			data["injected_vol"] = reac_volume
			var/obj/item/organ/heart/H = C.getorganslot(ORGAN_SLOT_HEART)
			if(data["grown_volume"] > 50 && H.organ_flags & ORGAN_FAILING)
				H.applyOrganDamage(-20)
	..()

/datum/reagent/synthtissue/on_mob_life(mob/living/carbon/C)
	if(!iscarbon(C))
		return ..()
	if(data["injected_vol"] > 14)
		if(data["grown_volume"] > 175) //I don't think this is even possible, but damn to I want to see if someone can (bare in mind it takes 2s to grow 0.05u)
			if(volume >= 14)
				if(C.regenerate_organs(only_one = TRUE))
					C.reagents.remove_reagent(type, 15)
					to_chat(C, "<span class='notice'>You feel something reform inside of you!</span>")

	data["injected_vol"] -= metabolization_rate
	if(borrowed_health)
		C.adjustToxLoss(1)
		C.adjustCloneLoss(1)
		borrowed_health -= 1
	..()

/datum/reagent/synthtissue/on_merge(passed_data)
	if(!passed_data)
		return ..()
	if(passed_data["grown_volume"] > data["grown_volume"])
		data["grown_volume"] = passed_data["grown_volume"]
	if(iscarbon(holder.my_atom))
		data["injected_vol"] = data["injected_vol"] + passed_data["injected_vol"]
		passed_data["injected_vol"] = 0
	update_name()
	..()

/datum/reagent/synthtissue/on_new(passed_data)
	if(!passed_data)
		return ..()
	if(passed_data["grown_volume"] > data["grown_volume"])
		data["grown_volume"] = passed_data["grown_volume"]
	update_name()
	..()

/datum/reagent/synthtissue/proc/update_name() //They are but babes on creation and have to grow unto godhood
	switch(data["grown_volume"])
		if(-INFINITY to 50)
			name = "Induced Synthtissue Colony"
		if(50 to 80)
			name = "Oligopotent Synthtissue Colony"
		if(80 to 135)
			name = "Pluripotent Synthtissue Colony"
		if(135 to 175)
			name = "SuperSomatic Synthtissue Colony"
		if(175 to INFINITY)
			name = "Omnipotent Synthtissue Colony"

/datum/reagent/synthtissue/on_mob_delete(mob/living/M)
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	C.adjustBruteLoss(borrowed_health*1.25)
	C.adjustToxLoss(borrowed_health*1.25)
	C.adjustCloneLoss(borrowed_health*1.25)
	C.adjustAllOrganLoss(borrowed_health*0.25)
	M.updatehealth()
	if(borrowed_health && C.health < -20)
		M.stat = DEAD
		M.visible_message("The synthetic tissue degrades off [M]'s wounds as they collapse to the floor.")
//NEEDS ON_MOB_DEAD()

/datum/reagent/fermi/zeolites
	name = "Artificial Zeolites"
	description = "Lab made Zeolite, used to clear radiation from people and items alike! Splashing just a small amount(5u) onto any item can clear away large amounts of contamination."
	pH = 8
	color = "#FFDADA"
	metabolization_rate = 8 * REAGENTS_METABOLISM //Metabolizes fast but heals a lot!
	value = REAGENT_VALUE_COMMON

/datum/reagent/fermi/zeolites/on_mob_life(mob/living/carbon/M)
	var/datum/component/radioactive/contamination = M.GetComponent(/datum/component/radioactive)
	if(M.radiation > 0)
		M.radiation -= min(M.radiation, 60)
	if(contamination.strength > 0)
		contamination.strength -= min(contamination.strength, 100)
	..()

/datum/reagent/fermi/zeolites/reaction_obj(obj/O, reac_volume)
	var/datum/component/radioactive/contamination = O.GetComponent(/datum/component/radioactive)
	if(contamination && reac_volume >= 5)
		qdel(contamination)
		return

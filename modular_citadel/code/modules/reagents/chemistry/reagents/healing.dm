/datum/reagent/fermi/yamerol
	name = "Yamerol"
	id = "yamerol"
	description = "For when you've trouble speaking or breathing, just yell YAMEROL! A chem that helps soothe any congestion problems and at high concentrations restores damaged lungs and tongues!"
	taste_description = "a weird, syrupy flavour, yamero"
	color = "#68e83a"
	pH = 8.6
	overdose_threshold = 35
	impure_chem 			= "yamerol_tox"
	inverse_chem_val 		= 0.4
	inverse_chem		= "yamerol_tox"
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
			T.Remove(C)
			qdel(T)
			nT.Insert(C)
			to_chat(C, "<span class='notice'>You feel your tongue.... unfluffify...?</span>")
			holder.remove_reagent(src.id, "10")
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
			holder.remove_reagent(src.id, "10")
		else
			if((oT.name == "fluffy tongue") && (purity == 1))
				var/obj/item/organ/tongue/T
				if(C.dna && C.dna.species && C.dna.species.mutanttongue)
					T = new C.dna.species.mutanttongue()
				else
					T = new()
				oT.Remove(C)
				qdel(oT)
				T.Insert(C)
				to_chat(C, "<span class='notice'>You feel your tongue.... unfluffify...?</span>")
				holder.remove_reagent(src.id, "10")

		if(!C.getorganslot(ORGAN_SLOT_LUNGS))
			var/obj/item/organ/lungs/yamerol/L = new()
			L.Insert(C)
			to_chat(C, "<span class='notice'>You feel the yamerol merge in your chest.</span>")
			holder.remove_reagent(src.id, "10")

	C.adjustOxyLoss(-3)
	..()

/datum/reagent/impure/yamerol_tox
	name = "Yamer oh no"
	id = "yamerol_tox"
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
	id = "synthtissue"
	description = "Synthetic tissue used for grafting onto damaged organs during surgery, or for treating limb damage. Has a very tight growth window between 305-320, any higher and the temperature will cause the cells to die. Additionally, growth time is considerably long, so chemists are encouraged to leave beakers with said reaction ongoing, while they tend to their other duties."
	pH = 7.6
	metabolization_rate = 0.05 //Give them time to graft
	data = list("grown_volume" = 0, "injected_vol" = 0)

/datum/reagent/synthtissue/reaction_mob(mob/living/M, method=TOUCH, reac_volume,show_message = 1)
	if(iscarbon(M))
		var/target = M.zone_selected
		if (M.stat == DEAD)
			show_message = 0
		if(method in list(PATCH, TOUCH))
			M.apply_damage(reac_volume*-1.5, BRUTE, target)
			M.apply_damage(reac_volume*-1.5, BURN, target)
			if(show_message)
				to_chat(M, "<span class='danger'>You feel your [target] heal! It stings like hell!</span>")
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "painful_medicine", /datum/mood_event/painful_medicine)
	if(method==INJECT)
		data["injected_vol"] = reac_volume
	..()

/datum/reagent/synthtissue/on_mob_life(mob/living/carbon/C)
	if(!iscarbon(C))
		return ..()
	if(data["injected_vol"] > 14)
		if(data["grown_volume"] > 175) //I don't think this is even possible, but damn to I want to see if someone can (bare in mind it takes 2s to grow 0.05u)
			if(volume >= 14)
				if(C.regenerate_organs(only_one = TRUE))
					C.reagents.remove_reagent(id, 15)
					to_chat(C, "<span class='notice'>You feel something reform inside of you!</span>")

	data["injected_vol"] -= metabolization_rate
	..()

/datum/reagent/synthtissue/on_merge(passed_data)
	if(!passed_data)
		return ..()
	if(passed_data["grown_volume"] > data["grown_volume"])
		data["grown_volume"] = passed_data["grown_volume"]
	if(iscarbon(holder.my_atom))
		data["injected_vol"] = data["injected_vol"] + passed_data["injected_vol"]
		passed_data["injected_vol"] = 0
	..()

/datum/reagent/synthtissue/on_new(passed_data)
	if(!passed_data)
		return ..()
	if(passed_data["grown_volume"] > data["grown_volume"])
		data["grown_volume"] = passed_data["grown_volume"]
	..()

//NEEDS ON_MOB_DEAD()

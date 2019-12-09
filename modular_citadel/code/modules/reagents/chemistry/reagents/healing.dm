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
	var/templungs = FALSE

/datum/reagent/fermi/yamerol/on_mob_life(mob/living/carbon/C)
	var/obj/item/organ/tongue/T = C.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)

	if(T)
		C.cureOrganDamage(ORGAN_SLOT_TONGUE, (-cached_purity*5)*REM, ORGAN_TREAT_CHRONIC)
	if(L)
		if(cached_purity > 0.90)
			C.cureOrganDamage(ORGAN_SLOT_LUNGS, (-cached_purity*5)*REM, ORGAN_TREAT_CHRONIC)
		else
			C.cureOrganDamage(ORGAN_SLOT_LUNGS, (-cached_purity*5)*REM, ORGAN_TREAT_ACUTE)
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
	if(C.losebreath >= 6)
		C.losebreath -= 3
	..()

/datum/reagent/fermi/yamerol/overdose_start(mob/living/M)
	to_chat(M, "<span class='notice'>You feel the Yamerol sooth your tongue and throat as it begins to expand into damaged areas in your chest...</span>")

/datum/reagent/fermi/yamerol/overdose_process(mob/living/carbon/C)
	var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)
	var/obj/item/organ/tongue/T1 = C.getorganslot(ORGAN_SLOT_TONGUE)
	if(current_cycle > 5)
		if(!(T1) || T1.organ_flags & ORGAN_FAILING)
			var/obj/item/organ/tongue/T
			if(C.dna && C.dna.species && C.dna.species.mutanttongue)
				T = new C.dna.species.mutanttongue()
			else
				T = new()
			T.Insert(C)
			to_chat(C, "<span class='notice'>You feel your tongue reform in your mouth.</span>")
			qdel(T1)
			holder.remove_reagent(src.id, "10")

		//If we've a failed lung, replace it. If a lobe has collapsed,
		if(!L || L.organ_flags & ORGAN_FAILING)
			var/obj/item/organ/lungs/yamerol/L2 = new()
			L2.Insert(C)
			to_chat(C, "<span class='notice'>You feel the yamerol merge together in your chest, forming a temporary airogel maxtrix.</span>")
			holder.remove_reagent(src.id, "10")
			//Potentially save the lungs on L2, and swap them back when L fails.
			qdel(L)

		else if (L.organ_flags & ORGAN_LUNGS_DEFLATED)
			L.organ_flags &= ~ORGAN_LUNGS_DEFLATED
			to_chat(C, "<span class='notice'>You feel the yamerol merge together in the side of your chest, aiding your breathing.</span>")
			holder.remove_reagent(src.id, "5")
			templungs = TRUE

	C.adjustOxyLoss(-3)
	..()

/datum/reagent/fermi/yamerol/on_mob_delete(mob/living/carbon/C)
	if(templungs)
		var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)
		if(L)
			L.organ_flags |= ORGAN_LUNGS_DEFLATED
			to_chat(C, "<span class='notice'>Your chest tightens up again as you feel the medicine dissolve away from inside of you.</span>")
	..()

/datum/reagent/impure/yamerol_tox
	name = "Yamer oh no"
	id = "yamerol_tox"
	description = "A dangerous, cloying toxin that stucks to a patient’s respiratory system, damaging their tongue, lungs and causing suffocation."
	taste_description = "a weird, syrupy flavour, yamero"
	metabolization_rate = 0.35 //18u for lung collapse, just over a syringe
	color = "#68e83a"
	pH = 8.6

/datum/reagent/impure/yamerol_tox/on_mob_life(mob/living/carbon/C)
	var/obj/item/organ/tongue/T = C.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)

	if(T)
		T.applyOrganDamage(1)
	if(L)
		C.adjustOrganLoss(ORGAN_SLOT_LUNGS, 5)
		if(L.organ_flags &= ~ORGAN_LUNGS_DEFLATED)
			C.adjustOxyLoss(6)
			return ..()
		C.adjustOxyLoss(3)
	else
		C.adjustOxyLoss(10)
	..()


/datum/reagent/medicine/synthtissue
	name = "Synthtissue"
	id = "synthtissue"
	description = "Synthetic tissue used for grafting onto damaged organs during surgery, or for treating limb damage. Has a very tight growth window between 305-320, any higher and the temperature will cause the cells to die. Additionally, growth time is considerably long, so chemists are encouraged to leave beakers with said reaction ongoing, while they tend to their other duties."
	pH = 7.6
	metabolization_rate = 0.05 //Give them time to graft
	color = "#FEADAD"
	data = list("grown_volume" = 0, "injected_vol" = 0)
	var/borrowed_health
	color = "#FFDADA"

/datum/reagent/medicine/synthtissue/reaction_mob(mob/living/M, method=TOUCH, reac_volume,show_message = 1)
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

/datum/reagent/medicine/synthtissue/on_mob_life(mob/living/carbon/C)
	if(!iscarbon(C))
		return ..()
	if(data["injected_vol"] > 14)
		if(data["grown_volume"] > 175) //I don't think this is even possible, but damn to I want to see if someone can (bare in mind it takes 2s to grow 0.05u)
			if(volume >= 14)
				if(C.regenerate_organs(only_one = TRUE))
					C.reagents.remove_reagent(id, 15)
					to_chat(C, "<span class='notice'>You feel something reform inside of you!</span>")

	data["injected_vol"] -= metabolization_rate
	if(borrowed_health)
		C.adjustToxLoss(1)
		C.adjustCloneLoss(1)
		borrowed_health -= 1
	..()

/datum/reagent/medicine/synthtissue/on_merge(passed_data)
	if(!passed_data)
		return ..()
	if(passed_data["grown_volume"] > data["grown_volume"])
		data["grown_volume"] = passed_data["grown_volume"]
	if(iscarbon(holder.my_atom))
		data["injected_vol"] = data["injected_vol"] + passed_data["injected_vol"]
		passed_data["injected_vol"] = 0
	update_name()
	..()

/datum/reagent/medicine/synthtissue/on_new(passed_data)
	if(!passed_data)
		return ..()
	if(passed_data["grown_volume"] > data["grown_volume"])
		data["grown_volume"] = passed_data["grown_volume"]
	update_name()
	..()

/datum/reagent/medicine/synthtissue/proc/update_name() //They are but babes on creation and have to grow unto godhood
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

/datum/reagent/medicine/synthtissue/on_mob_delete(mob/living/M)
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

/datum/reagent/medicine/antacidpregen
	name = "Antacid pregenitor"
	id = "antacidpregen"
	description = "A chem that turns into an antacid or antbase depending on it's reaction conditions. At the end of a reaction it'll turn into either an antacid for treating acidic stomachs, or an antbase for alkaline. Upon conversion the purity is inverted, the more extreme the pH is on reaction, the more effective it is."
	pH = 7
	chemical_flags 		= REAGENT_DONOTSPLIT
	color = "#12aa95"
	impure_chem 		= "generic_impure"
	inverse_chem_val 	= 0
	//TODO: using it with kidney stones makes it worse
	//OD gives kidney stones
	//Reduces Peptic ulcer disease severity too.

/datum/reagent/medicine/antacidpregen/on_mob_life(mob/living/carbon/C)
	var/stomach_heal = -((cached_purity-0.5)*3)
	if(stomach_heal<0)
		C.cureOrganDamage(ORGAN_SLOT_TONGUE, stomach_heal, ORGAN_TREAT_ACUTE)
	else
		C.adjustOrganLoss(ORGAN_SLOT_STOMACH, stomach_heal)
	..()

/datum/reagent/medicine/antacidpregen/antacid
	name = "Antacid"
	id = "antacid"
	description = "Antacids neutralise overly acidic pHes in patients. The purer it is, the faster it reduces it. Treats Stomach damage at high purities, but causes it at low."
	color = "#f29b22"
	purity = 0.8

/datum/reagent/medicine/antacidpregen/antacid/on_mob_life(mob/living/carbon/C)
	if(C.reagents.pH < 6.5)
		C.reagents.pH += cached_purity/2
	else if(C.reagents.pH < 7.5)
		C.cureOrganDamage(ORGAN_SLOT_STOMACH, cached_purity, ORGAN_TREAT_ACUTE)
	..()

/datum/reagent/medicine/antacidpregen/antbase
	name = "Antbase"
	id = "antbase"
	description = "Antbases neutralise overly basic pHes in patients. The purer it is, the faster it reduces it. Treats Stomach damage at high purities, but causes it at low."
	color = "#853cfa"
	purity = 0.8

/datum/reagent/medicine/antacidpregen/antbase/on_mob_life(mob/living/carbon/C)
	if(C.reagents.pH > 7.5)
		C.reagents.pH -= cached_purity/2
	else if(C.reagents.pH > 6.5)
		C.cureOrganDamage(ORGAN_SLOT_STOMACH, cached_purity, ORGAN_TREAT_ACUTE)
	..()

/datum/reagent/medicine/cryosenium
	name = "Cryosenium"
	id = "cryosenium"
	description = "Antbases neutralise overly basic pHes in patients. The purer it is, the faster it reduces it. Treats Stomach damage at high purities, but causes it at low."
	taste_description = "ice"
	chemical_flags = REAGENT_DEAD_PROCESS
	purity = 1//for syringe
	color = "#03f4fc"
	impure_chem 		= "generic_impure"
	inverse_chem_val 	= 0.4
	inverse_chem 		= "cryosenium_impure"
	metabolization_rate = 0.05

//Pauses decay! Does do something, I promise.

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
	data = list("grown_volume" = 0, "injected_vol" = 0, "borrowed_health" = 0)
	var/borrowed_health = 0
	color = "#FFDADA"
	value = REAGENT_VALUE_COMMON

/datum/reagent/synthtissue/reaction_mob(mob/living/M, method=TOUCH, reac_volume,show_message = 1)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/healing_factor = (((data["grown_volume"] / 100) + 1)*reac_volume)
		if(method == PATCH)	//Needs to actually be applied via patch / hypo / medspray and not just beakersplashed.
			if (C.stat == DEAD)
				C.visible_message("The synthetic tissue rapidly grafts into [M]'s wounds, attempting to repair the damage as quickly as possible.")
				var/preheal_brute = C.getBruteLoss()
				var/preheal_burn = C.getFireLoss()
				var/preheal_tox = C.getToxLoss()
				var/preheal_oxy = C.getOxyLoss()
				C.adjustBruteLoss(-healing_factor*2)
				C.adjustFireLoss(-healing_factor*2)
				C.adjustToxLoss(-healing_factor)
				C.adjustCloneLoss(-healing_factor)
				borrowed_health += (preheal_brute - C.getBruteLoss()) + (preheal_burn - C.getFireLoss()) + (preheal_tox - C.getToxLoss()) + ((preheal_oxy - C.getOxyLoss()) / 2)	//Ironically this means that while slimes get damaged by the toxheal, it will reduce borrowed health and longterm effects. Funky!
				C.updatehealth()
				if(data["grown_volume"] > 135 && ((C.health + C.oxyloss)>=80))
					var/tplus = world.time - M.timeofdeath
					if(C.can_revive(ignore_timelimit = TRUE, maximum_brute_dam = MAX_REVIVE_BRUTE_DAMAGE / 2, maximum_fire_dam = MAX_REVIVE_FIRE_DAMAGE / 2, ignore_heart = TRUE) && C.revive())
						C.grab_ghost()
						C.emote("gasp")
						borrowed_health *= 2
						if(borrowed_health < 100)
							borrowed_health = 100
						log_combat(C, C, "revived", src)
						var/list/policies = CONFIG_GET(keyed_list/policy)
						var/policy = policies[POLICYCONFIG_ON_DEFIB_LATE]	//Always causes memory loss due to the nature of synthtissue
						if(policy)
							to_chat(C, policy)
						C.log_message("revived using synthtissue, [tplus] deciseconds from time of death, considered late revival due to usage of synthtissue.", LOG_GAME)
			else
				var/preheal_brute = C.getBruteLoss()
				var/preheal_burn = C.getFireLoss()
				M.adjustBruteLoss(-healing_factor)
				M.adjustFireLoss(-healing_factor)
				var/datum/reagent/synthtissue/active_tissue = M.reagents.has_reagent(/datum/reagent/synthtissue)
				var/imperfect = FALSE 	//Merging with synthtissue that has borrowed health
				if(active_tissue && active_tissue.borrowed_health)
					borrowed_health += (preheal_brute - C.getBruteLoss()) + (preheal_burn - C.getFireLoss())
					imperfect = TRUE
				to_chat(M, "<span class='danger'>You feel your flesh [imperfect ? "partially and painfully" : ""] merge with the synthetic tissue! It stings like hell[imperfect ? " and is making you feel terribly sick" : ""]!</span>")
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "painful_medicine", /datum/mood_event/painful_medicine)
			data["borrowed_health"] += borrowed_health //Preserve health offset
			borrowed_health = 0	//We are applying this to someone else, so this info will be transferred via data.
		if(method==INJECT)
			data["injected_vol"] = reac_volume
			var/obj/item/organ/heart/H = C.getorganslot(ORGAN_SLOT_HEART)
			if(H && data["grown_volume"] > 50 && H.organ_flags & ORGAN_FAILING)
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

	data["injected_vol"] = max(0, data["injected_vol"] - metabolization_rate * C.metabolism_efficiency)	//No negatives.
	if(borrowed_health)
		var/ratio = (current_cycle > SYNTHTISSUE_DAMAGE_FLIP_CYCLES) ? 0 : (1 - (current_cycle / SYNTHTISSUE_DAMAGE_FLIP_CYCLES))
		var/payback = 2 * C.metabolism_efficiency	//How much borrowed health we are paying back. Starts as cloneloss, slowly flips over to toxloss.
		C.adjustToxLoss((1 - ratio) * payback * REAGENTS_EFFECT_MULTIPLIER, forced = TRUE, toxins_type = TOX_OMNI)
		C.adjustCloneLoss(ratio * payback * REAGENTS_EFFECT_MULTIPLIER)
		borrowed_health = max(borrowed_health - payback, 0)
	..()

/datum/reagent/synthtissue/on_merge(passed_data)
	if(!passed_data)
		return ..()
	borrowed_health += max(0, passed_data["borrowed_health"])
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
	borrowed_health = min(passed_data["borrowed_health"] + borrowed_health, SYNTHTISSUE_BORROW_CAP)
	if(passed_data["grown_volume"] > data["grown_volume"])
		data["grown_volume"] = passed_data["grown_volume"]
	update_name()
	..()

/datum/reagent/synthtissue/post_copy_data()
	data["borrowed_health"] = 0	//We passed this along to something that needed it, set it back to 0 so we don't do it twice.
	return ..()

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
	if(C.stat != DEAD && borrowed_health && C.health < -20)
		M.visible_message("The synthetic tissue degrades off [M]'s wounds as they collapse to the floor.")
		M.death()
//NEEDS ON_MOB_DEAD()

/datum/reagent/fermi/zeolites
	name = "Artificial Zeolite"
	description = "Lab made Zeolite, used to clear radiation from people and items alike! Splashing just a small amount(5u) onto any item can clear away large amounts of contamination, as long as its purity is at least 0.7."
	pH = 8
	taste_description = "chalky metal"
	color = "#FFDADA"
	metabolization_rate = 8 * REAGENTS_METABOLISM //Metabolizes fast but heals a lot! Lasts far longer if more pure.
	value = REAGENT_VALUE_RARE //Relatively hard to make now, might be fine with VERY_RARE instead depending on feedback.

/datum/reagent/fermi/zeolites/on_mob_life(mob/living/carbon/M)
	metabolization_rate = (4 / purity) * REAGENTS_METABOLISM //Metab rate directly influenced by purity. Linear.
	var/datum/component/radioactive/contamination = M.GetComponent(/datum/component/radioactive)
	if(M.radiation > 0) //hey so apparently pentetic literally purges 1/50 (2%) of the rad amount on someone per tick no matter the 'true' amount, sooo uhh time to tweak this some more..
		M.radiation -= clamp(round((M.radiation / 150) * (25 ** purity), 0.1), 0, M.radiation) //Purges between ~3% and ~16% of total rad amount, per tick, depending on purity. Exponential.
	if(contamination && contamination.strength > 0)
		contamination.strength -= min(contamination.strength, round(25 ** (0.5 + purity), 0.1)) //25 per tick at minimum purity; Tops out at ~125 per tick if purity is 1. Exponential.
	..()

/datum/reagent/fermi/zeolites/reaction_obj(obj/O, reac_volume)
	var/datum/component/radioactive/contamination = O.GetComponent(/datum/component/radioactive)
	if(contamination && purity >= 0.7) //you need at least 0.7 purity to instantly purge all contam on an object.
		qdel(contamination)
	..()

/obj/item/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	w_class = WEIGHT_CLASS_NORMAL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_STOMACH
	attack_verb = list("gored", "squished", "slapped", "digested")
	desc = "Onaka ga suite imasu."
	var/disgust_metabolism = 1

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = "<span class='info'>Your stomach flashes with pain before subsiding. Food doesn't seem like a good idea right now.</span>"
	high_threshold_passed = "<span class='warning'>Your stomach flares up with constant pain- you can hardly stomach the idea of food right now!</span>"
	high_threshold_cleared = "<span class='info'>The pain in your stomach dies down for now, but food still seems unappealing.</span>"
	low_threshold_cleared = "<span class='info'>The last bouts of pain in your stomach have died out.</span>"

	var/stomach_acid = /datum/reagent/metabolic/stomach_acid //IF you change this - the mob will be IMMUNE to this chem - it will do nothing to them.
	var/stomach_acid_volume = 50
	var/stomach_acid_opt_pH = 7 //what pH the stomach wants to be at

/obj/item/organ/stomach/on_life()
	. = ..()
	if(is_cold())
		return
	if(!owner)
		return

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!(organ_flags & ORGAN_FAILING))
			H.dna.species.handle_digestion(H)
		handle_disgust(H)

	var/mob/living/carbon/C = owner
	if(!C.reagents)
		return
	var/deltapH = (C.reagents.pH - stomach_acid_opt_pH)) 
	if(deltapH < 0)
		deltapH = -deltapH //Normalise around middle
	switch(deltapH)
		if(5.5 to INFINITY)
			applyOrganDamage(0.4)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.4) //heartburn!
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 2.5)
			owner.adjustOrganLoss(ORGAN_SLOT_TONGUE, 0.25)
			C.apply_damage(0.5, BURN, C.get_bodypart(BODY_ZONE_CHEST))
			if(prob(1))
				to_chat("Your throat feels like it's on fire!")
				owner.adjustStaminaLoss(10)
		if(4 to 5.5)
			applyOrganDamage(0.3)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25) //heartburn!
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 1.25)
			owner.adjustOrganLoss(ORGAN_SLOT_TONGUE, 0.1)
			if(prob(1))
				to_chat("You feel a burning sensation in your chest!")
		if(2.5 to 4)
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.5)
			applyOrganDamage(0.2)
		if(1 to 2.5)
			applyOrganDamage(0.1)
		if(-INFINITY to 1)
			passive_regen()

	if(organ_flags & ORGAN_FAILING)
		return
	//stomach acid stuff
	if(C.reagents.pH > stomach_acid_opt_pH + 0.2)
		var/adjust = C.reagents.pH - (0.1-(damage/2000))
		C.reagents.pH = clamp(adjust, 0, 14)
	else if (C.reagents.pH < stomach_acid_opt_pH - 0.2)
		var/adjust = C.reagents.pH + (0.1-(damage/2000))
		C.reagents.pH = clamp(adjust, 0, 14)

	var/datum/reagent/SA = C.reagents.has_reagent(stomach_acid)
	if(!SA)
		owner.reagents.add_reagent(stomach_acid, 1)
		applyOrganDamage(5)
	else if(SA.volume < stomach_acid_volume)
		SA.volume = clamp(SA.volume + 1, 0, stomach_acid_volume)

	if(damage < low_threshold)
		return

	var/datum/reagent/consumable/nutriment/Nutri = locate(/datum/reagent/consumable/nutriment) in C.reagents.reagent_list

	if(Nutri)
		if(prob((damage/40) * Nutri.volume * Nutri.volume))
			C.vomit(damage)
			to_chat(C, "<span class='warning'>Your stomach reels in pain as you're incapable of holding down all that food!</span>")

	else if(Nutri && damage > high_threshold)
		if(prob((damage/10) * Nutri.volume * Nutri.volume))
			C.vomit(damage)
			to_chat(C, "<span class='warning'>Your stomach reels in pain as you're incapable of holding down all that food!</span>")


/obj/item/organ/stomach/proc/regen_stomach_acid(amount)
	if(!owner || !owner.reagents)
		return FALSE
	var/datum/reagent/metabolic/stomach_acid/SA = owner.reagents.has_reagent(stomach_acid)
	if(!SA)
		owner.reagents.add_reagent(stomach_acid, amount)
	else if(SA.volume < stomach_acid_volume)
		SA.volume = clamp(SA.volume + amount, 0, stomach_acid_volume)
	owner.reagents.pH = stomach_acid_opt_pH


/obj/item/organ/stomach/proc/handle_disgust(mob/living/carbon/human/H)
	if(H.disgust)
		var/pukeprob = 5 + 0.05 * H.disgust
		if(H.disgust >= DISGUST_LEVEL_GROSS)
			if(prob(10))
				H.stuttering += 1
				H.confused += 2
			if(prob(10) && !H.stat)
				to_chat(H, "<span class='warning'>You feel kind of iffy...</span>")
			H.jitteriness = max(H.jitteriness - 3, 0)
		if(H.disgust >= DISGUST_LEVEL_VERYGROSS)
			if(prob(pukeprob)) //iT hAndLeS mOrE ThaN PukInG
				H.confused += 2.5
				H.stuttering += 1
				H.vomit(10, 0, 1, 0, 1, 0)
			H.Dizzy(5)
		if(H.disgust >= DISGUST_LEVEL_DISGUSTED)
			if(prob(25))
				H.blur_eyes(3) //We need to add more shit down here

		H.adjust_disgust(-0.5 * disgust_metabolism)
	switch(H.disgust)
		if(0 to DISGUST_LEVEL_GROSS)
			H.clear_alert("disgust")
			SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "disgust")
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			H.throw_alert("disgust", /obj/screen/alert/gross)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/gross)
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			H.throw_alert("disgust", /obj/screen/alert/verygross)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/verygross)
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			H.throw_alert("disgust", /obj/screen/alert/disgusted)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/disgusted)

/obj/item/organ/stomach/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	.=..()
	regen_stomach_acid(stomach_acid_volume)

/obj/item/organ/stomach/Initialize()
	.=..()
	regen_stomach_acid(stomach_acid_volume)

/obj/item/organ/stomach/Remove(mob/living/carbon/M, special = 0)
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		H.clear_alert("disgust")
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "disgust")
	if(owner.reagents)
		owner.reagents.remove_reagent(/datum/reagent/metabolic/stomach_acid, stomach_acid_volume) //Since stomach acid is inert, we do this. The otherones have bonuses if you remove them, so lets keep them!
	..()

/obj/item/organ/stomach/fly
	name = "insectoid stomach"
	icon_state = "stomach-x" //xenomorph liver? It's just a black liver so it fits.
	desc = "A mutant stomach designed to handle the unique diet of a flyperson."
	stomach_acid_volume = 30
	stomach_acid = /datum/reagent/toxin/acid //You need strong acid to be a fly
	stomach_acid_opt_pH = 2.75

/obj/item/organ/stomach/plasmaman
	name = "digestive crystal"
	icon_state = "stomach-p"
	desc = "A strange crystal that is responsible for metabolizing the unseen energy force that feeds plasmamen."
	stomach_acid_volume = 40
	stomach_acid = /datum/reagent/toxin/plasma //HOPEFULLY won't cause unexpected bad things
	stomach_acid_opt_pH = 4 //same as plasma

/obj/item/organ/stomach/ipc
	name = "ipc cell"
	icon_state = "stomach-ipc"
	stomach_acid = /datum/reagent/lube //Also see ignored metabolic reagents list so that they're not processed. (see liver.dm)

/obj/item/organ/stomach/ipc/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			owner.nutrition = min(owner.nutrition - 50, 0)
			to_chat(owner, "<span class='warning'>Alert: Detected severe battery discharge!</span>")
		if(2)
			owner.nutrition = min(owner.nutrition - 100, 0)
			to_chat(owner, "<span class='warning'>Alert: Minor battery discharge!</span>")

/obj/item/organ/stomach/ethereal
	name = "biological battery"
	icon_state = "stomach-p" //Welp. At least it's more unique in functionaliy.
	desc = "A crystal-like organ that stores the electric charge of ethereals."
	var/crystal_charge = ETHEREAL_CHARGE_FULL
	//stomach_acid = /datum/reagent/fermi/astral //SHOULDN'T do anything to someone who has this added (pH is 7)- WILL BE ENABLED WHEN ASTRAL IS FIXED IN ATOMISED PR
	stomach_acid_volume = 30 //25 is Addiction - BUT you should be okay - since you always have some in you! You're just buggered if you lose your stomach.

/obj/item/organ/stomach/ethereal/on_life()
	..()
	adjust_charge(-ETHEREAL_CHARGE_FACTOR)

/obj/item/organ/stomach/ethereal/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	..()
	RegisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, .proc/charge)
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, .proc/on_electrocute)

/obj/item/organ/stomach/ethereal/Remove(mob/living/carbon/M, special = 0)
	UnregisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	..()

/obj/item/organ/stomach/ethereal/proc/charge(datum/source, amount, repairs)
	adjust_charge(amount / 70)

/obj/item/organ/stomach/ethereal/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 2)
	to_chat(owner, "<span class='notice'>You absorb some of the shock into your body!</span>")

/obj/item/organ/stomach/ethereal/proc/adjust_charge(amount)
	crystal_charge = clamp(crystal_charge + amount, ETHEREAL_CHARGE_NONE, ETHEREAL_CHARGE_DANGEROUS)

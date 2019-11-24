//Reagents produced by metabolising/reacting fermichems inoptimally, i.e. inverse_chems or impure_chems
//Inverse = Splitting
//Invert = Whole conversion

/datum/reagent/impure
	chemical_flags = REAGENT_INVISIBLE | REAGENT_SNEAKYNAME //by default, it will stay hidden on splitting, but take the name of the source on inverting
	var/metastress = 1

/datum/reagent/impure/on_mob_life(mob/living/carbon/C)
	var/obj/item/organ/liver/L = C.getorganslot(ORGAN_SLOT_LIVER)
	L.adjustMetabolicStress(metastress)
	..()

/datum/reagent/impure/fermiTox
	name = "Chemical Isomers"
	id = "fermiTox"
	description = "Toxic chemical isomers made from impure reactions. At low volumes will cause light toxin damage, but as the volume increases, it deals larger amounts, damages the liver, then eventually the heart. This is default impure chem for all chems, and changes only if stated."
	data = "merge"
	color = "FFFFFF"
	can_synth = FALSE
	var/potency = 1 //potency multiplies the volume when added.


//I'm concerned this is too weak, but I also don't want deathmixes.
//TODO: liver damage, 100+ heart
/datum/reagent/impure/fermiTox/on_mob_life(mob/living/carbon/C, method)
	C.adjustToxLoss(2, TRUE)
	..()

/datum/reagent/impure/mannitol
	name = "Mannitoll"
	id = "mannitol_impure"
	description = "Inefficiently causes brain damage."
	color = "#DCDCFF"
	pH = 10.4
	metastress = 0.8

/datum/reagent/impure/mannitol/on_mob_life(mob/living/carbon/C)
	C.applyOrganDamage(ORGAN_SLOT_BRAIN, 1*REM)
	..()

//I am incapable of making anything simple
/datum/reagent/impure/neurine
	name = "Neruwhine"
	id = "neurine_impure"
	description = "Causes the patient a temporary trauma."
	color = "#DCDCFF"
	pH = 10.4
	metabolization_rate = 0.4 * REM
	metastress = 0.4
	var/temp_trauma

/datum/reagent/impure/neurine/on_mob_life(mob/living/carbon/C)
	.=..()
	if(temp_trauma)
		return
	if(!(prob(cached_purity)))
		return
	var/datum/brain_trauma/BT = pick(subtypesof(/datum/brain_trauma)
	var/obj/item/organ/brain/B = C.getorganslot(ORGAN_SLOT_BRAIN)
	if(!(B.can_gain_trauma(BT)))
		return
	B.brain_gain_trauma(BT, TRAUMA_RESILIENCE_MAGIC)
	temp_trauma = BT

/datum/reagent/impure/neurine/on_mob_delete(mob/living/carbon/C)
	.=..()
	if(!temp_trauma)
		return
	C.cure_trauma_type(BT, resilience = TRAUMA_RESILIENCE_MAGIC)

/datum/reagent/impure/corazone
	name = "Corazargh"
	id = "corazone_impure"
	description = "Induces a Myocardial Infarction while in the patient."
	color = "#F5F5F5"
	self_consuming = TRUE
	pH = 12.5
	metabolization_rate = 0.075 * REM
	metastress = 0.2
	var/temp_myo

/datum/reagent/impure/corazone/on_mob_add(mob/living/L)
	var/datum/disease/D = new /datum/disease/heart_failure
	if(M.ForceContractDisease(D))
		temp_myo = D

/datum/reagent/impure/neurine/on_mob_delete(mob/living/L)
	if(temp_myo)
		temp_myo.cure()

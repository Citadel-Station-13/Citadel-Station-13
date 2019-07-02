/datum/reagent/fermi/yamerol
	name = "Yamerol"
	id = "yamerol"
	description = "For when you've trouble speaking or breathing, just yell YAMEROL! A chem that helps soothe any congestion problems and at high concentrations restores damaged lungs and tongues!"
	taste_description = "a weird, syrupy flavour, yamero"
	color = "#68e83a"
	pH = 8.6
	overdose_threshold = 35
	ImpureChem 			= "yamerol_tox"
	InverseChemVal 		= 0.3
	InverseChem 		= "yamerol_tox"

/datum/reagent/fermi/yamerol/on_mob_life(mob/living/carbon/C)
	var/obj/item/organ/tongue/T = C.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)

	if(T)
		T.adjustTongueLoss(C, -2)
	if(L)
		L.adjustLungLoss(-5, C)
		C.adjustOxyLoss(-2)
	else
		C.adjustOxyLoss(-10)
	..()

/datum/reagent/fermi/yamerol/overdose_process(mob/living/carbon/C)
	var/obj/item/organ/tongue/oT = C.getorganslot(ORGAN_SLOT_TONGUE)

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
			var/obj/item/organ/lungs/L = new()
			L.Insert(C)
			to_chat(C, "<span class='notice'>You feel your lungs reform in your chest.</span>")
			holder.remove_reagent(src.id, "10")


	..()

/datum/reagent/fermi/yamerol_tox
	name = "Yamerol"
	id = "yamerol_tox"
	description = "For when you've trouble speaking or breathing, just yell YAMEROL! A chem that helps soothe any congestion problems and at high concentrations restores damaged lungs and tongues!"
	taste_description = "a weird, syrupy flavour, yamero"
	color = "#68e83a"
	pH = 8.6

/datum/reagent/fermi/yamerol_tox/on_mob_life(mob/living/carbon/C)
	var/obj/item/organ/tongue/T = C.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)

	if(T)
		T.adjustTongueLoss(C, 1)
	if(L)
		L.adjustLungLoss(2.5, C)
		C.adjustOxyLoss(2)
	else
		C.adjustOxyLoss(10)
	..()

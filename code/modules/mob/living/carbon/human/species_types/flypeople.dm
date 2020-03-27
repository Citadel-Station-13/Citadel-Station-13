/datum/species/fly
	name = "Anthromorphic Fly"
	id = "fly"
	say_mod = "buzzes"
	species_traits = list(NOEYES)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutanttongue = /obj/item/organ/tongue/fly
	mutantliver = /obj/item/organ/liver/fly
	mutantstomach = /obj/item/organ/stomach/fly
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	disliked_food = null
	liked_food = GROSS
	exotic_bloodtype = "BUG"

/datum/species/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(istype(chem, /datum/reagent/toxin/pestkiller))
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM)
		return TRUE
	else if(istype(chem, /datum/reagent/consumable))
		var/datum/reagent/consumable/nutri_check = chem
		if(nutri_check.nutriment_factor > 0)
			var/turf/pos = get_turf(H)
			H.vomit(0, FALSE, FALSE, 2, TRUE)
			var/obj/effect/decal/cleanable/vomit/V = locate() in pos
			if(V)
				H.reagents.trans_id_to(V, chem.type, chem.volume)
			playsound(pos, 'sound/effects/splat.ogg', 50, 1)
			H.visible_message("<span class='danger'>[H] vomits on the floor!</span>", \
						"<span class='userdanger'>You throw up on the floor!</span>")
			return TRUE
	return ..()

/datum/species/fly/check_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/melee/flyswatter))
		return 29 //Flyswatters deal 30x damage to flypeople.
	return 0

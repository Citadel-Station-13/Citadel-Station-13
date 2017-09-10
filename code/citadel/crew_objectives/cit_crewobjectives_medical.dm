/*				MEDICAL OBJECTIVES				*/

/datum/objective/crew/chiefmedicalofficer/

/datum/objective/crew/chiefmedicalofficer/morgue //Ported from old Hippie
	explanation_text = "Ensure there are no corpses on the station outside of the morgue when the shift ends."

/datum/objective/crew/chiefmedicalofficer/morgue/check_completion()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H.stat == DEAD && H.z == ZLEVEL_STATION)
			if(get_area(H) != /area/medical/morgue)
				return 0
	return 1

/datum/objective/crew/chiefmedicalofficer/chems //Ported from old Hippie
	var/targetchem = "none"
	var/datum/reagent/chempath
	explanation_text = "Have (yell about this in the development discussion channel of citadel's discord, something broke) in your bloodstream when the shift ends."

/datum/objective/crew/chiefmedicalofficer/chems/New()
	. = ..()
	var/blacklist = list(/datum/reagent/drug, /datum/reagent/drug/nicotine, /datum/reagent/drug/menthol, /datum/reagent/medicine, /datum/reagent/medicine/adminordrazine, /datum/reagent/medicine/adminordrazine/nanites, /datum/reagent/medicine/mine_salve, /datum/reagent/medicine/omnizine, /datum/reagent/medicine/syndicate_nanites, /datum/reagent/medicine/earthsblood, /datum/reagent/medicine/strange_reagent, /datum/reagent/medicine/miningnanites, /datum/reagent/medicine/changelingAdrenaline, /datum/reagent/medicine/changelingAdrenaline2)
	var/drugs = typesof(/datum/reagent/drug) - blacklist
	var/meds = typesof(/datum/reagent/medicine) - blacklist
	var/chemlist = drugs + meds
	chempath = pick(chemlist)
	targetchem = initial(chempath.id)
	update_explanation_text()

/datum/objective/crew/chiefmedicalofficer/chems/update_explanation_text()
	. = ..()
	explanation_text = "Have [initial(chempath.name)] in your bloodstream when the shift ends."

/datum/objective/crew/chiefmedicalofficer/chems/check_completion()
	if(owner.current)
		if(!owner.current.stat == DEAD && owner.current.reagents)
			if(owner.current.reagents.has_reagent(targetchem))
				return 1
	else
		return 0

/datum/objective/crew/geneticist

/datum/objective/crew/geneticist/morgue //Ported from old Hippie
	explanation_text = "Ensure there are no corpses on the station outside of the morgue when the shift ends."

/datum/objective/crew/geneticist/morgue/check_completion()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H.stat == DEAD && H.z == ZLEVEL_STATION)
			if(get_area(H) != /area/medical/morgue)
				return 0
	return 1

/datum/objective/crew/chemist/

/datum/objective/crew/chemist/chems //Ported from old Hippie
	var/targetchem = "none"
	var/datum/reagent/chempath
	explanation_text = "Have (yell about this in the development discussion channel of citadel's discord, something broke) in your bloodstream when the shift ends."

/datum/objective/crew/chemist/chems/New()
	. = ..()
	var/blacklist = list(/datum/reagent/drug, /datum/reagent/drug/nicotine, /datum/reagent/drug/menthol, /datum/reagent/medicine, /datum/reagent/medicine/adminordrazine, /datum/reagent/medicine/adminordrazine/nanites, /datum/reagent/medicine/mine_salve, /datum/reagent/medicine/omnizine, /datum/reagent/medicine/syndicate_nanites, /datum/reagent/medicine/earthsblood, /datum/reagent/medicine/strange_reagent, /datum/reagent/medicine/miningnanites, /datum/reagent/medicine/changelingAdrenaline, /datum/reagent/medicine/changelingAdrenaline2)
	var/drugs = typesof(/datum/reagent/drug) - blacklist
	var/meds = typesof(/datum/reagent/medicine) - blacklist
	var/chemlist = drugs + meds
	chempath = pick(chemlist)
	targetchem = initial(chempath.id)
	update_explanation_text()

/datum/objective/crew/chemist/chems/update_explanation_text()
	. = ..()
	explanation_text = "Have [initial(chempath.name)] in your bloodstream when the shift ends."

/datum/objective/crew/chemist/chems/check_completion()
	if(owner.current)
		if(!owner.current.stat == DEAD && owner.current.reagents)
			if(owner.current.reagents.has_reagent(targetchem))
				return 1
	else
		return 0

/datum/objective/crew/chemist/druglord //ported from old Hippie with adjustments
	var/targetchem = "none"
	var/datum/reagent/chempath
	explanation_text = "Have at least (somethin broke here) pills containing (report this on the development discussion channel of citadel's discord) when the shift ends."

/datum/objective/crew/chemist/druglord/New()
	. = ..()
	target_amount = rand(5,50)
	var/blacklist = list(/datum/reagent/drug, /datum/reagent/drug/nicotine, /datum/reagent/drug/menthol)
	var/drugs = typesof(/datum/reagent/drug) - blacklist
	var/chemlist = drugs
	chempath = pick(chemlist)
	targetchem = initial(chempath.id)
	update_explanation_text()

/datum/objective/crew/chemist/druglord/update_explanation_text()
	. = ..()
	explanation_text = "Have at least [target_amount] pills containing [initial(chempath.name)] when the shift ends."

/datum/objective/crew/chemist/druglord/check_completion()
	var/pillcount = target_amount
	if(owner.current)
		if(owner.current.contents)
			for(var/obj/item/reagent_containers/pill/P in owner.current.get_contents())
				if(P.reagents.has_reagent(targetchem))
					pillcount--
	if(pillcount <= 0)
		return 1
	else
		return 0

/datum/objective/crew/virologist

/datum/objective/crew/virologist/noinfections
	explanation_text = "Ensure no living crew members are infected with harmful viruses at the end of the shift"

/datum/objective/crew/virologist/noinfections/check_completion()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(!H.stat == DEAD)
			if(H.z == ZLEVEL_STATION || SSshuttle.emergency.shuttle_areas[get_area(H)])
				if(H.check_virus() == 2)
					return 0
	return 1

/datum/objective/crew/medicaldoctor

/datum/objective/crew/medicaldoctor/morgue //Ported from old Hippie
	explanation_text = "Ensure there are no corpses on the station outside of the morgue when the shift ends."

/datum/objective/crew/medicaldoctor/morgue/check_completion()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H.stat == DEAD && H.z == ZLEVEL_STATION)
			if(get_area(H) != /area/medical/morgue)
				return 0
	return 1

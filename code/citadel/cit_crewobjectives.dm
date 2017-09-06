/datum/controller/subsystem/ticker/proc/generate_crew_objectives()
	for(var/datum/mind/crewMind in SSticker.minds)
		if(prob(10) && GLOB.master_mode != "extended")//extended is supposed to have less chaos
			generate_miscreant_objectives(crewMind)
		else
			generate_individual_objectives(crewMind)
	return

/datum/controller/subsystem/ticker/proc/generate_individual_objectives(var/datum/mind/crewMind)
	if(!crewMind)
		return
	if(!crewMind.current || !crewMind.objectives || crewMind.special_role)
		return
	if(!crewMind.assigned_role)
		return
	var/rolePathString = "/datum/objective/crew/[ckey(crewMind.assigned_role)]"
	var/rolePath = text2path(rolePathString)
	if (isnull(rolePath))
		return
	var/list/objectiveTypes = typesof(rolePath) - rolePath
	if(!objectiveTypes.len)
		return
	var/selectedType = pick(objectiveTypes)
	var/datum/objective/crew/newObjective = new selectedType
	if(!newObjective)
		return
	newObjective.owner = crewMind
	crewMind.objectives += newObjective
	crewMind.announce_objectives()

/datum/objective/crew/
	explanation_text = "Yell on the development discussion channel on Citadels discord if this ever shows up. Something just broke here, dude"

/datum/objective/crew/proc/setup()

/*				COMMAND OBJECTIVES				*/

/datum/objective/crew/captain/

/datum/objective/crew/captain/hat //Ported from Goon
	explanation_text = "Don't lose your hat."

/datum/objective/crew/captain/hat/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/clothing/head/caphat))
		return 1
	else
		return 0

/datum/objective/crew/captain/datfukkendisk //Ported from old Hippie
	explanation_text = "Defend the nuclear authentication disk at all costs, and be the one to personally deliver it to Centcom."

/datum/objective/crew/captain/datfukkendisk/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/disk/nuclear) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return 1
	else
		return 0

/datum/objective/crew/headofpersonnel/

/datum/objective/crew/headofpersonnel/ian //Ported from old Hippie
	explanation_text = "Defend Ian at all costs, and ensure he gets delivered to Centcom at the end of the shift."

/datum/objective/crew/headofpersonnel/ian/check_completion()
	if(owner.current)
		for(var/mob/living/simple_animal/pet/dog/corgi/Ian/goodboy in GLOB.mob_list)
			if(goodboy.stat != DEAD && SSshuttle.emergency.shuttle_areas[get_area(goodboy)])
				return 1
		return 0
	return 0

/datum/objective/crew/headofpersonnel/datfukkendisk //Ported from old Hippie
	explanation_text = "Defend the nuclear authentication disk at all costs, and be the one to personally deliver it to Centcom."

/datum/objective/crew/headofpersonnel/datfukkendisk/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/disk/nuclear) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return 1
	else
		return 0

/*				SECURITY OBJECTIVES				*/

/datum/objective/crew/headofsecurity/

/datum/objective/crew/headofsecurity/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/headofsecurity/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/headofsecurity/datfukkendisk //Ported from old Hippie
	explanation_text = "Defend the nuclear authentication disk at all costs, and be the one to personally deliver it to Centcom."

/datum/objective/crew/headofsecurity/datfukkendisk/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/disk/nuclear) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return 1
	else
		return 0

/datum/objective/crew/securityofficer/

/datum/objective/crew/securityofficer/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/securityofficer/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/warden/

/datum/objective/crew/warden/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/warden/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/detective/

/datum/objective/crew/detective/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/detective/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/lawyer/

/datum/objective/crew/lawyer/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/lawyer/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/*				SCIENCE OBJECTIVES				*/

/datum/objective/crew/researchdirector/

/datum/objective/crew/researchdirector/cyborgs //Ported from old Hippie
	explanation_text = "Ensure there are at least (Yo something broke here, yell on citadel's development discussion channel about this) functioning cyborgs when the shift ends."

/datum/objective/crew/researchdirector/cyborgs/New()
	. = ..()
	target_amount = rand(3,10)
	update_explanation_text()

/datum/objective/crew/researchdirector/cyborgs/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] functioning cyborgs when the shift ends."

/datum/objective/crew/researchdirector/cyborgs/check_completion()
	var/borgcount = target_amount
	for(var/mob/living/silicon/robot/R in GLOB.living_mob_list)
		if(!R.stat == DEAD)
			borgcount--
	if(borgcount <= 0)
		return 1
	else
		return 0

/datum/objective/crew/roboticist/

/datum/objective/crew/roboticist/cyborgs //Ported from old Hippie
	explanation_text = "Ensure there are at least (Yo something broke here, yell on citadel's development discussion channel about this) functioning cyborgs when the shift ends."

/datum/objective/crew/roboticist/cyborgs/New()
	. = ..()
	target_amount = rand(3,10)
	update_explanation_text()

/datum/objective/crew/roboticist/cyborgs/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] functioning cyborgs when the shift ends."

/datum/objective/crew/roboticist/cyborgs/check_completion()
	var/borgcount = target_amount
	for(var/mob/living/silicon/robot/R in GLOB.living_mob_list)
		if(!R.stat == DEAD)
			borgcount--
	if(borgcount <= 0)
		return 1
	else
		return 0

/*				ENGINEERING OBJECTIVES			*/

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
	var/chemlist = drugs + meds + /datum/reagent/anaphrodisiac + /datum/reagent/aphrodisiac
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
	var/chemlist = drugs + meds + /datum/reagent/anaphrodisiac + /datum/reagent/aphrodisiac
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
	var/chemlist = drugs + /datum/reagent/anaphrodisiac + /datum/reagent/aphrodisiac
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
			

/*				CARGO OBJECTIVES				*/

/datum/objective/crew/quartermaster

/datum/objective/crew/quartermaster/petsplosion
	explanation_text = "Ensure there are at least (If you see this, yell on citadels discord in the development discussion channel) pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/quartermaster/petsplosion/New()
	. = ..()
	target_amount = rand(10,30)
	update_explanation_text()

/datum/objective/crew/quartermaster/petsplosion/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/quartermaster/petsplosion/check_completion()
	var/petcount = target_amount
	for(var/mob/living/simple_animal/pet/P in GLOB.mob_list)
		if(!P.stat == DEAD)
			if(P.z == ZLEVEL_STATION || SSshuttle.emergency.shuttle_areas[get_area(P)])
				petcount--
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(!H.stat == DEAD)
			if(H.z == ZLEVEL_STATION || SSshuttle.emergency.shuttle_areas[get_area(H)])
				if(istype(H.wear_neck, /obj/item/clothing/neck/petcollar))
					petcount--
	if(petcount <= 0)
		return 1
	else
		return 0

/datum/objective/crew/cargotechnician

/datum/objective/crew/cargotechnician/petsplosion
	explanation_text = "Ensure there are at least (If you see this, yell on citadels discord in the development discussion channel) pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/cargotechnician/petsplosion/New()
	. = ..()
	target_amount = rand(10,30)
	update_explanation_text()

/datum/objective/crew/cargotechnician/petsplosion/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/cargotechnician/petsplosion/check_completion()
	var/petcount = target_amount
	for(var/mob/living/simple_animal/pet/P in GLOB.mob_list)
		if(!P.stat == DEAD)
			if(P.z == ZLEVEL_STATION || SSshuttle.emergency.shuttle_areas[get_area(P)])
				petcount--
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(!H.stat == DEAD)
			if(H.z == ZLEVEL_STATION || SSshuttle.emergency.shuttle_areas[get_area(H)])
				if(istype(H.wear_neck, /obj/item/clothing/neck/petcollar))
					petcount--
	if(petcount <= 0)
		return 1
	else
		return 0

/datum/objective/crew/shaftminer

/datum/objective/crew/shaftminer/bubblegum
	explanation_text = "Ensure Bubblegum is dead at the end of the shift."

/datum/objective/crew/shaftminer/bubblegum/check_completion()
	for(var/mob/living/simple_animal/hostile/megafauna/bubblegum/B in GLOB.mob_list)
		if(!B.stat == DEAD)
			return 0
	return 1

/*				CIVILLIAN OBJECTIVES			*/

/datum/objective/crew/botanist

/datum/objective/crew/botanist/druglord //ported from old Hippie with adjustments
	var/targetchem = "none"
	var/datum/reagent/chempath
	explanation_text = "Have at least (somethin broke here) harvested plants containing (report this on the development discussion channel of citadel's discord) when the shift ends."

/datum/objective/crew/botanist/druglord/New()
	. = ..()
	target_amount = rand(3,20)
	var/blacklist = list(/datum/reagent/drug, /datum/reagent/drug/menthol, /datum/reagent/medicine, /datum/reagent/medicine/adminordrazine, /datum/reagent/medicine/adminordrazine/nanites, /datum/reagent/medicine/mine_salve, /datum/reagent/medicine/syndicate_nanites, /datum/reagent/medicine/strange_reagent, /datum/reagent/medicine/miningnanites, /datum/reagent/medicine/changelingAdrenaline, /datum/reagent/medicine/changelingAdrenaline2)
	var/drugs = typesof(/datum/reagent/drug) - blacklist
	var/meds = typesof(/datum/reagent/medicine) - blacklist
	var/chemlist = drugs + meds + /datum/reagent/anaphrodisiac + /datum/reagent/aphrodisiac
	chempath = pick(chemlist)
	targetchem = initial(chempath.id)
	update_explanation_text()

/datum/objective/crew/botanist/druglord/update_explanation_text()
	. = ..()
	explanation_text = "Have at least [target_amount] harvested plants containing [initial(chempath.name)] when the shift ends."

/datum/objective/crew/botanist/druglord/check_completion()
	var/pillcount = target_amount
	if(owner.current)
		if(owner.current.contents)
			for(var/obj/item/reagent_containers/food/snacks/grown/P in owner.current.get_contents())
				if(P.reagents.has_reagent(targetchem))
					pillcount--
	if(pillcount <= 0)
		return 1
	else
		return 0

/datum/objective/crew/bartender

/datum/objective/crew/bartender/responsibility
	explanation_text = "Make sure nobody dies of alchohol poisoning."

/datum/objective/crew/bartender/responsibility/check_completion()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H.stat == DEAD && H.drunkenness >= 80)
			if(H.z == ZLEVEL_STATION || SSshuttle.emergency.shuttle_areas[get_area(H)])
				return 0
	return 1

/datum/objective/crew/janitor

/datum/objective/crew/janitor/clean //ported from old Hippie
	var/list/areas = list()
	explanation_text = "Ensure sure that (Yo, something broke. Yell about this in citadels devlopmeent discussion channel.) remain spotless at the end of the shift."

/datum/objective/crew/janitor/clean/New()
	. = ..()
	var/list/possibleareas = GLOB.teleportlocs - /area - typesof(/area/space) - typesof(/area/lavaland) - typesof(/area/mine) - typesof(/area/ai_monitored/turret_protected) - typesof(/area/tcommsat)
	for(var/i in 1 to rand(1,6))
		areas |= pick_n_take(possibleareas)
	update_explanation_text()

/datum/objective/crew/janitor/clean/update_explanation_text()
	. = ..()
	explanation_text = "Ensure that the "
	for(var/i in 1 to areas.len)
		var/area/A = areas[i]
		explanation_text += "[A]"
		if(i != areas.len && areas.len >= 3)
			explanation_text += ", "
		if(i == areas.len - 1)
			explanation_text += "and "
	explanation_text += " [(areas.len ==1) ? "is completely" : "are [(areas.len == 2) ? "completely" : "all"]"] clean at the end of the shift."

/datum/objective/crew/janitor/clean/check_completion()
	for(var/area/A in areas)
		for(var/obj/effect/decal/cleanable/C in area_contents(A))
			return 0
	return 1

/datum/objective/crew/clown

/datum/objective/crew/clown/slipster //ported from old Hippie with adjustments
	explanation_text = "Slip at least (Yell on citadel's development discussion channel if you see this) different people with your PDA, and have it on you at the end of the shift."

/datum/objective/crew/clown/slipster/New()
	. = ..()
	target_amount = rand(5, 20)
	update_explanation_text()

/datum/objective/crew/clown/slipster/update_explanation_text()
	. = ..()
	explanation_text = "Slip at least [target_amount] different people with your PDA, and have it on you at the end of the shift."

/datum/objective/crew/clown/slipster/check_completion()
	var/uniqueslips = list()
	if(owner.current)
		for(/obj/item/device/pda/clown/PDA in get_contents(owner.current)) //100% open for badmin abuse
			for(var/mob/living/carbon/human/H in PDA.slipvictims)
				uniqueslips |= H
	if(uniqueslips.len >= target_amount)
		return 1
	else
		return 0

/datum/objective/crew/assistant

/datum/objective/crew/assistant/petsplosion
	explanation_text = "Ensure there are at least (If you see this, yell on citadels discord in the development discussion channel) pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/assistant/petsplosion/New()
	. = ..()
	target_amount = rand(10,20)
	update_explanation_text()

/datum/objective/crew/assistant/petsplosion/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/assistant/petsplosion/check_completion()
	var/petcount = target_amount
	for(var/mob/living/simple_animal/pet/P in GLOB.mob_list)
		if(!P.stat == DEAD)
			if(P.z == ZLEVEL_STATION || SSshuttle.emergency.shuttle_areas[get_area(P)])
				petcount--
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(!H.stat == DEAD)
			if(H.z == ZLEVEL_STATION || SSshuttle.emergency.shuttle_areas[get_area(H)])
				if(istype(H.wear_neck, /obj/item/clothing/neck/petcollar))
					petcount--
	if(petcount <= 0)
		return 1
	else
		return 0

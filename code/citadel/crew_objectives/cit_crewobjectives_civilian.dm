/*				CIVILIAN OBJECTIVES			*/

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
	var/list/uniqueslips = list()
	if(owner.current)
		for(var/obj/item/device/pda/clown/PDA in owner.current.get_contents()) //100% open for badmin abuse
			for(var/mob/living/carbon/human/H in PDA.slipvictims)
				uniqueslips |= H
	if(uniqueslips.len >= target_amount)
		return 1
	else
		return 0

/datum/objective/crew/mime

/datum/objective/crew/mime/vow //ported from old Hippie
	explanation_text = "Never break your vow of silence."

/datum/objective/crew/mime/vow/check_completion()
	if(owner.current)
		var/list/say_log = owner.current.logging[INDIVIDUAL_SAY_LOG]
		if(say_log.len > 0)
			return 0
	return 1

/datum/objective/crew/assistant

/datum/objective/crew/assistant/departmentclothes
	var/obj/item/clothing/under/rank/targetuniform
	explanation_text = "Be wearing a (Yo, this objective broke. report this to citadels discord via the development channel) at the end of the shift."

/datum/objective/crew/assistant/departmentclothes/New()
	. = ..()
	var/list/blacklist = list(/obj/item/clothing/under/rank, /obj/item/clothing/under/rank/miner, /obj/item/clothing/under/rank/medical/blue, /obj/item/clothing/under/rank/medical/green, /obj/item/clothing/under/rank/medical/purple, /obj/item/clothing/under/rank/security/grey, /obj/item/clothing/under/rank/warden/grey, /obj/item/clothing/under/rank/head_of_security/grey, /obj/item/clothing/under/rank/mailman, /obj/item/clothing/under/rank/psyche, /obj/item/clothing/under/rank/clown/sexy, /obj/item/clothing/under/rank/centcom_officer, /obj/item/clothing/under/rank/centcom_commander, /obj/item/clothing/under/rank/security/navyblue/russian, /obj/item/clothing/under/rank/security/blueshirt)
	var/list/validclothes = typesof(/obj/item/clothing/under/rank) - blacklist
	targetuniform = pick(validclothes)
	update_explanation_text()

/datum/objective/crew/assistant/departmentclothes/update_explanation_text()
	. = ..()
	explanation_text = "Be wearing a [targetuniform] at the end of the shift."

/datum/objective/crew/assistant/departmentclothes/check_completion()
	if(owner.current)
		var/mob/living/carbon/human/H = owner.current
		if(istype(H.w_uniform, targetuniform))
			return 1
	return 0

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

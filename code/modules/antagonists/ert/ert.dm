//Both ERT and DS are handled by the same datums since they mostly differ in equipment in objective.
/datum/team/ert
	name = "Emergency Response Team"
	var/datum/objective/mission //main mission

/datum/antagonist/ert
	name = "Emergency Response Officer"
	var/datum/team/ert/ert_team
	var/leader = FALSE
	var/datum/outfit/outfit = /datum/outfit/ert/security
	var/role = "Security Officer"
	var/list/name_source
	threat = -5
	var/random_names = TRUE
	var/rip_and_tear = FALSE
	var/equip_ert = TRUE
	var/forge_objectives_for_ert = TRUE
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	antag_moodlet = /datum/mood_event/focused

/datum/antagonist/ert/on_gain()
	if(random_names)
		update_name()
	if(forge_objectives_for_ert)
		forge_objectives()
	if(equip_ert)
		equipERT()
	. = ..()

/datum/antagonist/ert/get_team()
	return ert_team

/datum/antagonist/ert/New()
	. = ..()
	name_source = GLOB.last_names

/datum/antagonist/ert/proc/update_name()
	owner.current.fully_replace_character_name(owner.current.real_name,"[role] [pick(name_source)]")

/datum/antagonist/ert/deathsquad/New()
	. = ..()
	name_source = GLOB.commando_names

/datum/antagonist/ert/deathsquad/apply_innate_effects(mob/living/mob_override)
	ADD_TRAIT(owner, TRAIT_DISK_VERIFIER, DEATHSQUAD_TRAIT)

/datum/antagonist/ert/deathsquad/remove_innate_effects(mob/living/mob_override)
	REMOVE_TRAIT(owner, TRAIT_DISK_VERIFIER, DEATHSQUAD_TRAIT)

/datum/antagonist/ert/security // kinda handled by the base template but here for completion

/datum/antagonist/ert/security/amber
	outfit = /datum/outfit/ert/security/alert

/datum/antagonist/ert/security/red
	outfit = /datum/outfit/ert/security/alert/red

/datum/antagonist/ert/engineer
	role = "Engineer"
	outfit = /datum/outfit/ert/engineer
	skill_modifiers = list(/datum/skill_modifier/job/level/wiring)

/datum/antagonist/ert/engineer/amber
	outfit = /datum/outfit/ert/engineer/alert

/datum/antagonist/ert/engineer/red
	outfit = /datum/outfit/ert/engineer/alert/red

/datum/antagonist/ert/medic
	role = "Medical Officer"
	outfit = /datum/outfit/ert/medic
	skill_modifiers = list(/datum/skill_modifier/job/affinity/surgery)

/datum/antagonist/ert/medic/amber
	outfit = /datum/outfit/ert/medic/alert

/datum/antagonist/ert/medic/red
	outfit = /datum/outfit/ert/medic/alert/red

/datum/antagonist/ert/commander
	role = "Commander"
	outfit = /datum/outfit/ert/commander

/datum/antagonist/ert/commander/amber
	outfit = /datum/outfit/ert/commander/alert

/datum/antagonist/ert/commander/red
	outfit = /datum/outfit/ert/commander/alert/red

/datum/antagonist/ert/deathsquad
	name = "Deathsquad Trooper"
	outfit = /datum/outfit/death_commando
	role = "Trooper"

/datum/antagonist/ert/medic/inquisitor
	outfit = /datum/outfit/ert/medic/inquisitor

/datum/antagonist/ert/security/inquisitor
	outfit = /datum/outfit/ert/security/inquisitor

/datum/antagonist/ert/chaplain
	role = "Chaplain"
	outfit = /datum/outfit/ert/chaplain

/datum/antagonist/ert/chaplain/inquisitor
	outfit = /datum/outfit/ert/chaplain/inquisitor

/datum/antagonist/ert/chaplain/on_gain()
	. = ..()
	owner.isholy = TRUE

/datum/antagonist/ert/commander/inquisitor
	outfit = /datum/outfit/ert/commander/inquisitor

/datum/antagonist/ert/commander/inquisitor/on_gain()
	. = ..()
	owner.isholy = TRUE

/datum/antagonist/ert/deathsquad/leader
	name = "Deathsquad Officer"
	outfit = /datum/outfit/death_commando
	role = "Officer"

/datum/antagonist/ert/create_team(datum/team/ert/new_team)
	if(istype(new_team))
		ert_team = new_team

/datum/antagonist/ert/proc/forge_objectives()
	if(ert_team)
		objectives |= ert_team.objectives

/datum/antagonist/ert/proc/equipERT()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	H.equipOutfit(outfit)


/datum/antagonist/ert/greet()
	if(!ert_team)
		return

	to_chat(owner, "<B><font size=3 color=red>You are the [name].</font></B>")

	var/missiondesc = "Your squad is being sent on a mission to [station_name()] by Nanotrasen's Security Division."
	if(leader) //If Squad Leader
		missiondesc += " Lead your squad to ensure the completion of the mission. Board the shuttle when your team is ready."
	else
		missiondesc += " Follow orders given to you by your squad leader."

		missiondesc += "Avoid civilian casualites when possible."

	missiondesc += "<BR><B>Your Mission</B> : [ert_team.mission.explanation_text]"
	to_chat(owner,missiondesc)

/datum/antagonist/ert/deathsquad/greet()
	if(!ert_team)
		return

	to_chat(owner, "<B><font size=3 color=red>You are the [name].</font></B>")

	var/missiondesc = "Your squad is being sent on a mission to [station_name()] by Nanotrasen's Security Division."
	if(leader) //If Squad Leader
		missiondesc += " Lead your squad to ensure the completion of the mission. Board the shuttle when your team is ready."
	else
		missiondesc += " Follow orders given to you by your squad leader."

	missiondesc += "<BR><B>Your Mission</B> : [ert_team.mission.explanation_text]"
	to_chat(owner,missiondesc)


/datum/antagonist/ert/families
	name = "Space Police Responder"
	antag_hud_type = ANTAG_HUD_SPACECOP
	antag_hud_name = "hud_spacecop"
	suicide_cry = "FOR THE SPACE POLICE!!"

/datum/antagonist/ert/families/apply_innate_effects(mob/living/mob_override)
	..()
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)
	if(M.hud_used)
		var/datum/hud/H = M.hud_used
		var/atom/movable/screen/wanted/giving_wanted_lvl = new /atom/movable/screen/wanted()
		H.wanted_lvl = giving_wanted_lvl
		giving_wanted_lvl.hud = H
		H.infodisplay += giving_wanted_lvl
		H.mymob.client.screen += giving_wanted_lvl


/datum/antagonist/ert/families/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)
	if(M.hud_used)
		var/datum/hud/H = M.hud_used
		H.infodisplay -= H.wanted_lvl
		QDEL_NULL(H.wanted_lvl)
	..()

/datum/antagonist/ert/families/greet()
	var/missiondesc =  "<span class='warningplain'><B><font size=6 color=red>You are the [name].</font></B>"
	missiondesc += "<BR><B><font size=5 color=red>You are NOT a Nanotrasen Employee. You work for the local government.</font></B>"
	missiondesc += "<BR><B><font size=5 color=red>You are NOT a deathsquad. You are here to help innocents escape violence, criminal activity, and other dangerous things.</font></B>"
	missiondesc += "<BR>After an uptick in gang violence on [station_name()], you are responding to emergency calls from the station for immediate SSC Police assistance!\n"
	missiondesc += "<BR><B>Your Mission</B>:"
	missiondesc += "<BR> <B>1.</B> Serve the public trust."
	missiondesc += "<BR> <B>2.</B> Protect the innocent."
	missiondesc += "<BR> <B>3.</B> Uphold the law."
	missiondesc += "<BR> <B>4.</B> Find the Undercover Cops."
	missiondesc += "<BR> <B>5.</B> Detain Nanotrasen Security personnel if they harm any citizen."
	missiondesc += "<BR> You can <B>see gangsters</B> using your <B>special sunglasses</B>.</span>"
	to_chat(owner,missiondesc)
	var/policy = get_policy(ROLE_FAMILIES)
	if(policy)
		to_chat(owner, policy)
	var/mob/living/M = owner.current
	M.playsound_local(M, 'sound/effects/families_police.ogg', 100, FALSE, pressure_affected = FALSE)

/datum/antagonist/ert/families/undercover_cop
	name = "Undercover Cop"
	role = "Undercover Cop"
	outfit = /datum/outfit/families_police/beatcop
	var/free_clothes = list(/obj/item/clothing/glasses/hud/spacecop/hidden,
						/obj/item/clothing/under/rank/security/officer/beatcop,
						/obj/item/clothing/head/spacepolice)
	forge_objectives_for_ert = FALSE
	equip_ert = FALSE
	random_names = FALSE

/datum/antagonist/ert/families/undercover_cop/on_gain()
	if(istype(owner.current, /mob/living/carbon/human))
		for(var/C in free_clothes)
			var/obj/O = new C(owner.current)
			var/list/slots = list (
				"backpack" = ITEM_SLOT_BACKPACK,
				"left pocket" = ITEM_SLOT_LPOCKET,
				"right pocket" = ITEM_SLOT_RPOCKET
			)
			var/mob/living/carbon/human/H = owner.current
			var/equipped = H.equip_in_one_of_slots(O, slots)
			if(!equipped)
				to_chat(owner.current, "<span class='warningplain'>Unfortunately, you could not bring your [O] to this shift. You will need to find one.</span>")
				qdel(O)
	. = ..()


/datum/antagonist/ert/families/undercover_cop/greet()
	var/missiondesc = "<span class='warningplain'><B><font size=3 color=red>You are the [name].</font></B>"
	missiondesc += "<BR><B><font size=3 color=red>You are NOT a Nanotrasen Employee. You work for the local government.</font></B>"
	missiondesc += "<BR>You are an undercover police officer on board [station_name()]. You've been sent here by the Spinward Stellar Coalition because of suspected abusive behavior by the security department, and to keep tabs on a potential criminal organization operation."
	missiondesc += "<BR><B>Your Mission</B>:"
	missiondesc += "<BR> <B>1.</B> Keep a close eye on any gangsters you spot. You can view gangsters using your sunglasses in your backpack."
	missiondesc += "<BR> <B>2.</B> Keep an eye on how Security handles any gangsters, and watch for excessive security brutality."
	missiondesc += "<BR> <B>3.</B> Remain undercover and do not get found out by Security or any gangs. Nanotrasen does not take kindly to being spied on."
	missiondesc += "<BR> <B>4.</B> When your backup arrives to extract you in 1 hour, inform them of everything you saw of note, and assist them in securing the situation.</span>"
	to_chat(owner,missiondesc)

/datum/antagonist/ert/families/beatcop
	name = "Beat Cop"
	role = "Police Officer"
	outfit = /datum/outfit/families_police/beatcop

/datum/antagonist/ert/families/beatcop/armored
	name = "Armored Beat Cop"
	role = "Police Officer"
	outfit = /datum/outfit/families_police/beatcop/armored

/datum/antagonist/ert/families/beatcop/swat
	name = "S.W.A.T. Member"
	role = "S.W.A.T. Officer"
	outfit = /datum/outfit/families_police/beatcop/swat

/datum/antagonist/ert/families/beatcop/fbi
	name = "FBI Agent"
	role = "FBI Agent"
	outfit = /datum/outfit/families_police/beatcop/fbi

/datum/antagonist/ert/families/beatcop/military
	name = "Space Military"
	role = "Sergeant"
	outfit = /datum/outfit/families_police/beatcop/military

/datum/antagonist/ert/families/beatcop/military/New()
	. = ..()
	name_source = GLOB.commando_names

/datum/antagonist/ert/marine
	name = "Marine Commander"
	outfit = /datum/outfit/ert/commander/alert
	role = "Commander"

/datum/antagonist/ert/marine/security
	name = "Marine Heavy"
	outfit = /datum/outfit/ert/security/alert
	role = "Trooper"

/datum/antagonist/ert/marine/engineer
	name = "Marine Engineer"
	outfit = /datum/outfit/ert/engineer/alert
	role = "Engineer"

/datum/antagonist/ert/marine/medic
	name = "Marine Medic"
	outfit = /datum/outfit/ert/medic/alert
	role = "Medical Officer"

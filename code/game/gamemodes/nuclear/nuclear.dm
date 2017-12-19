/datum/game_mode
	var/list/datum/mind/syndicates = list()
	var/nukeops_lastname = ""

/datum/game_mode/nuclear
	name = "nuclear emergency"
	config_tag = "nuclear"
	false_report_weight = 10
	required_players = 30 // 30 players - 3 players to be the nuke ops = 27 players remaining
	required_enemies = 2
	recommended_enemies = 5
	antag_flag = ROLE_OPERATIVE
	enemy_minimum_age = 14

	announce_span = "danger"
	announce_text = "Syndicate forces are approaching the station in an attempt to destroy it!\n\
	<span class='danger'>Operatives</span>: Secure the nuclear authentication disk and use your nuke to destroy the station.\n\
	<span class='notice'>Crew</span>: Defend the nuclear authentication disk and ensure that it leaves with you on the emergency shuttle."

	var/const/agents_possible = 5 //If we ever need more syndicate agents.

	var/nukes_left = 1 // Call 3714-PRAY right now and order more nukes! Limited offer!
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level
	var/list/pre_nukeops = list()

/datum/game_mode/nuclear/pre_setup()
	var/n_agents = min(round(num_players() / 10), antag_candidates.len, agents_possible)
	for(var/i = 0, i < n_agents, ++i)
		var/datum/mind/new_op = pick_n_take(antag_candidates)
		pre_nukeops += new_op
		new_op.assigned_role = "Nuclear Operative"
		new_op.special_role = "Nuclear Operative"
		log_game("[new_op.key] (ckey) has been selected as a nuclear operative")
	return TRUE

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_synd_icons_added(datum/mind/synd_mind)
	var/datum/atom_hud/antag/opshud = GLOB.huds[ANTAG_HUD_OPS]
	opshud.join_hud(synd_mind.current)
	set_antag_hud(synd_mind.current, "synd")

/datum/game_mode/proc/update_synd_icons_removed(datum/mind/synd_mind)
	var/datum/atom_hud/antag/opshud = GLOB.huds[ANTAG_HUD_OPS]
	opshud.leave_hud(synd_mind.current)
	set_antag_hud(synd_mind.current, null)

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/datum/game_mode/nuclear/post_setup()
	var/nuke_code = random_nukecode()
	var/agent_number = 1
	var/datum/mind/leader = pick(pre_nukeops)
	syndicates += pre_nukeops
	for(var/i = 1 to pre_nukeops.len)
		var/datum/mind/op = pre_nukeops[i]

		forge_syndicate_objectives(op)
		greet_syndicate(op)
		equip_syndicate(op.current)

		if(nuke_code)
			op.store_memory("<B>Syndicate Nuclear Bomb Code</B>: [nuke_code]", 0, 0)
			to_chat(op.current, "The nuclear authorization code is: <B>[nuke_code]</B>")

		if(op == leader)
			op.current.forceMove(pick(GLOB.nukeop_leader_start))
			prepare_syndicate_leader(op, nuke_code)
		else
			op.current.forceMove(GLOB.nukeop_start[((i - 1) % GLOB.nukeop_start.len) + 1])
			op.current.real_name = "[syndicate_name()] Operative #[agent_number++]"

		update_synd_icons_added(op)
		op.current.playsound_local(get_turf(op.current), 'sound/ambience/antag/ops.ogg',100,0)

	var/obj/machinery/nuclearbomb/nuke = locate("syndienuke") in GLOB.nuke_list
	if(nuke)
		nuke.r_code = nuke_code
	return ..()

/datum/game_mode/proc/prepare_syndicate_leader(datum/mind/synd_mind, nuke_code)
	var/leader_title = pick("Czar", "Boss", "Commander", "Chief", "Kingpin", "Director", "Overlord")
	addtimer(CALLBACK(src, .proc/nuketeam_name_assign, synd_mind), 1)
	synd_mind.current.real_name = "[syndicate_name()] [leader_title]"
	to_chat(synd_mind.current, "<B>You are the Syndicate [leader_title] for this mission. You are responsible for the distribution of telecrystals and your ID is the only one who can open the launch bay doors.</B>")
	to_chat(synd_mind.current, "<B>If you feel you are not up to this task, give your ID to another operative.</B>")
	to_chat(synd_mind.current, "<B>In your hand you will find a special item capable of triggering a greater challenge for your team. Examine it carefully and consult with your fellow operatives before activating it.</B>")

	var/obj/item/device/nuclear_challenge/challenge = new /obj/item/device/nuclear_challenge
	synd_mind.current.put_in_hands(challenge, TRUE)

	var/static/id_cache = typecacheof(/obj/item/card/id)
	var/list/foundIDs = typecache_filter_list(synd_mind.current.GetAllContents(), id_cache)
	if(foundIDs.len)
		for(var/i in 1 to foundIDs.len)
			var/obj/item/card/id/ID = foundIDs[i]
			ID.name = "lead agent card"
			ID.access += ACCESS_SYNDICATE_LEADER
	else
		message_admins("Warning: Nuke Ops spawned without access to leave their spawn area!")

	var/obj/item/device/radio/headset/syndicate/alt/A = locate() in synd_mind.current
	if(A)
		A.command = TRUE

	if(nuke_code)
		var/obj/item/paper/P = new
		P.info = "The nuclear authorization code is: <b>[nuke_code]</b>"
		P.name = "nuclear bomb code"
		var/mob/living/carbon/human/H = synd_mind.current
		H.put_in_hands(P, TRUE)
		H.update_icons()
	else
		nuke_code = "code will be provided later"
	return

/datum/game_mode/proc/nuketeam_name_assign(datum/mind/synd_mind)
	nukeops_lastname = nukelastname(synd_mind.current)
	NukeNameAssign(nukeops_lastname, syndicates)


/datum/game_mode/proc/forge_syndicate_objectives(datum/mind/syndicate)
	var/datum/objective/nuclear/syndobj = new
	syndobj.owner = syndicate
	syndicate.objectives += syndobj


/datum/game_mode/proc/greet_syndicate(datum/mind/syndicate, you_are=1)
	if(you_are)
		to_chat(syndicate.current, "<span class='notice'>You are a [syndicate_name()] agent!</span>")
	syndicate.announce_objectives()

/datum/game_mode/proc/equip_syndicate(mob/living/carbon/human/synd_mob, telecrystals = TRUE)
	synd_mob.set_species(/datum/species/human) //Plasamen burn up otherwise, and lizards are vulnerable to asimov AIs

	if(telecrystals)
		synd_mob.equipOutfit(/datum/outfit/syndicate)
	else
		synd_mob.equipOutfit(/datum/outfit/syndicate/no_crystals)
	return TRUE

/datum/game_mode/nuclear/OnNukeExplosion(off_station)
	..()
	nukes_left--
	var/obj/docking_port/mobile/Shuttle = SSshuttle.getShuttle("syndicate")
	syndies_didnt_escape = (Shuttle && (Shuttle.z == ZLEVEL_CENTCOM || Shuttle.z == ZLEVEL_TRANSIT)) ? 0 : 1
	nuke_off_station = off_station

/datum/game_mode/nuclear/check_win()
	if (nukes_left == 0)
		return TRUE
	return ..()

/datum/game_mode/proc/are_operatives_dead()
	for(var/datum/mind/operative_mind in syndicates)
		if(ishuman(operative_mind.current) && (operative_mind.current.stat!=2))
			return FALSE
	return TRUE

/datum/game_mode/nuclear/check_finished() //to be called by SSticker
	if(replacementmode && round_converted == 2)
		return replacementmode.check_finished()
	if((SSshuttle.emergency.mode == SHUTTLE_ENDGAME) || station_was_nuked)
		return TRUE
	if(are_operatives_dead())
		var/obj/machinery/nuclearbomb/N
		pass(N)	//suppress unused warning
		if(N.bomb_set) //snaaaaaaaaaake! It's not over yet!
			return FALSE	//its a static var btw
	..()

/datum/game_mode/nuclear/set_round_result()
	var result = nuke_team.get_result()
	switch(result)
		if(NUKE_RESULT_FLUKE)
			SSticker.mode_result = "loss - syndicate nuked - disk secured"
			SSticker.news_report = NUKE_SYNDICATE_BASE
		if(NUKE_RESULT_NUKE_WIN)
			SSticker.mode_result = "win - syndicate nuke"
			SSticker.news_report = STATION_NUKED
		if(NUKE_RESULT_NOSURVIVORS)
			SSticker.mode_result = "halfwin - syndicate nuke - did not evacuate in time"
			SSticker.news_report = STATION_NUKED
		if(NUKE_RESULT_WRONG_STATION)
			SSticker.mode_result = "halfwin - blew wrong station"
			SSticker.news_report = NUKE_MISS
		if(NUKE_RESULT_WRONG_STATION_DEAD)
			SSticker.mode_result = "halfwin - blew wrong station - did not evacuate in time"
			SSticker.news_report = NUKE_MISS
		if(NUKE_RESULT_CREW_WIN_SYNDIES_DEAD)
			SSticker.mode_result = "loss - evacuation - disk secured - syndi team dead"
			SSticker.news_report = OPERATIVES_KILLED
		if(NUKE_RESULT_CREW_WIN)
			SSticker.mode_result = "loss - evacuation - disk secured"
			SSticker.news_report = OPERATIVES_KILLED
		if(NUKE_RESULT_DISK_LOST)
			SSticker.mode_result = "halfwin - evacuation - disk not secured"
			SSticker.news_report = OPERATIVE_SKIRMISH
		if(NUKE_RESULT_DISK_STOLEN)
			SSticker.mode_result = "halfwin - detonation averted"
			SSticker.news_report = OPERATIVE_SKIRMISH
		else
			SSticker.mode_result = "halfwin - interrupted"
			SSticker.news_report = OPERATIVE_SKIRMISH
	return ..()

/datum/game_mode/nuclear/generate_report()
	return "One of Central Command's trading routes was recently disrupted by a raid carried out by the Gorlex Marauders. They seemed to only be after one ship - a highly-sensitive \
			transport containing a nuclear fission explosive, although it is useless without the proper code and authorization disk. While the code was likely found in minutes, the only disk that \
			can activate this explosive is on your station. Ensure that it is protected at all times, and remain alert for possible intruders."

/proc/is_nuclear_operative(mob/M)
	return M && istype(M) && M.mind && SSticker && SSticker.mode && M.mind in SSticker.mode.syndicates

/datum/outfit/syndicate
	name = "Syndicate Operative - Basic"

	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack
	ears = /obj/item/device/radio/headset/syndicate/alt
	l_pocket = /obj/item/pinpointer/nuke/syndicate
	id = /obj/item/card/id/syndicate
	belt = /obj/item/gun/ballistic/automatic/pistol
	backpack_contents = list(/obj/item/storage/box/syndie=1)

	var/tc = 25

/datum/outfit/syndicate/no_crystals
	tc = 0


/datum/outfit/syndicate/post_equip(mob/living/carbon/human/H)
	var/obj/item/device/radio/R = H.ears
	R.set_frequency(GLOB.SYND_FREQ)
	R.freqlock = 1

	if(tc)
		var/obj/item/device/radio/uplink/nuclear/U = new(H, H.key, tc)
		H.equip_to_slot_or_del(U, slot_in_backpack)

	var/obj/item/implant/weapons_auth/W = new/obj/item/implant/weapons_auth(H)
	W.implant(H)
	var/obj/item/implant/explosive/E = new/obj/item/implant/explosive(H)
	E.implant(H)
	H.faction |= "syndicate"
	H.update_icons()

/datum/outfit/syndicate/full
	name = "Syndicate Operative - Full Kit"

	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/syndicate
	suit = /obj/item/clothing/suit/space/hardsuit/syndi
	r_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	internals_slot = slot_r_store
	belt = /obj/item/storage/belt/military
	r_hand = /obj/item/gun/ballistic/automatic/shotgun/bulldog
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/tank/jetpack/oxygen/harness=1,\
		/obj/item/gun/ballistic/automatic/pistol=1)

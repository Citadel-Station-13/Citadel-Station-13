GLOBAL_VAR_INIT(servants_active, FALSE) //This var controls whether or not a lot of the cult's structures work or not

/*

CLOCKWORK CULT: Based off of the failed pull requests from /vg/

While Nar'Sie is the oldest and most prominent of the elder gods, there are other forces at work in the universe.
Ratvar, the Clockwork Justiciar, a homage to Nar'Sie granted sentience by its own power, is one such other force.
Imprisoned within a massive construct known as the Celestial Derelict - or Reebe - an intense hatred of the Blood God festers.
Ratvar, unable to act in the mortal plane, seeks to return and forms covenants with mortals in order to bolster his influence.
Due to his mechanical nature, Ratvar is also capable of influencing silicon-based lifeforms, unlike Nar'Sie, who can only influence natural life.

This is a team-based gamemode, and the team's objective is shared by all cultists. Their goal is to defend an object called the Ark on a separate z-level.

The clockwork version of an arcane tome is the clockwork slab.

This file's folder contains:
	clock_cult.dm: Core gamemode files.
	clock_effect.dm: The base clockwork effect code.
	- Effect files are in game/gamemodes/clock_cult/clock_effects/
	clock_item.dm: The base clockwork item code.
	- Item files are in game/gamemodes/clock_cult/clock_items/
	clock_mobs.dm: Hostile clockwork creatures.
	clock_scripture.dm: The base Scripture code.
	- Scripture files are in game/gamemodes/clock_cult/clock_scripture/
	clock_structure.dm: The base clockwork structure code, including clockwork machines.
	- Structure files, and Ratvar, are in game/gamemodes/clock_cult/clock_structures/

	game/gamemodes/clock_cult/clock_helpers/ contains several helper procs, including the Ratvarian language.

	clockcult defines are in __DEFINES/clockcult.dm

Credit where due:
1. VelardAmakar from /vg/ for the entire design document, idea, and plan. Thank you very much.
2. SkowronX from /vg/ for MANY of the assets
3. FuryMcFlurry from /vg/ for many of the assets
4. PJB3005 from /vg/ for the failed continuation PR
5. Xhuis from /tg/ for coding the first iteration of the mode, and the new, reworked version
6. ChangelingRain from /tg/ for maintaining the gamemode for months after its release prior to its rework
7. Clockwork cult code as of now, at least the one being pulled from Citadel Station's master branch, is being, or already is, fixed by Coolgat3 and Avunia.
8. Modern clockwork cult code mixed with original clockwork code, with various changes to make it less of a fustercluck, done by KeRSe. \
	Fixes and assistance done by TimothyTeakettle, Kevinz000, and Deltafire15. -Very glad for the help they gave.
*/

///////////
// PROCS //
///////////

/proc/is_servant_of_ratvar(mob/M, require_full_power = FALSE, holy_water_check = FALSE)
	if(!istype(M) || isobserver(M))
		return FALSE
	var/datum/antagonist/clockcult/D = M?.mind?.has_antag_datum(/datum/antagonist/clockcult)
	return D && (!require_full_power || !D.neutered) && (!holy_water_check || !D.ignore_holy_water)

/proc/is_eligible_servant(mob/M)
	if(!istype(M))
		return FALSE
	if(M.mind)
		if(M.mind.assigned_role in list("Captain", "Chaplain"))
			return FALSE
		if(M.mind.enslaved_to && !is_servant_of_ratvar(M.mind.enslaved_to))
			return FALSE
		if(M.mind.unconvertable)
			return FALSE
	else
		return FALSE
	if(iscultist(M) || isconstruct(M) || ispAI(M))
		return FALSE
	if(isliving(M))
		var/mob/living/L = M
		if(HAS_TRAIT(L, TRAIT_MINDSHIELD))
			return FALSE
	if(ishuman(M) || isbrain(M) || isguardian(M) || issilicon(M) || isclockmob(M) || istype(M, /mob/living/simple_animal/drone/cogscarab) || istype(M, /mob/camera/eminence))
		return TRUE
	return FALSE

/proc/add_servant_of_ratvar(mob/L, silent = FALSE, create_team = TRUE, override_type)
	if(!L || !L.mind)
		return
	var/update_type = /datum/antagonist/clockcult
	if(silent)
		update_type = /datum/antagonist/clockcult/silent
	if(override_type)		//prioritizes
		update_type = override_type
	var/datum/antagonist/clockcult/C = new update_type(L.mind)
	C.make_team = create_team
	C.show_in_roundend = create_team //tutorial scarabs begone

	if(iscyborg(L))
		var/mob/living/silicon/robot/R = L
		if(R.deployed)
			var/mob/living/silicon/ai/AI = R.mainframe
			R.undeploy()
			to_chat(AI, "<span class='userdanger'>Anomaly Detected. Returned to core!</span>") //The AI needs to be in its core to properly be converted

	. = L.mind.add_antag_datum(C)

	if(!silent && L)
		if(.)
			to_chat(L, "<span class='heavy_brass'>The world before you suddenly glows a brilliant yellow. [issilicon(L) ? "You cannot compute this truth!" : \
			"Your mind is racing!"] You hear the whooshing steam and cl[pick("ank", "ink", "unk", "ang")]ing cogs of a billion billion machines, and all at once it comes to you.<br>\
			Ratvar, the Clockwork Justiciar, [GLOB.ratvar_awakens ? "has been freed from his eternal prison" : "lies in exile, derelict and forgotten in an unseen realm"].</span>")
			flash_color(L, flash_color = list("#BE8700", "#BE8700", "#BE8700", rgb(0,0,0)), flash_time = 50)
		else
			L.visible_message("<span class='boldwarning'>[L] seems to resist an unseen force!</span>", null, null, 7, L)
			to_chat(L, "<span class='heavy_brass'>The world before you suddenly glows a brilliant yellow. [issilicon(L) ? "You cannot compute this truth!" : \
			"Your mind is racing!"] You hear the whooshing steam and cl[pick("ank", "ink", "unk", "ang")]ing cogs of a billion billion machines, and the sound</span> <span class='boldwarning'>\
			is a meaningless cacophony.</span><br>\
			<span class='userdanger'>You see an abomination of rusting parts[GLOB.ratvar_awakens ? ", and it is here.<br>It is too late" : \
			" in an endless grey void.<br>It cannot be allowed to escape"].</span>")
			L.playsound_local(get_turf(L), 'sound/ambience/antag/clockcultalr.ogg', 40, TRUE, frequency = 100000, pressure_affected = FALSE)
			flash_color(L, flash_color = list("#BE8700", "#BE8700", "#BE8700", rgb(0,0,0)), flash_time = 5)

/proc/remove_servant_of_ratvar(mob/L, silent = FALSE)
	if(!L || !L.mind)
		return
	var/datum/antagonist/clockcult/clock_datum = L.mind.has_antag_datum(/datum/antagonist/clockcult)
	if(!clock_datum)
		return FALSE
	clock_datum.silent = silent
	clock_datum.on_removal()
	return TRUE

///////////////
// GAME MODE //
///////////////

/datum/game_mode
	var/list/servants_of_ratvar = list() //The Enlightened servants of Ratvar
	var/clockwork_explanation = "Defend the Ark of the Clockwork Justiciar and free Ratvar." //The description of the current objective

/datum/game_mode/clockwork_cult
	name = "clockwork cult"
	config_tag = "clockwork_cult"
	antag_flag = ROLE_SERVANT_OF_RATVAR
	false_report_weight = 10
	chaos = 8
	required_players = 24 //Fixing this directly for now since apparently config machine for forcing modes broke.
	required_enemies = 3
	recommended_enemies = 5
	enemy_minimum_age = 7
	protected_jobs = list("Prisoner", "AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster") //Silicons can eventually be converted
	restricted_jobs = list("Chaplain", "Captain")
	announce_span = "brass"
	announce_text = "Servants of Ratvar are trying to summon the Justiciar!\n\
	<span class='brass'>Servants</span>: Construct defenses to protect the Ark. Sabotage the station!\n\
	<span class='notice'>Crew</span>: Stop the servants before they can summon the Clockwork Justiciar."
	var/list/servants_to_serve = list() //Yes this list is made out of list
	var/roundstart_player_count

	var/datum/team/clockcult/main_clockcult

/datum/game_mode/clockwork_cult/pre_setup() //Gamemode and job code is pain. Have fun codediving all of that stuff, whoever works on this next - Delta
	if(!load_reebe())
		return FALSE
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs
	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"
	var/starter_servants = 4 //Try to go for at least four
	var/number_players = num_players()
	roundstart_player_count = number_players
	if(number_players > 30) //plus one servant for every additional 10 players above 30
		number_players -= 30
		starter_servants += round(number_players / 10)
		starter_servants = min(starter_servants, 8) //max 8 servants (that sould only happen with a ton of players)
	while(starter_servants)
		if(!antag_candidates.len)
			break //Skip setup, DO NOT RUNTIME
		var/datum/mind/servant = antag_pick(antag_candidates)
		servants_to_serve += servant
		antag_candidates -= servant
		servant.special_role = ROLE_SERVANT_OF_RATVAR
		servant.restricted_roles = restricted_jobs
		starter_servants--
	if(!servants_to_serve.len) //Uh oh, something went wrong
		setup_error = "There are no clockcult candidates! (Or something went very wrong)"
		return FALSE
	GLOB.clockwork_vitality += 50 * servants_to_serve.len //some starter Vitality to help recover from initial fuck ups
	return TRUE //Haha yes it works time to not touch it any more than that.

/datum/game_mode/clockwork_cult/post_setup()
	for(var/S in servants_to_serve)
		var/datum/mind/servant = S
		log_game("[key_name(servant)] was made an initial servant of Ratvar")
		var/mob/living/L = servant.current
		greet_servant(L)
		equip_servant(L)
		add_servant_of_ratvar(L, TRUE)
	..()
	return TRUE

/datum/game_mode/proc/greet_servant(mob/M) //Description of their role
	if(!M)
		return FALSE
	to_chat(M, "<span class='bold large_brass'>You are a servant of Ratvar, the Clockwork Justiciar!</span>")
	to_chat(M, "<span class='brass'>Unlock <b>Script</b> scripture by converting a new servant or when 35kw of power is reached.</span>")
	to_chat(M, "<span class='brass'><b>Application</b> scripture will be unlocked when 50kw of power is reached.</span>")
	M.playsound_local(get_turf(M), 'sound/ambience/antag/clockcultalr.ogg', 100, FALSE, pressure_affected = FALSE)
	return TRUE

/datum/game_mode/proc/equip_servant(mob/living/M) //Grants a clockwork slab to the mob
	if(!M || !ishuman(M))
		return FALSE
	var/mob/living/carbon/human/L = M
	var/obj/item/clockwork/slab/S = new
	var/slot = "At your feet"
	var/list/slots = list("In your left pocket" = ITEM_SLOT_LPOCKET, "In your right pocket" = ITEM_SLOT_RPOCKET, "In your backpack" = ITEM_SLOT_BACKPACK)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/clockwork/replica_fabricator/F = new
		if(H.equip_to_slot_or_del(F, ITEM_SLOT_BACKPACK))
			to_chat(H, "<span class='brass'>You have been equipped with a replica fabricator, an advanced tool that can convert objects like doors, tables or even coats into clockwork equivalents.</span>")
		slot = H.equip_in_one_of_slots(S, slots)
		if(slot == "In your backpack")
			slot = "In your [H.back.name]"
	if(slot == "At your feet")
		if(!S.forceMove(get_turf(L)))
			qdel(S)
	if(S && !QDELETED(S))
		to_chat(L, "<span class='alloy'>[slot] is a <b>clockwork slab</b>, a multipurpose tool used to construct machines and invoke ancient words of power. If this is your first time \
		as a servant, you can read <a href=\"https://citadel-station.net/wikimain/index.php?title=Clockwork_Cult\">the wiki page</a> to learn more.</span>")
		return TRUE
	return FALSE

/datum/game_mode/clockwork_cult/check_finished()
	if(GLOB.ark_of_the_clockwork_justiciar && !GLOB.ratvar_awakens) // Doesn't end until the Ark is destroyed or completed
		return FALSE
	return ..()

/datum/game_mode/clockwork_cult/proc/check_clockwork_victory()
	return main_clockcult.check_clockwork_victory()

/datum/game_mode/clockwork_cult/set_round_result()
	..()
	if(GLOB.clockwork_gateway_activated)
		SSticker.news_report = CLOCK_SUMMON
		SSticker.mode_result = "win - servants completed their objective (summon ratvar)"
	else
		SSticker.news_report = CULT_FAILURE
		SSticker.mode_result = "loss - servants failed their objective (summon ratvar)"

/datum/game_mode/clockwork_cult/generate_report()
	return "Bluespace monitors near your sector have detected a continuous stream of patterned fluctuations since the station was completed. It is most probable that a powerful entity \
	from a very far distance away is using to the station as a vector to cross that distance through bluespace. The theoretical power required for this would be monumental, and if \
	the entity is hostile, it would need to rely on a single central power source - disrupting or destroying that power source would be the best way to prevent said entity from causing \
	harm to company personnel or property.<br><br>Keep a sharp on any crew that appear to be oddly-dressed or using what appear to be magical powers, as these crew may be defectors \
	working for this entity and utilizing highly-advanced technology to cross the great distance at will. If they should turn out to be a credible threat, the task falls on you and \
	your crew to dispatch it in a timely manner."

/datum/game_mode/proc/update_servant_icons_added(datum/mind/M)
	var/datum/atom_hud/antag/A = GLOB.huds[ANTAG_HUD_CLOCKWORK]
	A.join_hud(M.current)
	set_antag_hud(M.current, "clockwork")

/datum/game_mode/proc/update_servant_icons_removed(datum/mind/M)
	var/datum/atom_hud/antag/A = GLOB.huds[ANTAG_HUD_CLOCKWORK]
	A.leave_hud(M.current)
	set_antag_hud(M.current, null)



//Servant of Ratvar outfit
/datum/outfit/servant_of_ratvar
	name = "Servant of Ratvar"
	uniform = /obj/item/clothing/under/rank/engineering/engineer //no more chameleon suit for them, as requested
	shoes = /obj/item/clothing/shoes/sneakers/black
	back = /obj/item/storage/backpack
	ears = /obj/item/radio/headset
	gloves = /obj/item/clothing/gloves/color/yellow
	belt = /obj/item/storage/belt/utility/servant
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
	/obj/item/clockwork/replica_fabricator = 1, /obj/item/stack/tile/brass/fifty = 1, /obj/item/reagent_containers/food/drinks/bottle/holyoil = 1)
	id = /obj/item/pda
	var/plasmaman //We use this to determine if we should activate internals in post_equip()

/datum/outfit/servant_of_ratvar/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H.dna.species.id == "plasmaman") //Plasmamen get additional equipment because of how they work
		head = /obj/item/clothing/head/helmet/space/plasmaman
		uniform = /obj/item/clothing/under/plasmaman //Plasmamen generally shouldn't need chameleon suits anyways, since everyone expects them to wear their fire suit
		r_hand = /obj/item/tank/internals/plasmaman/belt/full
		mask = /obj/item/clothing/mask/breath
		plasmaman = TRUE

/datum/outfit/servant_of_ratvar/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = new(H)
	var/obj/item/pda/PDA = H.wear_id
	W.assignment = "Assistant"
	W.access += ACCESS_MAINT_TUNNELS
	W.registered_name = H.real_name
	W.update_label()
	if(plasmaman && !visualsOnly) //If we need to breathe from the plasma tank, we should probably start doing that
		H.internal = H.get_item_for_held_index(2)
		H.update_internals_hud_icon(1)
	PDA.owner = H.real_name
	PDA.ownjob = "Assistant"
	PDA.update_label()
	PDA.id_check(H, W)
	H.sec_hud_set_ID()

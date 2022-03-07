/datum/job/mime
	title = "Mime"
	desc = "The Mime tries to entertain the crew with, well, miming. To varying degrees of success."
	faction = JOB_FACTION_STATION
	total_positions = 1
	roundstart_positions = 1
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/mime
	plasma_outfit = /datum/outfit/plasmaman/mime

	access = list(ACCESS_THEATRE)
	minimal_access = list(ACCESS_THEATRE)
	paycheck = PAYCHECK_MINIMAL
	paycheck_department = ACCOUNT_SRV


	threat = 0

/datum/job/mime/after_spawn(mob/M, latejoin, client/C)
	. = ..()
	M.apply_pref_name("mime", C.prefs)

/datum/outfit/job/mime
	name = "Mime"
	jobtype = /datum/job/mime

	belt = /obj/item/pda/mime
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/mime
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/frenchberet
	suit = /obj/item/clothing/suit/suspenders
	backpack_contents = list(/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing=1)

	backpack = /obj/item/storage/backpack/mime
	satchel = /obj/item/storage/backpack/mime


/datum/outfit/job/mime/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	..()

	if(visualsOnly)
		return

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak(null))
		H.mind.miming = 1

	var/client/C = H.client || preference_source
	if(C)
		H.apply_pref_name("mime", C)
	else
		H.fully_replace_character_name(H.real_name, pick(GLOB.mime_names))


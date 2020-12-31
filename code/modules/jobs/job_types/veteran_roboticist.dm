/datum/job/veteran_roboticist
	title = "Veteran Roboticist"
	flag = ROBOTICIST
	department_head = list("Research Director")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#9574cd"
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SCIENCE

	outfit = /datum/outfit/job/veteran_roboticist
	plasma_outfit = /datum/outfit/plasmaman/robotics

	access = list(ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_TECH_STORAGE, ACCESS_MORGUE, ACCESS_RESEARCH, ACCESS_MINERAL_STOREROOM, ACCESS_XENOBIOLOGY, ACCESS_GENETICS)
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE, ACCESS_MORGUE, ACCESS_RESEARCH, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SCI

	starting_modifiers = list(/datum/skill_modifier/job/level/wiring, /datum/skill_modifier/job/affinity/wiring)

	display_order = JOB_DISPLAY_ORDER_ROBOTICIST
	threat = 1

/datum/outfit/job/veteran_roboticist
	name = "Veteran Roboticist"
	jobtype = /datum/job/veteran_roboticist

	l_pocket = /obj/item/pda/roboticist
	ears = /obj/item/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/rnd/roboticist
	suit = /obj/item/clothing/suit/toggle/labcoat
	backpack_contents = list(/obj/item/autosurgeon/vet_toolkit=1)

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox


	pda_slot = SLOT_L_STORE


/datum/job/veteran_roboticist/after_spawn(mob/living/carbon/human/H, mob/M) //Instead of going through the process of adding spawnpoints
    var/turf/T
    var/spawn_point = locate(/obj/effect/landmark/start/roboticist) in GLOB.start_landmarks_list
    T = get_turf(spawn_point)
    H.Move(T)

/obj/item/autosurgeon/vet_toolkit
	desc = "A single use autosurgeon that contains a Toolkit augment. A screwdriver can be used to remove it, but implants can't be placed back in."
	uses = 1
	starting_organ = /obj/item/organ/cyberimp/arm/toolset


get_all_job_icons()
	return list("Veteran Roboticist") + ..()
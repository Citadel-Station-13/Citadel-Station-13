// Orgains and Robotics exports. Hearts, new lims, implants, etc.

/datum/export/robotics
	include_subtypes = FALSE
	k_elasticity = 0 //ALWAYS worth selling upgrades

/datum/export/implant
	include_subtypes = FALSE
	k_elasticity = 0 //ALWAYS worth selling upgrades

/datum/export/orgains
	include_subtypes = TRUE
	k_elasticity = 0 //ALWAYS worth selling orgains

/datum/export/implant/autodoc
	cost = 150
	unit_name = "autsurgeon"
	export_types = list(/obj/item/autosurgeon)
	include_subtypes = TRUE

/datum/export/implant/implant
	cost = 50
	unit_name = "implant"
	export_types = list(/obj/item/implant)
	include_subtypes = TRUE

/datum/export/implant/cnsreboot
	cost = 350
	unit_name = "anti drop implant"
	export_types = list(/obj/item/organ/cyberimp/brain/anti_drop)

/datum/export/implant/antistun
	cost = 450
	unit_name = "rebooter implant"
	export_types = list(/obj/item/organ/cyberimp/brain/anti_stun)

/datum/export/implant/breathtube
	cost = 150
	unit_name = "breath implant"
	export_types = list(/obj/item/organ/cyberimp/mouth/breathing_tube)

/datum/export/implant/hungerbgone
	cost = 200
	unit_name = "nutriment implant"
	export_types = list(/obj/item/organ/cyberimp/chest/nutriment)

/datum/export/implant/hungerbgoneplus
	cost = 300
	unit_name = "upgraded nutriment implant"
	export_types = list(/obj/item/organ/cyberimp/chest/nutriment/plus)

/datum/export/implant/reviver
	cost = 350
	unit_name = "reviver implant"
	export_types = list(/obj/item/organ/cyberimp/chest/reviver)

/datum/export/implant/thrusters
	cost = 150
	unit_name = "thrusters set implant"
	export_types = list(/obj/item/organ/cyberimp/chest/thrusters)

/datum/export/implant/thrusters
	cost = 150
	unit_name = "thrusters set implant"
	export_types = list(/obj/item/organ/cyberimp/chest/thrusters)

/datum/export/implant/arm
	cost = 200
	unit_name = "arm set implant"
	export_types = list(/obj/item/organ/cyberimp/arm/toolset, /obj/item/organ/cyberimp/arm/surgery)
	include_subtypes = TRUE

/datum/export/implant/combatarm
	cost = 800
	unit_name = "combat arm set implant"
	export_types = list(/obj/item/organ/cyberimp/arm/gun/laser, /obj/item/organ/cyberimp/arm/gun/taser, /obj/item/organ/cyberimp/arm/esword, /obj/item/organ/cyberimp/arm/medibeam, /obj/item/organ/cyberimp/arm/combat, /obj/item/organ/cyberimp/arm/flash, /obj/item/organ/cyberimp/arm/baton)
	include_subtypes = TRUE

/datum/export/orgains/heart
	cost = 250
	unit_name = "heart"
	export_types = list(/obj/item/organ/heart)
	exclude_types = list(/obj/item/organ/heart/cursed, /obj/item/organ/heart/cybernetic)

/datum/export/orgains/tongue
	cost = 75
	unit_name = "tongue"
	export_types = list(/obj/item/organ/tongue)

/datum/export/orgains/eyes
	cost = 50 //So many things take your eyes out anyways
	unit_name = "eyes"
	export_types = list(/obj/item/organ/eyes)
	exclude_types = list(/obj/item/organ/eyes/robotic)

/datum/export/orgains/stomach
	cost = 50 //can be replaced
	unit_name = "stomach"
	export_types = list(/obj/item/organ/stomach)

/datum/export/orgains/lungs
	cost = 150
	unit_name = "lungs"
	export_types = list(/obj/item/organ/lungs)
	exclude_types = list(/obj/item/organ/lungs/cybernetic, /obj/item/organ/lungs/cybernetic/upgraded)

/datum/export/orgains/liver
	cost = 175
	unit_name = "liver"
	export_types = list(/obj/item/organ/liver)
	exclude_types = list(/obj/item/organ/liver/cybernetic, /obj/item/organ/liver/cybernetic/upgraded)

/datum/export/orgains/tail //Shhh
	cost = 500
	unit_name = "error shipment failer"
	export_types = list(/obj/item/organ/tail)

/datum/export/orgains/vocal_cords
	cost = 500
	unit_name = "vocal cords"
	export_types = list(/obj/item/organ/vocal_cords) //These are gotten via different races

/datum/export/robotics/lims
	cost = 30
	unit_name = "robotic lim replacement"
	export_types = list(/obj/item/bodypart/l_arm/robot, /obj/item/bodypart/r_arm/robot, /obj/item/bodypart/l_leg/robot, /obj/item/bodypart/r_leg/robot, /obj/item/bodypart/chest/robot, /obj/item/bodypart/head/robot)

/datum/export/robotics/surpluse
	cost = 40
	unit_name = "robotic lim replacement"
	export_types = list(/obj/item/bodypart/l_arm/robot/surplus, /obj/item/bodypart/r_arm/robot/surplus, /obj/item/bodypart/l_leg/robot/surplus, /obj/item/bodypart/r_leg/robot/surplus)

/datum/export/robotics/surplus_upgraded
	cost = 50
	unit_name = "upgraded robotic lim replacement"
	export_types = list(/obj/item/bodypart/l_arm/robot/surplus_upgraded, /obj/item/bodypart/r_arm/robot/surplus_upgraded, /obj/item/bodypart/l_leg/robot/surplus_upgraded, /obj/item/bodypart/r_leg/robot/surplus_upgraded)

/datum/export/robotics/surgery_gear_basic
	cost = 5
	unit_name = "surgery tool"
	export_types = list(/obj/item/retractor, /obj/item/hemostat, /obj/item/cautery, /obj/item/surgicaldrill, /obj/item/scalpel, /obj/item/circular_saw, /obj/item/surgical_drapes)

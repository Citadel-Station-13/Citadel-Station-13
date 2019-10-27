// Orgains and Robotics exports. Hearts, new lims, implants, etc.

/datum/export/robotics
	include_subtypes = FALSE
	k_elasticity = 0 //ALWAYS worth selling upgrades

/datum/export/implant
	include_subtypes = FALSE
	k_elasticity = 0 //ALWAYS worth selling upgrades

/datum/export/organs
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
	k_elasticity = 300/20 //Large before depleating
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

/datum/export/organs/cybernetic
	cost = 225
	unit_name = "cybernetic organ"
	export_types = list(/obj/item/organ/liver/cybernetic, /obj/item/organ/lungs/cybernetic, /obj/item/organ/eyes/robotic, /obj/item/organ/heart/cybernetic)
	exclude_types = list(/obj/item/organ/lungs/cybernetic/upgraded, /obj/item/organ/liver/cybernetic/upgraded)

/datum/export/organs/upgraded
	cost = 275
	unit_name = "upgraded cybernetic organ"
	export_types = list(/obj/item/organ/lungs/cybernetic/upgraded, /obj/item/organ/liver/cybernetic/upgraded)

/datum/export/organs/tail //Shhh
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
	cost = 10
	unit_name = "surgery tool"
	export_types = list(/obj/item/retractor, /obj/item/hemostat, /obj/item/cautery, /obj/item/surgicaldrill, /obj/item/scalpel, /obj/item/circular_saw, /obj/item/surgical_drapes)

/datum/export/robotics/mech_weapon_laser
	cost = 300 //Sadly just metal and glass
	unit_name = "mech laser based weapon"
	include_subtypes = TRUE
	export_types = list(/obj/item/mecha_parts/mecha_equipment/medical/mechmedbeam, /obj/item/mecha_parts/mecha_equipment/weapon/energy)

/datum/export/robotics/mech_weapon_bullet
	cost = 250
	unit_name = "mech bullet based weapon"
	include_subtypes = TRUE
	export_types = list(/obj/item/mecha_parts/mecha_equipment/medical/syringe_gun, /obj/item/mecha_parts/mecha_equipment/weapon/honker, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic)

/datum/export/robotics/mech_tools
	cost = 150
	unit_name = "mech based tool"
	include_subtypes = TRUE
	export_types = list(/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp, /obj/item/mecha_parts/mecha_equipment/extinguisher, /obj/item/mecha_parts/mecha_equipment/rcd, /obj/item/mecha_parts/mecha_equipment/cable_layer, \
						/obj/item/mecha_parts/mecha_equipment/drill, /obj/item/mecha_parts/mecha_equipment/mining_scanner, /obj/item/mecha_parts/mecha_equipment/medical/sleeper)

/datum/export/robotics/mech_blue_space
	cost = 750
	k_elasticity = 1/10
	unit_name = "mech bluespace tech"
	export_types = list(/obj/item/mecha_parts/mecha_equipment/teleporter, /obj/item/mecha_parts/mecha_equipment/wormhole_generator, /obj/item/mecha_parts/mecha_equipment/gravcatapult)

/datum/export/robotics/mech_reactors
	cost = 350
	unit_name = "mech based reactor"
	export_types = list(/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay, /obj/item/mecha_parts/mecha_equipment/generator, /obj/item/mecha_parts/mecha_equipment/generator/nuclear)

/datum/export/robotics/mech_armor
	cost = 350
	unit_name = "mech armor tech"
	export_types = list(/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster, /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster, /obj/item/mecha_parts/mecha_equipment/repair_droid)

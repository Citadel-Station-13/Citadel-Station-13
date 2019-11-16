/datum/export/toolbox
	cost = 6
	unit_name = "toolbox"
	export_types = list(/obj/item/storage/toolbox)

// mechanical toolbox:	22cr
// emergency toolbox:	17-20cr
// electrical toolbox:	36cr
// robust: priceless

// Adv tools

/datum/export/gear/powerdrill
	cost = 25
	k_elasticity = 1/80 //Market can only take so much
	unit_name = "power tool"
	export_types = list(/obj/item/crowbar/power, /obj/item/screwdriver/power, \
						/obj/item/weldingtool/experimental, /obj/item/wirecutters/power, /obj/item/wrench/power)
	include_subtypes = TRUE

/datum/export/gear/advtool
	cost = 175
	k_elasticity = 0 //Only known to be made by 2 station, market is hungery for it
	unit_name = "adv tool"
	export_types = list(/obj/item/crowbar/advanced, /obj/item/crowbar/abductor, /obj/item/screwdriver/abductor, /obj/item/screwdriver/advanced, \
						/obj/item/weldingtool/abductor, /obj/item/weldingtool/advanced, /obj/item/wirecutters/abductor, /obj/item/wirecutters/advanced, \
						/obj/item/wrench/abductor, /obj/item/wrench/advanced)
	include_subtypes = TRUE

// Lights/Eletronic

/datum/export/lights
	cost = 10
	unit_name = "light fixer"
	export_types = list(/obj/item/wallframe/light_fixture)
	include_subtypes = TRUE

/datum/export/apc_board
	cost = 5
	unit_name = "apc electronics"
	export_types = list(/obj/item/electronics/apc)
	include_subtypes = TRUE

/datum/export/apc_frame
	cost = 3
	unit_name = "apc frame"
	export_types = list(/obj/item/wallframe/apc)
	include_subtypes = TRUE

/datum/export/floodlights
	cost = 15
	unit_name = "floodlight fixer"
	export_types = list(/obj/structure/floodlight_frame)
	include_subtypes = TRUE

/datum/export/bolbstubes
	cost = 1 //Time
	unit_name = "light replacement"
	export_types = list(/obj/item/light/tube, /obj/item/light/bulb)

/datum/export/lightreplacer
	cost = 20
	unit_name = "lightreplacer"
	export_types = list(/obj/item/lightreplacer)

// Basic tools
/datum/export/basicmining
	cost = 30
	unit_name = "basic mining tool"
	export_types = list(/obj/item/pickaxe, /obj/item/pickaxe/mini, /obj/item/shovel, /obj/item/resonator)
	include_subtypes = FALSE

/datum/export/upgradedmining
	cost = 80
	unit_name = "mining tool"
	export_types = list(/obj/item/pickaxe/silver, /obj/item/pickaxe/drill, /obj/item/gun/energy/plasmacutter, /obj/item/resonator/upgraded)
	include_subtypes = FALSE

/datum/export/advdmining
	cost = 150
	unit_name = "advanced mining tool"
	export_types = list(/obj/item/pickaxe/diamond, /obj/item/pickaxe/drill/diamonddrill, /obj/item/pickaxe/drill/jackhammer, /obj/item/gun/energy/plasmacutter/adv)
	include_subtypes = FALSE

/datum/export/screwdriver
	cost = 2
	unit_name = "screwdriver"
	export_types = list(/obj/item/screwdriver)
	include_subtypes = FALSE

/datum/export/wrench
	cost = 2
	unit_name = "wrench"
	export_types = list(/obj/item/wrench)

/datum/export/crowbar
	cost = 2
	unit_name = "crowbar"
	export_types = list(/obj/item/crowbar)

/datum/export/wirecutters
	cost = 2
	unit_name = "pair"
	message = "of wirecutters"
	export_types = list(/obj/item/wirecutters)

/datum/export/weldingtool
	cost = 5
	unit_name = "welding tool"
	export_types = list(/obj/item/weldingtool)
	include_subtypes = FALSE

/datum/export/weldingtool/emergency
	cost = 2
	unit_name = "emergency welding tool"
	export_types = list(/obj/item/weldingtool/mini)

/datum/export/weldingtool/industrial
	cost = 10
	unit_name = "industrial welding tool"
	export_types = list(/obj/item/weldingtool/largetank, /obj/item/weldingtool/hugetank)

/datum/export/extinguisher
	cost = 10
	unit_name = "fire extinguisher"
	export_types = list(/obj/item/extinguisher)
	include_subtypes = FALSE

/datum/export/extinguisher/mini
	cost = 2
	unit_name = "pocket fire extinguisher"
	export_types = list(/obj/item/extinguisher/mini)

/datum/export/flashlight
	cost = 3
	unit_name = "flashlight"
	export_types = list(/obj/item/flashlight)
	include_subtypes = FALSE

/datum/export/flashlight/flare
	cost = 2
	unit_name = "flare"
	export_types = list(/obj/item/flashlight/flare)

/datum/export/flashlight/seclite
	cost = 5
	unit_name = "seclite"
	export_types = list(/obj/item/flashlight/seclite)

/datum/export/analyzer
	cost = 5
	unit_name = "analyzer"
	export_types = list(/obj/item/analyzer)

/datum/export/analyzer/t_scanner
	cost = 10
	unit_name = "t-ray scanner"
	export_types = list(/obj/item/t_scanner)

/datum/export/radio
	cost = 5
	unit_name = "radio"
	export_types = list(/obj/item/radio)
	exclude_types = list(/obj/item/radio/mech)

/datum/export/rcd
	cost = 100
	unit_name = "rapid construction device"
	export_types = list(/obj/item/construction/rcd)

/datum/export/rcd_ammo
	cost = 60
	unit_name = "compressed matter cardridge"
	export_types = list(/obj/item/rcd_ammo)

/datum/export/rpd
	cost = 100
	unit_name = "rapid piping device"
	export_types = list(/obj/item/pipe_dispenser)

/datum/export/rld
	cost = 150
	unit_name = "rapid light device"
	export_types = list(/obj/item/construction/rld)

/datum/export/rped
	cost = 100
	unit_name = "rapid part exchange device"
	export_types = list(/obj/item/storage/part_replacer)

/datum/export/bsrped
	cost = 200
	unit_name = "blue space part exchange device"
	export_types = list(/obj/item/storage/part_replacer/bluespace)

/datum/export/singulo //failsafe in case someone decides to ship a live singularity to CentCom without the corresponding bounty
	cost = 1
	unit_name = "singularity"
	export_types = list(/obj/singularity)
	include_subtypes = FALSE

/datum/export/singulo/total_printout(datum/export_report/ex, notes = TRUE)
	. = ..()
	if(. && notes)
		. += " ERROR: Invalid object detected."

/datum/export/singulo/tesla //see above
	unit_name = "energy ball"
	export_types = list(/obj/singularity/energy_ball)

/datum/export/singulo/tesla/total_printout(datum/export_report/ex, notes = TRUE)
	. = ..()
	if(. && notes)
		. += " ERROR: Unscheduled energy ball delivery detected."

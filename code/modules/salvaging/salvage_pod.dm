//Salvaging pod. Large pod used to navigate debris fields. Capable of basic collection, sorting, and refining of scrap.

/obj/mecha/pod
	name = "pod"
	desc = "A space pod."

/obj/mecha/pod/salvage
	desc = "Powered Space Junk Recycler, version 1A1, designated \"Scrapper\" by NT and approved for use on their stations. While it doesn't quite roll off the tongue,\
			these tough ships are typically used in groups to clear debris fields of precious metals, artifacts, equipment, hardware, and other valuables. They're fitted\
			with advanced absorbant armor plates to protect the contents, both living and not, from explosives; a common hazard considering the munitions and fuel used on\
			most ships and stations."
	name = "\improper PSJR-1A1 \"Scrapper\""
	icon_state = "salpod"
	icon = 'icons/salvaging/salpod.dmi'
	step_in = 5
	max_temperature = 1000
	health = 200
	lights_power = 8
	deflect_chance = 20
	damage_absorption = list("brute"=0.7,"fire"=0.9,"bullet"=0.9,"laser"=0.9,"energy"=1,"bomb"=0.4)
	max_equip = 6
	wreckage = /obj/structure/mecha_wreckage/salpod

/obj/structure/mecha_wreckage/salpod/New()
	..()
	var/list/parts = list(/obj/item/mecha_parts/chassis/pod,
						  /obj/item/mecha_parts/part/pod_cockpit,
						  /obj/item/mecha_parts/part/pod_booster,
						  /obj/item/mecha_parts/part/pod_lifesupport,
						  /obj/item/mecha_parts/part/pod_storagebay)
	for(var/i = 0; i < 2; i++)
		if(parts.len && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part

//Parts

/obj/item/mecha_parts/chassis/pod
	name = "\improper Ripley chassis"
	icon_state = "pod_chassis"

/obj/item/mecha_parts/chassis/ripley/New()
	..()
	construct = new /datum/construction/mecha/ripley_chassis(src)

/obj/item/mecha_parts/part/pod_cockpit
	name = "\improper Scrapper cockpit"
	desc = "The cockpit of a PSJR-1A1. A tough "
	icon_state = "pod_cockpit"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"

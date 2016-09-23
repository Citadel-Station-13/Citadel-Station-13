//Salvaging ship. Large ship used to navigate debris fields. Capable of basic collection, sorting, and refining of scrap.

/obj/mecha/ship
	name = "ship"
	desc = "A space ship, or something."

//Ship itself
/obj/mecha/ship/salvage
	desc = "Powered Space Junk Recycler, revision 1A1, designated \"Scrapper\" by NT and approved for use on their stations. While it doesn't quite roll off the tongue, \
			these tough ships are typically used in groups to clear debris fields of precious metals, artifacts, equipment, hardware, and other valuables. They're fitted \
			with advanced absorbant armor plates to protect the contents, both living and not, from explosions; a common hazard considering the munitions and fuel used on \
			most ships and stations."
	name = "\improper PSJR-1A1 \"Scrapper\""
	icon_state = "scrapper"
	icon = 'icons/salvaging/scrapper.dmi'
	step_in = 4
	max_temperature = 1000
	health = 200
	lights_power = 8
	deflect_chance = 20
	damage_absorption = list("brute"=0.7,"fire"=0.9,"bullet"=0.9,"laser"=0.9,"energy"=1,"bomb"=0.4)
	max_equip = 6
	wreckage = /obj/structure/mecha_wreckage/scrapper
//	bound_height = 64
//	bound_width = 96
	pixel_x = -48
	pixel_y = -48
	turnsound = null
	stepsound = null

/obj/mecha/ship/salvage/GrantActions(mob/living/user, human_occupant = 0)
	..()
	thrusters_action.Grant(user, src)

/obj/mecha/ship/salvage/RemoveActions(mob/living/user, human_occupant = 0)
	..()
	thrusters_action.Remove(user)

/obj/mecha/mechturn()
	..()
	updatebounds()

/obj/mecha/proc/updatebounds()
/*	switch(dir)
		if(1)
			bound_height = initial(bound_height)
			bound_width = initial(bound_width)
		if(2)
			bound_height = initial(bound_height)
			bound_width = initial(bound_width)
		if(4)
			bound_height = initial(bound_width)
			bound_width = initial(bound_height)
		if(8)
			bound_height = initial(bound_width)
			bound_width = initial(bound_height)
*/
//Wreckage
/obj/structure/mecha_wreckage/scrapper
	name = "scrapper wreckage"
	icon_state = "scrapper-broken"
	icon = 'icons/salvaging/scrapper.dmi'

/obj/structure/mecha_wreckage/scrapper/New()
	..()
	var/list/parts = list(/obj/item/mecha_parts/chassis/scrapper,
						  /obj/item/mecha_parts/part/cockpit,
						  /obj/item/mecha_parts/part/engine,
						  /obj/item/mecha_parts/part/lifesupport,
						  /obj/item/mecha_parts/part/storage,
						  /obj/item/mecha_parts/part/scrap_refinery)
	for(var/i = 0; i < 2; i++)
		if(parts.len && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part

//Parts
/obj/item/mecha_parts/chassis/scrapper/New()
	..()
	construct = new /datum/construction/mecha/ripley_chassis(src)

/obj/item/mecha_parts/chassis/scrapper
	name = "\improper Scrapper chassis"
	icon_state = "scrapper_chassis"

/obj/item/mecha_parts/part/cockpit
	name = "shipcockpit"
	desc = "The cockpit of a small space ship."
	icon_state = "cockpit"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"

/obj/item/mecha_parts/part/engine
	name = "engine"
	desc = "The main source of thrust for small space ships."
	icon_state = "shipthruster"
	origin_tech = "programming=1;materials=3;engineering=3"

/obj/item/mecha_parts/part/lifesupport
	name = "life support systems"
	gender = PLURAL
	desc = "A series of systems to be installed in a small vessel. Ensures your ship will be nice and toasty, every time."
	icon_state = "shiplifesupport"
	origin_tech = "programming=1;materials=2;engineering=2;biotech=3"

/obj/item/mecha_parts/part/storage
	name = "storage compartments"
	gender = PLURAL
	desc = "A series of storage compartments that are typically installed on the sides of small ships."
	icon_state = "shipstorage"
	origin_tech = "materials=2;engineering=2"

/obj/item/mecha_parts/part/scrap_refinery
	name = "scrap refinery"
	desc = "A ship-mounted refinery used to turn unsorted scrap metals into useful raw materials."
	icon_state = "shiprefinery"
	origin_tech = "materials=2;engineering=3"

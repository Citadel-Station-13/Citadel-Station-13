/* Diffrent misc types of sheets
 * Contains:
 *		Metal
 *		Plasteel
 *		Wood
 *		Cloth
 *		Cardboard
 *		Runed Metal (cult)
 */

/*
 * Metal
 */
var/global/list/datum/stack_recipe/metal_recipes = list ( \
	new/datum/stack_recipe("stool", /obj/structure/chair/stool, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("bar stool", /obj/structure/chair/stool/bar, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("chair", /obj/structure/chair, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("swivel chair", /obj/structure/chair/office/dark, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("comfy chair", /obj/structure/chair/comfy/beige, 2, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1), \
	null, \
	new/datum/stack_recipe("rack parts", /obj/item/weapon/rack_parts), \
	new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1), \
	null, \
	new/datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = 1, on_floor = 1), \
	null, \
	new/datum/stack_recipe("floor tile", /obj/item/stack/tile/plasteel, 1, 4, 20), \
	new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60), \
	null, \
	new/datum/stack_recipe("wall girders", /obj/structure/girder, 2, time = 40, one_per_turf = 1, on_floor = 1), \
	null, \
	new/datum/stack_recipe("computer frame", /obj/structure/frame/computer, 5, time = 25, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("machine frame", /obj/structure/frame/machine, 5, time = 25, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("airlock assembly", /obj/structure/door_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("firelock frame", /obj/structure/firelock_frame, 3, time = 50, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("meatspike frame", /obj/structure/kitchenspike_frame, 5, time = 25, one_per_turf = 1, on_floor = 1), \
/*	new/datum/stack_recipe("reflector frame", /obj/structure/reflector, 5, time = 25, one_per_turf = 1, on_floor = 1), \*/
	null, \
	new/datum/stack_recipe("grenade casing", /obj/item/weapon/grenade/chem_grenade), \
	new/datum/stack_recipe("light fixture frame", /obj/item/wallframe/light_fixture, 2), \
	new/datum/stack_recipe("small light fixture frame", /obj/item/wallframe/light_fixture/small, 1), \
	null, \
	new/datum/stack_recipe("apc frame", /obj/item/wallframe/apc, 2), \
	new/datum/stack_recipe("air alarm frame", /obj/item/wallframe/airalarm, 2), \
	new/datum/stack_recipe("fire alarm frame", /obj/item/wallframe/firealarm, 2), \
	new/datum/stack_recipe("extinguisher cabinet frame", /obj/item/wallframe/extinguisher_cabinet, 2), \
	new/datum/stack_recipe("button frame", /obj/item/wallframe/button, 1), \
	null, \
	new/datum/stack_recipe("iron door", /obj/structure/mineral_door/iron, 20, one_per_turf = 1, on_floor = 1), \
)

/obj/item/stack/sheet/metal
	name = "metal"
	desc = "Sheets made out of metal."
	singular_name = "metal sheet"
	icon_state = "sheet-metal"
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)
	throwforce = 10
	flags = CONDUCT
	origin_tech = "materials=1"

/obj/item/stack/sheet/metal/narsie_act()
	if(prob(20))
		new /obj/item/stack/sheet/runed_metal(loc, amount)
		qdel(src)

/obj/item/stack/sheet/metal/fifty
	amount = 50

/obj/item/stack/sheet/metal/five
	amount = 5

/obj/item/stack/sheet/metal/cyborg
	materials = list()
	is_cyborg = 1
	cost = 500

/obj/item/stack/sheet/metal/New(var/loc, var/amount=null)
	recipes = metal_recipes
	return ..()

/*
 * Plasteel
 */
var/global/list/datum/stack_recipe/plasteel_recipes = list ( \
	new/datum/stack_recipe("AI core", /obj/structure/AIcore, 4, time = 50, one_per_turf = 1), \
	new/datum/stack_recipe("bomb assembly", /obj/machinery/syndicatebomb/empty, 10, time = 50), \
)

/obj/item/stack/sheet/plasteel
	name = "plasteel"
	singular_name = "plasteel sheet"
	desc = "This sheet is an alloy of iron and plasma."
	icon_state = "sheet-plasteel"
	item_state = "sheet-metal"
	materials = list(MAT_METAL=6000, MAT_PLASMA=6000)
	throwforce = 10
	flags = CONDUCT
	origin_tech = "materials=2"

/obj/item/stack/sheet/plasteel/New(var/loc, var/amount=null)
	recipes = plasteel_recipes
	return ..()

/obj/item/stack/sheet/plasteel/twenty
	amount = 20

/obj/item/stack/sheet/plasteel/fifty
	amount = 50

/*
 * Wood
 */
var/global/list/datum/stack_recipe/wood_recipes = list ( \
	new/datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1), \
	new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20), \
	new/datum/stack_recipe("wood table frame", /obj/structure/table_frame/wood, 2, time = 10), \
	new/datum/stack_recipe("rifle stock", /obj/item/weaponcrafting/stock, 10, time = 40), \
	new/datum/stack_recipe("wooden chair", /obj/structure/chair/wood/normal, 3, time = 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("wooden barricade", /obj/structure/barricade/wooden, 5, time = 50, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("wooden door", /obj/structure/mineral_door/wood, 10, time = 20, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("book case", /obj/structure/bookcase, 4, time = 15, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("drying rack", /obj/machinery/smartfridge/drying_rack, 10, time = 15, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("dog bed", /obj/structure/bed/dogbed, 10, time = 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("display case chassis", /obj/structure/displaycase_chassis, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("wooden buckler", /obj/item/weapon/shield/riot/buckler, 20, time = 40), \
	new/datum/stack_recipe("apiary", /obj/structure/beebox, 40, time = 50),\
	new/datum/stack_recipe("honey frame", /obj/item/honey_frame, 5, time = 10),\
	new/datum/stack_recipe("ore box", /obj/structure/ore_box, 4, time = 50, one_per_turf = 1, on_floor = 1),\
	)

/obj/item/stack/sheet/mineral/wood
	name = "wooden plank"
	desc = "One can only guess that this is a bunch of wood."
	singular_name = "wood plank"
	icon_state = "sheet-wood"
	icon = 'icons/obj/items.dmi'
	origin_tech = "materials=1;biotech=1"
	sheettype = "wood"
	burn_state = FLAMMABLE

/obj/item/stack/sheet/mineral/wood/New(var/loc, var/amount=null)
	recipes = wood_recipes
	return ..()

/obj/item/stack/sheet/mineral/wood/fifty
	amount = 50

/*
 * Cloth
 */
var/global/list/datum/stack_recipe/cloth_recipes = list ( \
	new/datum/stack_recipe("grey jumpsuit", /obj/item/clothing/under/color/grey, 3), \
	null, \
	new/datum/stack_recipe("backpack", /obj/item/weapon/storage/backpack, 4), \
	new/datum/stack_recipe("dufflebag", /obj/item/weapon/storage/backpack/dufflebag, 6), \
	null, \
	new/datum/stack_recipe("plant bag", /obj/item/weapon/storage/bag/plants, 4), \
	new/datum/stack_recipe("book bag", /obj/item/weapon/storage/bag/books, 4), \
	new/datum/stack_recipe("mining satchel", /obj/item/weapon/storage/bag/ore, 4), \
	new/datum/stack_recipe("chemistry bag", /obj/item/weapon/storage/bag/chemistry, 4), \
	new/datum/stack_recipe("bio bag", /obj/item/weapon/storage/bag/bio, 4), \
	null, \
	new/datum/stack_recipe("improvised gauze", /obj/item/stack/medical/gauze/improvised, 1, 2, 6), \
	new/datum/stack_recipe("rag", /obj/item/weapon/reagent_containers/glass/rag, 1), \
	new/datum/stack_recipe("black shoes", /obj/item/clothing/shoes/sneakers/black, 2), \
	new/datum/stack_recipe("bedsheet", /obj/item/weapon/bedsheet, 3), \
	new/datum/stack_recipe("empty sandbag", /obj/item/weapon/emptysandbag, 4), \
	)

/obj/item/stack/sheet/cloth
	name = "cloth"
	desc = "Is it cotton? Linen? Denim? Burlap? Canvas? You can't tell."
	singular_name = "cloth roll"
	icon_state = "sheet-cloth"
	origin_tech = "materials=2"
	burn_state = FLAMMABLE
	force = 0
	throwforce = 0

/obj/item/stack/sheet/cloth/New(var/loc, var/amount=null)
	recipes = cloth_recipes
	return ..()

/obj/item/stack/sheet/cloth/ten
	amount = 10

/*
 * Cardboard
 */
var/global/list/datum/stack_recipe/cardboard_recipes = list ( \
	new/datum/stack_recipe("box", /obj/item/weapon/storage/box), \
	new/datum/stack_recipe("light tubes", /obj/item/weapon/storage/box/lights/tubes), \
	new/datum/stack_recipe("light bulbs", /obj/item/weapon/storage/box/lights/bulbs), \
	new/datum/stack_recipe("mouse traps", /obj/item/weapon/storage/box/mousetraps), \
	new/datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3), \
	new/datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg), \
	new/datum/stack_recipe("pizza box", /obj/item/pizzabox), \
	new/datum/stack_recipe("folder", /obj/item/weapon/folder), \
	new/datum/stack_recipe("large box", /obj/structure/closet/cardboard, 4), \
	new/datum/stack_recipe("cardboard cutout", /obj/item/cardboard_cutout, 5), \
)

/obj/item/stack/sheet/cardboard	//BubbleWrap //it's cardboard you fuck
	name = "cardboard"
	desc = "Large sheets of card, like boxes folded flat."
	singular_name = "cardboard sheet"
	icon_state = "sheet-card"
	origin_tech = "materials=1"
	burn_state = FLAMMABLE

/obj/item/stack/sheet/cardboard/New(var/loc, var/amount=null)
		recipes = cardboard_recipes
		return ..()

/obj/item/stack/sheet/cardboard/fifty
	amount = 50

/*
 * Runed Metal
 */

var/global/list/datum/stack_recipe/runed_metal_recipes = list ( \
	new/datum/stack_recipe("runed door", /obj/machinery/door/airlock/cult, 3, time = 50, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("runed girder", /obj/structure/girder/cult, 1, time = 50, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("pylon", /obj/structure/cult/pylon, 3, time = 40, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("forge", /obj/structure/cult/forge, 5, time = 40, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("archives", /obj/structure/cult/tome, 2, time = 40, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("altar", /obj/structure/cult/talisman, 5, time = 40, one_per_turf = 1, on_floor = 1), \
	)

/obj/item/stack/sheet/runed_metal
	name = "runed metal"
	desc = "Sheets of cold metal with shifting inscriptions writ upon them."
	singular_name = "runed metal"
	icon_state = "sheet-runed"
	icon = 'icons/obj/items.dmi'
	sheettype = "runed"

/obj/item/stack/sheet/runed_metal/attack_self(mob/living/user)
	if(!iscultist(user))
		user << "<span class='warning'>Only one with forbidden knowledge could hope to work this metal...</span>"
		return
	return ..()

/obj/item/stack/sheet/runed_metal/attack(atom/target, mob/living/user)
	if(!iscultist(user))
		user << "<span class='warning'>Only one with forbidden knowledge could hope to work this metal...</span>"
		return
	..()

/obj/item/stack/sheet/runed_metal/fifty
	amount = 50

/obj/item/stack/sheet/runed_metal/New(var/loc, var/amount=null)
	recipes = runed_metal_recipes
	return ..()

/obj/item/stack/sheet/lessergem
	name = "lesser gems"
	desc = "Rare kind of gems which are only gained by blood sacrifice to minor deities. They are needed in crafting powerful objects."
	singular_name = "lesser gem"
	icon_state = "sheet-lessergem"
	origin_tech = "materials=4"


/obj/item/stack/sheet/greatergem
	name = "greater gems"
	desc = "Rare kind of gems which are only gained by blood sacrifice to minor deities. They are needed in crafting powerful objects."
	singular_name = "greater gem"
	icon_state = "sheet-greatergem"
	origin_tech = "materials=7"

	/*
 * Bones
 */
/obj/item/stack/sheet/bone
	name = "bones"
	icon = 'icons/obj/mining.dmi'
	icon_state = "bone"
	singular_name = "bone"
	desc = "Someone's been drinking their milk."
	force = 7
	throwforce = 5
	w_class = 3
	throw_speed = 1
	throw_range = 3
	origin_tech = "materials=2;biotech=2"

/*****************************Money bag********************************/

/obj/item/storage/bag/money
	name = "money bag"
	icon_state = "moneybag"
	force = 10
	throwforce = 0
	resistance_flags = FLAMMABLE
	max_integrity = 100
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/bag/money/Initialize(mapload)
	. = ..()
	if(prob(20))
		icon_state = "moneybagalt"
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_items = 40
	STR.max_combined_w_class = 40
	STR.can_hold = typecacheof(list(/obj/item/coin, /obj/item/stack/spacecash, /obj/item/holochip))

/obj/item/storage/bag/money/vault/PopulateContents()
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/adamantine(src)

/obj/item/storage/bag/money/c5000/PopulateContents()
	for(var/i = 0, i < 5, i++)
		new /obj/item/stack/spacecash/c1000(src)

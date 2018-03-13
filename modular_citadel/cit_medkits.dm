//help I have no idea what I'm doing

/obj/item/storage/firstaid
	icon = 'modular_citadel/icons/firstaid.dmi'

/obj/item/storage/firstaid/Initialize(mapload)
	. = ..()
	icon_state = pick("[initial(icon_state)]","[initial(icon_state)]2","[initial(icon_state)]3","[initial(icon_state)]4")

/obj/item/storage/firstaid/fire
	icon_state = "burn"

/obj/item/storage/firstaid/fire/Initialize(mapload)
	. = ..()
	icon_state = pick("[initial(icon_state)]","[initial(icon_state)]2","[initial(icon_state)]3","[initial(icon_state)]4")

/obj/item/storage/firstaid/toxin
	icon_state = "toxin"

/obj/item/storage/firstaid/toxin/Initialize(mapload)
	. = ..()
	icon_state = pick("[initial(icon_state)]","[initial(icon_state)]2","[initial(icon_state)]3","[initial(icon_state)]4")

/obj/item/storage/firstaid/o2
	icon_state = "oxy"

/obj/item/storage/firstaid/tactical
	icon_state = "tactical"

/obj/item/storage/minifirstaid
	name = "mini first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon = 'modular_citadel/icons/firstaid.dmi'
	icon_state = "firstaid-mini"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	var/empty = FALSE
	item_state = "firstaid"
	w_class = WEIGHT_CLASS_SMALL
	max_combined_w_class = 4		//half that of regular kits
	storage_slots = 2

/obj/item/storage/minifirstaid/regular
	icon_state = "firstaid-mini"
	desc = "An emergency first aid kit with the ability to heal the most minor of common injuries."

/obj/item/storage/minifirstaid/regular/PopulateContents()
	if(empty)
		return
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)

/obj/item/storage/minifirstaid/fire
	name = "micro burn treatment kit"
	desc = "A specialized medical kit for when some bloke sets themselves on fire."
	icon_state = "burn-mini"
	item_state = "firstaid-ointment"

/obj/item/storage/minifirstaid/fire/PopulateContents()
	if(empty)
		return
	new /obj/item/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/reagent_containers/pill/oxandrolone(src)

/obj/item/storage/minifirstaid/toxin
	name = "micro toxin treatment kit"
	desc = "Used to treat the various crewmembers whose blood alcohol content are above 0.1."
	icon_state = "toxin-mini"
	item_state = "firstaid-toxin"

/obj/item/storage/minifirstaid/toxin/PopulateContents()
	if(empty)
		return
	new /obj/item/reagent_containers/syringe/charcoal(src)
	new /obj/item/storage/pill_bottle/charcoal(src)

/obj/item/storage/minifirstaid/o2
	name = "micro oxygen deprivation treatment kit"
	desc = "A nice box for spacewalking with."
	icon_state = "oxy-mini"
	item_state = "firstaid-o2"

/obj/item/storage/minifirstaid/o2/PopulateContents()
	if(empty)
		return
	new /obj/item/reagent_containers/pill/salbutamol(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)

/obj/item/storage/minifirstaid/brute
	name = "brute trauma treatment kit"
	desc = "A first aid kit for when you stub your toe."
	icon_state = "brute-mini"
	item_state = "firstaid-brute"

/obj/item/storage/minifirstaid/brute/PopulateContents()
	if(empty)
		return
	new /obj/item/reagent_containers/pill/patch/styptic(src)
	new /obj/item/stack/medical/gauze(src)

/obj/item/storage/minifirstaid/tactical
	name = "mini combat medkit"
	desc = "A miniature box containing tactical medical supplies."
	icon_state = "tactical-mini"
	max_w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/minifirstaid/tactical/PopulateContents()
	if(empty)
		return
	new /obj/item/defibrillator/compact/combat/loaded(src)
	new /obj/item/reagent_containers/hypospray/combat(src)
//Cloaks. No, not THAT kind of cloak.

/obj/item/clothing/neck/cloak
	name = "brown cloak"
	desc = "It's a cape that can be worn around your neck."
	icon = 'icons/obj/clothing/cloaks.dmi'
	icon_state = "qmcloak"
	item_state = "qmcloak"
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|LEGS|ARMS

/obj/item/clothing/head/cloakhood
	name = "cloak hood"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "golhood"
	desc = "A hood for a cloak."
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/neck/cloak/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is strangling [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return(OXYLOSS)

/obj/item/clothing/neck/cloak/hos
	name = "head of security's cloak"
	desc = "Worn by Securistan, ruling the station with an iron fist."
	icon_state = "hoscloak"

/obj/item/clothing/neck/cloak/qm
	name = "quartermaster's cloak"
	desc = "Worn by Cargonia, supplying the station with the necessary tools for survival."

/obj/item/clothing/neck/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "Worn by Meditopia, the valiant men and women keeping pestilence at bay."
	icon_state = "cmocloak"

/obj/item/clothing/neck/cloak/ce
	name = "chief engineer's cloak"
	desc = "Worn by Engitopia, wielders of an unlimited power."
	icon_state = "cecloak"

/obj/item/clothing/neck/cloak/rd
	name = "research director's cloak"
	desc = "Worn by Sciencia, thaumaturges and researchers of the universe."
	icon_state = "rdcloak"

/obj/item/clothing/neck/cloak/cap
	name = "captain's cloak"
	desc = "Worn by the commander of Space Station 13."
	icon_state = "capcloak"

/obj/item/clothing/neck/cloak/hop
	name = "head of personnel's cloak"
	desc = "Worn by the Head of Personnel. It smells faintly of bureaucracy."
	icon_state = "hopcloak"

/obj/item/clothing/suit/hooded/cloak/goliath
	name = "goliath cloak"
	icon_state = "goliath_cloak"
	desc = "A staunch, practical cape made out of numerous monster materials, it is coveted amongst exiles & hermits."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/pickaxe, /obj/item/spear, /obj/item/spear/bonespear, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife/combat/bone, /obj/item/kitchen/knife/combat/survival)
	armor = list(MELEE = 35, BULLET = 10, LASER = 25, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 60, ACID = 60) //a fair alternative to bone armor, requiring alternative materials and gaining a suit slot
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath
	body_parts_covered = CHEST|ARMS|LEGS

/obj/item/clothing/head/hooded/cloakhood/goliath
	name = "goliath cloak hood"
	icon_state = "golhood"
	desc = "A protective & concealing hood."
	armor = list(MELEE = 35, BULLET = 10, LASER = 25, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 60, ACID = 60)
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/suit/hooded/cloak/drake
	name = "drake armour"
	icon_state = "dragon"
	desc = "A suit of armour fashioned from the remains of an ash drake."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator, /obj/item/pickaxe, /obj/item/spear)
	armor = list(MELEE = 70, BULLET = 20, LASER = 35, ENERGY = 25, BOMB = 25, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/drake
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF | GOLIATH_RESISTANCE

/obj/item/clothing/head/hooded/cloakhood/drake
	name = "drake helm"
	icon_state = "dragon"
	desc = "The skull of a dragon."
	armor = list(MELEE = 70, BULLET = 20, LASER = 35, ENERGY = 25, BOMB = 25, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF | GOLIATH_RESISTANCE

/obj/item/clothing/neck/cloak/polychromic
	name = "polychromic cloak"
	desc = "For when you want to show off your horrible colour coordination skills."
	icon_state = "polyce"
	item_state = "qmcloak"
	var/list/poly_colors = list("#FFFFFF", "#FFFFFF", "#808080")

/obj/item/clothing/neck/cloak/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, 3)

/obj/item/clothing/neck/cloak/cancloak/polychromic
	name = "canvas cloak"
	desc = "A rugged cloak made of canvas."
	icon_state = "cancloak"
	item_state = "cloak"
	var/list/poly_colors = list("#585858", "#373737", "#BEBEBE")

/obj/item/clothing/neck/cloak/cancloak/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, 3)

/obj/item/clothing/neck/cloak/alt
	name = "cloak"
	desc = "A ragged up white cloak. It reminds you of a place not far from here."
	icon_state = "cloak"
	item_state = "cloak"

/obj/item/clothing/neck/cloak/alt/polychromic
	name = "polychromic cloak"
	desc = "A ragged up cloak. It reminds you of a place not far from here."
	icon_state = "cloak"
	item_state = "cloak"
	var/list/poly_colors = list("#FFFFFF", "#676767", "#4C4C4C")

/obj/item/clothing/neck/cloak/alt/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, 3)

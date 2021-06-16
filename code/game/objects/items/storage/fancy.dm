/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Cigarette Box
 *		Cigar Case
 *		Heart Shaped Box w/ Chocolates
 *		Ring Box
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	resistance_flags = FLAMMABLE
	var/icon_type = "donut"
	var/spawn_type = null
	var/fancy_open = FALSE

/obj/item/storage/fancy/PopulateContents()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	for(var/i = 1 to STR.max_items)
		new spawn_type(src)

/obj/item/storage/fancy/update_icon_state()
	if(fancy_open)
		icon_state = "[icon_type]box[contents.len]"
	else
		icon_state = "[icon_type]box"

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(fancy_open)
		if(length(contents) == 1)
			. += "There is one [icon_type] left."
		else
			. += "There are [contents.len <= 0 ? "no" : "[contents.len]"] [icon_type]s left."

/obj/item/storage/fancy/attack_self(mob/user)
	fancy_open = !fancy_open
	update_icon()
	. = ..()

/obj/item/storage/fancy/Exited()
	. = ..()
	fancy_open = TRUE
	update_icon()

/obj/item/storage/fancy/Entered()
	. = ..()
	fancy_open = TRUE
	update_icon()

#define DONUT_INBOX_SPRITE_WIDTH 3

/*
 * Donut Box
 */

/obj/item/storage/fancy/donut_box
	name = "donut box"
	desc = "Mmm. Donuts."
	icon = 'icons/obj/food/donut.dmi'
	icon_state = "donutbox_inner"
	icon_type = "donut"
	spawn_type = /obj/item/reagent_containers/food/snacks/donut
	fancy_open = TRUE
	custom_price = PRICE_NORMAL
	appearance_flags = KEEP_TOGETHER

/obj/item/storage/fancy/donut_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/donut))

/obj/item/storage/fancy/donut_box/PopulateContents()
	. = ..()
	update_icon()

/obj/item/storage/fancy/donut_box/update_icon_state()
	if(fancy_open)
		icon_state = "donutbox_inner"
	else
		icon_state = "donutbox"

/obj/item/storage/fancy/donut_box/update_overlays()
	. = ..()

	if (!fancy_open)
		return

	var/donuts = 0

	for (var/_donut in contents)
		var/obj/item/reagent_containers/food/snacks/donut/donut = _donut
		if (!istype(donut))
			continue

		. += image(icon = initial(icon), icon_state = donut.in_box_sprite(), pixel_x = donuts * DONUT_INBOX_SPRITE_WIDTH)
		donuts += 1

	. += image(icon = initial(icon), icon_state = "donutbox_top")

#undef DONUT_INBOX_SPRITE_WIDTH

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	item_state = "eggbox"
	icon_state = "eggbox"
	icon_type = "egg"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	name = "egg box"
	desc = "A carton for containing eggs."
	spawn_type = /obj/item/reagent_containers/food/snacks/egg

/obj/item/storage/fancy/egg_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 12
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/egg))

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	throwforce = 2
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/candle
	fancy_open = TRUE

/obj/item/storage/fancy/candle_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5

/obj/item/storage/fancy/candle_box/attack_self(mob_user)
	return

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "\improper Space Cigarettes packet"
	desc = "The most popular brand of cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig"
	item_state = "cigpacket"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_BELT
	icon_type = "cigarette"
	spawn_type = /obj/item/clothing/mask/cigarette/space_cigarette
	custom_price = PRICE_ALMOST_CHEAP
	var/spawn_coupon = TRUE

/obj/item/storage/fancy/cigarettes/attack_self(mob/user)
	if(contents.len == 0 && spawn_coupon)
		to_chat(user, "<span class='notice'>You rip the back off \the [src] and get a coupon!</span>")
		var/obj/item/coupon/attached_coupon = new
		user.put_in_hands(attached_coupon)
		attached_coupon.generate()
		attached_coupon = null
		spawn_coupon = FALSE
		name = "discarded cigarette packet"
		desc = "An old cigarette packet with the back torn off, worth less than nothing now."
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR.max_items = 0
		return
	return ..()

/obj/item/storage/fancy/cigarettes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter))

/obj/item/storage/fancy/cigarettes/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to extract contents.</span>"
	if(spawn_coupon)
		. += "<span class='notice'>There's a coupon on the back of the pack! You can tear it off once it's empty.</span>"

/obj/item/storage/fancy/cigarettes/AltClick(mob/living/carbon/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	var/obj/item/lighter/L = locate() in contents
	if(L)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, L, user)
		user.put_in_hands(L)
		to_chat(user, "<span class='notice'>You take \a [L] out of the pack.</span>")
		return TRUE
	var/obj/item/clothing/mask/cigarette/W = locate() in contents
	if(W && contents.len > 0)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
		user.put_in_hands(W)
		to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
	else
		to_chat(user, "<span class='notice'>There are no [icon_type]s left in the pack.</span>")
	return TRUE

/obj/item/storage/fancy/cigarettes/update_icon_state()
	if(!contents.len)
		icon_state = "[initial(icon_state)]_empty"
	else if(fancy_open)
		icon_state = initial(icon_state)

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	if(!fancy_open || !contents.len)
		return
	. += "[icon_state]_open"
	var/cig_position = 1
	for(var/C in contents)
		var/mutable_appearance/inserted_overlay = mutable_appearance(icon)

		if(istype(C, /obj/item/lighter/greyscale))
			inserted_overlay.icon_state = "lighter_in"
		else if(istype(C, /obj/item/lighter))
			inserted_overlay.icon_state = "zippo_in"
		else
			inserted_overlay.icon_state = "cigarette"

		inserted_overlay.icon_state = "[inserted_overlay.icon_state]_[cig_position]"
		. += inserted_overlay
		cig_position++

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(M != user || !istype(M))
		return ..()
	var/obj/item/clothing/mask/cigarette/cig = locate(/obj/item/clothing/mask/cigarette) in contents
	if(cig)
		if(!user.wear_mask && !(SLOT_WEAR_MASK in M.check_obscured_slots()))
			var/obj/item/clothing/mask/cigarette/W = cig
			SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, M)
			M.equip_to_slot_if_possible(W, SLOT_WEAR_MASK)
			contents -= W
			to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
		else
			return ..()
	else
		to_chat(user, "<span class='notice'>There are no [icon_type]s left in the pack.</span>")

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "dromedary"
	spawn_type = /obj/item/clothing/mask/cigarette/dromedary

/obj/item/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper Uplift Smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "uplift"
	spawn_type = /obj/item/clothing/mask/cigarette/uplift

/obj/item/storage/fancy/cigarettes/cigpack_robust
	name = "\improper Robust packet"
	desc = "Smoked by the robust."
	icon_state = "robust"
	spawn_type = /obj/item/clothing/mask/cigarette/robust

/obj/item/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustg"
	spawn_type = /obj/item/clothing/mask/cigarette/robustgold

/obj/item/storage/fancy/cigarettes/cigpack_carp
	name = "\improper Carp Classic packet"
	desc = "Since 2313."
	icon_state = "carp"
	spawn_type = /obj/item/clothing/mask/cigarette/carp

/obj/item/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndie"
	spawn_type = /obj/item/clothing/mask/cigarette/syndicate

/obj/item/storage/fancy/cigarettes/cigpack_midori
	name = "\improper Midori Tabako packet"
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/nicotine

/obj/item/storage/fancy/cigarettes/cigpack_shadyjims
	name = "\improper Shady Jim's Super Slims packet"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/shadyjims

/obj/item/storage/fancy/cigarettes/cigpack_xeno
	name = "\improper Xeno Filtered packet"
	desc = "Loaded with 100% pure slime. And also nicotine."
	icon_state = "slime"
	spawn_type = /obj/item/clothing/mask/cigarette/xeno

/obj/item/storage/fancy/cigarettes/cigpack_cannabis
	name = "\improper Freak Brothers' Special packet"
	desc = "A label on the packaging reads, \"Endorsed by Phineas, Freddy and Franklin.\""
	icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/cannabis

/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker
	name = "\improper Leary's Delight packet"
	desc = "Banned in over 36 galaxies."
	icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/mindbreaker

/obj/item/storage/fancy/rollingpapers
	name = "rolling paper pack"
	desc = "A pack of Nanotrasen brand rolling papers."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper_pack"
///The value in here has NOTHING to do with icons. It needs to be this for the proper examine.
	icon_type = "rolling paper"
	spawn_type = /obj/item/rollingpaper
	custom_price = PRICE_REALLY_CHEAP

/obj/item/storage/fancy/rollingpapers/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.can_hold = typecacheof(list(/obj/item/rollingpaper))

///Overrides to do nothing because fancy boxes are fucking insane.
/obj/item/storage/fancy/rollingpapers/update_icon_state()
	return

/obj/item/storage/fancy/rollingpapers/update_overlays()
	. = ..()
	if(!contents.len)
		. += "[icon_state]_empty"

//Derringer "Cigarettes"//
/obj/item/storage/fancy/cigarettes/derringer
	name = "\improper Robust packet"
	desc = "Smoked by the robust."
	icon_state = "robust"
	spawn_type = /obj/item/gun/ballistic/derringer/traitor

/obj/item/storage/fancy/cigarettes/derringer/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter, /obj/item/gun/ballistic/derringer, /obj/item/ammo_casing/c38, /obj/item/ammo_casing/a357, /obj/item/ammo_casing/g4570))

/obj/item/storage/fancy/cigarettes/derringer/AltClick(mob/living/carbon/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	var/obj/item/W = (locate(/obj/item/ammo_casing/a357) in contents) || (locate(/obj/item/clothing/mask/cigarette) in contents) ||(locate(/obj/item/gun/ballistic/derringer) in contents) || (locate(/obj/item/ammo_casing/c38) in contents) || locate(/obj/item/ammo_casing/g4570) in contents//Easy access smokes and bullets
	if(W && contents.len > 0)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
		user.put_in_hands(W)
		contents -= W
		to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
	else
		to_chat(user, "<span class='notice'>There are no items left in the pack.</span>")

/obj/item/storage/fancy/cigarettes/derringer/PopulateContents()
	new spawn_type(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/clothing/mask/cigarette/syndicate(src)

//For traitors with luck/class
/obj/item/storage/fancy/cigarettes/derringer/gold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustg"
	spawn_type = /obj/item/gun/ballistic/derringer/gold

//For operatives, bound in a ka-tet.
/obj/item/storage/fancy/cigarettes/derringer/midworld
	name = "\improper Midworld's Lime Bend"
	desc = "The wheel of Ka turns, Gunslinger."
	icon_state = "slime"
	spawn_type = /obj/item/gun/ballistic/derringer/nukeop

/obj/item/storage/fancy/cigarettes/derringer/midworld/PopulateContents()
	new spawn_type(src)
	new /obj/item/ammo_casing/g4570(src)
	new /obj/item/ammo_casing/g4570(src)
	new /obj/item/ammo_casing/g4570(src)
	new /obj/item/ammo_casing/g4570(src)
	new /obj/item/ammo_casing/g4570(src)
	new /obj/item/clothing/mask/cigarette/xeno(src)

//For Cargomen, looking for a good deal on arms, with no quarrels as to where they're from.
/obj/item/storage/fancy/cigarettes/derringer/smuggled
	name = "\improper Shady Jim's Super Slims packet"
	desc = "If you get caught with this, we don't know you, capiche?"
	icon_state = "shadyjim"
	spawn_type = /obj/item/gun/ballistic/derringer

/obj/item/storage/fancy/cigarettes/derringer/smuggled/PopulateContents()
	new spawn_type(src)
	new /obj/item/ammo_casing/c38/lethal(src)
	new /obj/item/ammo_casing/c38/lethal(src)
	new /obj/item/ammo_casing/c38/lethal(src)
	new /obj/item/ammo_casing/c38/lethal(src)
	new /obj/item/ammo_casing/c38/lethal(src)
	new /obj/item/clothing/mask/cigarette/shadyjims (src)
/////////////
//CIGAR BOX//
/////////////

/obj/item/storage/fancy/cigarettes/cigars
	name = "\improper premium cigar case"
	desc = "A case of premium cigars. Very expensive."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarcase"
	w_class = WEIGHT_CLASS_NORMAL
	icon_type = "premium cigar"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar
	spawn_coupon = FALSE

/obj/item/storage/fancy/cigarettes/cigars/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.can_hold = typecacheof(list(/obj/item/clothing/mask/cigarette/cigar))

/obj/item/storage/fancy/cigarettes/cigars/update_icon_state()
	if(fancy_open)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/storage/fancy/cigarettes/cigars/update_overlays()
	. = ..()
	if(!fancy_open)
		return
	var/cigar_position = 0 //to keep track of the pixel_x offset of each new overlay.
	for(var/obj/item/clothing/mask/cigarette/cigar/smokes in contents)
		var/mutable_appearance/cigar_overlay = mutable_appearance(icon, "[smokes.icon_off]")
		cigar_overlay.pixel_x = 3 * cigar_position
		. += cigar_overlay
		cigar_position++

/obj/item/storage/fancy/cigarettes/cigars/cohiba
	name = "\improper Cohiba Robusto cigar case"
	desc = "A case of imported Cohiba cigars, renowned for their strong flavor."
	icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/cohiba

/obj/item/storage/fancy/cigarettes/cigars/havana
	name = "\improper premium Havanian cigar case"
	desc = "A case of classy Havanian cigars."
	icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/havana

/*
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy/heart_box
	name = "heart-shaped box"
	desc = "A heart-shaped box for holding tiny chocolates."
	icon = 'icons/obj/food/containers.dmi'
	item_state = "chocolatebox"
	icon_state = "chocolatebox"
	icon_type = "chocolate"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	spawn_type = /obj/item/reagent_containers/food/snacks/tinychocolate

/obj/item/storage/fancy/heart_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 8
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/tinychocolate))

/obj/item/storage/fancy/nugget_box
	name = "nugget box"
	desc = "A cardboard box used for holding chicken nuggies."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "nuggetbox"
	icon_type = "nugget"
	spawn_type = /obj/item/reagent_containers/food/snacks/nugget

/obj/item/storage/fancy/nugget_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/nugget))

/obj/item/storage/fancy/treat_box
	name = "treat box"
	desc = "A cardboard box used for holding dog treats."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "treatbox"
	icon_type = "treat"
	spawn_type = /obj/item/reagent_containers/food/snacks/dogtreat

/obj/item/storage/fancy/treat_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/dogtreat))

/obj/item/storage/fancy/cracker_pack
	name = "cracker pack"
	desc = "A pack of delicious crackers. Keep away from parrots!"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "crackerbox"
	icon_type = "cracker"
	spawn_type = /obj/item/reagent_containers/food/snacks/cracker

/obj/item/storage/fancy/cracker_pack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/cracker))

/*
 * Ring Box
 */

/obj/item/storage/fancy/ringbox
	name = "ring box"
	desc = "A tiny box covered in soft red felt made for holding rings."
	icon = 'icons/obj/ring.dmi'
	icon_state = "gold ringbox"
	icon_type = "gold ring"
	w_class = WEIGHT_CLASS_TINY
	spawn_type = /obj/item/clothing/gloves/ring

/obj/item/storage/fancy/ringbox/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.can_hold = typecacheof(list(/obj/item/clothing/gloves/ring))

/obj/item/storage/fancy/ringbox/diamond
	icon_state = "diamond ringbox"
	icon_type = "diamond ring"
	spawn_type = /obj/item/clothing/gloves/ring/diamond

/obj/item/storage/fancy/ringbox/silver
	icon_state = "silver ringbox"
	icon_type = "silver ring"
	spawn_type = /obj/item/clothing/gloves/ring/silver


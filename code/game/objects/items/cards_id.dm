/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */

/*
 * DATA CARDS - Used for the IC data card reader
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = WEIGHT_CLASS_TINY

	var/list/files = list()

/obj/item/card/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins to swipe [user.p_their()] neck with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/card/data
	name = "data card"
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has a stripe running down the middle."
	icon_state = "data_1"
	obj_flags = UNIQUE_RENAME
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	var/detail_color = COLOR_ASSEMBLY_ORANGE

/obj/item/card/data/Initialize()
	.=..()
	update_icon()

/obj/item/card/data/update_overlays()
	. = ..()
	if(detail_color == COLOR_FLOORTILE_GRAY)
		return
	var/mutable_appearance/detail_overlay = mutable_appearance('icons/obj/card.dmi', "[icon_state]-color")
	detail_overlay.color = detail_color
	. += detail_overlay

/obj/item/card/data/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/integrated_electronics/detailer))
		var/obj/item/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	return ..()

/obj/item/proc/GetCard()

/obj/item/card/data/GetCard()
	return src

/obj/item/card/data/full_color
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has the entire card colored."
	icon_state = "data_2"

/obj/item/card/data/disk
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one inexplicibly looks like a floppy disk."
	icon_state = "data_3"

/*
 * ID CARDS
 */
/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	item_flags = NO_MAT_REDEMPTION | NOBLUDGEON
	var/prox_check = TRUE //If the emag requires you to be in range
	var/uses = 15

/obj/item/card/emag/bluespace
	name = "bluespace cryptographic sequencer"
	desc = "It's a blue card with a magnetic strip attached to some circuitry. It appears to have some sort of transmitter attached to it."
	icon_state = "emag_bs"
	prox_check = FALSE

/obj/item/card/emag/attack()
	return

/obj/item/card/emag/afterattack(atom/target, mob/user, proximity)
	. = ..()
	var/atom/A = target
	if(!proximity && prox_check || !(isobj(A) || issilicon(A) || isbot(A) || isdrone(A)))
		return
	if(istype(A, /obj/item/storage) && !(istype(A, /obj/item/storage/lockbox) || istype(A, /obj/item/storage/pod)))
		return
	if(!uses)
		user.visible_message("<span class='warning'>[src] emits a weak spark. It's burnt out!</span>")
		playsound(src, 'sound/effects/light_flicker.ogg', 100, 1)
		return
	else if(uses <= 3)
		playsound(src, 'sound/effects/light_flicker.ogg', 30, 1)	//Tiiiiiiny warning sound to let ya know your emag's almost dead
	if(!A.emag_act(user))
		return
	uses = max(uses - 1, 0)
	if(!uses)
		user.visible_message("<span class='warning'>[src] fizzles and sparks. It seems like it's out of charges.</span>")
		playsound(src, 'sound/effects/light_flicker.ogg', 100, 1)

/obj/item/card/emag/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It has <b>[uses ? uses : "no"]</b> charges left.</span>"

/obj/item/card/emag/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/emagrecharge))
		var/obj/item/emagrecharge/ER = W
		if(ER.uses)
			uses += ER.uses
			to_chat(user, "<span class='notice'>You have added [ER.uses] charges to [src]. It now has [uses] charges.</span>")
			playsound(src, "sparks", 100, 1)
			ER.uses = 0
		else
			to_chat(user, "<span class='warning'>[ER] has no charges left.</span>")
		return
	. = ..()

/obj/item/card/emag/empty
	uses = 0

/obj/item/emagrecharge
	name = "electromagnet charging device"
	desc = "A small cell with two prongs lazily jabbed into it. It looks like it's made for charging the small batteries found in electromagnetic devices, sadly this can't be recharged like a normal cell."
	icon = 'icons/obj/module.dmi'
	icon_state = "cell_mini"
	item_flags = NOBLUDGEON
	var/uses = 5	//Dictates how many charges the device adds to compatible items

/obj/item/emagrecharge/examine(mob/user)
	. = ..()
	if(uses)
		. += "<span class='notice'>It can add up to [uses] charges to compatible devices</span>"
	else
		. += "<span class='warning'>It has a small, red, blinking light coming from inside of it. It's spent.</span>"

/obj/item/card/emagfake
	desc = "It's a card with a magnetic strip attached to some circuitry. Closer inspection shows that this card is a poorly made replica, with a \"DonkCo\" logo stamped on the back."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'

/obj/item/card/emagfake/afterattack()
	. = ..()
	playsound(src, 'sound/items/bikehorn.ogg', 50, 1)

/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	slot_flags = ITEM_SLOT_ID
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/id_type_name = "identification card"
	var/mining_points = 0 //For redeeming at mining equipment vendors
	var/list/access = list()
	var/registered_name = null // The name registered_name on the card
	var/assignment = null
	var/access_txt // mapping aid
	var/datum/bank_account/registered_account
	var/obj/machinery/paystand/my_store
	var/uses_overlays = TRUE
	var/icon/cached_flat_icon

/obj/item/card/id/Initialize(mapload)
	. = ..()
	if(mapload && access_txt)
		access = text2access(access_txt)
	switch(bank_support)
		if(ID_FREE_BANK_ACCOUNT)
			var/turf/T = get_turf(src)
			if(T && is_vr_level(T.z)) //economy is exploitable on VR in so many ways.
				bank_support = ID_NO_BANK_ACCOUNT
		if(ID_LOCKED_BANK_ACCOUNT)
			registered_account = new /datum/bank_account/remote/non_transferable(pick(GLOB.redacted_strings))

/obj/item/card/id/Destroy()
	if(bank_support == ID_LOCKED_BANK_ACCOUNT)
		QDEL_NULL(registered_account)
	else
		registered_account = null
	if(my_store)
		my_store.my_card = null
		my_store = null
	return ..()

/obj/item/card/id/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if("assignment","registered_name")
				update_label()

/obj/item/card/id/attack_self(mob/user)
	if(Adjacent(user))
		user.visible_message("<span class='notice'>[user] shows you: [icon2html(src, viewers(user))] [src.name].</span>", \
					"<span class='notice'>You show \the [src.name].</span>")
		add_fingerprint(user)

/obj/item/card/id/attackby(obj/item/W, mob/user, params)
	if(!bank_support)
		return ..()
	if(istype(W, /obj/item/holochip))
		insert_money(W, user)
	else if(istype(W, /obj/item/stack/spacecash) || istype(W, /obj/item/coin))
		insert_money(W, user, TRUE)
	else if(istype(W, /obj/item/storage/bag/money))
		var/obj/item/storage/bag/money/money_bag = W
		var/list/money_contained = money_bag.contents
		var/money_added = mass_insert_money(money_contained, user)
		if (money_added)
			to_chat(user, "<span class='notice'>You stuff the contents into the card! They disappear in a puff of bluespace smoke, adding [money_added] worth of credits to the linked account.</span>")
	else
		return ..()

/obj/item/card/id/proc/insert_money(obj/item/I, mob/user, physical_currency)
	var/cash_money = I.get_item_credit_value()
	if(!cash_money)
		to_chat(user, "<span class='warning'>[I] doesn't seem to be worth anything!</span>")
		return

	if(!registered_account)
		to_chat(user, "<span class='warning'>[src] doesn't have a linked account to deposit [I] into!</span>")
		return

	registered_account.adjust_money(cash_money)
	if(physical_currency)
		to_chat(user, "<span class='notice'>You stuff [I] into [src]. It disappears in a small puff of bluespace smoke, adding [cash_money] credits to the linked account.</span>")
	else
		to_chat(user, "<span class='notice'>You insert [I] into [src], adding [cash_money] credits to the linked account.</span>")

	to_chat(user, "<span class='notice'>The linked account now reports a balance of [registered_account.account_balance] cr.</span>")
	qdel(I)

/obj/item/card/id/proc/mass_insert_money(list/money, mob/user)
	if (!money || !money.len)
		return FALSE

	var/total = 0

	for (var/obj/item/physical_money in money)
		var/cash_money = physical_money.get_item_credit_value()

		total += cash_money

		registered_account.adjust_money(cash_money)

	QDEL_LIST(money)

	return total

/obj/item/card/id/proc/alt_click_can_use_id(mob/living/user)
	if(!isliving(user))
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	return TRUE

// Returns true if new account was set.
/obj/item/card/id/proc/set_new_account(mob/living/user)
	if(bank_support != ID_FREE_BANK_ACCOUNT)
		to_chat(user, "<span class='warning'>This ID has no modular banking support whatsover, must be an older model...</span>")
		return
	. = FALSE
	var/datum/bank_account/old_account = registered_account

	var/new_bank_id = input(user, "Enter your account ID number.", "Account Reclamation", 111111) as num | null

	if (isnull(new_bank_id))
		return

	if(!alt_click_can_use_id(user))
		return
	if(!new_bank_id || new_bank_id < 111111 || new_bank_id > 999999)
		to_chat(user, "<span class='warning'>The account ID number needs to be between 111111 and 999999.</span>")
		return
	if (registered_account && registered_account.account_id == new_bank_id)
		to_chat(user, "<span class='warning'>The account ID was already assigned to this card.</span>")
		return

	for(var/A in SSeconomy.bank_accounts)
		var/datum/bank_account/B = A
		if(B.account_id == new_bank_id)
			if (old_account)
				old_account.bank_cards -= src

			B.bank_cards += src
			registered_account = B
			to_chat(user, "<span class='notice'>The provided account has been linked to this ID card.</span>")

			return TRUE

	to_chat(user, "<span class='warning'>The account ID number provided is invalid.</span>")
	return

/obj/item/card/id/AltClick(mob/living/user)
	. = ..()
	if(!bank_support || !alt_click_can_use_id(user))
		return

	if(!registered_account && bank_support == ID_FREE_BANK_ACCOUNT)
		set_new_account(user)
		return

	if (world.time < registered_account.withdrawDelay)
		registered_account.bank_card_talk("<span class='warning'>ERROR: UNABLE TO LOGIN DUE TO SCHEDULED MAINTENANCE. MAINTENANCE IS SCHEDULED TO COMPLETE IN [(registered_account.withdrawDelay - world.time)/10] SECONDS.</span>", TRUE)
		return

	var/amount_to_remove =  input(user, "How much do you want to withdraw? Current Balance: [registered_account.account_balance]", "Withdraw Funds", 5) as num|null

	if(!amount_to_remove || amount_to_remove < 0)
		return
	if(!alt_click_can_use_id(user))
		return
	amount_to_remove = FLOOR(min(amount_to_remove, registered_account.account_balance), 1)
	if(amount_to_remove && registered_account.adjust_money(-amount_to_remove))
		var/obj/item/holochip/holochip = new (user.drop_location(), amount_to_remove)
		user.put_in_hands(holochip)
		to_chat(user, "<span class='notice'>You withdraw [amount_to_remove] credits into a holochip.</span>")
		return
	registered_account.bank_card_talk("<span class='warning'>ERROR: The linked account has no sufficient credits to perform that withdrawal.</span>", TRUE)
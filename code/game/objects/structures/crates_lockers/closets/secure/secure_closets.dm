/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's a card-locked storage unit."
	locked = TRUE
	icon_state = "secure"
	max_integrity = 250
	armor = list("melee" = 30, "bullet" = 50, "laser" = 50, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)
	secure = TRUE
	var/melee_min_damage = 20

/obj/structure/closet/secure_closet/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == "melee" && damage_amount < melee_min_damage)
		return 0
	. = ..()

// Exists to work around the minimum 700 cr price for goodies / small items
/obj/structure/closet/secure_closet/goodies
	icon_state = "goodies"
	desc = "A sturdier card-locked storage unit used for bulky shipments."
	max_integrity = 500 // Same as crates.
	melee_min_damage = 25 // Idem.

/obj/structure/closet/secure_closet/goodies/owned
	name = "private locker"
	desc = "A locker designed to only open for who purchased its contents."
	///Account of the person buying the crate if private purchasing.
	var/datum/bank_account/buyer_account
	///Department of the person buying the crate if buying via the NIRN app.
	var/datum/bank_account/department/department_account
	///Is the secure crate opened or closed?
	var/privacy_lock = TRUE
	///Is the crate being bought by a person, or a budget card?
	var/department_purchase = FALSE

/obj/structure/closet/secure_closet/goodies/owned/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It's locked with a privacy lock, and can only be unlocked by the buyer's ID.</span>"

/obj/structure/closet/secure_closet/goodies/owned/Initialize(mapload, datum/bank_account/_buyer_account)
	. = ..()
	buyer_account = _buyer_account
	if(istype(buyer_account, /datum/bank_account/department))
		department_purchase = TRUE
		department_account = buyer_account

/obj/structure/closet/secure_closet/goodies/owned/togglelock(mob/living/user, silent)
	if(privacy_lock)
		if(!broken)
			var/obj/item/card/id/id_card = user.get_idcard(TRUE)
			if(id_card)
				if(id_card.registered_account)
					if(id_card.registered_account == buyer_account || (department_purchase && (id_card.registered_account?.account_job?.paycheck_department) == (department_account.department_id)))
						if(iscarbon(user))
							add_fingerprint(user)
						locked = !locked
						user.visible_message("<span class='notice'>[user] unlocks [src]'s privacy lock.</span>",
										"<span class='notice'>You unlock [src]'s privacy lock.</span>")
						privacy_lock = FALSE
						update_icon()
					else if(!silent)
						to_chat(user, "<span class='notice'>Bank account does not match with buyer!</span>")
				else if(!silent)
					to_chat(user, "<span class='notice'>No linked bank account detected!</span>")
			else if(!silent)
				to_chat(user, "<span class='notice'>No ID detected!</span>")
		else if(!silent)
			to_chat(user, "<span class='warning'>[src] is broken!</span>")
	else ..()

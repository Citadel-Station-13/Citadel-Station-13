/obj/item/reagent_containers/medspray
	name = "medical spray"
	desc = "A medical spray bottle, designed for precision application, with an unscrewable cap."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "medspray"
	item_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	item_flags = NOBLUDGEON
	obj_flags = UNIQUE_RENAME
	reagent_flags = OPENCONTAINER
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	amount_per_transfer_from_this = 10
	volume = 60
	var/can_fill_from_container = TRUE
	var/apply_type = PATCH
	var/apply_method = "spray"
	var/self_delay = 3 SECONDS
	var/squirt_mode = FALSE
	var/squirt_amount = 5

/obj/item/reagent_containers/medspray/attack_self(mob/user)
	squirt_mode = !squirt_mode
	if(squirt_mode)
		amount_per_transfer_from_this = squirt_amount
	else
		amount_per_transfer_from_this = initial(amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You will now apply the medspray's contents in [squirt_mode ? "short bursts":"extended sprays"]. You'll now use [amount_per_transfer_from_this] units per use.</span>")

/obj/item/reagent_containers/medspray/attack(mob/living/L, mob/user, def_zone)
	INVOKE_ASYNC(src, PROC_REF(attempt_spray), L, user, def_zone)		// this is shitcode because the params for attack aren't even right but i'm not in the mood to refactor right now.

/obj/item/reagent_containers/medspray/proc/attempt_spray(mob/living/L, mob/user, def_zone)
	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return

	if(ishuman(L))
		var/obj/item/bodypart/affecting = L.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			to_chat(user, "<span class='warning'>The limb is missing!</span>")
			return
		if(!L.can_inject(user, TRUE, user.zone_selected, FALSE, TRUE)) //stopped by clothing, like patches
			return
		if(!affecting.is_organic_limb())
			to_chat(user, "<span class='notice'>Medicine won't work on a robotic limb!</span>")
			return
		else if(!affecting.is_organic_limb(FALSE))
			to_chat(user, "<span class='notice'>Medical sprays won't work on a biomechanical limb!</span>")

	if(L == user)
		L.visible_message("<span class='notice'>[user] attempts to [apply_method] [src] on [user.p_them()]self.</span>")
		if(self_delay)
			if(!do_mob(user, L, self_delay))
				return
			if(!reagents || !reagents.total_volume)
				return
		to_chat(L, "<span class='notice'>You [apply_method] yourself with [src].</span>")

	else
		log_combat(user, L, "attempted to apply", src, reagents.log_list())
		L.visible_message("<span class='danger'>[user] attempts to [apply_method] [src] on [L].</span>", \
							"<span class='userdanger'>[user] attempts to [apply_method] [src] on [L].</span>")
		if(!do_mob(user, L))
			return
		if(!reagents || !reagents.total_volume)
			return
		L.visible_message("<span class='danger'>[user] [apply_method]s [L] down with [src].</span>", \
							"<span class='userdanger'>[user] [apply_method]s [L] down with [src].</span>")

	if(!reagents || !reagents.total_volume)
		return

	else
		log_combat(user, L, "applied", src, reagents.log_list())
		playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
		reagents.reaction(L, apply_type, fraction)
		reagents.trans_to(L, amount_per_transfer_from_this, log = TRUE)
	return

/obj/item/reagent_containers/medspray/styptic
	name = "medical spray (styptic powder)"
	desc = "A medical spray bottle, designed for precision application, with an unscrewable cap. This one contains styptic powder, for treating cuts and bruises."
	icon_state = "brutespray"
	list_reagents = list(/datum/reagent/medicine/styptic_powder = 60)

/obj/item/reagent_containers/medspray/silver_sulf
	name = "medical spray (silver sulfadiazine)"
	desc = "A medical spray bottle, designed for precision application, with an unscrewable cap. This one contains silver sulfadiazine, useful for treating burns."
	icon_state = "burnspray"
	list_reagents = list(/datum/reagent/medicine/silver_sulfadiazine = 60)

/obj/item/reagent_containers/medspray/synthflesh
	name = "medical spray (synthflesh)"
	desc = "A medical spray bottle, designed for precision application, with an unscrewable cap. This one contains synthflesh, an apex brute and burn healing agent."
	icon_state = "synthspray"
	list_reagents = list(/datum/reagent/medicine/synthflesh = 60)

/obj/item/reagent_containers/medspray/sterilizine
	name = "sterilizer spray"
	desc = "Spray bottle loaded with non-toxic sterilizer. Useful in preparation for surgery."
	list_reagents = list(/datum/reagent/space_cleaner/sterilizine = 60)

/obj/item/reagent_containers/medspray/synthtissue
	name = "Synthtissue young culture spray"
	desc = "Spray bottle loaded with synthtissue. Useful in synthtissue grafting surgeries."
	list_reagents = list(/datum/reagent/synthtissue = 60)

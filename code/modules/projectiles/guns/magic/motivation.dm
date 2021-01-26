/obj/item/gun/magic/staff/motivation
	name = "Motivation"
	desc = "Rumored to have the ability to open up a portal the depths of Lavaland."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "motivation"
	item_state = "motivation"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	fire_sound = 'sound/magic/fireball.ogg'
	ammo_type = /obj/item/ammo_casing/magic/judgement_cut
	force = 40
	armour_penetration = 50
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = SHARP_EDGED
	max_integrity = 200
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	max_charges = 3
	recharge_rate = 5
	var/datum/action/judgement_cut/judgementcut = new/datum/action/judgement_cut()
	

/obj/item/gun/magic/staff/motivation/Initialize()
	. = ..()
	judgementcut = new(src)

/obj/item/gun/magic/staff/motivation/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, "<span class='warning'>Judgment Cut is recharging.</span>")

/datum/action/judgement_cut
	name = "Judgement Cut - Allows Motivation to slash at a longer distance."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "neckchop"
	var/judgement_toggled = TRUE

/datum/action/judgement_cut/Trigger()
	judgement_toggled = !judgement_toggled
	to_chat(owner, "<span class='notice'>You [judgement_toggled ? "enable" : "disable"] Judgement Cuts with [src].</span>")

/obj/item/gun/magic/staff/motivation/can_trigger_gun(mob/living/user)
	. = ..()
	if(!judgementcut.judgement_toggled)
		to_chat(user, "<span class='notice'> Judgment Cut is disabled.</span>")
		return

/obj/item/gun/magic/staff/motivation/pickup(mob/living/user)
	. = ..()
	judgementcut.Grant(user, src)
	user.update_icons()
	playsound(src, 'sound/items/unsheath.ogg', 25, 1)

/obj/item/gun/magic/staff/motivation/dropped(mob/user)
	. = ..()
	judgementcut.Remove(user)
	user.update_icons()

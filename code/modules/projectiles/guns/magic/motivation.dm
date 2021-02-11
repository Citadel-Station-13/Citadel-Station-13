/obj/item/gun/magic/staff/motivation
	name = "Motivation"
	desc = "Rumored to have the ability to open up a portal the depths of Lavaland."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "motivation"
	item_state = "motivation"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	fire_sound = 'sound/weapons/judgementhit.ogg'
	ammo_type = /obj/item/ammo_casing/magic/judgement_cut
	force = 20 //so it's worth that 20 tc
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
	block_parry_data = /datum/block_parry_data/motivation
	
//to get this to toggle correctly
/obj/item/gun/magic/staff/motivation/Initialize()
	. = ..()
	judgementcut = new(src)

//lets the user know that their judgment cuts are recharging
/obj/item/gun/magic/staff/motivation/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, "<span class='warning'>Judgment Cut is recharging.</span>")

//action button to toggle judgement cuts on/off
/datum/action/judgement_cut
	name = "Judgement Cut - Allows Motivation to slash at a longer distance."
	icon_icon = 'icons/obj/projectiles.dmi'
	button_icon_state = "judgement_fire"
	var/judgement_toggled = TRUE

//lets the user know that you toggled them on/off
/datum/action/judgement_cut/Trigger()
	judgement_toggled = !judgement_toggled
	to_chat(owner, "<span class='notice'>You [judgement_toggled ? "enable" : "disable"] Judgement Cuts with Motivation.</span>")

//Prevents "firing" the judgement cuts if toggled off and lets the user know
/obj/item/gun/magic/staff/motivation/can_trigger_gun(mob/living/user)
	. = ..()
	if(!judgementcut.judgement_toggled)
		to_chat(user, "<span class='notice'> Judgment Cut is disabled.</span>")
		return FALSE

//adds/removes judgement cut and judgement cut end upon pickup/drop
/obj/item/gun/magic/staff/motivation/pickup(mob/living/user)
	. = ..()
	judgementcut.Grant(user, src)
	user.update_icons()
	playsound(src, 'sound/items/unsheath.ogg', 25, 1)

/obj/item/gun/magic/staff/motivation/dropped(mob/user)
	. = ..()
	judgementcut.Remove(user)
	user.update_icons()

//A parry tight enough to stagger, but not to counter attack
/datum/block_parry_data/motivation
	parry_time_windup = 0.5
	parry_time_active = 5
	parry_time_spindown = 0
	parry_attack_types = ALL
	parry_time_active_visual_override = 3
	parry_time_spindown_visual_override = 2
	parry_flags = PARRY_DEFAULT_HANDLE_FEEDBACK | PARRY_LOCK_ATTACKING
	parry_time_perfect = 0
	parry_time_perfect_leeway = 3
	parry_time_perfect_leeway_override = list(
		TEXT_ATTACK_TYPE_PROJECTILE = 1
	)
	parry_imperfect_falloff_percent_override = list(
		TEXT_ATTACK_TYPE_PROJECTILE = 50				// useless after 3rd decisecond
	)
	parry_imperfect_falloff_percent = 30
	parry_efficiency_to_counterattack = 100
	parry_efficiency_considered_successful = 1
	parry_efficiency_perfect = 100
	parry_data = list(
		PARRY_STAGGER_ATTACKER = 10
	)
	parry_failed_stagger_duration = 2 SECONDS
	parry_failed_clickcd_duration = CLICK_CD_RANGE
	parry_cooldown = 0

/datum/antagonist/dodgeball
	name = "Doomballer"
	var/obj/item/toy/beach_ball/doomball/mine
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	can_hijack = HIJACK_HIJACKER

/datum/antagonist/dodgeball/apply_innate_effects(mob/living/mob_override)
	var/mob/living/L = owner.current || mob_override
	ADD_TRAIT(L, TRAIT_NOGUNS, "doomballer")

/datum/antagonist/dodgeball/remove_innate_effects(mob/living/mob_override)
	var/mob/living/L = owner.current || mob_override
	REMOVE_TRAIT(L, TRAIT_NOGUNS, "doomballer")

/datum/antagonist/dodgeball/proc/forge_objectives()
	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = owner
	objectives += steal_objective

	var/datum/objective/hijack/hijack_objective = new
	hijack_objective.explanation_text = "Escape on the shuttle alone. Ensure that nobody else makes it out."
	hijack_objective.owner = owner
	objectives += hijack_objective

	owner.objectives |= objectives

/datum/antagonist/dodgeball/on_gain()
	forge_objectives()
	owner.special_role = "doomballer"
	give_equipment()
	. = ..()

/datum/antagonist/dodgeball/greet()
	to_chat(owner, "<span class='boldannounce'>Your doomball cries out for souls. Claim the lives of others, or die trying</span>")

	owner.announce_objectives()

/datum/antagonist/dodgeball/proc/give_equipment()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	for(var/obj/item/I in H.get_equipped_items(TRUE))
		qdel(I)
	for(var/obj/item/I in H.held_items)
		qdel(I)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/shorts/black(H), SLOT_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/radio/headset/heads/captain(H), SLOT_EARS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/collectable/tophat(H), SLOT_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), SLOT_SHOES)
	H.equip_to_slot_or_del(new /obj/item/pinpointer/nuke(H), SLOT_L_STORE)
	for(var/obj/item/pinpointer/nuke/P in H)
		P.attack_self(H)
	var/obj/item/card/id/W = new(H)
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.assignment = "Doomballer"
	W.registered_name = H.real_name
	W.item_flags |= NODROP
	W.update_label(H.real_name)
	H.equip_to_slot_or_del(W, SLOT_WEAR_ID)
	mine = new(H)
	if(!GLOB.doomball)
		mine.flags_1 |= ADMIN_SPAWNED_1 //To prevent announcing
	mine.pickup(H) //For the stun shielding
	H.put_in_hands(mine)

	var/obj/item/bloodcrawl/antiwelder = new(H)
	antiwelder.name = "compulsion of honor"
	antiwelder.desc = "You are unable to hold anything in this hand until you're the last one left!"
	antiwelder.icon_state = "bloodhand_right"
	antiwelder.item_flags = DROPDEL | NODROP
	H.put_in_hands(antiwelder)



/obj/item/toy/beach_ball/doomball
	name = "doomball"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "doomball"
	item_state = "doomball"
	desc = "Used for playing the most violent and degrading of childhood games."

/obj/item/toy/beach_ball/doomball/throw_at(atom/target, range, speed, mob/thrower, spin=FALSE, diagonals_first = FALSE, datum/callback/callback)
	if(thrower.lying)
		return
	. = ..(target, range, speed, thrower, FALSE, diagonals_first, callback)


/obj/item/toy/beach_ball/doomball/throw_impact(atom/hit_atom)
	.  = ..()
	if(!iscarbon(hit_atom))
		return
//	var/mob/living/carbon/H = thrownthing.thrower
	var/mob/living/carbon/M = hit_atom
//	if(H.lying)
//		H.gib()
//		return
	if(!.)
		playsound(src, 'sound/items/dodgeball.ogg', 50, 1)
		visible_message("<span class='danger'>[M] explodes violently into gore!</span>")
		M.gib()
		return


/obj/item/toy/beach_ball/doomball/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !ismob(target) || !iscarbon(user)) //exploding after touching yourself would be bad
		return
	if(user.lying)
		return
	var/mob/M = target
	do_sparks(4, FALSE, M.loc)
	M.gib()
	return ..()


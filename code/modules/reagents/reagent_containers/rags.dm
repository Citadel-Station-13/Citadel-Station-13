/obj/item/reagent_containers/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	item_flags = NOBLUDGEON
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 5
	spillable = FALSE
	var/wipe_sound
	var/soak_efficiency = 1
	var/extinguish_efficiency = 0

/obj/item/reagent_containers/rag/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is smothering [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (OXYLOSS)

/obj/item/reagent_containers/rag/afterattack(atom/A as obj|turf|area, mob/user,proximity)
	. = ..()
	if(!proximity)
		return
	if(iscarbon(A) && A.reagents && reagents.total_volume)
		var/mob/living/carbon/C = A
		var/reagentlist = pretty_string_from_reagent_list(reagents)
		var/log_object = "a damp rag containing [reagentlist]"
		if(user.a_intent == INTENT_HARM && !C.is_mouth_covered())
			reagents.reaction(C, INGEST)
			reagents.trans_to(C, 5)
			C.visible_message("<span class='danger'>[user] has smothered \the [C] with \the [src]!</span>", "<span class='userdanger'>[user] has smothered you with \the [src]!</span>", "<span class='italics'>You hear some struggling and muffled cries of surprise.</span>")
			log_combat(user, C, "smothered", log_object)
		else
			reagents.reaction(C, TOUCH)
			reagents.remove_all(5)
			C.visible_message("<span class='notice'>[user] has touched \the [C] with \the [src].</span>")
			log_combat(user, C, "touched", log_object)

	else if(istype(A) && src in user)
		user.visible_message("[user] starts to wipe down [A] with [src]!", "<span class='notice'>You start to wipe down [A] with [src]...</span>")
		if(do_after(user,30, target = A))
			user.visible_message("[user] finishes wiping off [A]!", "<span class='notice'>You finish wiping off [A].</span>")
			SEND_SIGNAL(A, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
	return

/obj/item/reagent_containers/rag/pre_altattackby(mob/living/M, mob/living/user, params)
	if(istype(M) && user.a_intent == INTENT_HELP)
		user.changeNext_move(CLICK_CD_MELEE)
		if(user.on_fire)
			user.visible_message("<span class='warning'>\The [user] uses \the [src] to pat out [M == user ? "[user.p_their()]" : "\the [M]'s"] flames!</span>")
			if(hitsound)
				playsound(M, hitsound, 25, 1)
			M.adjust_fire_stacks(-extinguish_efficiency)
		else
			user.visible_message("<span class='notice'>\The [user] starts drying [M == user ? "[user.p_them()]self" : "\the [M]"] off with \the [src]...</span>")
			if(do_mob(user, M, 3 SECONDS))
				user.visible_message("<span class='notice'>\The [user] dries [M == user ? "[user.p_them()]self" : "\the [M]"] off with \the [src].</span>")
				if(wipe_sound)
					playsound(M, wipe_sound, 25, 1)
				M.adjust_fire_stacks(-soak_efficiency)
		return TRUE
	return ..()

/obj/item/reagent_containers/rag/towel
	name = "towel"
	desc = "A soft cotton towel."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "towel"
	item_state = "towel"
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_BELT | ITEM_SLOT_OCLOTHING
	item_flags = NO_UNIFORM_REQUIRED //so it can be worn on the belt slot even with no uniform.
	force = 1
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/items/towelwhip.ogg'
	volume = 10
	total_mass = 2
	wipe_sound = 'sound/items/towelwipe.ogg'
	soak_efficiency = 2
	extinguish_efficiency = 2
	var/flat_icon = "towel_flat"
	var/folded_icon = "towel"

/obj/item/reagent_containers/rag/towel/attack(mob/living/M, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		DISABLE_BITFIELD(item_flags, NOBLUDGEON)
		. = TRUE
	..()
	if(.)
		ENABLE_BITFIELD(item_flags, NOBLUDGEON)

/obj/item/reagent_containers/rag/towel/equipped(mob/living/user, slot)
	. = ..()
	switch(slot)
		if(SLOT_BELT)
			body_parts_covered = GROIN|LEGS
		if(SLOT_WEAR_SUIT)
			body_parts_covered = CHEST|GROIN|LEGS
		if(SLOT_HEAD)
			body_parts_covered = HEAD
			flags_inv = HIDEHAIR

/obj/item/reagent_containers/rag/towel/dropped(mob/user)
	. = ..()
	body_parts_covered = NONE
	flags_inv = NONE

/obj/item/reagent_containers/rag/towel/attack_self(mob/user)
	if(!user.CanReach(src) || !user.dropItemToGround(src))
		return
	to_chat(user, "<span class='notice'>You lay out \the [src] flat on the ground.</span>")
	icon_state = flat_icon
	layer = BELOW_OBJ_LAYER
	qdel(src)

/obj/item/reagent_containers/rag/towel/pickup(mob/living/user)
	. = ..()
	icon_state = folded_icon
	layer = initial(layer)

/obj/item/reagent_containers/rag/towel/random/Initialize()
	. = ..()
	add_atom_colour(pick("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"), FIXED_COLOUR_PRIORITY)

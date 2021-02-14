/obj/item/reagent_containers/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	item_flags = NOBLUDGEON
	reagent_flags = REFILLABLE | DRAINABLE
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	container_flags = APTFT_VERB
	volume = 5
	spillable = FALSE
	reagent_value = NO_REAGENTS_VALUE
	var/wipe_sound
	var/soak_efficiency = 1
	var/extinguish_efficiency = 0
	var/action_speed = 3 SECONDS
	var/damp_threshold = 0.5

/obj/item/reagent_containers/rag/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is smothering [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (OXYLOSS)

/obj/item/reagent_containers/rag/examine(mob/user)
	. = ..()
	if(reagents.total_volume)
		. += "<span class='notice'>It's soaked. Alt-Click to squeeze it dry, and perhaps gather the liquids into another held open container.</span>"

/obj/item/reagent_containers/rag/afterattack(atom/A, mob/user,proximity)
	. = ..()
	if(!proximity)
		return
	if(iscarbon(A) && A.reagents && reagents.total_volume)
		var/mob/living/carbon/C = A
		var/reagentlist = pretty_string_from_reagent_list(reagents)
		var/log_object = "a damp rag containing [reagentlist]"
		if(user.a_intent == INTENT_HARM && !C.is_mouth_covered())
			C.visible_message("<span class='danger'>[user] is trying to smother \the [C] with \the [src]!</span>", "<span class='userdanger'>[user] is trying to smother you with \the [src]!</span>", "<span class='italics'>You hear some struggling and muffled cries of surprise.</span>")
			if(do_after(user, 20, target = C))
				reagents.reaction(C, INGEST)
				reagents.trans_to(C, 5, log = "rag smother")
				C.visible_message("<span class='danger'>[user] has smothered \the [C] with \the [src]!</span>", "<span class='userdanger'>[user] has smothered you with \the [src]!</span>", "<span class='italics'>You hear some struggling and a heavy breath taken.</span>")
				log_combat(user, C, "smothered", log_object)
		else
			C.visible_message("<span class='notice'>[user] is trying to wipe \the [C] with \the [src].</span>")
			if(do_after(user, 20, target = C))
				reagents.reaction(C, TOUCH)
				reagents.remove_all(5)
				C.visible_message("<span class='notice'>[user] has wiped \the [C] with \the [src].</span>")
				log_combat(user, C, "touched", log_object)

	else if(istype(A) && (src in user))
		user.visible_message("[user] starts to wipe down [A] with [src]!", "<span class='notice'>You start to wipe down [A] with [src]...</span>")
		if(do_after(user, action_speed, target = A))
			user.visible_message("[user] finishes wiping off [A]!", "<span class='notice'>You finish wiping off [A].</span>")
			SEND_SIGNAL(A, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)

/obj/item/reagent_containers/rag/alt_pre_attack(mob/living/M, mob/living/user, params)
	if(istype(M) && user.a_intent == INTENT_HELP)
		user.DelayNextAction(CLICK_CD_MELEE)
		if(M.on_fire)
			user.visible_message("<span class='warning'>\The [user] uses \the [src] to pat out [M == user ? "[user.p_their()]" : "\the [M]'s"] flames!</span>")
			if(hitsound)
				playsound(M, hitsound, 25, 1)
			M.adjust_fire_stacks(-min(extinguish_efficiency, M.fire_stacks))
		else
			if(reagents.total_volume > (volume * damp_threshold))
				to_chat(user, "<span class='warning'>\The [src] is too drenched to be used to dry [user == M ? "yourself" : "\the [M]"] off.</span>")
				return TRUE
			user.visible_message("<span class='notice'>\The [user] starts drying [M == user ? "[user.p_them()]self" : "\the [M]"] off with \the [src]...</span>")
			if(do_mob(user, M, action_speed))
				if(reagents.total_volume > (volume * damp_threshold))
					return
				user.visible_message("<span class='notice'>\The [user] dries [M == user ? "[user.p_them()]self" : "\the [M]"] off with \the [src].</span>")
				if(wipe_sound)
					playsound(M, wipe_sound, 25, 1)
				if(M.fire_stacks)
					var/minus_plus = M.fire_stacks < 0 ? 1 : -1
					var/amount = min(abs(M.fire_stacks), soak_efficiency)
					var/r_id = /datum/reagent/fuel
					if(M.fire_stacks < 0)
						r_id = /datum/reagent/water
					reagents.add_reagent(r_id, amount * 0.3)
					M.adjust_fire_stacks(minus_plus * amount)
				M.wash_cream()
		return TRUE
	return ..()

/obj/item/reagent_containers/rag/AltClick(mob/user)
	. = ..()
	if(reagents.total_volume && user.canUseTopic(src, BE_CLOSE))
		to_chat(user, "<span class='notice'>You start squeezing \the [src] dry...</span>")
		if(do_after(user, action_speed, TRUE, src))
			var/msg = "You squeeze \the [src]"
			var/obj/item/target
			if(Adjacent(user)) //Allows the user to drain the reagents into a beaker if adjacent (no telepathy).
				for(var/obj/item/I in user.held_items)
					if(I == src)
						continue
					if(I.is_open_container() && !I.reagents.holder_full())
						target = I
						break
			if(!target)
				msg += " dry"
				reagents.reaction(get_turf(src), TOUCH)
				reagents.clear_reagents()
			else
				msg += "'s liquids into \the [target]"
				reagents.trans_to(target, reagents.total_volume, log = "rag squeeze dry")
			to_chat(user, "<span class='notice'>[msg].</span>")
		return TRUE


/obj/item/reagent_containers/rag/towel
	name = "towel"
	desc = "A soft cotton towel."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "towel"
	item_state = "towel"
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_BELT | ITEM_SLOT_OCLOTHING
	item_flags = NOBLUDGEON | NO_UNIFORM_REQUIRED //so it can be worn on the belt slot even with no uniform.
	force = 1
	w_class = WEIGHT_CLASS_NORMAL
	mutantrace_variation = STYLE_DIGITIGRADE
	attack_verb = list("whipped")
	hitsound = 'sound/items/towelwhip.ogg'
	volume = 10
	total_mass = 2
	wipe_sound = 'sound/items/towelwipe.ogg'
	soak_efficiency = 4
	extinguish_efficiency = 3
	var/flat_icon = "towel_flat"
	var/folded_icon = "towel"
	var/list/possible_colors

/obj/item/reagent_containers/rag/towel/Initialize()
	. = ..()
	if(possible_colors)
		add_atom_colour(pick(possible_colors), FIXED_COLOUR_PRIORITY)

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

/obj/item/reagent_containers/rag/towel/pickup(mob/living/user)
	. = ..()
	icon_state = folded_icon
	layer = initial(layer)

/obj/item/reagent_containers/rag/towel/on_reagent_change(changetype)
	force = initial(force) + round(reagents.total_volume * 0.5)

/obj/item/reagent_containers/rag/towel/random
	possible_colors = list("#FF0000","#FF7F00","#FFFF00","#00FF00","#0000FF","#4B0082","#8F00FF")

/obj/item/reagent_containers/rag/towel/syndicate
	name = "syndicate towel"
	desc = "Truly a weapon of mass destruction."
	possible_colors = list("#DD1A1A", "#DB4325", "#E02700")
	force = 4
	armour_penetration = 10
	volume = 20
	soak_efficiency = 6
	extinguish_efficiency = 5
	action_speed = 15
	damp_threshold = 0.8
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 20, "bio" = 20, "rad" = 20, "fire" = 50, "acid" = 50) //items don't provide armor to wearers unlike clothing yet.

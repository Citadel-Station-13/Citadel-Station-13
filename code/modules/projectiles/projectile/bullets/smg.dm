// .45 (M1911 & C20r)

/obj/item/projectile/bullet/c45
	name = ".45 bullet"
	damage = 30

/obj/item/projectile/bullet/c45_cleaning
	name = ".45 bullet"
	damage = 40 //BANG BANG BANG

/obj/item/projectile/bullet/c45_cleaning/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/turf/T = get_turf(target)
	SEND_SIGNAL(T, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
	for(var/A in T)
		if(is_cleanable(A))
			qdel(A)
		else if(isitem(A))
			var/obj/item/cleaned_item = A
			SEND_SIGNAL(cleaned_item, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
			cleaned_item.clean_blood()
			if(ismob(cleaned_item.loc))
				var/mob/M = cleaned_item.loc
				M.regenerate_icons()
		else if(ishuman(A))
			var/mob/living/carbon/human/cleaned_human = A
			if(cleaned_human.lying)
				if(cleaned_human.head)
					SEND_SIGNAL(cleaned_human.head, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
					cleaned_human.head.clean_blood()
					cleaned_human.update_inv_head()
				if(cleaned_human.wear_suit)
					SEND_SIGNAL(cleaned_human.wear_suit, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
					cleaned_human.wear_suit.clean_blood()
					cleaned_human.update_inv_wear_suit()
				else if(cleaned_human.w_uniform)
					SEND_SIGNAL(cleaned_human.w_uniform, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
					cleaned_human.w_uniform.clean_blood()
					cleaned_human.update_inv_w_uniform()
				if(cleaned_human.shoes)
					SEND_SIGNAL(cleaned_human.shoes, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
					cleaned_human.shoes.clean_blood()
					cleaned_human.update_inv_shoes()
				SEND_SIGNAL(cleaned_human, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
				cleaned_human.clean_blood()
				cleaned_human.wash_cream()
				cleaned_human.regenerate_icons()

// 4.6x30mm (Autorifles)

/obj/item/projectile/bullet/c46x30mm
	name = "4.6x30mm bullet"
	damage = 15

/obj/item/projectile/bullet/c46x30mm_ap
	name = "4.6x30mm armor-piercing bullet"
	damage = 12.5
	armour_penetration = 40

/obj/item/projectile/bullet/incendiary/c46x30mm
	name = "4.6x30mm incendiary bullet"
	damage = 7.5
	fire_stacks = 1

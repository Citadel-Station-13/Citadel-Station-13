// .45 (M1911 & C20r)

/obj/item/projectile/bullet/c45
	name = ".45 bullet"
	damage = 20
	stamina = 65

/obj/item/projectile/bullet/c45_nostamina
	name = ".45 bullet"
	damage = 30

/obj/item/projectile/bullet/c45_cleaning
	name = ".45 bullet"
	damage = 24
	stamina = 10

/obj/item/projectile/bullet/c45_cleaning/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/turf/T = get_turf(target)

	//section shamelessly copypasta'd from the clean component
	SEND_SIGNAL(T, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
	for(var/A in T)
		if(is_cleanable(A))
			qdel(A)
		else if(istype(A, /obj/item))
			var/obj/item/I = A
			SEND_SIGNAL(I, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
			if(ismob(I.loc))
				var/mob/M = I.loc
				M.regenerate_icons()
		else if(ishuman(A))
			var/mob/living/carbon/human/cleaned_human = A
			if(cleaned_human.head)
				SEND_SIGNAL(cleaned_human.head, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
			if(cleaned_human.wear_suit)
				SEND_SIGNAL(cleaned_human.wear_suit, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
			else if(cleaned_human.w_uniform)
				SEND_SIGNAL(cleaned_human.w_uniform, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
			if(cleaned_human.shoes)
				SEND_SIGNAL(cleaned_human.shoes, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
			SEND_SIGNAL(cleaned_human, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
			cleaned_human.wash_cream()
			cleaned_human.regenerate_icons()

// 4.6x30mm (Autorifles)

/obj/item/projectile/bullet/c46x30mm
	name = "4.6x30mm bullet"
	damage = 20

/obj/item/projectile/bullet/c46x30mm_ap
	name = "4.6x30mm armor-piercing bullet"
	damage = 15
	armour_penetration = 40

/obj/item/projectile/bullet/incendiary/c46x30mm
	name = "4.6x30mm incendiary bullet"
	damage = 10
	fire_stacks = 1

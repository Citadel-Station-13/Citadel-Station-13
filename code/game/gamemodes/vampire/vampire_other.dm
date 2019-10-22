/*
	In this file:
		various vampire interactions and items
*/


/obj/item/clothing/suit/draculacoat
	name = "Vampire Coat"
	desc = "What is a man? A miserable little pile of secrets."
	alternate_worn_icon = 'icons/mob/suit.dmi'
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "draculacoat"
	item_state = "draculacoat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	armor = list("melee" = 30, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 0, "bio" = 0, "rad" = 0)

/mob/living/carbon/human/handle_fire()
	. = ..()
	if(mind)
		var/datum/antagonist/vampire/L = mind.has_antag_datum(/datum/antagonist/vampire)
		if(on_fire && stat == DEAD && L && !L.get_ability(/datum/vampire_passive/full))
			dust()

/obj/item/storage/book/bible/attack(mob/living/M, mob/living/carbon/human/user, heal_mode = TRUE)
	. = ..()
	if(!(user.mind && user.mind.isholy) && is_vampire(user))
		to_chat(user, "<span class='danger'>[deity_name] channels through \the [src] and sets you ablaze for your blasphemy!</span>")
		user.fire_stacks += 5
		user.IgniteMob()
		user.emote("scream", 1)

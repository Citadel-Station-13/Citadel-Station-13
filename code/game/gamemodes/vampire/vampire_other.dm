/*
	In this file:
		various vampire interactions and items
*/


/obj/item/clothing/suit/dracula/vamp_coat
	name = "vampire Coat"
	desc = "What is a man? A miserable little pile of secrets."
	alternate_worn_icon = 'icons/mob/suit.dmi'
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "draculacoat"
	item_state = "draculacoat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 30, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 0, "bio" = 0, "rad" = 0)
	//todo, give it a hood or something and make it more special.

/obj/item/storage/book/bible/attack(mob/living/M, mob/living/carbon/human/user, heal_mode = TRUE)
	. = ..()
	if(!(user.mind && user.mind.isholy) && is_vampire(user))
		to_chat(user, "<span class='danger'>[deity_name] channels through \the [src] and sets you ablaze for your blasphemy!</span>")
		user.fire_stacks += 5
		user.IgniteMob()
		user.emote("scream", 1)

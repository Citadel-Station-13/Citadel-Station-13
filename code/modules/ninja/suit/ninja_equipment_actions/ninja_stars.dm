/datum/action/item_action/ninjastar
	name = "Create Throwing Stars (1E)"
	desc = "Creates a throwing star in your hand, if possible."
	button_icon_state = "throwingstar"
	icon_icon = 'icons/obj/items_and_weapons.dmi'

/**
 * Proc called to create a ninja star in the ninja's hands.
 *
 * Called to create a ninja star in the wearer's hand.  The ninja
 * star doesn't do much up-front damage, but deals stamina damage
 * as the target moves around, forcing a finish or flee scenario.
 */
/obj/item/clothing/suit/space/space_ninja/proc/ninjastar()
	if(ninjacost(10))
		return
	var/mob/living/carbon/human/ninja = affecting
	var/obj/item/throwing_star/stamina/ninja/ninja_star = new(ninja)
	if(ninja.put_in_hands(ninja_star))
		to_chat(ninja, "<span class='notice'>A throwing star has been created in your hand!</span>")
	else
		qdel(ninja_star)
		to_chat(ninja, "<span class='notice'>You can't create a throwing star, your hands are full!</span>")
	ninja.throw_mode_on() //So they can quickly throw it.

/**
 * # Ninja Throwing Star
 *
 * a throwing star which specifically makes sure you know it came from a real ninja.
 *
 * The most important item in the entire codebase, as without it we would all cease to exist.
 * Inherits everything that makes it interesting the stamina throwing star, but the most
 * important change made is that its name specifically has the prefix, 'ninja' in it.
 * This provides the detective role with information to play off of by ensuring that his
 * assumption that a space ninja is aboard the ship to be true when he find 20 of these in
 * the captain's back.  Along with this, its throwforce is 10 instead of the 5 of the stamina
 * throwing star, meaning it'll do a little more damage than the stamina throwing star does as well.
 * Changes to this item need to be approved by all maintainers, so if you do change it, make sure
 * you go through the proper channels, lest you get permabanned.  Do I make myself clear?
 */
/obj/item/throwing_star/stamina/ninja
	name = "ninja throwing star"
	icon_state = "ninjastar"
	item_state = "ninjastar"
	throwforce = 10
	embedding = list("pain_chance" = 5, "embed_chance" = 100, "fall_chance" = 10, "jostle_chance" = 10, "pain_stam_pct" = 2.5, "jostle_pain_mult" = 3)

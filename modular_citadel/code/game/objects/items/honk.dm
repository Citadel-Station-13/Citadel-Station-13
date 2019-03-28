/obj/item/bikehorn/silver
	name = "silver bike horn"
	desc = "A shiny bike horn handcrafted in the artisan workshops of Mars, with superior kevlar-reinforced rubber bulb attached to a polished plasteel reed horn."
	attack_verb = list("elegantly HONKED")
	icon = 'modular_citadel/icons/obj/honk.dmi'
	icon_state = "silverhorn"

/obj/item/bikehorn/bluespacehonker
	name = "bluespace bike horn"
	desc = "A normal bike horn colored blue and has bluespace dust held in to reed horn allowing for silly honks through space and time, into your in childhood."
	attack_verb = list("HONKED in bluespace", "HONKED", "quantumly HONKED")
	icon = 'modular_citadel/icons/obj/honk.dmi'
	icon_state = "bluespacehonker"

/obj/item/bikehorn/bluespacehonker/attack(mob/living/carbon/M, mob/living/carbon/user)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "bshonk", /datum/mood_event/bshonk)
	return ..()

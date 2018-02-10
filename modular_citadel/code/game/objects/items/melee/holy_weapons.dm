obj/item/nullrod/monkeyidol
	name = "Golden monkey idol"
	desc = "Great authority dwells within this idol"
	icon_state = "Monkeyidol"
	item_state = "Monkeyidol"
	icon = 'modular_citadel/icons/obj/holyweapons.dmi'
	force = 5
	throwforce = 20
	w_class = WEIGHT_CLASS_HUGE
	var/used_blessing = FALSE

/obj/item/nullrod/monkeyidol/attack_self(mob/living/user)
	if(used_blessing)
	else if(user.mind && (user.mind.isholy))
		to_chat(user, "You are blessed by Harambe. Gorillas will no longer attack you.")
		user.faction |= "jungle"
		used_blessing = TRUE
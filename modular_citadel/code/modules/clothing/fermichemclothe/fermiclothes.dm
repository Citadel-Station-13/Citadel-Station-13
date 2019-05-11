//Fermiclothes!
//Clothes made from FermiChem

/obj/item/clothing/head/hattip	//I wonder if anyone else has played cryptworlds
	name = "Sythetic hat"
    con = 'icons/obj/clothing/hats.dmi'
	icon_state = "top_hat"
	desc = "A sythesized hat, you can't seem to take it off. And tips their hat."

/obj/item/clothing/head/hattip/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			M.emote("me",1,"tips their hat.",TRUE)
			return
	return ..()

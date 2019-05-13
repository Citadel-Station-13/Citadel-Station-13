//Fermiclothes!
//Clothes made from FermiChem

/obj/item/clothing/head/hattip	//I wonder if anyone else has played cryptworlds
	name = "Sythetic hat"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "cowboy"
	desc = "A sythesized hat, you can't seem to take it off. And tips their hat."
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	item_flags = NODROP //Tips their hat!

/obj/item/clothing/head/hattip/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			C.emote("me",1,"tips their hat.",TRUE)
			return
	else
		user.emote("me",1,"admires such a spiffy hat.",TRUE)
	return ..()

/obj/item/clothing/head/hattip/speechModification(message)
	if(prob(0.01))
		message += "\" and tips their hat. \"Spy's sappin' my Sentry!"
		return message
	message += "\" and tips their hat. \"[pick("Yeehaw!", "Boy howdy.", "Darn tootin'.", "Well don't that beat all.", "Whoooowee, would ya look at that!", "Whoooowee! Makin' bacon!", "Cream Gravy!", "Yippekeeyah-heeyapeeah-kayoh!", "Move 'em out!", "Giddy up!")]"
	return message

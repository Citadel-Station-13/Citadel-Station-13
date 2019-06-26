//Fermiclothes!
//Clothes made from FermiChem

/obj/item/clothing/head/hattip	//I wonder if anyone else has played cryptworlds
	name = "Sythetic hat"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "cowboy"
	desc = "A sythesized hat, you can't seem to take it off. And tips their hat."
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	//item_flags = NODROP //Tips their hat!

/obj/item/clothing/head/hattip/attack_hand(mob/user)
	if(is_ninja(user))
		to_chat(user, "<span class='notice'>Using your superior ninja reflexes, you take the hat off before tipping.</span>")
		return ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			C.emote("me",1,"tips their hat.",TRUE)
			return
	else
		user.emote("me",1,"admires such a spiffy hat.",TRUE)
	return ..()

/obj/item/clothing/head/hattip/MouseDrop(atom/over_object)
	if(is_ninja(user))
		to_chat(user, "<span class='notice'>Using your superior ninja reflexes, you take the hat off before tipping.</span>")
		return ..()
	//You sure do love tipping your hat.
	if(usr)
		var/mob/living/carbon/C = usr
		if(src == C.head)
			C.emote("me",1,"tips their hat.",TRUE)
			return
	..()

/obj/item/clothing/head/hattip/speechModification(message, /mob/living/carbon/C)
	..()
	var/mob/living/carbon/C = get_wearer()//user
	var/obj/item/organ/tongue/T = C.getorganslot(ORGAN_SLOT_TONGUE)
	if (T.name == "fluffy tongue")
		if(prob(0.01))
			message += "\" and tips their hat. \"swpy's sappin' my chem dispwencer uwu!!"
			return message
		message += "\" and tips their hat. \"[pick("weehaw!", "bwoy howdy.", "dawn tuutin'.", "weww don't that beat aww.", "whoooowee, wouwd ya wook at that!", "whoooowee! makin' bwacon!", "cweam gwavy!", "yippekeeyah-heeyapeeah-kwayoh!", "mwove 'em uut!", "gwiddy up!")]"
		return message
	if(prob(0.01))
		message += "\" and tips their hat. \"Spy's sappin' my chem dispenser!"//How did I not think of this earlier
		message_admins("I really appreciate all the hard work you put into adminning citadel, I hope you're all having a good day and I hope this hidden and rare message admins brightens up your day.")
		return message
	message += "\" and tips their hat. \"[pick("Yeehaw!", "Boy howdy.", "Darn tootin'.", "Well don't that beat all.", "Whoooowee, would ya look at that!", "Whoooowee! Makin' bacon!", "Cream Gravy!", "Yippekeeyah-heeyapeeah-kayoh!", "Move 'em out!", "Giddy up!")]"
	return message


/obj/item/clothing/head/hattip/proc/get_wearer()
	return loc

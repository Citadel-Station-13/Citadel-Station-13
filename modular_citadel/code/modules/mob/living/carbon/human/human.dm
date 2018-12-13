/mob/living/carbon/human/species/mammal
	race = /datum/species/mammal

/mob/living/carbon/human/species/avian
	race = /datum/species/avian

/mob/living/carbon/human/species/aquatic
	race = /datum/species/aquatic

/mob/living/carbon/human/species/insect
	race = /datum/species/insect

/mob/living/carbon/human/species/xeno
	race = /datum/species/xeno

/mob/living/carbon/human/resist()
	. = ..()
	if(wear_suit && wear_suit.breakouttime)//added in human cuff breakout proc
		return
	if(.)
		if(canmove && !on_fire)
			for(var/obj/item/bodypart/L in bodyparts)
				if(istype(L) && L.embedded_objects.len)
					for(var/obj/item/I in L.embedded_objects)
						if(istype(I) && I.w_class >= WEIGHT_CLASS_NORMAL)	//minimum weight class to insta-ripout via resist
							remove_embedded_unsafe(L, I, src, 1.5)	//forcefully call the remove embedded unsafe proc but with extra pain multiplier. if you want to remove it less painfully, examine and remove it carefully.
							return FALSE //Hands are occupied
	return

/mob/living/carbon/human/proc/remove_embedded_unsafe(obj/item/bodypart/L, obj/item/I, mob/user, painmul = 1)
	if(!I || !L || I.loc != src || !(I in L.embedded_objects))
		return
	L.embedded_objects -= I
	L.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class*painmul)//It hurts to rip it out, get surgery you dingus. And if you're ripping it out quickly via resist, it's gonna hurt even more
	I.forceMove(get_turf(src))
	user.put_in_hands(I)
	user.emote("scream")
	user.visible_message("[user] rips [I] out of [user.p_their()] [L.name]!","<span class='notice'>You remove [I] from your [L.name].</span>")
	if(!has_embedded_objects())
		clear_alert("embeddedobject")
		SEND_SIGNAL(user, COMSIG_CLEAR_MOOD_EVENT, "embedded")
	return

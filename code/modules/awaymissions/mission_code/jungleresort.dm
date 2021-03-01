// welcome to the jungle, we got fun and games

//areas

/area/awaymission/jungleresort
	name = "Jungle Resort"
	icon_state = "awaycontent30"

//objects

/obj/item/paper/crumpled/awaymissions/jungleresort/notice
	name = "Resort Notice"
	info = "Due to unforeseen circumstances and the disappearance of several resort employees and visitors, the resort shall be closed to the public until further notice. - <i>Resort Manager Joe Lawrence</i.>"

/obj/item/melee/chainofcommand/jungle
	name = "treasure hunter's whip"
	desc = "The tool of a fallen treasure hunter, old and outdated, it still stings like hell to be hit by."
	hitsound = 'sound/weapons/whip.ogg'
	icon_state = "whip"

/obj/item/clothing/suit/hooded/wintercoat/captain/jungle
	armor = list("melee" = 5, "bullet" = 5, "laser" = 5, "energy" = 0, "bomb" = 0, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/rice_hat/cursed // this was a stupid idea lmao
	name = "cursed rice hat"
	desc = "Welcome to the rice fields, motherfucker. This particular one seems to give you second thoughts about wearing it."

/obj/item/clothing/head/rice_hat/cursed/equipped(mob/M, slot)
    . = ..()
    if (slot == SLOT_HEAD)
        RegisterSignal(M, COMSIG_MOB_SAY, .proc/handle_speech)
    else
        UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/rice_hat/cursed/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, SHAMEBRERO_TRAIT)

/obj/item/clothing/head/rice_hat/cursed/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		var/list/temp_message = splittext(message, " ")
		var/list/pick_list = list()
		for(var/i in 1 to temp_message.len)
			pick_list += i
		for(var/i in 1 to abs(temp_message.len/3))
			var/H = pick(pick_list)
			if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":"))
				continue
			temp_message[H] = ninjaspeak(temp_message[H])
			pick_list -= H
		message = temp_message.Join(" ")

		//The Alternate speech mod is now the main one.
		message = replacetext(message, "l", "r")
		message = replacetext(message, "rr", "ru")
		message = replacetext(message, "v", "b")
		message = replacetext(message, "f", "hu")
		message = replacetext(message, "'t", "")
		message = replacetext(message, "t ", "to ")
		message = replacetext(message, " I ", " ai ")
		message = replacetext(message, "th", "z")
		message = replacetext(message, "is", "izu")
		message = replacetext(message, "ziz", "zis")
		message = replacetext(message, "se", "su")
		message = replacetext(message, "br", "bur")
		message = replacetext(message, "ry", "ri")
		message = replacetext(message, "you", "yuu")
		message = replacetext(message, "ck", "cku")
		message = replacetext(message, "eu", "uu")
		message = replacetext(message, "ow", "au")
		message = replacetext(message, "are", "aa")
		message = replacetext(message, "ay", "ayu")
		message = replacetext(message, "ea", "ii")
		message = replacetext(message, "ch", "chi")
		message = replacetext(message, "than", "sen")
		message = replacetext(message, ".", "")
		message = lowertext(message)
		speech_args[SPEECH_MESSAGE] = message

//turfs

/turf/open/water/jungle
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/turf/open/floor/plating/dirt/jungle
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/turf/open/floor/plating/dirt/dark/jungle
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/turf/closed/mineral/random/labormineral/jungle
	baseturfs = /turf/open/floor/plating/asteroid
	turf_type = /turf/open/floor/plating/asteroid

//mobs

/mob/living/carbon/monkey/punpun/curiousgorge
	name = "Curious Gorge"
	pet_monkey_names = list("Curious Gorge", "Jungle Gorge", "Jungah Joe", "Mr. Monke")
	rare_pet_monkey_names = list("Sun Mukong", "Monkey Kong")

/mob/living/simple_animal/hostile/jungle/leaper/boss
	health = 550
	name = "Froggerosa"

/mob/living/simple_animal/hostile/gorilla/jungle
	tame = 1
	faction = list("neutral")

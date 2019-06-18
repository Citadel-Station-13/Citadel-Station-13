
/*

Contents:
- The Ninja Space Mask
- Ninja Space Mask speech modification

*/




/obj/item/clothing/mask/gas/space_ninja
	name = "ninja mask"
	desc = "A close-fitting mask that acts both as an air filter and a post-modern fashion statement."
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	strip_delay = 120
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/mask/gas/space_ninja/speechModification(message)
	if(copytext(message, 1, 2) != "*")
		var/list/temp_message = text2list(message, " ")
		var/list/pick_list = list()
		for(var/i = 1, i <= temp_message.len, i++)
			pick_list += i
		for(var/i=1, i <= abs(temp_message.len/3), i++)
			var/H = pick(pick_list)
			if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
			temp_message[H] = ninjaspeak(temp_message[H])
			pick_list -= H
		message = list2text(temp_message, " ")

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

	return message

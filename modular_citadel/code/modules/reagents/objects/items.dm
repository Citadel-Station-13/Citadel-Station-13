/obj/item/pHbooklet
    name = "pH indicator booklet"
    desc = "A booklet containing paper soaked in universal indicator."
    icon_state = "pHbooklet"
    icon = 'modular_citadel/icons/obj/FermiChem.dmi'
    item_flags = NOBLUDGEON
    var/numberOfPages = 50
    //set flammable somehow

/obj/item/pHbooklet/attack_hand(mob/user)
	..()
	if(user.get_held_index_of_item(src))
		if(numberOfPages >= 1)
			var/obj/item/pHpaper/P = new /obj/item/pHpaper
			P.add_fingerprint(user)
			P.forceMove(user.loc)
			user.put_in_active_hand(P)
			to_chat(user, "<span class='notice'>You take [P] out of \the [src].</span>")
			numberOfPages--
			playsound(user.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			add_fingerprint(user)
			return
		else
			to_chat(user, "<span class='warning'>[src] is empty!</span>")
			add_fingerprint(user)
			return
	var/I = user.get_active_held_item()
	if(!I)
		user.put_in_active_hand(src)
	return

/obj/item/pHpaper
    name = "pH indicator strip"
    desc = "A piece of paper that will change colour depending on the pH of a solution."
    icon_state = "pHpaper"
    icon = 'modular_citadel/icons/obj/FermiChem.dmi'
    //item_flags = NOBLUDGEON
    color = "#f5c352"
    var/used = FALSE
    //set flammable somehow

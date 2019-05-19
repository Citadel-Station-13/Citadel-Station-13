/obj/item/pHbooklet
    name = "pH indicator booklet"
    desc = "A booklet containing paper soaked in universal indicator."
    icon_state = "pHbooklet"
    icon = 'modular_citadel/icons/obj/FermiChem.dmi'
    item_flags = NOBLUDGEON
    var/numberOfPages = 50
    resistance_flags = FLAMMABLE
    w_class = WEIGHT_CLASS_TINY
    //set flammable somehow

/obj/item/pHbooklet/attack_hand(mob/user)
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
    ..()
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
    resistance_flags = FLAMMABLE
    w_class = WEIGHT_CLASS_TINY
    //set flammable somehow

/obj/item/pHpaper/afterattack(obj/item/reagent_containers/cont, mob/user, proximity)
    if(!istype(cont))
        return
    if(used == TRUE)
        to_chat(user, "<span class='warning'>[user] has already been used!</span>")
        return
    switch(cont.reagents.pH)
        if(13.5 to INFINITY)
            color = "#462c83"
        if(12.5 to 13.5)
            color = "#63459b"
        if(11.5 to 12.5)
            color = "#5a51a2"
        if(10.5 to 11.5)
            color = "#3853a4"
        if(9.5 to 10.5)
            color = "#3f93cf"
        if(8.5 to 9.5)
            color = "#0bb9b7"
        if(7.5 to 8.5)
            color = "#23b36e"
        if(6.5 to 7.5)
            color = "#3aa651"
        if(5.5 to 6.5)
            color = "#4cb849"
        if(4.5 to 5.5)
            color = "#b5d335"
        if(3.5 to 4.5)
            color = "#b5d333"
        if(2.5 to 3.5)
            color = "#f7ec1e"
        if(1.5 to 2.5)
            color = "#fbc314"
        if(0.5 to 1.5)
            color = "#f26724"
        if(-INFINITY to 0.5)
            color = "#ef1d26"
        description += " The paper looks to be around [round(glass.reagents.pH)]"
    used = TRUE

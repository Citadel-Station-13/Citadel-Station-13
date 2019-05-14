/obj/item/pHbooklet
    name = "pH indicator booklet"
    desc = "A piece of paper that will change colour depending on the pH of what it's added to."
    icon_state = "pHbooklet"
    icon = 'modular_citadel/icons/obj/FermiChem.dmi'
    item_flags = NOBLUDGEON
    var/numberOfPages = 100

/obj/item/pHbooklet/attack_hand(mob/user)
	if(numberOfPages >= 1)
		var/obj/item/pHpaper/P = new /obj/item/pHpaper
		//P.add_fingerprint(user)
		P.forceMove(user.loc)
		user.put_in_hands(P)
		to_chat(user, "<span class='notice'>You take [P] out of \the [src].</span>")
		numberOfPages--
	else
		to_chat(user, "<span class='warning'>[src] is empty!</span>")
	add_fingerprint(user)
	return ..()

/obj/item/pHpaper
    name = "pH indicator strip"
    desc = "A piece of paper that will change colour depending on the pH of a solution."
    icon_state = "pHpaper"
    icon = 'modular_citadel/icons/obj/FermiChem.dmi'
    item_flags = NOBLUDGEON
    color = "#f5c352"
    var/used = FALSE

/obj/item/pHpaper/attack_hand(mob/user, obj/I)
	if(!I.reagents.pH)
		return
	if(used == TRUE)
		to_chat(user, "<span class='warning'>[src] has already been used!</span>")
		return
	switch(I.reagents.pH)
		if(14 to INFINITY)
			src.color = "#462c83"
		if(13 to 14)
			src.color = "#63459b"
		if(12 to 13)
			src.color = "#5a51a2"
		if(11 to 12)
			src.color = "#3853a4"
		if(10 to 11)
			src.color = "#3f93cf"
		if(9 to 10)
			src.color = "#0bb9b7"
		if(8 to 9)
			src.color = "#23b36e"
		if(7 to 8)
			src.color = "#3aa651"
		if(6 to 7)
			src.color = "#4cb849"
		if(5 to 6)
			src.color = "#b5d335"
		if(4 to 5)
			src.color = "#b5d333"
		if(3 to 4)
			src.color = "#f7ec1e"
		if(2 to 3)
			src.color = "#fbc314"
		if(1 to 2)
			src.color = "#f26724"
		if(0 to 1)
			src.color = "#ef1d26"

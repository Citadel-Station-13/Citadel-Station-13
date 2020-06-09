/obj/structure/dresser
	name = "dresser"
	desc = "A nicely-crafted wooden dresser. It's filled with lots of undies."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "dresser"
	var/list/associated_users = list()
	var/max_uses_per_user = 3
	density = TRUE
	anchored = TRUE

/obj/structure/dresser/examine(mob/user)
	. = ..()
	if(associated_users[user])
		. += "<span class='notice'>You've used \the [src] <b>[associated_users[user]]</b> times, out of a maximum of <b>[max_uses_per_user]</b> uses.</span>"
	else
		. += "<span class='notice'>You have yet to use \the [src].</span>"

/obj/structure/dresser/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/wrench))
		to_chat(user, "<span class='notice'>You begin to [anchored ? "unwrench" : "wrench"] [src].</span>")
		if(I.use_tool(src, user, 20, volume=50))
			to_chat(user, "<span class='notice'>You successfully [anchored ? "unwrench" : "wrench"] [src].</span>")
			setAnchored(!anchored)
	else
		return ..()

/obj/structure/dresser/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)
	qdel(src)

/obj/structure/dresser/attack_hand(mob/user)
	. = ..()
	var/mob/living/H = user

	var/list/undergarment_choices = list("Underwear", "Shirt or bra", "Socks", "Color")

	var/choice = input(H, "Color, Underwear, Shirt or bra, or Socks?", "Changing") as null|anything in undergarment_choices
	if(!H.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(!associated_users[user] || (associated_users[user] < max_uses_per_user))
		switch(choice)
			if("Underwear")
				var/choose = input(H, "Select your underwear", "Changing") as null|anything in GLOB.underwear_list
				if(choose)
					var/temp = GLOB.underwear_list[choose]
					var/obj/item/clothing/underwear/U = new temp(get_turf(src))
					if(U.has_colors)
						choose = input(H, "Do you want to color the [U]?", "Changing") as null|anything in list("Yes", "No")
						if(choose == "Yes")
							choose = input(H, "Choose the new color for the [U]", "Changing") as color
							U.overlay_color = choose ? choose : initial(U.overlay_color)
							U.update_icon()
					if(!associated_users[user])
						associated_users[user] = 1
					else
						associated_users[user]++
			if("Undershirt")
				var/choose = input(H, "Select your shirt", "Changing") as null|anything in GLOB.undershirt_list
				if(choose)
					var/temp = GLOB.undershirt_list[choose]
					var/obj/item/clothing/underwear/U = new temp(get_turf(src))
					if(U.has_colors)
						choose = input(H, "Do you want to color the [U]?", "Changing") as null|anything in list("Yes", "No")
						if(choose == "Yes")
							choose = input(H, "Choose the new color for the [U]", "Changing") as color
							U.overlay_color = choose ? choose : initial(U.overlay_color)
							U.update_icon()
					if(!associated_users[user])
						associated_users[user] = 1
					else
						associated_users[user]++
			if("Socks")
				var/choose = input(H, "Select your underwear", "Changing") as null|anything in GLOB.underwear_list
				if(choose)
					var/temp = GLOB.underwear_list[choose]
					var/obj/item/clothing/underwear/U = new temp(get_turf(src))
					if(U.has_colors)
						choose = input(H, "Do you want to color the [U]?", "Changing") as null|anything in list("Yes", "No")
						if(choose == "Yes")
							choose = input(H, "Choose the new color for the [U]", "Changing") as color
							U.overlay_color = choose ? choose : initial(U.overlay_color)
							U.update_icon()
					if(!associated_users[user])
						associated_users[user] = 1
					else
						associated_users[user]++
			if("Color")
				var/list/possible = list()
				for(var/obj/item/clothing/underwear/U in user)
					possible[U.name] = U
				var/choose = input(H, "Select the undergarments you want to color", "Changing") as null|anything in possible
				if(choose)
					var/obj/item/clothing/underwear/U = possible[choose]
					if(U && istype(U) && U.has_colors)
						choose = input(H, "Reset [U]'s color?", "Changing") as null|anything in list("Yes", "No")
						if(choose == "Yes")
							U.overlay_color = initial(U.overlay_color)
							U.update_icon()
						else
							choose = input(H, "Choose the new color for the [U]", "Changing") as color
							U.overlay_color = choose ? choose : initial(U.overlay_color)
							U.update_icon()
						if(!associated_users[user])
							associated_users[user] = 1
						else
							associated_users[user]++
	else
		to_chat(user, "<span class='warning'>You've already used the [src] [max_uses_per_user] or more times!</span>")

	add_fingerprint(H)
	H.update_body(TRUE)

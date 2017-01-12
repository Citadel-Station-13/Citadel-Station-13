
/**********************Ore box**************************/

/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox"
	name = "ore box"
	desc = "A heavy wooden box, which can be filled with a lot of ores."
	density = 1
	pressure_resistance = 5*ONE_ATMOSPHERE

/obj/structure/ore_box/attackby(obj/item/weapon/W, mob/user, params)
	if (istype(W, /obj/item/weapon/ore))
		if(!user.drop_item())
			return
		W.loc = src
	else if (istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		for(var/obj/item/weapon/ore/O in S.contents)
			S.remove_from_storage(O, src) //This will move the item to this item's contents
		user << "<span class='notice'>You empty the ore in [S] into \the [src].</span>"
	else if(istype(W, /obj/item/weapon/crowbar))
		playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		var/obj/item/weapon/crowbar/C = W
		var/time = 50
		if(do_after(user, time/C.toolspeed, target = src))
			user.visible_message("[user] pries \the [src] apart.", "<span class='notice'>You pry apart \the [src].</span>", "<span class='italics'>You hear splitting wood.</span>")
			// If you change the amount of wood returned, remember
			// to change the construction costs
			var/obj/item/stack/sheet/mineral/wood/wo = new (loc, 4)
			wo.add_fingerprint(user)
			deconstruct()
	else
		return ..()

/obj/structure/ore_box/attack_hand(mob/user)
	if(Adjacent(user))
		show_contents(user)

/obj/structure/ore_box/attack_robot(mob/user)
	if(Adjacent(user))
		show_contents(user)

/obj/structure/ore_box/proc/show_contents(mob/user)
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_diamond = 0
	var/amt_glass = 0
	var/amt_iron = 0
	var/amt_plasma = 0
	var/amt_uranium = 0
	var/amt_clown = 0
	var/amt_bluespace = 0

	for (var/obj/item/weapon/ore/C in contents)
		if (istype(C,/obj/item/weapon/ore/diamond))
			amt_diamond++;
		if (istype(C,/obj/item/weapon/ore/glass))
			amt_glass++;
		if (istype(C,/obj/item/weapon/ore/plasma))
			amt_plasma++;
		if (istype(C,/obj/item/weapon/ore/iron))
			amt_iron++;
		if (istype(C,/obj/item/weapon/ore/silver))
			amt_silver++;
		if (istype(C,/obj/item/weapon/ore/gold))
			amt_gold++;
		if (istype(C,/obj/item/weapon/ore/uranium))
			amt_uranium++;
		if (istype(C,/obj/item/weapon/ore/bananium))
			amt_clown++;
		if (istype(C,/obj/item/weapon/ore/bluespace_crystal))
			amt_bluespace++

	var/dat = text("<b>The contents of the ore box reveal...</b><br>")
	if (amt_gold)
		dat += text("Gold ore: [amt_gold]<br>")
	if (amt_silver)
		dat += text("Silver ore: [amt_silver]<br>")
	if (amt_iron)
		dat += text("Metal ore: [amt_iron]<br>")
	if (amt_glass)
		dat += text("Sand: [amt_glass]<br>")
	if (amt_diamond)
		dat += text("Diamond ore: [amt_diamond]<br>")
	if (amt_plasma)
		dat += text("Plasma ore: [amt_plasma]<br>")
	if (amt_uranium)
		dat += text("Uranium ore: [amt_uranium]<br>")
	if (amt_clown)
		dat += text("Bananium ore: [amt_clown]<br>")
	if (amt_bluespace)
		dat += text("Bluespace crystals: [amt_bluespace]<br>")

	dat += text("<br><br><A href='?src=\ref[src];removeall=1'>Empty box</A>")
	user << browse("[dat]", "window=orebox")
	return

/obj/structure/ore_box/proc/dump_contents()
	for (var/obj/item/weapon/ore/O in contents)
		contents -= O
		O.loc = src.loc

/obj/structure/ore_box/Topic(href, href_list)
	if(..())
		return
	if(!Adjacent(usr))
		return

	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["removeall"])
		dump_contents()
		usr << "<span class='notice'>You empty the box.</span>"
	src.updateUsrDialog()
	return

/obj/structure/ore_box/ex_act(severity, target)
	if(prob(100 / severity) && severity < 3)
		qdel(src) //nothing but ores can get inside unless its a bug and ores just return nothing on ex_act, not point in calling it on them

/obj/structure/ore_box/Destroy()
	dump_contents()
	return ..()


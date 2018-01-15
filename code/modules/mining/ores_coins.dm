
#define GIBTONITE_QUALITY_HIGH 3
#define GIBTONITE_QUALITY_MEDIUM 2
#define GIBTONITE_QUALITY_LOW 1

/**********************Mineral ores**************************/

/obj/item/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore"
	var/points = 0 //How many points this ore gets you from the ore redemption machine
	var/refined_type = null //What this ore defaults to being refined into

/obj/item/ore/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(15) && refined_type)
			new refined_type(get_turf(src.loc))
			qdel(src)
		else if(W.isOn())
			to_chat(user, "<span class='info'>Not enough fuel to smelt [src].</span>")
	..()

/obj/item/ore/Crossed(atom/movable/AM)
	set waitfor = FALSE
	var/show_message = TRUE
	for(var/obj/item/ore/O in loc)
		if(O != src)
			show_message = FALSE
			break
	var/obj/item/storage/bag/ore/OB
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		OB = locate(/obj/item/storage/bag/ore) in H.get_storage_slots()
		if(!OB)
			OB = locate(/obj/item/storage/bag/ore) in H.held_items
	else if(iscyborg(AM))
		var/mob/living/silicon/robot/R = AM
		OB = locate(/obj/item/storage/bag/ore) in R.held_items
	if(OB)
		var/obj/structure/ore_box/box
		if(!OB.can_be_inserted(src, TRUE, AM))
			if(!OB.spam_protection)
				to_chat(AM, "<span class='warning'>Your [OB.name] is full and can't hold any more ore!</span>")
				OB.spam_protection = TRUE
				sleep(1)
				OB.spam_protection = FALSE
		else
			OB.handle_item_insertion(src, TRUE, AM)
		// Then, if the user is dragging an ore box, empty the satchel
		// into the box.
		var/mob/living/L = AM
		if(istype(L.pulling, /obj/structure/ore_box))
			box = L.pulling
			for(var/obj/item/ore/O in OB)
				OB.remove_from_storage(src, box)
		if(show_message)
			playsound(L, "rustle", 50, TRUE)
			if(box)
				L.visible_message("<span class='notice'>[L] offloads the ores into [box].</span>", \
				"<span class='notice'>You offload the ores beneath you into your [box.name].</span>")
			else
				L.visible_message("<span class='notice'>[L] scoops up the ores beneath them.</span>", \
				"<span class='notice'>You scoop up the ores beneath you with your [OB.name].</span>")
	return ..()

/obj/item/ore/uranium
	name = "uranium ore"
	icon_state = "Uranium ore"
	points = 30
	materials = list(MAT_URANIUM=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/uranium

/obj/item/ore/iron
	name = "iron ore"
	icon_state = "Iron ore"
	points = 1
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/metal

/obj/item/ore/glass
	name = "sand pile"
	icon_state = "Glass ore"
	points = 1
	materials = list(MAT_GLASS=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/glass
	w_class = WEIGHT_CLASS_TINY

/obj/item/ore/glass/attack_self(mob/living/user)
	to_chat(user, "<span class='notice'>You use the sand to make sandstone.</span>")
	var/sandAmt = 1
	for(var/obj/item/ore/glass/G in user.loc) // The sand on the floor
		sandAmt += 1
		qdel(G)
	while(sandAmt > 0)
		var/obj/item/stack/sheet/mineral/sandstone/SS = new /obj/item/stack/sheet/mineral/sandstone(user.loc)
		if(sandAmt >= SS.max_amount)
			SS.amount = SS.max_amount
		else
			SS.amount = sandAmt
			for(var/obj/item/stack/sheet/mineral/sandstone/SA in user.loc)
				if(SA != SS && SA.amount < SA.max_amount)
					SA.attackby(SS, user) //we try to transfer all old unfinished stacks to the new stack we created.
		sandAmt -= SS.max_amount
	qdel(src)
	return

/obj/item/ore/glass/throw_impact(atom/hit_atom)
	if(..() || !ishuman(hit_atom))
		return
	var/mob/living/carbon/human/C = hit_atom
	if(C.head && C.head.flags_cover & HEADCOVERSEYES)
		visible_message("<span class='danger'>[C]'s headgear blocks the sand!</span>")
		return
	if(C.wear_mask && C.wear_mask.flags_cover & MASKCOVERSEYES)
		visible_message("<span class='danger'>[C]'s mask blocks the sand!</span>")
		return
	if(C.glasses && C.glasses.flags_cover & GLASSESCOVERSEYES)
		visible_message("<span class='danger'>[C]'s glasses block the sand!</span>")
		return
	C.adjust_blurriness(6)
	C.adjustStaminaLoss(15)//the pain from your eyes burning does stamina damage
	C.confused += 5
	to_chat(C, "<span class='userdanger'>\The [src] gets into your eyes! The pain, it burns!</span>")
	qdel(src)

/obj/item/ore/glass/basalt
	name = "volcanic ash"
	icon_state = "volcanic_sand"

/obj/item/ore/plasma
	name = "plasma ore"
	icon_state = "Plasma ore"
	points = 15
	materials = list(MAT_PLASMA=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/plasma

/obj/item/ore/plasma/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I
		if(W.welding)
			to_chat(user, "<span class='warning'>You can't hit a high enough temperature to smelt [src] properly!</span>")
	else
		..()


/obj/item/ore/silver
	name = "silver ore"
	icon_state = "Silver ore"
	points = 16
	materials = list(MAT_SILVER=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/silver

/obj/item/ore/gold
	name = "gold ore"
	icon_state = "Gold ore"
	points = 18
	materials = list(MAT_GOLD=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/gold

/obj/item/ore/diamond
	name = "diamond ore"
	icon_state = "Diamond ore"
	points = 50
	materials = list(MAT_DIAMOND=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/diamond

/obj/item/ore/bananium
	name = "bananium ore"
	icon_state = "Clown ore"
	points = 60
	materials = list(MAT_BANANIUM=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/bananium

/obj/item/ore/titanium
	name = "titanium ore"
	icon_state = "Titanium ore"
	points = 50
	materials = list(MAT_TITANIUM=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/titanium

/obj/item/ore/slag
	name = "slag"
	desc = "Completely useless."
	icon_state = "slag"

/obj/item/twohanded/required/gibtonite
	name = "gibtonite ore"
	desc = "Extremely explosive if struck with mining equipment, Gibtonite is often used by miners to speed up their work by using it as a mining charge. This material is illegal to possess by unauthorized personnel under space law."
	icon = 'icons/obj/mining.dmi'
	icon_state = "Gibtonite ore"
	item_state = "Gibtonite ore"
	w_class = WEIGHT_CLASS_BULKY
	throw_range = 0
	var/primed = FALSE
	var/det_time = 100
	var/quality = GIBTONITE_QUALITY_LOW //How pure this gibtonite is, determines the explosion produced by it and is derived from the det_time of the rock wall it was taken from, higher value = better
	var/attacher = "UNKNOWN"
	var/det_timer

/obj/item/twohanded/required/gibtonite/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/item/twohanded/required/gibtonite/attackby(obj/item/I, mob/user, params)
	if(!wires && istype(I, /obj/item/device/assembly/igniter))
		user.visible_message("[user] attaches [I] to [src].", "<span class='notice'>You attach [I] to [src].</span>")
		wires = new /datum/wires/explosive/gibtonite(src)
		attacher = key_name(user)
		qdel(I)
		add_overlay("Gibtonite_igniter")
		return

	if(wires && !primed)
		if(is_wire_tool(I))
			wires.interact(user)
			return

	if(istype(I, /obj/item/pickaxe) || istype(I, /obj/item/resonator) || I.force >= 10)
		GibtoniteReaction(user)
		return
	if(primed)
		if(istype(I, /obj/item/device/mining_scanner) || istype(I, /obj/item/device/t_scanner/adv_mining_scanner) || istype(I, /obj/item/device/multitool))
			primed = FALSE
			if(det_timer)
				deltimer(det_timer)
			user.visible_message("The chain reaction was stopped! ...The ore's quality looks diminished.", "<span class='notice'>You stopped the chain reaction. ...The ore's quality looks diminished.</span>")
			icon_state = "Gibtonite ore"
			quality = GIBTONITE_QUALITY_LOW
			return
	..()

/obj/item/twohanded/required/gibtonite/attack_self(user)
	if(wires)
		wires.interact(user)
	else
		..()

/obj/item/twohanded/required/gibtonite/bullet_act(obj/item/projectile/P)
	GibtoniteReaction(P.firer)
	..()

/obj/item/twohanded/required/gibtonite/ex_act()
	GibtoniteReaction(null, 1)



/obj/item/twohanded/required/gibtonite/proc/GibtoniteReaction(mob/user, triggered_by = 0)
	if(!primed)
		primed = TRUE
		playsound(src,'sound/effects/hit_on_shattered_glass.ogg',50,1)
		icon_state = "Gibtonite active"
		var/turf/bombturf = get_turf(src)
		var/area/A = get_area(bombturf)
		var/notify_admins = 0
		if(z != 5)//Only annoy the admins ingame if we're triggered off the mining zlevel
			notify_admins = 1

		if(notify_admins)
			if(triggered_by == 1)
				message_admins("An explosion has triggered a [name] to detonate at [ADMIN_COORDJMP(bombturf)].")
			else if(triggered_by == 2)
				message_admins("A signal has triggered a [name] to detonate at [ADMIN_COORDJMP(bombturf)]. Igniter attacher: [ADMIN_LOOKUPFLW(attacher)]")
			else
				message_admins("[ADMIN_LOOKUPFLW(attacher)] has triggered a [name] to detonate at [ADMIN_COORDJMP(bombturf)].")
		if(triggered_by == 1)
			log_game("An explosion has primed a [name] for detonation at [A][COORD(bombturf)]")
		else if(triggered_by == 2)
			log_game("A signal has primed a [name] for detonation at [A][COORD(bombturf)]. Igniter attacher: [key_name(attacher)].")
		else
			user.visible_message("<span class='warning'>[user] strikes \the [src], causing a chain reaction!</span>", "<span class='danger'>You strike \the [src], causing a chain reaction.</span>")
			log_game("[key_name(user)] has primed a [name] for detonation at [A][COORD(bombturf)]")
		det_timer = addtimer(CALLBACK(src, .proc/detonate, notify_admins), det_time, TIMER_STOPPABLE)

/obj/item/twohanded/required/gibtonite/proc/detonate(notify_admins)
	if(primed)
		switch(quality)
			if(GIBTONITE_QUALITY_HIGH)
				explosion(src,2,4,9,adminlog = notify_admins)
			if(GIBTONITE_QUALITY_MEDIUM)
				explosion(src,1,2,5,adminlog = notify_admins)
			if(GIBTONITE_QUALITY_LOW)
				explosion(src,0,1,3,adminlog = notify_admins)
		qdel(src)

/obj/item/ore/Initialize()
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/ore/ex_act()
	return

/*****************************Coin********************************/

// The coin's value is a value of it's materials.
// Yes, the gold standard makes a come-back!
// This is the only way to make coins that are possible to produce on station actually worth anything.
/obj/item/coin
	icon = 'icons/obj/economy.dmi'
	name = "coin"
	icon_state = "coin__heads"
	flags_1 = CONDUCT_1
	force = 1
	throwforce = 2
	w_class = WEIGHT_CLASS_TINY
	var/string_attached
	var/list/sideslist = list("heads","tails")
	var/cmineral = null
	var/cooldown = 0
	var/value = 1

/obj/item/coin/Initialize()
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/coin/examine(mob/user)
	..()
	if(value)
		to_chat(user, "<span class='info'>It's worth [value] credit\s.</span>")

/obj/item/coin/gold
	name = "gold coin"
	cmineral = "gold"
	icon_state = "coin_gold_heads"
	value = 50
	materials = list(MAT_GOLD = MINERAL_MATERIAL_AMOUNT*0.2)

/obj/item/coin/silver
	name = "silver coin"
	cmineral = "silver"
	icon_state = "coin_silver_heads"
	value = 20
	materials = list(MAT_SILVER = MINERAL_MATERIAL_AMOUNT*0.2)

/obj/item/coin/diamond
	name = "diamond coin"
	cmineral = "diamond"
	icon_state = "coin_diamond_heads"
	value = 500
	materials = list(MAT_DIAMOND = MINERAL_MATERIAL_AMOUNT*0.2)

/obj/item/coin/iron
	name = "iron coin"
	cmineral = "iron"
	icon_state = "coin_iron_heads"
	value = 1
	materials = list(MAT_METAL = MINERAL_MATERIAL_AMOUNT*0.2)

/obj/item/coin/plasma
	name = "plasma coin"
	cmineral = "plasma"
	icon_state = "coin_plasma_heads"
	value = 100
	materials = list(MAT_PLASMA = MINERAL_MATERIAL_AMOUNT*0.2)

/obj/item/coin/uranium
	name = "uranium coin"
	cmineral = "uranium"
	icon_state = "coin_uranium_heads"
	value = 80
	materials = list(MAT_URANIUM = MINERAL_MATERIAL_AMOUNT*0.2)

/obj/item/coin/clown
	name = "bananium coin"
	cmineral = "bananium"
	icon_state = "coin_bananium_heads"
	value = 1000 //makes the clown cry
	materials = list(MAT_BANANIUM = MINERAL_MATERIAL_AMOUNT*0.2)

/obj/item/coin/adamantine
	name = "adamantine coin"
	cmineral = "adamantine"
	icon_state = "coin_adamantine_heads"
	value = 1500

/obj/item/coin/mythril
	name = "mythril coin"
	cmineral = "mythril"
	icon_state = "coin_mythril_heads"
	value = 3000

/obj/item/coin/twoheaded
	cmineral = "iron"
	icon_state = "coin_iron_heads"
	desc = "Hey, this coin's the same on both sides!"
	sideslist = list("heads")
	materials = list(MAT_METAL = MINERAL_MATERIAL_AMOUNT*0.2)
	value = 1

/obj/item/coin/antagtoken
	name = "antag token"
	icon_state = "coin_valid_valid"
	cmineral = "valid"
	desc = "A novelty coin that helps the heart know what hard evidence cannot prove."
	sideslist = list("valid", "salad")
	value = 0

/obj/item/coin/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, "<span class='warning'>There already is a string attached to this coin!</span>")
			return

		if (CC.use(1))
			add_overlay("coin_string_overlay")
			string_attached = 1
			to_chat(user, "<span class='notice'>You attach a string to the coin.</span>")
		else
			to_chat(user, "<span class='warning'>You need one length of cable to attach a string to the coin!</span>")
			return

	else if(istype(W, /obj/item/wirecutters))
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.update_icon()
		overlays = list()
		string_attached = null
		to_chat(user, "<span class='notice'>You detach the string from the coin.</span>")
	else
		..()

/obj/item/coin/attack_self(mob/user)
	if(cooldown < world.time)
		if(string_attached) //does the coin have a wire attached
			to_chat(user, "<span class='warning'>The coin won't flip very well with something attached!</span>" )
			return //do not flip the coin
		var/coinflip = pick(sideslist)
		cooldown = world.time + 15
		flick("coin_[cmineral]_flip", src)
		icon_state = "coin_[cmineral]_[coinflip]"
		playsound(user.loc, 'sound/items/coinflip.ogg', 50, 1)
		var/oldloc = loc
		sleep(15)
		if(loc == oldloc && user && !user.incapacitated())
			user.visible_message("[user] has flipped [src]. It lands on [coinflip].", \
 							 "<span class='notice'>You flip [src]. It lands on [coinflip].</span>", \
							 "<span class='italics'>You hear the clattering of loose change.</span>")

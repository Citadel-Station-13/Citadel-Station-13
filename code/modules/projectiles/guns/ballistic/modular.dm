
/obj/item/gun/ballistic/automatic/modular //The base modular weapon. The name, desc, stats are all modified when a part is changed or on initialize.
	name = "debug modular gun"
	desc = "You shouldn't see this description. It's a bug. Please report it."
	icon_state = "saber"
	w_class = WEIGHT_CLASS_NORMAL
	can_suppress = FALSE
	can_bayonet = FALSE
	burst_size = 1
	fire_delay = 1
	actions_types = list(/datum/action/item_action/toggle_firemode)
	pin = null
	spread = 0
	basespread = 0
	burstspread = 0
	var/failchance = 0
	//All modular gunparts affect reliability if so desired. Intended for Science/improvised weapons.
	receiever = /obj/item/gunmodule/receiever //The modular gunpart that's the receiever. Affects calibre, magazine, and fire delay.
	barrel = /obj/item/gunmodule/barrel //The modular gunpart that's the barrel. Affects accuracy and size, alongside suppress/bayonetabilty.
	stock = /obj/item/gunmodule/stock //The modular gunpart that's the stock. Affects accuracy and size and the sprite.
	grip = /obj/item/gunmodule/grip //The modular gunpart that's the grip. Affects accuracy and size alongside the sprite.
	trigassembly = /obj/item/gunmodule/trigassembly //The modular gunpart that's the trigger asssembly. Affects the weapon's max burst and can allow automatic fire.

/obj/item/gun/ballistic/automatic/modular/disable_burst()
	. = ..()
	spread = basespread

/obj/item/gun/ballistic/automatic/modular/enable_burst()
	. = ..()
	spread = burstspread

/obj/item/gun/ballistic/automatic/modular/proc/partRefresh()
	burst_size = trigassembly.maxburst
	if(burst_size == 1)
		actions_types = list()
	automatic = trigassembly.automatic
	w_class = round(barrel.weightmod + stock.weightmod + grip.weightmod) //wclass defines are magic numbers. round floors the individual modifiers so a 1 weightmod stock, 1 weightmod grip and .5 weightmod barrel will make a small weapon.
	recoil = round(barrel.recoilmod + stock.recoilmod + grip.recoilmod) //2 recoil is sniper rifle, 8 recoil is golden revolver.
	basespread = round(barrel.accuracymod + stock.accuracymod + grip.accuracymod) //15 spread is the WT550 on burst, 0 is the WT550 on normal. 7 spread is the SAW.
	spread = basespread
	burstspread = basespread * 4
	failchance = receiver.failchancemod + barrel.failchancemod + trigassembly.failchancemod
	if(w_class >= WEIGHT_CLASS_BULKY)
		weapon_weight = WEAPON_HEAVY
	mag_type = receiver.magazine
	name = receiver.gunname
	desc = "A modular gun. It appears to use a [receiver.name] receiver, a [stock.name] stock, a [barrel.name] barrel, a [grip.name] grip, and a [trigassembly.name] trigger assembly. Use a screwdriver to dissassemble. You can hot-swap barrels."
	update_icon()

/obj/item/gun/ballistic/automatic/modular/initialize()
	. = ..()
	partRefresh()

/obj/item/gun/ballistic/automatic/modular/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/gunmodule))
		var/obj/item/gunmodule/part = A
		if(!istype(part, /obj/item/gunmodule/barrel))
			to_chat(user, "You can't swap that part without disassembling the weapon!")
		else if(istype(part, /obj/item/gunmodule/barrel) && if(user.transferItemToLoc(part, src)))
			oldpart = barrel
			oldpart.dropped()
			to_chat(user, "You replace the [oldpart.name] with the [part.name].")
			oldpart.forceMove(get_turf(src.loc))
			barrel = part
	else if(istype(A, /obj/item/screwdriver) && if(user.transferItemToLoc(src, user))
		to_chat(user, "You dissassemble the gun.")
		receiver.dropped()
		receiver.forceMove(get_turf(user.loc))
		barrel.dropped()
		barrel.forceMove(get_turf(user.loc))
		stock.dropped()
		stock.forceMove(get_turf(user.loc))
		grip.dropped()
		grip.forceMove(get_turf(user.loc))
		trigassembly.dropped()
		trigassembly.forceMove(get_turf(user.loc))
		qdel(src)

/obj/item/gun/ballistic/automatic/modular/process_fire()
	if(prob(failchance))
		to_chat(user, "The gun misfires!")
		playsound(src, "gun_dry_fire", 30, 1)
	else
		..()

/obj/item/gunwip
	name = "unfinished gun"
	desc = "You shouldn't see this description. It's a bug. Please report it."
	icon_state = "saber"
	var/receiever
	var/barrel
	var/stock
	var/grip
	var/trigassembly

/obj/item/gunwip/initialize()
	desc = "An unfinished gun. It appears to be built on a [receiver]."

/obj/item/gunwip/proc/partAdd(/obj/item/gunmodule/G, mob/user)
	switch(G)
		if(istype(G, /obj/item/gunmodule/receiver) && if(user.transferItemToLoc(G, src))
			oldpart = receiver
			newpart = G
			oldpart.dropped()
			to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
			oldpart.forceMove(get_turf(src.loc))
			receiver = newpart
		if(istype(G, /obj/item/gunmodule/barrel) && if(user.transferItemToLoc(G, src))
			oldpart = barrel
			newpart = G
			oldpart.dropped()
			to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
			oldpart.forceMove(get_turf(src.loc))
			barrel = newpart
		if(istype(G, /obj/item/gunmodule/stock) && if(user.transferItemToLoc(G, src))
			oldpart = stock
			newpart = G
			oldpart.dropped()
			to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
			oldpart.forceMove(get_turf(src.loc))
			stock = newpart
		if(istype(G, /obj/item/gunmodule/grip) && if(user.transferItemToLoc(G, src))
			oldpart = grip
			newpart = G
			oldpart.dropped()
			to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
			oldpart.forceMove(get_turf(src.loc))
			grip = newpart
		if(istype(G, /obj/item/gunmodule/trigassembly) && if(user.transferItemToLoc(G, src))
			oldpart = trigassembly
			newpart = G
			oldpart.dropped()
			to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
			oldpart.forceMove(get_turf(src.loc))
			trigassembly = newpart

/obj/item/gunwip/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/gunmodule))
		var/obj/item/gunmodule/part = A
		partAdd(part, user)

/obj/item/gunwip/attack_hand(mob/user)
	if(loc != user)
		..()
		return	//let them pick it up
	else
		if(receiver)
			user.transferItemToLoc(receiver, user)
		if(barrel)
			user.transferItemToLoc(barrel, user)
		if(stock)
			user.transferItemToLoc(stock, user)
		if(grip)
			user.transferItemToLoc(grip, user)
		if(trigassembly)
			user.transferItemToLoc(trigassembly, user)
		to_chat(user, "You disassemble the [name].")
		qdel(src)

//
// PARTS
//

/obj/item/gunmodule
	name = "modular weapon part"
	desc = "If you see this there's a really big problem. Please report the issue on github."
	var/failchancemod = 0
	var/finalweptype =

/obj/item/gunmodule/receiever
	name = "debug modular reciever"
	desc = "No, not that modular receiever. Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_SMALL
	var/gunname = "/improper 9mm modular SMG"
	var/calibre = "9mm"
	var/magazine = /obj/item/ammo_box/magazine/wt550m9
	var/firerate = 300 //firerate in RPM, converted to decisecond fire delay.

/obj/item/gunmodule/receiever/examine(mob/user)
	. = ..()
	to_chat(user, "The modular receiever is designed for [calibre] ammunition.")
	to_chat(user, "The average rate of fire of the weapon is [firerate] RPM.")
	to_chat(user, "The receiver accepts [magazine.name] magazines.")

/obj/item/gunmodule/receiever/attack_hand(mob/user)
	if(loc != user)
		..()
		return	//let them pick it up
	else
		var/obj/item/gunwip/rawgun = new(src)
		if(user.transferItemToLoc(src, rawgun))
			rawgun.receiver = src
		else
			return

/obj/item/gunmodule/barrel
	name = "debug modular barrel"
	desc = "Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_NORMAL
	var/accuracymod = 1
	var/weightmod = 1
	var/suppress = FALSE
	var/bayonet = FALSE //SUPPRESS and BAYONET shouldn't be enabled together unless your barrel sprite has offets that allow both.
	var/recoilmod = 0.4

/obj/item/gunmodule/stock
	name = "debug modular stock"
	desc = "Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_NORMAL
	var/accuracymod = 1
	var/weightmod = 1
	var/recoilmod = 0.4

/obj/item/gunmodule/grip
	name = "debug modular grip"
	desc = "Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_SMALL
	var/accuracymod = 1
	var/weightmod = 1
	var/recoilmod = 0.4

/obj/item/gunmodule/trigassembly
	name = "debug modular trigger assembly"
	desc = "Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_SMALL
	var/maxburst = 3
	var/automatic = FALSE
//if you set automatic to true make sure your maxburst is one or else funky (untested) things happen

/obj/item/gunmodule/receiver/improv
	name = "improvised receiver"
	desc = "An improvised receiver for a firearm."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"
	gunname = "improvised 7.62mm boltaction rifle"
	magazine = /obj/item/ammo_box/magazine/a762
	calibre = "7.62mm"
	failchancemod = 2.5

/obj/item/gunmodule/barrel/lathed
	name = "lathed barrel"
	desc = "A simple lathed barrel. Better than a pipe."
	accuracymod = 2

/obj/item/gunmodule/stock/crude
	name = "rifle stock"
	desc = "A heavy, crude rifle stock roughly carved out of wood. Pretty stable."
	weightmod = 1.5

/obj/item/gunmodule/grip/crude
	name = "rifle grip"
	desc = "A bulky, crude rifle grip, roughly carved out of wood. Fairly stable."
 weightmod = 1.5

/obj/item/gunmodule/trigassembly/improv
	name = "improvised trigger assembly"
	desc = "An improvised trigger assembly for a firearm."
	maxburst = 1
	failchancemod = 2.5

/obj/item/gunmodule/barrel/generic
	name = "basic barrel"
	desc = "Basic barrel. Doesn't affect the weapon that much."


/obj/item/gunmodule/stock/generic
	name = "generic stock"
	desc = "A basic polycarbonate stock. Pretty average."

/obj/item/gunmodule/grip/generic
	name = "simple grip"
	desc = "A basic weapon grip."

/obj/item/gunmodule/trigassembly/improv
	name = "improvised trigger assembly"
	desc = "An improvised trigger assembly for a firearm."
	maxburst = 1


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
	var/basespread = 0
	var/burstspread = 0
	var/failchance = 0
	//All modular gunparts affect reliability if so desired. Intended for Science/improvised weapons.
	var/obj/item/gunmodule/receiverpart/receiver = /obj/item/gunmodule/receiverpart //The modular gunpart that's the receiver. Affects calibre, magazine, and fire delay.
	var/obj/item/gunmodule/barrelpart/barrel = /obj/item/gunmodule/barrelpart //The modular gunpart that's the barrel. Affects accuracy and size, alongside suppress/bayonetabilty.
	var/obj/item/gunmodule/stockpart/stock = /obj/item/gunmodule/stockpart //The modular gunpart that's the stock. Affects accuracy and size and the sprite.
	var/obj/item/gunmodule/grippart/grip = /obj/item/gunmodule/grippart //The modular gunpart that's the grip. Affects accuracy and size alongside the sprite.
	var/obj/item/gunmodule/triggerassembly/trigassembly = /obj/item/gunmodule/triggerassembly //The modular gunpart that's the trigger asssembly. Affects the weapon's max burst and can allow automatic fire.

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

/obj/item/gun/ballistic/automatic/modular/Initialize()
	. = ..()
	partRefresh()

/obj/item/gun/ballistic/automatic/modular/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/gunmodule))
		var/obj/item/gunmodule/part = A
		if(!istype(part, /obj/item/gunmodule/barrelpart))
			to_chat(user, "You can't swap that part without disassembling the weapon!")
		else
			if(istype(part, /obj/item/gunmodule/barrelpart) && user.transferItemToLoc(part, src))
				var/obj/item/gunmodule/barrelpart/oldpart = barrel
				oldpart.dropped()
				to_chat(user, "You replace the [oldpart.name] with the [part.name].")
				oldpart.forceMove(get_turf(src.loc))
				barrel = part
	else
		if(istype(A, /obj/item/screwdriver) && user.transferItemToLoc(src, user))
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

/obj/item/gun/ballistic/automatic/modular/process_fire(mob/user)
	if(prob(failchance))
		to_chat(user, "The gun misfires!")
		playsound(src, "gun_dry_fire", 30, 1)
	else
		..()

/obj/item/gunwip
	name = "unfinished gun"
	desc = "A bug. Please report it."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"
	var/obj/item/gunmodule/receiverpart/receiver
	var/obj/item/gunmodule/barrelpart/barrel
	var/obj/item/gunmodule/stockpart/stock
	var/obj/item/gunmodule/grippart/grip
	var/obj/item/gunmodule/triggerassembly/trigassembly


/obj/item/gunwip/proc/partAdd(mob/user, obj/item/I = null)
	if(!istype(I, /obj/item/gunmodule))
		return
	var/obj/item/gunmodule/G = I
	var/obj/item/gunmodule/oldpart
	var/obj/item/gunmodule/newpart
	if(istype(G, /obj/item/gunmodule/receiverpart))
		oldpart = receiver
		newpart = G
		oldpart.dropped()
		to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
		oldpart.forceMove(get_turf(src.loc))
		receiver = newpart
	if(istype(G, /obj/item/gunmodule/barrelpart))
		oldpart = barrel
		newpart = G
		oldpart.dropped()
		to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
		oldpart.forceMove(get_turf(src.loc))
		barrel = newpart
	if(istype(G, /obj/item/gunmodule/stockpart))
		oldpart = stock
		newpart = G
		oldpart.dropped()
		to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
		oldpart.forceMove(get_turf(src.loc))
		stock = newpart
	if(istype(G, /obj/item/gunmodule/grippart))
		oldpart = grip
		newpart = G
		oldpart.dropped()
		to_chat(user, "You replace the [oldpart.name] with the [newpart.name].")
		oldpart.forceMove(get_turf(src.loc))
		grip = newpart
	if(istype(G, /obj/item/gunmodule/triggerassembly))
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
	if(istype(A, /obj/item/screwdriver))
		if(receiver && barrel && stock && grip && trigassembly)
			var/obj/item/gun/ballistic/automatic/modular/cookedgun = new(get_turf(src))
			user.put_in_hands(cookedgun)
			user.transferItemToLoc(receiver, cookedgun)
			cookedgun.receiver = receiver
			user.transferItemToLoc(barrel, cookedgun)
			cookedgun.barrel = barrel
			user.transferItemToLoc(stock, cookedgun)
			cookedgun.stock = stock
			user.transferItemToLoc(grip, cookedgun)
			cookedgun.grip = grip
			user.transferItemToLoc(trigassembly, cookedgun)
			cookedgun.trigassembly = trigassembly
			qdel(src)
		else
			return

/obj/item/gunwip/attack_self(mob/user)
	if(receiver)
		user.transferItemToLoc(receiver, get_turf(user))
	if(barrel)
		user.transferItemToLoc(barrel, get_turf(user))
	if(stock)
		user.transferItemToLoc(stock, get_turf(user))
	if(grip)
		user.transferItemToLoc(grip, get_turf(user))
	if(trigassembly)
		user.transferItemToLoc(trigassembly, get_turf(user))
	to_chat(user, "You disassemble the [name].")
	qdel(src)

/obj/item/gunwip/attack_hand(mob/user)
	. = ..()
	return
//
// PARTS
//

/obj/item/gunmodule
	name = "modular weapon part"
	desc = "If you see this there's a really big problem. Please report the issue on github."
	var/failchancemod = 0
	icon = 'icons/obj/improvised.dmi'
	icon_state = null

/obj/item/gunmodule/receiverpart
	name = "debug modular reciever"
	desc = "No, not that modular receiver. Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_SMALL
	var/gunname = "/improper 9mm modular SMG"
	var/calibre = "9mm"
	var/obj/item/ammo_box/magazine = /obj/item/ammo_box/magazine/wt550m9
	var/firerate = 300 //firerate in RPM, converted to decisecond fire delay.
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"

/obj/item/gunmodule/receiverpart/examine(mob/user)
	. = ..()
	. += "The modular receiver is designed for [calibre] ammunition."
	. += "The average rate of fire of the weapon is [firerate] RPM."


/obj/item/gunmodule/receiverpart/attack_self(mob/user)
	var/obj/item/gunwip/rawgun = /obj/item/gunwip
	rawgun.desc = "An unfinished gun. It appears to be built on a [src.name]."
	rawgun.partAdd(user, src)
	user.put_in_hands(rawgun)


/obj/item/gunmodule/barrelpart
	name = "debug modular barrel"
	desc = "Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_NORMAL
	var/accuracymod = 1
	var/weightmod = 1
	var/suppress = FALSE
	var/bayonet = FALSE //SUPPRESS and BAYONET shouldn't be enabled together unless your barrel sprite has offets that allow both.
	var/recoilmod = 0.4

/obj/item/gunmodule/stockpart
	name = "debug modular stock"
	desc = "Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_SMALL
	var/accuracymod = 1
	var/weightmod = 1
	var/recoilmod = 0.4

/obj/item/gunmodule/grippart
	name = "debug modular grip"
	desc = "Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_SMALL
	var/accuracymod = 1
	var/weightmod = 1
	var/recoilmod = 0.4

/obj/item/gunmodule/triggerassembly
	name = "debug modular trigger assembly"
	desc = "Debug item. Report it on github if you see it."
	w_class = WEIGHT_CLASS_SMALL
	var/maxburst = 3
	var/automatic = FALSE
//if you set automatic to true make sure your maxburst is one or else funky (untested) things happen

/obj/item/gunmodule/receiverpart/improv
	name = "improvised receiver"
	desc = "An improvised receiver for a firearm."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"
	gunname = "improvised 7.62mm boltaction rifle"
	magazine = /obj/item/ammo_box/magazine/a762
	calibre = "7.62mm"
	failchancemod = 2.5
	firerate = 60

/obj/item/gunmodule/barrelpart/lathed
	name = "lathed barrel"
	desc = "A simple lathed barrel. Better than a pipe."
	accuracymod = 2

/obj/item/gunmodule/stockpart/crude
	name = "rifle stock"
	desc = "A heavy, crude rifle stock roughly carved out of wood. Pretty stable."
	weightmod = 1.5
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gunmodule/grippart/crude
	name = "rifle grip"
	desc = "A bulky, crude rifle grip, roughly carved out of wood. Fairly stable."
	weightmod = 1.5
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gunmodule/triggerassembly/improv
	name = "improvised trigger assembly"
	desc = "An improvised trigger assembly for a firearm. A little unreliable.s"
	maxburst = 1
	failchancemod = 2.5

/obj/item/gunmodule/barrelpart/generic
	name = "basic barrel"
	desc = "Basic barrel. Doesn't affect the weapon that much."


/obj/item/gunmodule/stockpart/generic
	name = "generic stock"
	desc = "A basic polycarbonate stock. Pretty average."

/obj/item/gunmodule/grippart/generic
	name = "simple grip"
	desc = "A basic weapon grip."

/obj/item/gunmodule/triggerassembly/improv
	name = "improvised trigger assembly"
	desc = "An improvised trigger assembly for a firearm."
	maxburst = 1

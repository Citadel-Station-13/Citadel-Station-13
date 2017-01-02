//In this file: C4

/obj/item/weapon/c4
	name = "C-4"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = NOBLUDGEON
	w_class = 2
	origin_tech = "syndicate=1"
	var/timer = 10
	var/open_panel = 0
	parent_type = /obj/item/weapon/grenade/plastic/c4

/obj/item/weapon/c4/New()
	wires = new /datum/wires/explosive/c4(src)
	image_overlay = image('icons/obj/grenade.dmi', "plastic-explosive2")
	..()

/obj/item/weapon/c4/Destroy()
	qdel(wires)
	wires = null
	target = null
	return ..()

/obj/item/weapon/c4/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] activates the [src.name] and holds it above \his head! It looks like \he's going out with a bang!</span>")
	var/message_say = "FOR NO RAISIN!"
	if(user.mind)
		if(user.mind.special_role)
			var/role = lowertext(user.mind.special_role)
			if(role == "traitor" || role == "syndicate")
				message_say = "FOR THE SYNDICATE!"
			else if(role == "changeling")
				message_say = "FOR THE HIVE!"
			else if(role == "cultist")
				message_say = "FOR NAR-SIE!"
			else if(role == "revolutionary" || role == "head revolutionary")
				message_say = "VIVA LA REVOLUTION!"
			else if(user.mind.gang_datum)
				message_say = "[uppertext(user.mind.gang_datum.name)] RULES!"
	user.say(message_say)
	target = user
	message_admins("[key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) suicided with [src.name] at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	message_admins("[key_name(user)] suicided with [src.name] at ([x],[y],[z])")
	sleep(10)
	explode(get_turf(user))
	user.gib(1, 1)

/obj/item/weapon/c4/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		open_panel = !open_panel
		user << "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>"
	else if(is_wire_tool(I))
		wires.interact(user)
	else
		return ..()

/obj/item/weapon/c4/attack_self(mob/user)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(user.get_active_hand() == src)
		newtime = Clamp(newtime, 10, 60000)
		timer = newtime
		user << "Timer set for [timer] seconds."

/obj/item/weapon/c4/afterattack(atom/movable/AM, mob/user, flag)
	if (!flag)
		return
	if (ismob(AM))
		return
	if(loc == AM)
		return
	if((istype(AM, /obj/item/weapon/storage/)) && !((istype(AM, /obj/item/weapon/storage/secure)) || (istype(AM, /obj/item/weapon/storage/lockbox)))) //If its storage but not secure storage OR a lockbox, then place it inside.
		return
	if((istype(AM,/obj/item/weapon/storage/secure)) || (istype(AM, /obj/item/weapon/storage/lockbox)))
		var/obj/item/weapon/storage/secure/S = AM
		if(!S.locked) //Literal hacks, this works for lockboxes despite incorrect type casting, because they both share the locked var. But if its unlocked, place it inside, otherwise PLANTING C4!
			return

	user << "<span class='notice'>You start planting the bomb...</span>"

	if(do_after(user, 50, target = AM))
		if(!user.unEquip(src))
			return
		src.target = AM
		loc = null

		message_admins("[key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) planted [src.name] on [target.name] at ([target.x],[target.y],[target.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>) with [timer] second fuse",0,1)
		log_game("[key_name(user)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z]) with [timer] second fuse")

		target.add_overlay(image_overlay, 1)
		user << "<span class='notice'>You plant the bomb. Timer counting down from [timer].</span>"
		addtimer(src, "explode", timer * 10)

/obj/item/weapon/c4/proc/explode()
	if(qdeleted(src))
		return
	var/turf/location
	if(target)
		if(!qdeleted(target))
			location = get_turf(target)
			target.overlays -= image_overlay
			target.priority_overlays -= image_overlay
	else
		location = get_turf(src)
	if(location)
		location.ex_act(2, target)
		explosion(location,0,0,3)
	qdel(src)

/obj/item/weapon/c4/attack(mob/M, mob/user, def_zone)
	return

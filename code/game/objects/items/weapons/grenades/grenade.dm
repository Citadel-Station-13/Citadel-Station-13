/obj/item/weapon/grenade
	name = "grenade"
	desc = "It has an adjustable timer."
	w_class = 2
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "flashbang"
	throw_speed = 3
	throw_range = 7
	flags = CONDUCT
	slot_flags = SLOT_BELT
	burn_state = FLAMMABLE
	burntime = 5
	var/active = 0
	var/det_time = 50
	var/display_timer = 1

/obj/item/weapon/grenade/burn()
	prime()
	..()

/obj/item/weapon/grenade/proc/clown_check(mob/living/carbon/human/user)
	if(user.disabilities & CLUMSY && prob(50))
		user << "<span class='warning'>Huh? How does this thing work?</span>"
		active = 1
		icon_state = initial(icon_state) + "_active"
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		spawn(5)
			if(user)
				user.drop_item()
			prime()
		return 0
	return 1


/obj/item/weapon/grenade/examine(mob/user)
	..()
	if(display_timer)
		if(det_time > 1)
			user << "The timer is set to [det_time/10] second\s."
		else
			user << "\The [src] is set for instant detonation."


/obj/item/weapon/grenade/attack_self(mob/user)
	if(!active)
		if(clown_check(user))
			user << "<span class='warning'>You prime the [name]! [det_time/10] seconds!</span>"
			playsound(user.loc, 'sound/weapons/armbomb.ogg', 60, 1)
			active = 1
			icon_state = initial(icon_state) + "_active"
			add_fingerprint(user)
			var/turf/bombturf = get_turf(src)
			var/area/A = get_area(bombturf)
			message_admins("[key_name_admin(usr)]<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[usr]'>FLW</A>) has primed a [name] for detonation at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>.")
			log_game("[key_name(usr)] has primed a [name] for detonation at [A.name] ([bombturf.x],[bombturf.y],[bombturf.z]).")
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
			spawn(det_time)
				prime()


/obj/item/weapon/grenade/proc/prime()

/obj/item/weapon/grenade/proc/update_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.unEquip(src)


/obj/item/weapon/grenade/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/screwdriver))
		switch(det_time)
			if ("1")
				det_time = 10
				user << "<span class='notice'>You set the [name] for 1 second detonation time.</span>"
			if ("10")
				det_time = 30
				user << "<span class='notice'>You set the [name] for 3 second detonation time.</span>"
			if ("30")
				det_time = 50
				user << "<span class='notice'>You set the [name] for 5 second detonation time.</span>"
			if ("50")
				det_time = 1
				user << "<span class='notice'>You set the [name] for instant detonation.</span>"
		add_fingerprint(user)
	else
		return ..()

/obj/item/weapon/grenade/attack_hand()
	walk(src, null, null)
	..()

/obj/item/weapon/grenade/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/weapon/grenade/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type)
	if(damage && attack_type == PROJECTILE_ATTACK && prob(15))
		owner.visible_message("<span class='danger'>[attack_text] hits [owner]'s [src], setting it off! What a shot!</span>")
		prime()
		return 1 //It hit the grenade, not them
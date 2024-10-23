/obj/item/grenade
	name = "grenade"
	desc = "It has an adjustable timer."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "flashbang"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = FLAMMABLE
	max_integrity = 40
	var/active = 0
	var/det_time = 50
	var/display_timer = 1
	var/clumsy_check = GRENADE_CLUMSY_FUMBLE
	var/sticky = FALSE
	// I moved the explosion vars and behavior to base grenades because we want all grenades to call [/obj/item/grenade/proc/prime] so we can send COMSIG_GRENADE_PRIME
	///how big of a devastation explosion radius on prime
	var/ex_dev = 0
	///how big of a heavy explosion radius on prime
	var/ex_heavy = 0
	///how big of a light explosion radius on prime
	var/ex_light = 0
	///how big of a flame explosion radius on prime
	var/ex_flame = 0

	// dealing with creating a [/datum/component/pellet_cloud] on prime
	/// if set, will spew out projectiles of this type
	var/shrapnel_type
	/// the higher this number, the more projectiles are created as shrapnel
	var/shrapnel_radius
	var/shrapnel_initialized

/obj/item/grenade/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] primes [src], then eats it! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(shrapnel_type && shrapnel_radius)
		shrapnel_initialized = TRUE
		AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
	playsound(src, 'sound/items/eatfood.ogg', 50, 1)
	SEND_SIGNAL(src, COMSIG_GRENADE_ARMED, det_time)
	preprime(user, det_time)
	user.transferItemToLoc(src, user, TRUE)//>eat a grenade set to 5 seconds >rush captain
	sleep(det_time)//so you dont die instantly
	return BRUTELOSS

/obj/item/grenade/deconstruct(disassembled = TRUE)
	if(!disassembled)
		prime()
	if(!QDELETED(src))
		qdel(src)

/obj/item/grenade/proc/botch_check(mob/living/carbon/human/user)
	var/clumsy = HAS_TRAIT(user, TRAIT_CLUMSY)
	if(clumsy)
		if(clumsy_check == GRENADE_CLUMSY_FUMBLE && prob(50))
			to_chat(user, "<span class='warning'>Huh? How does this thing work?</span>")
			preprime(user, 5, FALSE)
			return TRUE
	else if(clumsy_check == GRENADE_NONCLUMSY_FUMBLE && !(user.mind && HAS_TRAIT(user.mind, TRAIT_CLOWN_MENTALITY)))
		to_chat(user, "<span class='warning'>You pull the pin on [src]. Attached to it is a pink ribbon that says, \"<span class='clown'>HONK</span>\"</span>")
		preprime(user, 5, FALSE)
		return TRUE

	else if(sticky && prob(50)) // to add risk to sticky tape grenade cheese, no return cause we still prime as normal after
		to_chat(user, "<span class='warning'>What the... [src] is stuck to your hand!</span>")
		ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)

/obj/item/grenade/examine(mob/user)
	. = ..()
	if(display_timer)
		if(det_time > 1)
			. += "The timer is set to [DisplayTimeText(det_time)]."
		else
			. += "\The [src] is set for instant detonation."


/obj/item/grenade/attack_self(mob/user)
	if(HAS_TRAIT(src, TRAIT_NODROP))
		to_chat(user, "<span class='notice'>You try prying [src] off your hand...</span>")
		if(do_after(user, 70, target=src))
			to_chat(user, "<span class='notice'>You manage to remove [src] from your hand.</span>")
			REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)

		return

	if(!active)
		if(!botch_check(user)) // if they botch the prime, it'll be handled in botch_check
			preprime(user)

/obj/item/grenade/proc/log_grenade(mob/user, turf/T)
	var/message = "[ADMIN_LOOKUPFLW(user)]) has primed \a [src] for detonation at [ADMIN_VERBOSEJMP(T)]"
	GLOB.bombers += message
	message_admins(message)
	log_game("[key_name(user)] has primed \a [src] for detonation at [AREACOORD(T)].")

/obj/item/grenade/proc/preprime(mob/user, delayoverride, msg = TRUE, volume = 60)
	var/turf/T = get_turf(src)
	log_grenade(user, T) //Inbuilt admin procs already handle null users
	if(user)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()
		if(msg)
			to_chat(user, "<span class='warning'>You prime [src]! [DisplayTimeText(det_time)]!</span>")
	playsound(src, 'sound/weapons/armbomb.ogg', volume, 1)
	active = TRUE
	icon_state = initial(icon_state) + "_active"
	addtimer(CALLBACK(src, PROC_REF(prime)), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/proc/prime(mob/living/lanced_by)
	var/turf/T = get_turf(src)
	log_game("Grenade detonation at [AREACOORD(T)], location [loc]")

	if(shrapnel_type && shrapnel_radius && !shrapnel_initialized) // add a second check for adding the component in case whatever triggered the grenade went straight to prime (badminnery for example)
		shrapnel_initialized = TRUE
		AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)

	SEND_SIGNAL(src, COMSIG_GRENADE_PRIME, lanced_by)
	if(ex_dev || ex_heavy || ex_light || ex_flame)
		explosion(loc, ex_dev, ex_heavy, ex_light, flame_range = ex_flame)

/obj/item/grenade/proc/update_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.dropItemToGround(src)
	else if(isitem(loc))
		var/obj/item/I = loc
		I.grenade_prime_react(src)

/obj/item/grenade/tool_act(mob/living/user, obj/item/I, tool_behaviour)
	if(tool_behaviour == TOOL_SCREWDRIVER)
		switch(det_time)
			if(1)
				det_time = 1 SECONDS
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if(1 SECONDS)
				det_time = 3 SECONDS
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if(3 SECONDS)
				det_time = 5 SECONDS
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if(5 SECONDS)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	else
		return ..()

/obj/item/grenade/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/grenade/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(attack_type & ATTACK_TYPE_PROJECTILE)
		var/obj/item/projectile/P = object
		if(damage && !P.nodamage && (P.damage_type != STAMINA) && prob(15))
			owner.visible_message("<span class='danger'>[attack_text] hits [owner]'s [src], setting it off! What a shot!</span>")
			prime()
			return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return ..()

/obj/item/proc/grenade_prime_react(obj/item/grenade/nade)
	return

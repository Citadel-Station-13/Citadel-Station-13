

/obj/item/projectile/energy/flenser
	name = "flensing net"
	damage_type = BRUTE
	damage = 5//this isn't even the start of how much pain this causes

/obj/item/projectile/energy/flenser/on_hit(atom/target, blocked = FALSE)
	if(target)
		var/turf/Tloc = get_turf(target)
		if(!locate(/obj/structure/flensingnet) in Tloc)
			new /obj/structure/flensingnet(Tloc)
	return ..()

/obj/structure/flensingnet
	name = "flensing net"
	desc = "A net made of concertina wire."
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "iv_drip"
	can_buckle = 1
	max_integrity = 40
	density = FALSE
	can_buckle = TRUE
	buckle_prevents_pull = TRUE
	buckle_lying = FALSE
	var/rended = FALSE

/obj/structure/flensingnet/user_unbuckle_mob(mob/living/dyingman, mob/living/user)
	if(user == dyingman)
		user.visible_message("<span class='warning'>[user] starts wriggling off of [src]!</span>", \
		"<span class='danger'>You start agonizingly working your way off of [src]...</span>")
		if(!do_after(user, 300, target = user))
			user.visible_message("<span class='warning'>[user] slides back down [src]!</span>")
			user.emote("scream")
			user.apply_damage(10, BRUTE, BODY_ZONE_CHEST)
			playsound(user, 'sound/misc/desceration-03.ogg', 50, TRUE)
			return
	else
		user.visible_message("<span class='danger'>[user] starts tenderly lifting [src] off of [dyingman]...</span>", \
		"<span class='danger'>You start tenderly lifting [src] off of [dyingman]...</span>")
		if(!do_after(user, 60, target = dyingman))
			dyingman.visible_message("<span class='warning'>[src] painfully rends [dyingman].</span>")
			if(dyingman.stat >= UNCONSCIOUS)
				return
			dyingman.say("Oof, ouch owwie!!", forced = "flensing net removal failure")
			return
	dyingman.visible_message("<span class='danger'>[dyingman] comes free of [src] with a squelch!</span>", \
	"<span class='boldannounce'>You come free of [src]!</span>")
	dyingman.DefaultCombatKnockdown(30)
	playsound(dyingman, 'sound/misc/desceration-03.ogg', 50, TRUE)
	unbuckle_mob(dyingman)

/obj/structure/flensingnet/user_buckle_mob()
		return

/obj/structure/flensingnet/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)
	var/mob/living/whale = locate() in get_turf(src)
	if(whale)
		if(iscyborg(whale))
			if(!whale.stat)
				whale.visible_message("<span class='boldwarning'>The flensing net rends [whale]'s chassis, going blunt and useless in the process!</span>", \
				"<span class='userdanger'>A razor net rips your chassis and bursts into shrapnel in your casing!</span>")
				whale.adjustBruteLoss(35)
				whale.Stun(20)
				addtimer(CALLBACK(src, .proc/take_damage, max_integrity), 1)
		else
			whale.visible_message("<span class='boldwarning'>A flensing net ensnares [whale], embedding itself into their skin!</span>", \
			"<span class='userdanger'>A flensing net ensnares you, its razors digging painfully into your flesh!</span>")
			whale.emote("scream")
			playsound(whale, 'sound/effects/splat.ogg', 50, TRUE)
			playsound(whale, 'sound/misc/desceration-03.ogg', 50, TRUE)
			whale.adjustBruteLoss(10)
		mouse_opacity = MOUSE_OPACITY_OPAQUE //So players can interact with the tile it's on to pull them off
		buckle_mob(whale, TRUE)

/obj/structure/flensingnet/process()
	if(buckled_mobs && LAZYLEN(buckled_mobs))
		var/mob/living/spitroast = buckled_mobs[1]
		spitroast.adjustBruteLoss(0.1)
		if(spitroast.health < spitroast.maxHealth/1.3)//around 153 hp on a 200hp mob
			rend()

/obj/structure/flensingnet/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(rended)
		return ..()
	if(buckled_mobs && LAZYLEN(buckled_mobs))
		var/mob/living/L = buckled_mobs[1]
		if(iscarbon(L))
			L.DefaultCombatKnockdown(100)
			L.visible_message("<span class='warning'>[L] is maimed as the net shatters while still embedded in [L.p_their()] flesh!</span>")
			L.adjustBruteLoss(25)
		unbuckle_mob(L)
	return ..()

/obj/structure/flensingnet/proc/rend()
	if(rended)
		return FALSE
	if(buckled_mobs && LAZYLEN(buckled_mobs))
		var/mob/living/unrended = buckled_mobs[1]
		if(ishuman(unrended))
			var/mob/living/carbon/human/H = unrended
			CHECK_DNA_AND_SPECIES(H)
			H.adjustBruteLoss(15) // skin gone!
			H.DefaultCombatKnockdown(30)
			if(!istype(H.dna.species, /datum/species/krokodil_addict))
				to_chat(H, "<span class='userdanger'>Your skin is flensed by the [src]!</span>")
				H.emote("scream")
				H.set_species(/datum/species/krokodil_addict)
			else
				to_chat(H, "<span class='userdanger'>The [src] rends your flesh!</span>")
				H.emote("scream")
		else
			to_chat(unrended, "<span class='userdanger'>The [src] rends your flesh!</span>")
			unrended.adjustBruteLoss(15)
	rended = TRUE

// For all of the items that are really just the user's hand used in different ways, mostly (all, really) from emotes

/obj/item/circlegame
	name = "circled hand"
	desc = "If somebody looks at this while it's below your waist, you get to bop them."
	icon_state = "madeyoulook"
	force = 0
	throwforce = 0
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM
	attack_verb_continuous = list("bops")
	attack_verb_simple = list("bop")

/obj/item/circlegame/Initialize()
	. = ..()
	var/mob/living/owner = loc
	if(!istype(owner))
		return
	RegisterSignal(owner, COMSIG_PARENT_EXAMINE, .proc/ownerExamined)

/obj/item/circlegame/Destroy()
	var/mob/owner = loc
	if(istype(owner))
		UnregisterSignal(owner, COMSIG_PARENT_EXAMINE)
	return ..()

/obj/item/circlegame/dropped(mob/user)
	UnregisterSignal(user, COMSIG_PARENT_EXAMINE)		//loc will have changed by the time this is called, so Destroy() can't catch it
	// this is a dropdel item.
	return ..()

/// Stage 1: The mistake is made
/obj/item/circlegame/proc/ownerExamined(mob/living/owner, mob/living/sucker)
	SIGNAL_HANDLER

	if(!istype(sucker) || !in_range(owner, sucker))
		return
	addtimer(CALLBACK(src, .proc/waitASecond, owner, sucker), 4)

/// Stage 2: Fear sets in
/obj/item/circlegame/proc/waitASecond(mob/living/owner, mob/living/sucker)
	if(QDELETED(sucker) || QDELETED(src) || QDELETED(owner))
		return

	if(owner == sucker) // big mood
		to_chat(owner, "<span class='danger'>Wait a second... you just looked at your own [src.name]!</span>")
		addtimer(CALLBACK(src, .proc/selfGottem, owner), 10)
	else
		to_chat(sucker, "<span class='danger'>Wait a second... was that a-</span>")
		addtimer(CALLBACK(src, .proc/GOTTEM, owner, sucker), 6)

/// Stage 3A: We face our own failures
/obj/item/circlegame/proc/selfGottem(mob/living/owner)
	if(QDELETED(src) || QDELETED(owner))
		return

	playsound(get_turf(owner), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	owner.visible_message("<span class='danger'>[owner] shamefully bops [owner.p_them()]self with [owner.p_their()] [src.name].</span>", "<span class='userdanger'>You shamefully bop yourself with your [src.name].</span>", \
		"<span class='hear'>You hear a dull thud!</span>")
	log_combat(owner, owner, "bopped", src.name, "(self)")
	owner.do_attack_animation(owner)
	owner.apply_damage(100, STAMINA)
	owner.Knockdown(10)
	qdel(src)

/// Stage 3B: We face our reckoning (unless we moved away or they're incapacitated)
/obj/item/circlegame/proc/GOTTEM(mob/living/owner, mob/living/sucker)
	if(QDELETED(sucker))
		return

	if(QDELETED(src) || QDELETED(owner))
		to_chat(sucker, "<span class='warning'>Nevermind... must've been your imagination...</span>")
		return

	if(!in_range(owner, sucker) || !(owner.mobility_flags & MOBILITY_USE))
		to_chat(sucker, "<span class='notice'>Phew... you moved away before [owner] noticed you saw [owner.p_their()] [src.name]...</span>")
		return

	to_chat(owner, "<span class='warning'>[sucker] looks down at your [src.name] before trying to avert [sucker.p_their()] eyes, but it's too late!</span>")
	to_chat(sucker, "<span class='danger'><b>[owner] sees the fear in your eyes as you try to look away from [owner.p_their()] [src.name]!</b></span>")

	owner.face_atom(sucker)
	if(owner.client)
		owner.client.give_award(/datum/award/achievement/misc/gottem, owner) // then everybody clapped

	playsound(get_turf(owner), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	owner.do_attack_animation(sucker)

	if(HAS_TRAIT(owner, TRAIT_HULK))
		owner.visible_message("<span class='danger'>[owner] bops [sucker] with [owner.p_their()] [src.name] much harder than intended, sending [sucker.p_them()] flying!</span>", \
			"<span class='danger'>You bop [sucker] with your [src.name] much harder than intended, sending [sucker.p_them()] flying!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", ignored_mobs=list(sucker))
		to_chat(sucker, "<span class='userdanger'>[owner] bops you incredibly hard with [owner.p_their()] [src.name], sending you flying!</span>")
		sucker.apply_damage(50, STAMINA)
		sucker.Knockdown(50)
		log_combat(owner, sucker, "bopped", src.name, "(setup- Hulk)")
		var/atom/throw_target = get_edge_target_turf(sucker, owner.dir)
		sucker.throw_at(throw_target, 6, 3, owner)
	else
		owner.visible_message("<span class='danger'>[owner] bops [sucker] with [owner.p_their()] [src.name]!</span>", "<span class='danger'>You bop [sucker] with your [src.name]!</span>", \
			"<span class='hear'>You hear a dull thud!</span>", ignored_mobs=list(sucker))
		sucker.apply_damage(15, STAMINA)
		log_combat(owner, sucker, "bopped", src.name, "(setup)")
		to_chat(sucker, "<span class='userdanger'>[owner] bops you with [owner.p_their()] [src.name]!</span>")
	qdel(src)

/obj/item/slapper
	name = "slapper"
	desc = "This is how real men fight."
	icon_state = "latexballon"
	inhand_icon_state = "nothing"
	force = 0
	throwforce = 0
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM
	attack_verb_continuous = list("slaps")
	attack_verb_simple = list("slap")
	hitsound = 'sound/effects/snap.ogg'

/obj/item/slapper/attack(mob/M, mob/living/carbon/human/user)
	if(ishuman(M))
		var/mob/living/carbon/human/L = M
		if(L && L.dna && L.dna.species)
			L.dna.species.stop_wagging_tail(M)
	user.do_attack_animation(M)
	playsound(M, 'sound/weapons/slap.ogg', 50, TRUE, -1)
	user.visible_message("<span class='danger'>[user] slaps [M]!</span>",
	"<span class='notice'>You slap [M]!</span>",\
	"<span class='hear'>You hear a slap.</span>")
	return

/obj/item/kisser
	name = "kiss"
	desc = "I want you all to know, everyone and anyone, to seal it with a kiss."
	icon = 'icons/mob/animal.dmi'
	icon_state = "heart"
	inhand_icon_state = "nothing"
	force = 0
	throwforce = 0
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM
	/// The kind of projectile this version of the kiss blower fires
	var/kiss_type = /obj/projectile/kiss

/obj/item/kisser/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	var/obj/projectile/blown_kiss = new kiss_type(get_turf(user))
	user.visible_message("<b>[user]</b> blows \a [blown_kiss] at [target]!", "<span class='notice'>You blow \a [blown_kiss] at [target]!</span>")

	//Shooting Code:
	blown_kiss.spread = 0
	blown_kiss.original = target
	blown_kiss.fired_from = user
	blown_kiss.firer = user // don't hit ourself that would be really annoying
	blown_kiss.impacted = list(user = TRUE) // just to make sure we don't hit the wearer
	blown_kiss.preparePixelProjectile(target, user)
	blown_kiss.fire()
	qdel(src)

/obj/projectile/kiss
	name = "kiss"
	icon = 'icons/mob/animal.dmi'
	icon_state = "heart"
	hitsound = 'sound/effects/kiss.ogg'
	hitsound_wall = 'sound/effects/kiss.ogg'
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	speed = 1.6
	damage_type = BRUTE
	damage = 0
	nodamage = TRUE // love can't actually hurt you
	armour_penetration = 100 // but if it could, it would cut through even the thickest plate
	flag = MAGIC // and most importantly, love is magic~

/obj/projectile/kiss/fire(angle, atom/direct_target)
	if(firer)
		name = "[name] blown by [firer]"
	return ..()

/obj/projectile/kiss/on_hit(atom/target, blocked, pierce_hit)
	def_zone = BODY_ZONE_HEAD // let's keep it PG, people
	. = ..()
	if(!ismob(target))
		return
	SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "kiss", /datum/mood_event/kiss, firer)
	var/mob/living/target_living = target
	if(!(HAS_TRAIT(target_living, TRAIT_ANXIOUS) && prob(30)))
		return

	// flustered!!!
	var/other_msg
	var/self_msg
	var/roll = rand(1, 3)
	switch(roll)
		if(1)
			other_msg = "stumbles slightly, turning a bright red!"
			self_msg = "You lose control of your limbs for a moment as your blood rushes to your face, turning it bright red!"
			target_living.add_confusion(rand(5, 10))
		if(2)
			other_msg = "stammers softly for a moment before choking on something!"
			self_msg = "You feel your tongue disappear down your throat as you fight to remember how to make words!"
			addtimer(CALLBACK(target_living, /atom/movable.proc/say, pick("Uhhh...", "O-oh, uhm...", "I- uhhhhh??", "You too!!", "What?")), rand(0.5 SECONDS, 1.5 SECONDS))
			target_living.stuttering += rand(5, 15)
		if(3)
			other_msg = "locks up with a stunned look on [target_living.p_their()] face, staring at [firer ? firer : "the ceiling"]!"
			self_msg = "Your brain completely fails to process what just happened, leaving you rooted in place staring [firer ? "at [firer]" : "the ceiling"] for what feels like an eternity!"
			target_living.face_atom(firer)
			target_living.Stun(rand(3 SECONDS, 8 SECONDS))

	target_living.visible_message("<b>[target_living]</b> [other_msg]", "<span class='userdanger'>Whoa! [self_msg]</span>")

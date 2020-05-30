//Magical traumas, caused by spells and curses.
//Blurs the line between the victim's imagination and reality
//Unlike regular traumas this can affect the victim's body and surroundings

/datum/brain_trauma/magic
	resilience = TRAUMA_RESILIENCE_LOBOTOMY

/datum/brain_trauma/magic/stalker
	name = "Stalking Phantom"
	desc = "Patient is stalked by a phantom only they can see."
	scan_desc = "extra-sensory paranoia"
	gain_text = "<span class='warning'>You feel like something wants to kill you...</span>"
	lose_text = "<span class='notice'>You no longer feel eyes on your back.</span>"
	var/obj/effect/hallucination/simple/stalker_phantom/stalker
	var/close_stalker = FALSE //For heartbeat

/datum/brain_trauma/magic/stalker/on_gain()
	create_stalker()
	..()

/datum/brain_trauma/magic/stalker/proc/create_stalker()
	var/turf/stalker_source = locate(owner.x + pick(-12, 12), owner.y + pick(-12, 12), owner.z) //random corner
	stalker = new(stalker_source, owner)

/datum/brain_trauma/magic/stalker/on_lose()
	QDEL_NULL(stalker)
	..()

/datum/brain_trauma/magic/stalker/on_life()
	// Dead and unconscious people are not interesting to the psychic stalker.
	if(owner.stat != CONSCIOUS)
		return

	// Not even nullspace will keep it at bay.
	if(!stalker || !stalker.loc || stalker.z != owner.z)
		qdel(stalker)
		create_stalker()

	if(get_dist(owner, stalker) <= 1)
		playsound(owner, 'sound/magic/demon_attack1.ogg', 50)
		owner.visible_message("<span class='warning'>[owner] is torn apart by invisible claws!</span>", "<span class='userdanger'>Ghostly claws tear your body apart!</span>")
		owner.take_bodypart_damage(rand(20, 45))
	else if(prob(50))
		stalker.forceMove(get_step_towards(stalker, owner))
	if(get_dist(owner, stalker) <= 8)
		if(!close_stalker)
			var/sound/slowbeat = sound('sound/health/slowbeat.ogg', repeat = TRUE)
			owner.playsound_local(owner, slowbeat, 40, 0, channel = CHANNEL_HEARTBEAT)
			close_stalker = TRUE
	else
		if(close_stalker)
			owner.stop_sound_channel(CHANNEL_HEARTBEAT)
			close_stalker = FALSE
	..()

/obj/effect/hallucination/simple/stalker_phantom
	name = "???"
	desc = "It's coming closer..."
	image_icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	image_state = "curseblob"

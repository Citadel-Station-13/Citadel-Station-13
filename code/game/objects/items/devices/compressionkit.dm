/obj/item/compressionkit
	name = "bluespace compression kit"
	desc = "An illegally modified BSRPED, capable of reducing the size of most items."
	icon = 'icons/obj/tools.dmi'
	icon_state = "compression_c"
	item_state = "RPED"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	var/charges = 5
	// var/damage_multiplier = 0.2 Not in use yet.
	var/mode = 0

/obj/item/compressionkit/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It has [charges] charges left. Recharge with bluespace crystals.</span>"
	. += "<span class='notice'>Use in-hand to swap toggle compress/expand mode (expand mode not yet implemented).</span>"

/obj/item/compressionkit/attack_self(mob/user)
	if(mode == 0)
		mode = 1
		icon_state = "compression_e"
		to_chat(user, "<span class='notice'>You switch the compressor to expand mode. This isn't implemented yet, so right now it wont do anything different!</span>")
		return
	if(mode == 1)
		mode = 0
		icon_state = "compression_c"
		to_chat(user, "<span class='notice'>You switch the compressor to compress mode. Usage will now reduce the size of objects.</span>")
		return
	else
		mode = 0
		icon_state = "compression_c"
		to_chat(user, "<span class='notice'>Some coder cocked up or an admin broke your compressor. It's been set back to compress mode..</span>")

/obj/item/compressionkit/proc/sparks()
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, get_turf(src))
	s.start()

/obj/item/compressionkit/suicide_act(mob/living/carbon/M)
	M.visible_message("<span class='suicide'>[M] is sticking their head in [src] and turning it on! [M.p_theyre(TRUE)] going to compress their own skull!</span>")
	var/obj/item/bodypart/head = M.get_bodypart("head")
	if(!head)
		return
	var/turf/T = get_turf(M)
	var/list/organs = M.getorganszone("head") + M.getorganszone("eyes") + M.getorganszone("mouth")
	for(var/internal_organ in organs)
		var/obj/item/organ/I = internal_organ
		I.Remove()
		I.forceMove(T)
	head.drop_limb()
	qdel(head)
	new M.gib_type(T,1,M.get_static_viruses())
	M.add_splatter_floor(T)
	playsound(M, 'sound/weapons/flash.ogg', 50, 1)
	playsound(M, 'sound/effects/splat.ogg', 50, 1)

	return OXYLOSS

/obj/item/compressionkit/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !target)
		return
	else
		if(charges == 0)
			playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 50, 1)
			to_chat(user, "<span class='notice'>The bluespace compression kit is out of charges! Recharge it with bluespace crystals.</span>")
			return
	if(istype(target, /obj/item))
		var/obj/item/O = target
		if(O.w_class == 1)
			playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 50, 1)
			to_chat(user, "<span class='notice'>[target] cannot be compressed smaller!.</span>")
			return
		if(O.GetComponent(/datum/component/storage))
			to_chat(user, "<span class='notice'>You feel like compressing an item that stores other items would be counterproductive.</span>")
			return
		if(O.w_class > 1)
			playsound(get_turf(src), 'sound/weapons/flash.ogg', 50, 1)
			user.visible_message("<span class='warning'>[user] is compressing [O] with their bluespace compression kit!</span>")
			if(do_mob(user, O, 40) && charges > 0 && O.w_class > 1)
				playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 50, 1)
				sparks()
				flash_lighting_fx(3, 3, LIGHT_COLOR_CYAN)
				O.w_class -= 1
				// O.force_mult -= damage_multiplier
				charges -= 1
				to_chat(user, "<span class='notice'>You successfully compress [target]! The compressor now has [charges] charges.</span>")
		else
			to_chat(user, "<span class='notice'>Anomalous error. Summon a coder.</span>")

	else if(ishuman(target) && user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/genital/penis/P = H.getorganslot(ORGAN_SLOT_PENIS)
		if(!P)
			return
		playsound(get_turf(src), 'sound/weapons/flash.ogg', 50, 1)
		H.visible_message("<span class='warning'>[user] is preparing to shrink [H]\'s [P.name] with their bluespace compression kit!</span>")
		if(do_mob(user, H, 40) && charges > 0 && P.length > 0)
			H.visible_message("<span class='warning'>[user] has shrunk [H]\'s [P.name]!</span>")
			playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 50, 1)
			sparks()
			flash_lighting_fx(3, 3, LIGHT_COLOR_CYAN)
			charges -= 1
			var/p_name = P.name
			P.modify_size(-5)
			if(QDELETED(P))
				H.visible_message("<span class='warning'>[H]\'s [p_name] vanishes!</span>")


/obj/item/compressionkit/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/ore/bluespace_crystal))
		var/obj/item/stack/ore/bluespace_crystal/B = I
		charges += 2
		to_chat(user, "<span class='notice'>You insert [I] into [src]. It now has [charges] charges.</span>")
		if(B.amount > 1)
			B.amount -= 1
		else
			qdel(I)
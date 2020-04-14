/obj/item/nutcracker
	name = "nutcracker"
	desc = "It seems quite oversized. You could probably even crush a watermelon with it."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "nutcracker"
	force = 10
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("smashed", "beaten", "crushed")

/obj/item/nutcracker/proc/gib_head(mob/living/carbon/M)
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
	playsound(M, 'sound/effects/splat.ogg', 50, 1)

//It's a bit of a clusterfuck, but if someone wants, it can be easily repurposed to work on other limbs too.
/obj/item/nutcracker/attack(mob/living/carbon/M, mob/living/carbon/user)
	. = ..()
	var/target_zone = "head"
	var/obj/item/bodypart/target_limb = M.get_bodypart(target_zone)

	if(!get_turf(M))
		return
	if(!istype(M))
		return
	if(M == user) //just use the suicide verb instead
		return
	if(user.zone_selected != "head")
		return
	if(!target_limb)
		to_chat(user, "<span class='notice'>[M] has no [parse_zone(target_zone)]!</span>")
		return
	if(!get_location_accessible(M, target_zone))
		to_chat(user, "<span class='notice'>Expose [M]\s head before trying to crush it!</span>")
		return

	M.visible_message("<span class='warning'>[user] is trying to crush [M]\s head with \the [src]!</span>")

	var/crush_time = max(0, 400 - target_limb.brute_dam*2)
	if(do_mob(user, M, crush_time))
		if(get_location_accessible(M, target_zone)) //Yes, two checks, before and after the timer. What if someone puts a helmet on the guy while you're crushing his head?
			if(target_limb)//If he still has the head. In case you queue up a lot of these up at once or the guy loses the head while you're removing it.
				M.visible_message("<span class='warning'>[M]\s head cracks like a watermelon, spilling everything inside, as it becomes an unrecognizable mess!</span>")
				gib_head(M)
		else
			to_chat(user, "<span class='notice'>Expose [M]\s head before trying to crush it!</span>")


/obj/item/nutcracker/suicide_act(mob/living/carbon/user)
	var/obj/item/bodypart/target_limb = user.get_bodypart("head")
	if(target_limb) //I mean like... for example lings can be still alive without heads.
		user.visible_message("<span class='suicide'>[user] is crushing [user.p_their()] own head with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		if(do_after(user, 30))
			gib_head(user)
	else
		return
	return (BRUTELOSS)

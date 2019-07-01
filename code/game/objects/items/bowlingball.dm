/obj/item/weapon/clowningball
	name = "clowning ball"
	desc = "A perfectly normal looking bowling ball, it is as good at knocking over people as pins in the right hands."
	icon = 'icons/obj/bowling.dmi'
	icon_state = "bowling_ball"
	force = 5 // Its a bowling ball man.
	attack_verb = list("bashed", "slammed", "bludgeoned")
	hitsound = "sound/effects/bowling2.ogg"
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 3
	throw_range = 2
	throw_speed = 1
	var/clown_wielded = 0

/obj/item/weapon/clowningball/Initialize()
	. = ..()
	color = pick("white","green","yellow","purple","red")
	update_icon()

/obj/item/weapon/clowningball/throw_at(atom/target, range, speed, mob/thrower, spin=FALSE, diagonals_first = FALSE, datum/callback/callback)
	if(istype(thrower, /mob/living/carbon/human))
		var/mob/living/carbon/human/user = thrower
		if(user.w_uniform && istype(user.w_uniform, /obj/item/clothing/under/rank/clown))
			unlimitedthrow = 1
			clown_wielded = 1
			icon_state = "bowling_ball_spin"
			playsound(src, 'sound/effects/bowl.ogg', 50, 1)
	. = ..(target, range, speed, thrower, FALSE, diagonals_first, callback)

/obj/item/weapon/clowningball/throw_impact(atom/hit_atom)
	if(!ishuman(hit_atom))//if the ball hits a nonhuman
		unspin()
		return ..()
	var/mob/living/carbon/human/H = hit_atom
	if(clown_wielded) //Only the clown can actually bowl people.
		visible_message("<span class='danger'>\The expertly-bowled [src] knocks over [H] like a bowling pin!</span>")
		H.adjust_blurriness(6)
		H.Knockdown(8)
		H.throw_at(get_edge_target_turf(H,pick(GLOB.alldirs)),rand(1, 3),rand(1, 10))
		playsound(src,'sound/effects/bowling2.ogg',50,0)
		return
	else //Caught and not spinning or something else weird.
		unspin()
		return ..()

/obj/item/weapon/clowningball/proc/unspin()
	icon_state = "bowling_ball"
	unlimitedthrow = 0 //This variable is located in atoms_movable, thanks to it using throwing-subsystem.
	clown_wielded = 0 //This sets it back to 0, so people that aren't the clown don't touch it.


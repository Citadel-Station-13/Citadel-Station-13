/obj/item/clothing/head/bowler/bowlersharp
	name = "bowler-hat"
	desc = "A bowler hat whos edges seem unyielding, hopefully like the gentleman who wears it once you read this."
	force = 10
	throwforce = 20
	throw_speed = 5
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_SHARP //It can embed to stop too.

/obj/item/clothing/head/bowler/bowlersharp/Initialize()
	. = ..()

/obj/item/clothing/head/bowler/bowlersharp/throw_at(atom/target, range, speed, mob/thrower, spin=FALSE, diagonals_first = FALSE, datum/callback/callback)
	unlimitedthrow = 1
	. = ..(target, range, speed, thrower, FALSE, diagonals_first, callback)

/obj/item/clothing/head/bowler/bowlersharp/throw_impact(atom/hit_atom)
	if(!iscarbon(hit_atom))//if the ball hits a nonhuman
		unlimitedthrow = FALSE
		return ..()
	var/mob/living/carbon/human/H = hit_atom
	if(iscarbon(H))
		H.Knockdown(81) //Heres the downfall of this, they need to go down.
	var/obj/item/bodypart/l_arm = H.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/r_arm = H.get_bodypart(BODY_ZONE_R_ARM)
	if(prob(90) && iscarbon(H) && (r_arm || l_arm) && !HAS_TRAIT(H, TRAIT_NODISMEMBER))
		H.visible_message("<span class='warning'>\The [src] sends [H]'s arm on a journey to the floor!!</span>", "<span class='warning'>\The [src] sliced your arm off!</span>")
		if(l_arm)
			l_arm.dismember()
		else
			r_arm.dismember()
		return ..()
			//It has a 10% chance to just go by and not take one of your arms.
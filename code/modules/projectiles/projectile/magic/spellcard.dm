/obj/item/projectile/spellcard
	name = "enchanted card"
	desc = "A piece of paper enchanted to give it extreme durability and stiffness, along with a very hot burn to anyone unfortunate enough to get hit by a charged one."
	icon_state = "spellcard"
	damage_type = BURN
	damage = 2

/obj/item/projectile/magic/spellcard/book
	nodamage = FALSE
	name = "enchanted page"
	desc = "A piece of paper enchanted to give it extreme durability and stiffness, along with a very hot burn to anyone unfortunate enough to get hit by a charged one."
	icon_state = "spellcard"
	damage_type = BURN
	damage = 12
	flag = MAGIC

/obj/item/projectile/magic/spellcard/book/spark
	damage = 4
	var/fire_stacks = 4

/obj/item/projectile/magic/spellcard/book/spark/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/carbon/M = target
	if(ismob(target))
		if(M.anti_magic_check())
			M.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			return BULLET_ACT_BLOCK

	if(iscarbon(target))
		M.adjust_fire_stacks(fire_stacks)
		M.IgniteMob()
		return
	else
		damage = 20 //If we are a simplemob we deal 5x damage

/obj/item/projectile/magic/spellcard/book/shock
	damage = 0
	stamina = 11
	stutter = 5
	jitter = 20
	knockdown = 10

/obj/item/projectile/magic/spellcard/book/heal
	damage = 0
	nodamage  = TRUE

/obj/item/projectile/magic/spellcard/book/heal/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/carbon/M = target
	if(ismob(target))
		if(M.anti_magic_check())
			M.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			return BULLET_ACT_BLOCK
	if(iscarbon(target))
		M.visible_message("<span class='warning'>[src] mends [target]!</span>")
		M.adjustBruteLoss(-5) //HEALS
		M.adjustOxyLoss(-5)
		M.adjustBruteLoss(-5)
		M.adjustFireLoss(-5)
		M.adjustToxLoss(-5, TRUE) //heals TOXINLOVERs
		M.adjustCloneLoss(-5)
		M.adjustStaminaLoss(-5)
		return

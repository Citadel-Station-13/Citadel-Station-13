/obj/item/projectile/energy/bolt //ebow bolts
	name = "bolt"
	icon_state = "cbbolt"
	damage = 8
	damage_type = TOX
	nodamage = 0
	stamina = 60
	eyeblur = 10
	knockdown = 10
	slur = 5

/obj/item/projectile/energy/bolt/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		var/obj/item/I = C.get_active_held_item()
		if(I && C.dropItemToGround(I))
			to_chat(C, "<span class ='notice'>Your arm goes limp, and you drop what you're holding!</span>")

/obj/item/projectile/energy/bolt/halloween
	name = "candy corn"
	icon_state = "candy_corn"

/obj/item/projectile/energy/bolt/large
	damage = 20

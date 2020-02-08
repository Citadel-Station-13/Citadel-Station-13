/obj/item/clothing/gloves/ring
	name = "gold ring"
	desc = "A tiny gold ring, sized to wrap around a finger."
	gender = NEUTER
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/ring.dmi'
	icon_state = "ringgold"
	body_parts_covered = 0
	attack_verb = list("proposed")
	transfer_prints = TRUE
	strip_delay = 40

/obj/item/clothing/gloves/ring/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>\[user] is putting the [src] in [user.p_their()] mouth! It looks like [user] is trying to choke on the [src]!</span>")
	return OXYLOSS


/obj/item/clothing/gloves/ring/diamond
	name = "diamond ring"
	desc = "A tiny gold ring, studded with a diamond. Cultures have used these rings in courtship for a millenia."
	icon_state = "ringdiamond"

/obj/item/clothing/gloves/ring/silver
	name = "silver ring"
	desc = "A tiny silver ring, sized to wrap around a finger."
	icon_state = "ringsilver"

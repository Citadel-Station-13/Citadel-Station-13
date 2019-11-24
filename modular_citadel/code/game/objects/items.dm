/obj/item
	var/list/alternate_screams = list() //REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

// lazy for screaming.
/obj/item/clothing/head/xenos
	alternate_screams = list('sound/voice/hiss6.ogg')

/obj/item/clothing/head/cardborg
	alternate_screams = list('modular_citadel/sound/voice/scream_silicon.ogg')

/obj/item/clothing/head/ushanka
	alternate_screams = list('sound/voice/human/cyka1.ogg', 'sound/voice/human/cheekibreeki.ogg')

/obj/item/proc/grenade_prime_react(obj/item/grenade/nade)
	return
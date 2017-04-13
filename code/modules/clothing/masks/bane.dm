/obj/item/clothing/mask/gas/bane
	name = "Bane's Mask"
	desc = "It doesn't matter who we are. What matters is our plan."
	actions_types = list(/datum/action/item_action/banepost)
	icon_state = "sechailer"
	item_state = "sechailer"
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACIALHAIR|HIDEFACE
	w_class = WEIGHT_CLASS_SMALL
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/gas/bane/ui_action_click(mob/user, action)
	banepost()

/obj/item/clothing/mask/gas/bane/attack_self()
	banepost()

/obj/item/clothing/mask/gas/bane/verb/banepost()
	set category = "Object"
	set name = "BANEPOST"
	set src in usr
	if(!isliving(usr))
		return
	if(!can_use(usr))
		return
	var/phrase = rand(1,7)
	var/phrase_text = null
	var/phrase_sound = null


	if(cooldown < world.time - 30)

		switch(phrase)
			if(1)
				phrase_text = "Do you feel in charge?"
				phrase_sound = "bane1"
			if(2)
				phrase_text = "We both know that I have to kill you now."
				phrase_sound = "bane2"
			if(3)
				phrase_text = "Oooh, you think darkness is your ally. You merely adopted the dark. I was born in it; molded by it."
				phrase_sound = "bane3"
			if(4)
				phrase_text = "No one cared who I was 'til I put on the mask."
				phrase_sound = "bane4"
			if(5)
				phrase_text = "Let's not stand on ceremony here."
				phrase_sound = "bane5"
			if(6)
				phrase_text = "It doesn't matter who we are. What matters is our plan."
				phrase_sound = "bane6"
			if(7)
				phrase_text = "Then, I will break you."
				phrase_sound = "bane7"


		usr.visible_message("[usr]'s mask: <font color='red' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "sound/voice/bane/[phrase_sound].ogg", 100, 0, 4)
		cooldown = world.time
/obj/item/proc/showoff(mob/user)
	for(var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>", 1)

/mob/living/carbon/verb/show_item()
	set name = "Show Held Item"
	set category = "Object"
	set desc = "Show the thing you're holding."

	showoff(usr)

/mob/living/carbon/proc/showoff()
	var/obj/item/I = get_active_held_item()
	var/obj/item/arm = get_active_hand()
	if(!I && arm)
		usr.show_message("[usr] holds up [arm].", 1)
	else if(!arm && !I)
		to_chat(usr, "<span class='notice'>You frown because now there's nothing you can show.</span>")
	else if(!HAS_TRAIT(I, ABSTRACT_ITEM_TRAIT))
		I.showoff(src)

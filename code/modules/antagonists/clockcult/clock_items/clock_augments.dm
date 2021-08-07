//This file is for snowflakey clock augmentations and clock-themed cybernetic implants.

//The base clockie arm implant, which only clock cultist can use unless it is emagged. THIS SHOULD NEVER ACTUALLY EXIST
/obj/item/organ/cyberimp/arm/clockwork
	name = "clock-themed arm-mounted implant"
	var/clockwork_desc = "According to Ratvar, this really shouldn't exist. Tell Him about this immediately."
	syndicate_implant = TRUE
	icon_state = "toolkit_implant"

/obj/item/organ/cyberimp/arm/clockwork/ui_action_click()
	if(is_servant_of_ratvar(owner) || (obj_flags & EMAGGED)) //If you somehow manage to steal a clockie's implant AND have an emag AND manage to get it implanted for yourself, good on ya!
		return ..()
	to_chat(owner, "<span class='warning'>The implant refuses to activate..</span>")

/obj/item/organ/cyberimp/arm/clockwork/examine(mob/user)
	if((is_servant_of_ratvar(user) || isobserver(user)) && clockwork_desc)
		desc = clockwork_desc
	. = ..()
	desc = initial(desc)

/obj/item/organ/cyberimp/arm/clockwork/emag_act()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(usr, "<span class='notice'>You emag [src], hoping it'll achieve something..</span>")

//Brass claw implant. Holds the brass claw from brass_claw.dm and can extend / retract it at will.
/obj/item/organ/cyberimp/arm/clockwork/claw
	name = "brass claw implant"
	desc = "Yikes, the claw attached to this looks pretty darn sharp."
	clockwork_desc = "This implant, when added to a servant's arm, allows them to extend and retract a claw at will, though this is mildly painful to do. It will refuse to work for any non-servants."
	contents = newlist(/obj/item/clockwork/brass_claw)

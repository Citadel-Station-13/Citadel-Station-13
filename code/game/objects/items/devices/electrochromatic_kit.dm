/obj/item/electronics/electrochromatic_kit
	name = "electrochromatic kit"
	desc = "A kit for upgrading a window into an electrochromatic one."
	/// Electrochromatic ID
	var/id

/obj/item/electronics/electrochromatic_kit/attack_self(mob/user)
	. = ..()
	if(.)
		return
	var/new_id = tgui_input_text(user, "Set this kit's electrochromatic ID", "Set ID", id)
	if(isnull(new_id))
		return
	id = new_id

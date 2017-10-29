/obj/item/restraints/handcuffs/cable/vorecuffs
	name = "vorecuffs"
	desc = "Because Poojawa is at a loss for actually making people stop being muppets during vore."
	icon_state = "vorecuffs"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	materials = list()
	breakouttime = 20 //Deciseconds = 2s
	trashtype = /obj/item/restraints/handcuffs/cable/vorecuffs/used

/obj/item/restraints/handcuffs/cable/vorecuffs/used
	desc = "You don't see this coder related vore trick."
	icon_state = "vorecuffs_used"
	item_state = "vorecuffs"

/obj/item/restraints/handcuffs/cable/vorecuffs/used/attack()
	return

/obj/structure/closet/crate/vore
  name = "Slimy ooze"
  desc = "A mass of ooze, with something within"
  icon_state = "vore_ooze"

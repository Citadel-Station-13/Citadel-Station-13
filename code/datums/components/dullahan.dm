//turns the user into a dullahan by popping their head off and applying a bunch of snowflakey stuff
/datum/component/dullahan
	//who is the person who is going to lose their head
	var/mob/living/carbon/human/owner
	//do we need to change what their head looks like
	var/custom_head_icon
	var/custom_head_icon_state

/datum/component/dullahan/pumpkin //easier to just make this a subtype for the sake of checking if they're a pumpkin dullahan or a regular one
	custom_head_icon = 'icons/obj/clothing/hats.dmi'
	custom_head_icon_state = "hardhat1_pumpkin_j"

/datum/component/dullahan/Initialize()
	if(ishuman(parent))
		owner = parent
	else
		//they shouldn't have this component!
		RemoveComponent()

/datum/component/dullahan/has_custom_head()
	return (custom_head_icon && custom_head_icon_state)

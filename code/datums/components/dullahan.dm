//turns the user into a dullahan by popping their head off and applying a bunch of snowflakey stuff
/datum/component/dullahan
	var/mob/living/carbon/human/owner

/datum/component/dullahan/Initialize()
	if(ishuman(parent))
		owner = parent
	else
		//they shouldn't have this component!
		RemoveComponent()

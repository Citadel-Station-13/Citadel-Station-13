//V-tech kicked in yo
/obj/effect/proc_holder/silicon/cyborg/vtecControl
	name = "vTec Control"
	desc = "Allows finer-grained control of the vTec speed boost."
	action_icon = 'icons/mob/actions.dmi'
	action_icon_state = "Chevron_State_0"

	var/currentState = 0
	var/maxReduction = 2


/obj/effect/proc_holder/silicon/cyborg/vtecControl/Click(mob/living/silicon/robot/user)

	var/mob/living/silicon/robot/self = usr

	currentState = (currentState + 1) % 3

	if(usr)
		switch(currentState)
			if (0)
				self.speed += maxReduction
			if (1)
				self.speed -= maxReduction*0.5
			if (2)
				self.speed -= maxReduction*0.5

	action.button_icon_state = "Chevron_State_[currentState]"
	action.UpdateButtonIcon()

	return

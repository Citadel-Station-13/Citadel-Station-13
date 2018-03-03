/obj/machinery/wish_granter/attack_hand(mob/living/carbon/user)
	if(charges <= 0)
		to_chat(user, "The Wish Granter lies silent.")
		return

	else if(!ishuman(user))
		to_chat(user, "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's.")
		return

	else if(is_special_character(user))
		to_chat(user, "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual makes you pull away.")

	else if (!insisting)
		to_chat(user, "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?")
		insisting++

	else
		to_chat(user, "You speak.  [pick("I want the station to disappear","Humanity is corrupt, mankind must be destroyed","I want to be rich", "I want to rule the world","I want immortality.")].  The Wish Granter answers.")
		if(alert("Are you really sure?", "Confirm decision", "Yes", "No") == "Yes")
			if(alert("Are you really, really sure?", "Confirm decision", "Yes", "No") == "Yes")
				if(alert("You have a chance of being dusted if you keep clicking yes. Are you sure?", "Confirm decision", "Yes", "No") == "Yes")
					if(alert("Do you want to self-antag so badly you'd risk being dusted?", "Confirm decision", "Yes", "No") == "Yes")
						if(alert("Really?", "Confirm decision", "Yes", "No") == "Yes")
							if (prob(75))
								to_chat(user, "Your head pounds for a moment, before your vision clears. You instantly regret all of your life choices up to this point. Your flesh rapidly flashes away into dust.")
								user.dust()
								insisting = 0
								return
							else
								to_chat(user, "Your head pounds for a moment, before your vision clears.  You are the avatar of the Wish Granter, and your power is LIMITLESS!  And it's all yours.  You need to make sure no one can take it from you.  No one can know, first.")
								charges--
								insisting = 0
								user.mind.add_antag_datum(/datum/antagonist/wishgranter)
								to_chat(user, "You have a very great feeling about this!")
								return
						else
							insisting = 0
							return
					else
						insisting = 0
						return
				else
					insisting = 0
					return
			else
				insisting = 0
				return
		else
			insisting = 0
			return

	return